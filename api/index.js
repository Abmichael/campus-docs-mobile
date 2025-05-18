import express from 'express';
import cors from 'cors';
import { Low } from 'lowdb';
import { JSONFile } from 'lowdb/node';
import { nanoid } from 'nanoid';

const app = express();
const port = 4000;

// Middleware
app.use(cors({
  origin: ['http://localhost:3000', 'http://localhost:8080', 'http://localhost:4000', 'http://192.168.1.2:4000']
}));
app.use(express.json());

// Request logging middleware
app.use((req, res, next) => {
  const timestamp = new Date().toISOString();
  const token = req.headers.authorization?.split(' ')[1] || 'No token';
  console.log(`[${timestamp}] ${req.method} ${req.url} Token: ${token}`);
  if (req.body && Object.keys(req.body).length > 0) {
    console.log('Request Body:', req.body);
  }
  next();
});

// LowDB setup
const adapter = new JSONFile('db.json');
const defaultData = {
  users: [],
  requests: [],
  templates: [],
  auditLogs: [],
  settings: {
    systemName: 'MIT Mobile App',
    emailFrom: 'noreply@mit.edu',
    smtpServer: 'smtp.mit.edu',
    smtpPort: '587',
    smtpUsername: '',
    smtpPassword: ''
  }
};
const db = new Low(adapter, defaultData);

// Initialize DB
await db.read();
await db.write();

// Audit log middleware
const auditLogMiddleware = (action) => async (req, res, next) => {
  const log = {
    id: nanoid(),
    action,
    user: req.user.email,
    timestamp: new Date().toISOString(),
    details: req.body
  };
  
  await db.read();
  if (!db.data.auditLogs) {
    db.data.auditLogs = [];
  }
  db.data.auditLogs.push(log);
  await db.write();
  next();
};

// Auth middleware
const authMiddleware = async (req, res, next) => {
  const token = req.headers.authorization?.split(' ')[1];
  if (!token) return res.status(401).json({ error: 'No token provided' });

  await db.read();
  const user = db.data.users.find(u => u.token === token);
  if (!user) return res.status(401).json({ error: 'Invalid token' });

  req.user = user;
  next();
};

// Admin middleware
const adminMiddleware = (req, res, next) => {
  if (req.user.role !== 'administrator') {
    return res.status(403).json({ error: 'Admin access required' });
  }
  next();
};

// Auth routes
app.post('/auth/login', async (req, res) => {
  const { email, password } = req.body;
  if (!email || !password) {
    return res.status(400).json({ error: 'Email and password required' });
  }

  await db.read();
  const user = db.data.users.find(u => u.email === email);
  
  if (!user || user.password !== password) { // In a real app, use proper password hashing
    return res.status(401).json({ error: 'Invalid credentials' });
  }

  // Generate token if not exists
  if (!user.token) {
    user.token = nanoid();
    await db.write();
  }

  res.json({
    token: user.token,
    user: {
      id: user.id,
      name: user.name,
      email: user.email,
      role: user.role
    }
  });
});

app.post('/auth/logout', authMiddleware, auditLogMiddleware('logout'), async (req, res) => {
  await db.read();
  const user = db.data.users.find(u => u.id === req.user.id);
  if (user) {
    user.token = null;
    await db.write();
  }
  res.json({ message: 'Logged out successfully' });
});

// User management routes (admin only)
app.get('/users', authMiddleware, adminMiddleware, async (req, res) => {
  await db.read();
  const users = db.data.users?.map(({ password, token, ...user }) => user) || [];
  res.json(users);
});

app.post('/users', authMiddleware, adminMiddleware, auditLogMiddleware('create_user'), async (req, res) => {
  const { name, email, password, role } = req.body;
  if (!name || !email || !password || !role) {
    return res.status(400).json({ error: 'All fields required' });
  }

  await db.read();
  if (db.data.users.some(u => u.email === email)) {
    return res.status(400).json({ error: 'Email already exists' });
  }

  const user = {
    id: nanoid(),
    name,
    email,
    password, // In a real app, hash the password
    role,
    token: null
  };

  db.data.users.push(user);
  await db.write();

  const { password: _, token: __, ...userWithoutSensitive } = user;
  res.status(201).json(userWithoutSensitive);
});

app.patch('/users/:id', authMiddleware, adminMiddleware, auditLogMiddleware('update_user'), async (req, res) => {
  const { id } = req.params;
  const { name, email, role } = req.body;

  await db.read();
  const user = db.data.users.find(u => u.id === id);
  if (!user) {
    return res.status(404).json({ error: 'User not found' });
  }

  if (email && email !== user.email) {
    if (db.data.users.some(u => u.email === email)) {
      return res.status(400).json({ error: 'Email already exists' });
    }
    user.email = email;
  }

  if (name) user.name = name;
  if (role) user.role = role;

  await db.write();
  const { password, token, ...userWithoutSensitive } = user;
  res.json(userWithoutSensitive);
});

app.delete('/users/:id', authMiddleware, adminMiddleware, auditLogMiddleware('delete_user'), async (req, res) => {
  const { id } = req.params;
  
  await db.read();
  const userIndex = db.data.users.findIndex(u => u.id === id);
  if (userIndex === -1) {
    return res.status(404).json({ error: 'User not found' });
  }

  db.data.users.splice(userIndex, 1);
  await db.write();
  res.json({ message: 'User deleted successfully' });
});

// Request routes
app.get('/requests', authMiddleware, async (req, res) => {
  await db.read();
  let requests = db.data.requests || [];
  if (req.user.role === 'student') {
    requests = requests.filter(r => r.userId === req.user.email);
  }
  res.json(requests);
});

app.post('/requests', authMiddleware, async (req, res) => {
  const { type, notes } = req.body;
  if (!type) {
    return res.status(400).json({ error: 'Type is required' });
  }

  const request = {
    id: nanoid(),
    type,
    notes: notes || '',
    status: 'pending',
    userId: req.user.email,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  };

  db.data.requests.push(request);
  await db.write();
  res.status(201).json(request);
});

app.patch('/requests/:id', authMiddleware, async (req, res) => {
  const { id } = req.params;
  const { status } = req.body;
  if (!status) {
    return res.status(400).json({ error: 'Status required' });
  }

  const request = db.data.requests.find(r => r.id === id);
  if (!request) {
    return res.status(404).json({ error: 'Request not found' });
  }

  request.status = status;
  request.updatedAt = new Date().toISOString();
  await db.write();
  res.json(request);
});

// Letter template routes
app.get('/letter-templates', authMiddleware, async (req, res) => {
  await db.read();
  res.json(db.data.templates || []);
});

app.post('/letter-templates', authMiddleware, async (req, res) => {
  const { title, body, placeholders } = req.body;
  if (!title || !body || !placeholders) {
    return res.status(400).json({ error: 'Title, body, and placeholders required' });
  }

  const template = {
    id: nanoid(),
    title,
    body,
    placeholders
  };

  db.data.templates.push(template);
  await db.write();
  res.status(201).json(template);
});

// Admin dashboard routes
app.get('/admin/stats', authMiddleware, adminMiddleware, async (req, res) => {
  await db.read();
  const totalUsers = db.data.users.length;
  const activeRequests = db.data.requests.filter(r => r.status === 'PENDING').length;
  const pendingApprovals = db.data.requests.filter(r => r.status === 'PENDING').length;

  res.json({
    totalUsers,
    activeRequests,
    pendingApprovals
  });
});

// Audit logs endpoint
app.get('/admin/audit-logs', authMiddleware, adminMiddleware, async (req, res) => {
  await db.read();
  res.json(db.data.auditLogs || []);
});

// System settings endpoints
app.get('/admin/settings', authMiddleware, adminMiddleware, async (req, res) => {
  await db.read();
  res.json(db.data.settings || {});
});

app.patch('/admin/settings', authMiddleware, adminMiddleware, async (req, res) => {
  const { systemName, emailFrom, smtpServer, smtpPort, smtpUsername, smtpPassword } = req.body;
  
  await db.read();
  const settings = db.data.settings;
  
  if (systemName) settings.systemName = systemName;
  if (emailFrom) settings.emailFrom = emailFrom;
  if (smtpServer) settings.smtpServer = smtpServer;
  if (smtpPort) settings.smtpPort = smtpPort;
  if (smtpUsername) settings.smtpUsername = smtpUsername;
  if (smtpPassword) settings.smtpPassword = smtpPassword;
  
  await db.write();
  res.json(settings);
});

app.listen(port, '0.0.0.0', () => {
  console.log(`Server running at http://0.0.0.0:${port}`);
}); 