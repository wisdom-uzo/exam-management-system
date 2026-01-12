# CBT Exam Management System 🎓

A **centralized offline LAN-based** Computer-Based Test (CBT) system built with Next.js, MySQL, and Tailwind CSS.

## System Overview

This project consists of **two separate Next.js applications**:

1. **Exam Management System** (Port 3000) - For administrators
2. **Student Portal** (Port 3001) - For students taking exams

Both applications connect to a **shared MySQL database** running on the server.

---

## Quick Start

### 1. Install Dependencies

```bash
# Exam Management
cd exam_management
npm install

# Student Portal
cd ../student
npm install
```

### 2. Set Up Database

```sql
CREATE DATABASE cbt_exam_db;
CREATE USER 'cbt_admin'@'localhost' IDENTIFIED BY 'YourPassword';
GRANT ALL PRIVILEGES ON cbt_exam_db.* TO 'cbt_admin'@'localhost';
FLUSH PRIVILEGES;
```

### 3. Configure Environment

Copy `.env.example` to `.env.local` in **both** directories and update with your credentials.

### 4. Start Applications

**Easy way:**
```bash
# From project root
start-server.bat
```

**Manual way:**
```bash
# Terminal 1 - Exam Management
cd exam_management
npm run dev

# Terminal 2 - Student Portal  
cd student
npm run dev
```

---

## Network Configuration

### On Server Machine

- **Exam Management**: `http://localhost:3000`
- **Student Portal**: `http://localhost:3001`

### From Student PCs (LAN)

- **Student Portal**: `http://[SERVER_IP]:3001`

Replace `[SERVER_IP]` with your actual server IP (find using `ipconfig`)

---

## Health Check Endpoints

Test connectivity:

- **Admin**: `http://localhost:3000/api/health`
- **Student**: `http://localhost:3001/api/health`

Expected response:
```json
{
  "status": "healthy",
  "database": {
    "success": true,
    "message": "Database connection successful"
  }
}
```

---

## Project Structure

```
cbt app web/
├── exam_management/          # Admin portal (Port 3000)
│   ├── app/
│   │   ├── api/
│   │   │   └── health/       # Health check endpoint
│   │   ├── globals.css
│   │   ├── layout.js
│   │   └── page.js
│   ├── lib/
│   │   └── db.js            # MySQL connection utility
│   ├── .env.example         # Environment template
│   └── package.json
│
├── student/                  # Student portal (Port 3001)
│   ├── app/
│   │   ├── api/
│   │   │   └── health/
│   │   ├── globals.css
│   │   ├── layout.js
│   │   └── page.js
│   ├── lib/
│   │   └── db.js
│   ├── .env.example
│   └── package.json
│
├── LAN_SETUP_GUIDE.md       # Detailed setup instructions
├── start-server.bat         # Windows startup script
└── README.md                # This file
```

---

## Technology Stack

- **Framework**: Next.js 16.1.1 (App Router)
- **UI**: React 19.2.3
- **Styling**: Tailwind CSS v4
- **Database**: MySQL (mysql2 driver)
- **Runtime**: Node.js 18+

---

## Firewall Configuration

Allow these ports on the server:

- **3000** - Exam Management
- **3001** - Student Portal  
- **3306** - MySQL (if needed)

**Quick PowerShell (Run as Admin):**
```powershell
New-NetFirewallRule -DisplayName "CBT Exam Management" -Direction Inbound -Protocol TCP -LocalPort 3000 -Action Allow
New-NetFirewallRule -DisplayName "CBT Student Portal" -Direction Inbound -Protocol TCP -LocalPort 3001 -Action Allow
```

---

## Documentation

📖 **Full setup guide**: See [LAN_SETUP_GUIDE.md](./LAN_SETUP_GUIDE.md)

Includes:
- MySQL installation
- Network configuration
- Troubleshooting
- Security best practices

---
