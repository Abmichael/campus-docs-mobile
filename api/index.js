import express from "express";
import cors from "cors";
import { Low } from "lowdb";
import { JSONFile } from "lowdb/node";
import { nanoid } from "nanoid";

const app = express();
const port = 4000;

// Middleware
app.use(
  cors({
    origin: [
      "http://localhost:3000",
      "http://localhost:8080",
      "http://localhost:4000",
      "http://192.168.1.2:4000",
    ],
  })
);
app.use(express.json());

// Request logging middleware
app.use((req, res, next) => {
  const timestamp = new Date().toISOString();
  const token = req.headers.authorization?.split(" ")[1] || "No token";
  console.log(`[${timestamp}] ${req.method} ${req.url} Token: ${token}`);
  if (req.body && Object.keys(req.body).length > 0) {
    console.log("Request Body:", req.body);
  }
  next();
});

// LowDB setup
const adapter = new JSONFile("db.json");
const defaultData = {
  users: [],
  requests: [],
  templates: [],
  letters: [],
  auditLogs: [],
  settings: {
    systemName: "MIT Mobile App",
    emailFrom: "noreply@mit.edu",
    smtpServer: "smtp.mit.edu",
    smtpPort: "587",
    smtpUsername: "",
    smtpPassword: "",
  },
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
    details: req.body,
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
  const token = req.headers.authorization?.split(" ")[1];
  if (!token) return res.status(401).json({ error: "No token provided" });

  await db.read();
  const user = db.data.users.find((u) => u.token === token);
  if (!user) return res.status(401).json({ error: "Invalid token" });

  req.user = user;
  next();
};

// Admin middleware
const adminMiddleware = (req, res, next) => {
  if (req.user.role !== "administrator") {
    return res.status(403).json({ error: "Admin access required" });
  }
  next();
};

// Auth routes
app.post("/auth/login", async (req, res) => {
  const { email, password } = req.body;
  if (!email || !password) {
    return res.status(400).json({ error: "Email and password required" });
  }

  await db.read();
  const user = db.data.users.find((u) => u.email === email);

  if (!user || user.password !== password) {
    // In a real app, use proper password hashing
    return res.status(401).json({ error: "Invalid credentials" });
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
      role: user.role,
    },
  });
});

app.post(
  "/auth/logout",
  authMiddleware,
  auditLogMiddleware("logout"),
  async (req, res) => {
    await db.read();
    const user = db.data.users.find((u) => u.id === req.user.id);
    if (user) {
      user.token = null;
      await db.write();
    }
    res.json({ message: "Logged out successfully" });
  }
);

// User management routes (admin only)
app.get("/users", authMiddleware, adminMiddleware, async (req, res) => {
  await db.read();
  const users =
    db.data.users?.map(({ password, token, ...user }) => user) || [];
  res.json(users);
});

app.post(
  "/users",
  authMiddleware,
  adminMiddleware,
  auditLogMiddleware("create_user"),
  async (req, res) => {
    const { name, email, password, role, studentId } = req.body;
    if (!name || !email || !password || !role) {
      return res.status(400).json({ error: "All fields required" });
    }

    await db.read();
    if (db.data.users.some((u) => u.email === email)) {
      return res.status(400).json({ error: "Email already exists" });
    }

    const user = {
      id: nanoid(),
      name,
      email,
      password, // In a real app, hash the password
      role,
      token: null,
      ...(role === 'student' && studentId ? { studentId } : {}),
    };

    db.data.users.push(user);
    await db.write();

    const { password: _, token: __, ...userWithoutSensitive } = user;
    res.status(201).json(userWithoutSensitive);
  }
);

app.patch(
  "/users/:id",
  authMiddleware,
  adminMiddleware,
  auditLogMiddleware("update_user"),
  async (req, res) => {
    const { id } = req.params;
    const { name, email, role, studentId } = req.body;

    await db.read();
    const user = db.data.users.find((u) => u.id === id);
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    if (email && email !== user.email) {
      if (db.data.users.some((u) => u.email === email)) {
        return res.status(400).json({ error: "Email already exists" });
      }
      user.email = email;
    }

    if (name) user.name = name;
    if (role) user.role = role;
    
    // Handle studentId for students
    if (role === 'student' && studentId) {
      user.studentId = studentId;
    } else if (role !== 'student') {
      // Remove studentId if role is changed from student to something else
      delete user.studentId;
    }

    await db.write();
    const { password, token, ...userWithoutSensitive } = user;
    res.json(userWithoutSensitive);
  }
);

app.delete(
  "/users/:id",
  authMiddleware,
  adminMiddleware,
  auditLogMiddleware("delete_user"),
  async (req, res) => {
    const { id } = req.params;

    await db.read();
    const userIndex = db.data.users.findIndex((u) => u.id === id);
    if (userIndex === -1) {
      return res.status(404).json({ error: "User not found" });
    }

    db.data.users.splice(userIndex, 1);
    await db.write();
    res.json({ message: "User deleted successfully" });
  }
);

// Request routes
app.get("/requests", authMiddleware, async (req, res) => {
  await db.read();
  let requests = db.data.requests || [];
  if (req.user.role === "student") {
    requests = requests.filter((r) => r.userId === req.user.email);
  }
  // Enrich requests with user information
  const enrichedRequests = requests.map(request => {
    const user = db.data.users.find(u => u.email === request.userId);
    return {
      ...request,
      userName: user ? user.name : 'Unknown User',
      userStudentId: user && user.role === 'student' ? user.studentId : null
    };
  });

  // Check if client wants paginated response
  const wantsPagination = req.query.page || req.query.limit || req.query.status;
  
  if (wantsPagination) {
    // Handle pagination
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const status = req.query.status;

    let filteredRequests = enrichedRequests;

    // Filter by status if provided
    if (status) {
      filteredRequests = filteredRequests.filter((r) => r.status === status);
    }

    // Sort by updatedAt descending (newest first)
    filteredRequests.sort((a, b) => new Date(b.updatedAt) - new Date(a.updatedAt));

    // Calculate pagination
    const startIndex = (page - 1) * limit;
    const endIndex = page * limit;
    const paginatedRequests = filteredRequests.slice(startIndex, endIndex);

    res.json({
      requests: paginatedRequests,
      pagination: {
        page,
        limit,
        total: filteredRequests.length,
        totalPages: Math.ceil(filteredRequests.length / limit),
        hasMore: endIndex < filteredRequests.length
      }
    });
  } else {
    // Return old format for backward compatibility
    res.json(enrichedRequests);
  }
});

app.post("/requests", authMiddleware, async (req, res) => {
  const { type, notes } = req.body;
  if (!type) {
    return res.status(400).json({ error: "Type is required" });
  }

  const request = {
    id: nanoid(),
    type,
    notes: notes || "",
    status: "pending",
    userId: req.user.email,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
  };

  db.data.requests.push(request);
  await db.write();
  res.status(201).json(request);
});

app.patch("/requests/:id", authMiddleware, async (req, res) => {
  const { id } = req.params;
  const { status } = req.body;
  if (!status) {
    return res.status(400).json({ error: "Status required" });
  }

  const request = db.data.requests.find((r) => r.id === id);
  if (!request) {
    return res.status(404).json({ error: "Request not found" });
  }

  request.status = status;
  request.updatedAt = new Date().toISOString();
  await db.write();
  res.json(request);
});

// Letter template routes
app.get("/letter-templates", authMiddleware, async (req, res) => {
  await db.read();
  res.json(db.data.templates || []);
});

app.post("/letter-templates", authMiddleware, async (req, res) => {
  const { title, body, placeholders } = req.body;
  if (!title || !body || !placeholders) {
    return res
      .status(400)
      .json({ error: "Title, body, and placeholders required" });
  }

  const template = {
    id: nanoid(),
    title,
    body,
    placeholders,
  };

  db.data.templates.push(template);
  await db.write();
  res.status(201).json(template);
});

// Letter management routes
// Get all letters (admin/staff: all, student: own)
app.get("/letters", authMiddleware, async (req, res) => {
  await db.read();
  let letters = db.data.letters || [];
  if (req.user.role === "student") {
    letters = letters.filter((l) => l.userId === req.user.email);
  }
  res.json(letters);
});

// Get letters created by current staff member
app.get("/letters/my-created", authMiddleware, async (req, res) => {
  if (req.user.role !== "staff" && req.user.role !== "administrator") {
    return res.status(403).json({ error: "Staff access required" });
  }
  await db.read();
  const letters = (db.data.letters || []).filter((l) => l.createdBy === req.user.email);
  res.json(letters);
});

// Get letters for current student
app.get("/letters/my-documents", authMiddleware, async (req, res) => {
  if (req.user.role !== "student") {
    return res.status(403).json({ error: "Student access required" });
  }
  await db.read();
  const letters = (db.data.letters || []).filter((l) => l.userId === req.user.email);
  res.json(letters);
});

// Get a specific letter (access controlled)
app.get("/letters/:id", authMiddleware, async (req, res) => {
  await db.read();
  const letter = (db.data.letters || []).find((l) => l.id === req.params.id);
  if (!letter) return res.status(404).json({ error: "Letter not found" });
  if (req.user.role === "student" && letter.userId !== req.user.email) {
    return res.status(403).json({ error: "Access denied" });
  }
  res.json(letter);
});

// Create a letter (staff only)
app.post("/letters", authMiddleware, async (req, res) => {
  if (req.user.role !== "staff" && req.user.role !== "administrator") {
    return res.status(403).json({ error: "Staff access required" });
  }
  const { requestId, content, templateId, templateVariables } = req.body;
  if (!requestId || !content) {
    return res.status(400).json({ error: "requestId and content required" });
  }
  await db.read();
  const request = db.data.requests.find((r) => r.id === requestId);
  if (!request) {
    return res.status(404).json({ error: "Request not found" });
  }
  // Get user information for automatic variables
  const user = db.data.users.find((u) => u.email === request.userId);
  
  // Get template information if templateId is provided
  const template = templateId ? db.data.templates.find((t) => t.id === templateId) : null;
    // Generate automatic template variables if not provided
  const currentDate = new Date();
  let automaticVariables = {
    date: currentDate.toLocaleDateString(),
    issue_date: currentDate.toLocaleDateString(),
    student_name: user?.name || 'Student Name',
    student_id: user?.studentId || 'Student ID',
    ...templateVariables
  };

  // Always include ref_no - use provided value or auto-generate
  if (!automaticVariables.ref_no) {
    // Format: MIT-YYYYMMDD-<nanoid>
    const dateStr = new Date().toISOString().slice(0, 10).replace(/-/g, "");
    automaticVariables.ref_no = `MIT-${dateStr}-${nanoid(6)}`;
  }

  // Add template title if template is found
  if (template) {
    automaticVariables.template_title = template.title;
  }

  // Apply template variables to content
  let finalContent = content;
  Object.keys(automaticVariables).forEach(key => {
    const value = automaticVariables[key];
    // Replace both [placeholder] and {{placeholder}} syntax
    finalContent = finalContent.replace(new RegExp(`\\[${key}\\]`, 'g'), value);
    finalContent = finalContent.replace(new RegExp(`\\{\\{${key}\\}\\}`, 'g'), value);
  });

  const letter = {
    id: nanoid(),
    requestId,
    userId: request.userId,
    createdBy: req.user.email,
    signedBy: null,
    createdAt: new Date().toISOString(),
    signedAt: null,
    content: finalContent,
    templateId: templateId || null,
    templateVariables: automaticVariables || null,
  };
  if (!db.data.letters) db.data.letters = [];
  db.data.letters.push(letter);
  await db.write();
  res.status(201).json(letter);
});

// Sign a letter (staff only)
app.patch("/letters/:id/sign", authMiddleware, async (req, res) => {
  if (req.user.role !== "staff" && req.user.role !== "administrator") {
    return res.status(403).json({ error: "Staff access required" });
  }
  await db.read();
  const letter = (db.data.letters || []).find((l) => l.id === req.params.id);
  if (!letter) return res.status(404).json({ error: "Letter not found" });
  if (letter.signedBy)
    return res.status(400).json({ error: "Letter already signed" });
  letter.signedBy = req.user.email;
  letter.signedAt = new Date().toISOString();
  await db.write();
  res.json(letter);
});

// Admin dashboard routes
app.get("/admin/stats", authMiddleware, adminMiddleware, async (req, res) => {
  await db.read();
  const totalUsers = db.data.users.length;
  const activeRequests = db.data.requests.filter(
    (r) => r.status === "PENDING"
  ).length;
  const pendingApprovals = db.data.requests.filter(
    (r) => r.status === "PENDING"
  ).length;

  res.json({
    totalUsers,
    activeRequests,
    pendingApprovals,
  });
});

// Audit logs endpoint
app.get(
  "/admin/audit-logs",
  authMiddleware,
  adminMiddleware,
  async (req, res) => {
    await db.read();
    res.json(db.data.auditLogs || []);
  }
);

// System settings endpoints
app.get(
  "/admin/settings",
  authMiddleware,
  adminMiddleware,
  async (req, res) => {
    await db.read();
    res.json(db.data.settings || {});
  }
);

app.patch(
  "/admin/settings",
  authMiddleware,
  adminMiddleware,
  async (req, res) => {
    const {
      systemName,
      emailFrom,
      smtpServer,
      smtpPort,
      smtpUsername,
      smtpPassword,
    } = req.body;

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
  }
);

app.listen(port, "0.0.0.0", () => {
  console.log(`Server running at http://0.0.0.0:${port}`);
});
