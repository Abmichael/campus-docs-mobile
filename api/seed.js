import { Low } from 'lowdb';
import { JSONFile } from 'lowdb/node';
import { nanoid } from 'nanoid';

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

// Initialize DB with seed data
await db.read();
db.data = {
  users: [{
    id: nanoid(),
    name: 'Admin User',
    email: 'admin@mit.edu',
    password: 'admin123', // In a real app, this would be hashed
    role: 'administrator',
    token: null
  }],
  requests: [],
  templates: [{
    id: nanoid(),
    title: 'Enrollment Verification',
    body: 'This is to certify that {{student_name}} is currently enrolled at MIT.\n\nReference No: {{ref_no}}\nIssue Date: {{issue_date}}',
    placeholders: ['student_name', 'ref_no', 'issue_date']
  }]
};

await db.write();
console.log('Database seeded successfully!'); 