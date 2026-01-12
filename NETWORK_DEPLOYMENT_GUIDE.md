# 🌐 CBT Exam System - Network Deployment Guide

## Simple Setup for Local Network (LAN)

This guide shows you how to run your CBT exam system on a local network where:
- **Admin Computer** (your system) runs the exam management + WampServer
- **Student Computers** connect through router to take exams

---

## 📋 What You Need

✅ **Admin Computer** (Your System):
- WampServer installed and running
- Exam Management system
- Student Portal system
- Router connection

✅ **Student Computers**:
- Connected to same router/network
- Web browser (Chrome, Edge, Firefox)

---

## 🚀 Step-by-Step Setup

### **STEP 1: Setup WampServer Database**

1. **Start WampServer** on your admin computer
2. **Open phpMyAdmin**: Click WampServer icon → phpMyAdmin
3. **Create Database**:
   - Click "New" on left sidebar
   - Database name: `cbt_exam_db`
   - Click "Create"

4. **Import Database Schema**:
   - Click on `cbt_exam_db` database
   - Click "Import" tab
   - Choose file: `exam_management/lib/schema.sql`
   - Click "Go"

✅ **Database is now ready!**

---

### **STEP 2: Find Your Computer's IP Address**

1. **Open Command Prompt** (Press `Win + R`, type `cmd`, press Enter)
2. **Type**: `ipconfig`
3. **Look for**: "IPv4 Address" under your network adapter
   - Example: `192.168.1.100`  255.255.255.0
4. **Write down this IP address** - you'll need it!

---

### **STEP 3: Configure Admin System (Exam Management)**

1. **Create `.env` file** in `exam_management` folder:

```env
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=
DB_NAME=cbt_exam_db
```

2. **Update `next.config.js`** in `exam_management` folder:

```javascript
/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'standalone',
  // Allow access from network
  async headers() {
    return [
      {
        source: '/:path*',
        headers: [
          { key: 'Access-Control-Allow-Origin', value: '*' },
        ],
      },
    ];
  },
};

export default nextConfig;
```

3. **Start Exam Management**:
```bash
cd exam_management
npm run dev -- -H 0.0.0.0 -p 3000
```

✅ **Admin system running on**: `http://YOUR_IP:3000`
   - Example: `http://192.168.1.100:3000`

---

### **STEP 4: Configure Student System**

1. **Create `.env.local` file** in `student` folder:

```env
NEXT_PUBLIC_API_URL=http://YOUR_IP:3000
DB_HOST=YOUR_IP
DB_PORT=3306
DB_USER=root
DB_PASSWORD=
DB_NAME=cbt_exam_db
```

**Replace `YOUR_IP`** with the IP address from Step 2!
   - Example: `192.168.1.100`

2. **Update `next.config.js`** in `student` folder:

```javascript
/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'standalone',
};

export default nextConfig;
```

3. **Start Student Portal**:
```bash
cd student
npm run dev -- -H 0.0.0.0 -p 3001
```

✅ **Student portal running on**: `http://YOUR_IP:3001`
   - Example: `http://192.168.1.100:3001`

---

### **STEP 5: Configure WampServer for Network Access**

1. **Allow Network Access**:
   - Click WampServer icon (green)
   - Go to: Apache → httpd.conf
   - Find line: `Require local`
   - Change to: `Require all granted`
   - Save file

2. **Restart Apache**:
   - Click WampServer icon
   - Apache → Service → Restart Service

3. **Check Firewall**:
   - Windows Firewall might block connections
   - Allow ports: `3000`, `3001`, `3306`

---

### **STEP 6: Test Connection**

**On Admin Computer:**
1. Open browser
2. Go to: `http://localhost:3000` (Exam Management)
3. Go to: `http://localhost:3001` (Student Portal)

**On Student Computer:**
1. Open browser
2. Go to: `http://192.168.1.100:3001` (Replace with your IP)
3. You should see the login page!

---

## 🎯 Quick Reference

| System | URL | Purpose |
|--------|-----|---------|
| **Exam Management** | `http://YOUR_IP:3000` | Admin creates exams |
| **Student Portal** | `http://YOUR_IP:3001` | Students take exams |
| **Database** | `localhost:3306` | WampServer MySQL |

---

## 🔧 Common Issues & Solutions

### ❌ **Students can't connect**

**Solution 1: Check Firewall**
```bash
# Open Command Prompt as Administrator
netsh advfirewall firewall add rule name="CBT Exam" dir=in action=allow protocol=TCP localport=3000,3001,3306
```

**Solution 2: Verify IP Address**
- Make sure you're using the correct IP
- Run `ipconfig` again to confirm

**Solution 3: Check WampServer**
- WampServer icon should be GREEN
- If orange/red, click icon → Put Online

### ❌ **Database connection error**

**Solution:**
1. Check WampServer is running (green icon)
2. Verify database name is `cbt_exam_db`
3. Check `.env` file has correct settings

### ❌ **"Cannot GET /" error**

**Solution:**
- Make sure both systems are running
- Check you used `-H 0.0.0.0` when starting

---

## 📱 For Students

**To access the exam:**
1. Connect to the school/office WiFi or network
2. Open any web browser
3. Type in address bar: `http://192.168.1.100:3001` (Use your actual IP)
4. Login with your matric number and password
5. Start exam!

---

## 🎓 Admin Quick Start

**Every day before exams:**

1. **Start WampServer** (wait for green icon)
2. **Start Exam Management**:
   ```bash
   cd exam_management
   npm run dev -- -H 0.0.0.0 -p 3000
   ```
3. **Start Student Portal**:
   ```bash
   cd student
   npm run dev -- -H 0.0.0.0 -p 3001
   ```
4. **Tell students the URL**: `http://YOUR_IP:3001`

---

## 💡 Pro Tips

✅ **Use Static IP**: Set your admin computer to use a static IP so it doesn't change
✅ **Test First**: Test with one student computer before exam day
✅ **Backup Database**: Export database regularly from phpMyAdmin
✅ **Print Student URL**: Print the student URL on paper for easy reference
✅ **Keep Systems Running**: Don't close the command prompts during exams!

---

## 🆘 Need Help?

**Check if systems are running:**
- Open browser on admin computer
- Go to `http://localhost:3000` - Should see exam management
- Go to `http://localhost:3001` - Should see student login

**Check network connection:**
- Ping from student computer: `ping YOUR_IP`
- Should get replies

**Still stuck?**
- Restart WampServer
- Restart both Next.js applications
- Check Windows Firewall settings

---

## ✅ Checklist Before Exam Day

- [ ] WampServer installed and running (green icon)
- [ ] Database created and schema imported
- [ ] IP address noted down
- [ ] `.env` files created with correct IP
- [ ] Exam Management running on port 3000
- [ ] Student Portal running on port 3001
- [ ] Tested from at least one student computer
- [ ] Firewall configured to allow connections
- [ ] Student URL printed/written for reference
- [ ] Exams created and activated in admin panel

---

**You're all set! 🎉**

Students can now access the exam system from any computer on your network!
