# Campus Docs Mobile 📲

<img src="https://img.shields.io/badge/Flutter-5.0-blue" />
<img src="https://img.shields.io/badge/Express.js-4.19-green" />
<img src="https://img.shields.io/badge/LowDB-JSON-lightgrey" />

A cross-platform Flutter app backed by a super-lean Express API (LowDB) that lets university staff issue official letters while students & alumni request transcripts, degree copies, and more.

---

## ✨ Features
- **Role-based UX** – staff, administrator, student, alumni
- **Letter templates** with `{{placeholder}}` injection + PDF render hook
- **Transcript / degree request workflow** with status tracking
- Local JSON storage for instant prototyping (swap in real DB later)
- Light-theme default (dark optional)

---

## 🗂️ Project structure
```

my\_app/
├─ flutter/            # Flutter sources (lib/, android/, ios/, web/)
└─ api/                # Minimal Node backend
├─ index.js
├─ db.json          # auto-generated, git-ignored
└─ package.json

````

---

## 🚀 Quick start

```bash
# 1. Clone
git clone https://github.com/your-org/campus-docs-mobile.git
cd campus-docs-mobile

# 2. Flutter app
cd flutter
flutter pub get
flutter run            # or flutter run -d chrome

# 3. Backend (new terminal tab)
cd ../api
npm i
npm start              # serves on http://localhost:4000
````

Backend endpoints (all JSON):

| Method | Endpoint            | Notes                     |
| ------ | ------------------- | ------------------------- |
| POST   | `/auth/login`       | returns `{ token, user }` |
| GET    | `/requests`         | list user requests        |
| POST   | `/requests`         | create new request        |
| PATCH  | `/requests/:id`     | update `status`           |
| GET    | `/letter-templates` | list all templates        |
| POST   | `/letter-templates` | create template           |

---

## 🛠️ Tech stack

| Layer    | Library                               | Why                             |
| -------- | ------------------------------------- | ------------------------------- |
| Frontend | Flutter 3 · Riverpod · GoRouter · Dio | Modern, testable, multiplatform |
| Backend  | Express 5 · LowDB · Nanoid            | 1-file API, JSON persistence    |
| DevOps   | GitHub Actions (lint + build)         | CI checks                       |

---

## 🧪 Tests

```bash
# Flutter
flutter test

# Backend
cd api && npm test   # placeholder Jest suite
```

---
