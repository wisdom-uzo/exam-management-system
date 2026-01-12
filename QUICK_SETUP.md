# Quick Setup Instructions

## Step 1: Create .env files

### For exam_management folder:
1. Copy `.env.example` to `.env`
2. The default values are already correct for local WampServer

### For student folder:
1. Copy `.env.example` to `.env.local`
2. Find your IP address:
   - Open Command Prompt
   - Type: `ipconfig`
   - Look for "IPv4 Address" (e.g., 192.168.1.100)
3. Replace `YOUR_IP` in `.env.local` with your actual IP address

## Step 2: Start the systems

### Start Exam Management:
```bash
cd exam_management
npm run dev -- -H 0.0.0.0 -p 3000
```

### Start Student Portal:
```bash
cd student
npm run dev -- -H 0.0.0.0 -p 3001
```

## Step 3: Access the systems

- **Admin (on your computer)**: http://localhost:3000
- **Students (on network)**: http://YOUR_IP:3001

---

**Note**: The `next.config.mjs` files are already configured for network access!
