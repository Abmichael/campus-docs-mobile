import { Low } from 'lowdb';
import { JSONFile } from 'lowdb/node';
import { nanoid } from 'nanoid';

const adapter = new JSONFile('db.json');
const defaultData = {
  users: [],
  requests: [],
  templates: [],
  auditLogs: [],
  letters: [],
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
  requests: [],  templates: [{
    id: nanoid(),
    title: 'Enrollment Verification',
    body: 'This is to certify that [student_name] is currently enrolled at MIT.\n\n',
    placeholders: ['student_name']
  }]
};

await db.write();
console.log('Database seeded successfully!'); 