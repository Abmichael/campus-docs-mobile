import express from 'express';
import cors from 'cors';
import { Low } from 'lowdb';
import { JSONFile } from 'lowdb/node';
import { nanoid } from 'nanoid';

const app = express();
const port = 4000;

// Middleware
app.use(cors({
  origin: ['http://localhost:3000', 'http://localhost:8080', 'http://localhost:4000']
}));
app.use(express.json());

// LowDB setup
const adapter = new JSONFile('db.json');
const defaultData = {
  users: [],
  requests: [],
  templates: []
};
const db = new Low(adapter, defaultData);

// Initialize DB
await db.read();
await db.write();

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

app.post('/auth/logout', authMiddleware, async (req, res) => {
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
  const users = db.data.users.map(({ password, token, ...user }) => user);
  res.json(users);
});

app.post('/users', authMiddleware, adminMiddleware, async (req, res) => {
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

app.patch('/users/:id', authMiddleware, adminMiddleware, async (req, res) => {
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

app.delete('/users/:id', authMiddleware, adminMiddleware, async (req, res) => {
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
  res.json(db.data.requests);
});

app.post('/requests', authMiddleware, async (req, res) => {
  const { type, userId } = req.body;
  if (!type || !userId) {
    return res.status(400).json({ error: 'Type and userId required' });
  }

  const request = {
    id: nanoid(),
    type,
    status: 'PENDING',
    userId,
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
  res.json(db.data.templates);
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

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
}); 