import { Low } from "lowdb";
import { JSONFile } from "lowdb/node";
import { nanoid } from "nanoid";

const adapter = new JSONFile("db.json");
const defaultData = {
  users: [],
  requests: [],
  templates: [],
  auditLogs: [],
  letters: [],
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

// Initialize DB with seed data
await db.read();
db.data = {
  users: [
    {
      id: nanoid(),
      name: "Admin User",
      email: "admin@mit.edu",
      password: "admin123", // In a real app, this would be hashed
      role: "administrator",
      token: nanoid(),
    },
    {
      id: nanoid(),
      name: "Student User",
      email: "student@mit.edu",
      password: "password123",
      role: "student",
      token: nanoid(),
      studentId: "MIT/UR/001/12",
    },
    {
      id: nanoid(),
      name: "Alice Wonderland",
      email: "alice@mit.edu",
      password: "password123",
      role: "student",
      token: nanoid(),
      studentId: "MIT/UR/002/12",
    },
    {
      id: nanoid(),
      name: "Bob The Builder",
      email: "bob@mit.edu",
      password: "password123",
      role: "student",
      token: nanoid(),
      studentId: "MIT/UR/003/12",
    },
    {
      id: nanoid(),
      name: "Staff User",
      email: "staff@mit.edu",
      password: "password123",
      role: "staff",
      token: nanoid(),
    },
    {
      id: nanoid(),
      name: "Professor Dumbledore",
      email: "dumbledore@mit.edu",
      password: "password123",
      role: "staff",
      token: nanoid(),
    },
  ],
  requests: [
    {
      id: nanoid(),
      type: "letter",
      notes: "Requesting a letter for internship application.",
      status: "pending",
      userId: "student@mit.edu",
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    },
    {
      id: nanoid(),
      type: "transcript",
      notes: "Need official transcript for graduate school application.",
      status: "approved",
      userId: "student@mit.edu",
      createdAt: new Date(Date.now() - 86400000 * 2).toISOString(), // 2 days ago
      updatedAt: new Date(Date.now() - 86400000 * 1).toISOString(), // 1 day ago
    },
    {
      id: nanoid(),
      type: "letter",
      notes: "Enrollment verification for scholarship.",
      status: "approved",
      userId: "alice@mit.edu",
      createdAt: new Date(Date.now() - 86400000 * 3).toISOString(), // 3 days ago
      updatedAt: new Date(Date.now() - 86400000 * 2).toISOString(), // 2 days ago
    },
    {
      id: nanoid(),
      type: "other",
      notes: "Inquiry about library access during break.",
      status: "rejected",
      userId: "bob@mit.edu",
      createdAt: new Date(Date.now() - 86400000 * 1).toISOString(), // 1 day ago
      updatedAt: new Date().toISOString(),
    },
    {
      id: nanoid(),
      type: "letter",
      notes: "Request for good standing letter for visa.",
      status: "pending",
      userId: "alice@mit.edu",
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    },
  ],
  templates: [
    {
      id: nanoid(),
      title: "Enrollment Verification Letter",
      body: "This is to certify that [student_name] (ID: [student_id]) is a currently enrolled student at the Massachusetts Institute of Technology. This letter was issued on [issue_date]. Reference Number: [ref_no].",
      placeholders: ["student_name", "student_id", "issue_date", "ref_no"],
    },
    {
      id: nanoid(),
      title: "Good Standing Letter",
      body: "This letter confirms that [student_name] (ID: [student_id]) is a student in good academic standing at MIT as of [date]. This letter was issued on [issue_date]. Reference Number: [ref_no].",
      placeholders: [
        "student_name",
        "student_id",
        "date",
        "issue_date",
        "ref_no",
      ],
    },
  ],
  auditLogs: [
    {
      id: nanoid(),
      action: "login",
      user: "admin@mit.edu",
      timestamp: new Date(Date.now() - 3600000 * 1).toISOString(), // 1 hour ago
      details: { ip: "127.0.0.1", userAgent: "SeedScript/1.0" },
    },
    {
      id: nanoid(),
      action: "create_user",
      user: "admin@mit.edu",
      timestamp: new Date(Date.now() - 3600000 * 2).toISOString(), // 2 hours ago
      details: {
        name: "Student User",
        email: "student@mit.edu",
        role: "student",
      },
    },
    {
      id: nanoid(),
      action: "login",
      user: "alice@mit.edu",
      timestamp: new Date(Date.now() - 3600000 * 3).toISOString(), // 3 hours ago
      details: { ip: "192.168.1.100", userAgent: "MobileApp/1.1" },
    },
  ],
  letters: [
    {
      id: nanoid(),
      requestId:
        db.data.requests.find(
          (r) => r.userId === "student@mit.edu" && r.status === "approved"
        )?.id || nanoid(),
      userId: "student@mit.edu",
      createdBy: "staff@mit.edu",
      signedBy: "staff@mit.edu",
      createdAt: new Date(Date.now() - 86400000 * 1).toISOString(), // 1 day ago
      signedAt: new Date().toISOString(),
      content:
        "This is to certify that Student User (ID: MIT/UR/001/12) is a currently enrolled student at the Massachusetts Institute of Technology. This letter was issued on " +
        new Date(Date.now() - 86400000 * 1).toLocaleDateString() +
        ". Reference Number: MIT-" +
        new Date().toISOString().slice(0, 10).replace(/-/g, "") +
        "-" +
        nanoid(6).toUpperCase() +
        ".",
      templateId: db.data.templates[0]?.id, // Link to the first template
      templateVariables: {
        student_name: "Student User",
        student_id: "MIT/UR/001/12",
        issue_date: new Date(Date.now() - 86400000 * 1).toLocaleDateString(),
        ref_no:
          "MIT-" +
          new Date().toISOString().slice(0, 10).replace(/-/g, "") +
          "-" +
          nanoid(6).toUpperCase(),
      },
    },
    {
      id: nanoid(),
      requestId:
        db.data.requests.find(
          (r) => r.userId === "alice@mit.edu" && r.status === "approved"
        )?.id || nanoid(),
      userId: "alice@mit.edu",
      createdBy: "dumbledore@mit.edu",
      signedBy: "dumbledore@mit.edu",
      createdAt: new Date(Date.now() - 86400000 * 2).toISOString(), // 2 days ago
      signedAt: new Date(Date.now() - 86400000 * 1).toISOString(), // 1 day ago
      content:
        "This is to certify that Alice Wonderland (ID: MIT/UR/002/12) is a currently enrolled student at the Massachusetts Institute of Technology. This letter was issued on " +
        new Date(Date.now() - 86400000 * 2).toLocaleDateString() +
        ". Reference Number: MIT-" +
        new Date().toISOString().slice(0, 10).replace(/-/g, "") +
        "-" +
        nanoid(6).toUpperCase() +
        ".",
      templateId: db.data.templates[0]?.id, // Link to the first template
      templateVariables: {
        student_name: "Alice Wonderland",
        student_id: "MIT/UR/002/12",
        issue_date: new Date(Date.now() - 86400000 * 2).toLocaleDateString(),
        ref_no:
          "MIT-" +
          new Date().toISOString().slice(0, 10).replace(/-/g, "") +
          "-" +
          nanoid(6).toUpperCase(),
      },
    },
    {
      id: nanoid(),
      requestId:
        db.data.requests.find(
          (r) => r.userId === "bob@mit.edu" && r.status === "approved"
        )?.id || nanoid(), // This will likely be a new nanoid as Bob has no approved requests
      userId: "bob@mit.edu",
      createdBy: "staff@mit.edu",
      // This letter is not signed yet
      signedBy: null,
      createdAt: new Date().toISOString(),
      signedAt: null,
      content:
        "This letter confirms that Bob The Builder (ID: MIT/UR/003/12) is a student in good academic standing at MIT as of " +
        new Date().toLocaleDateString() +
        ". This letter was issued on " +
        new Date().toLocaleDateString() +
        ". Reference Number: MIT-" +
        new Date().toISOString().slice(0, 10).replace(/-/g, "") +
        "-" +
        nanoid(6).toUpperCase() +
        ".",
      templateId: db.data.templates[1]?.id, // Link to the second template
      templateVariables: {
        student_name: "Bob The Builder",
        student_id: "MIT/UR/003/12",
        date: new Date().toLocaleDateString(),
        issue_date: new Date().toLocaleDateString(),
        ref_no:
          "MIT-" +
          new Date().toISOString().slice(0, 10).replace(/-/g, "") +
          "-" +
          nanoid(6).toUpperCase(),
      },
    },
  ],
  settings: {
    // Retain existing settings, or update if necessary
    systemName: "MIT Mobile App - Seeded",
    emailFrom: "noreply@mit.edu",
    smtpServer: "smtp.mit.edu",
    smtpPort: "587",
    smtpUsername: "",
    smtpPassword: "",
  },
};

await db.write();
console.log("Database seeded successfully!");
