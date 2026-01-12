# WampServer Network Access - Simple Guide

## Method 1: Put WampServer Online (Easiest)

1. **Look at WampServer icon** in system tray (bottom-right corner)
2. **Left-click** the WampServer icon
3. Click **"Put Online"**
4. Icon should turn **GREEN**

✅ **That's it! WampServer is now accessible on the network.**

---

## Method 2: Configure MySQL for Network Access

If Method 1 doesn't work, configure MySQL directly:

### Step 1: Open phpMyAdmin
1. Click WampServer icon
2. Click **"phpMyAdmin"**

### Step 2: Create Network User
1. In phpMyAdmin, click **"User accounts"** tab at the top
2. Click **"Add user account"** at the bottom
3. Fill in:
   - **User name**: `root` (or create new user like `cbt_user`)
   - **Host name**: Select **"Any host"** from dropdown (shows as `%`)
   - **Password**: Leave blank (or set a password)
4. Scroll down to **"Global privileges"**
5. Click **"Check all"**
6. Click **"Go"** at the bottom

✅ **MySQL now accepts connections from network!**

---

## Method 3: Windows Firewall (If students still can't connect)

### Open Command Prompt as Administrator:
1. Press `Win + X`
2. Click **"Command Prompt (Admin)"** or **"PowerShell (Admin)"**

### Run these commands:
```bash
netsh advfirewall firewall add rule name="CBT Exam Management" dir=in action=allow protocol=TCP localport=3000

netsh advfirewall firewall add rule name="CBT Student Portal" dir=in action=allow protocol=TCP localport=3001

netsh advfirewall firewall add rule name="MySQL Database" dir=in action=allow protocol=TCP localport=3306
```

✅ **Firewall now allows connections!**

---

## Quick Test

### On Your Computer:
1. Open browser
2. Go to: `http://10.96.80.17:3001`
3. Should see student login page

### On Another Computer (same network):
1. Open browser
2. Go to: `http://10.96.80.17:3001`
3. Should see student login page

---

## Troubleshooting

### ❌ Students see "Can't connect" or "ERR_CONNECTION_REFUSED"

**Try these in order:**

1. **Check WampServer is Online**
   - Icon should be GREEN
   - If orange/red, click icon → "Put Online"

2. **Check both systems are running**
   - Look at your command prompts
   - Should see "Ready in X seconds"
   - No errors

3. **Restart WampServer**
   - Right-click WampServer icon
   - Click "Exit"
   - Start WampServer again
   - Wait for GREEN icon

4. **Check IP address hasn't changed**
   - Run `ipconfig` again
   - Verify still `10.96.80.17`

5. **Disable Windows Firewall temporarily** (for testing)
   - Open Windows Settings
   - Search "Firewall"
   - Turn off temporarily
   - Test if students can connect
   - Turn back on and use Method 3 above

---

## Current Setup Summary

**Your IP**: `10.96.80.17`

**Admin URLs** (on your computer):
- Exam Management: `http://localhost:3000`
- Student Portal: `http://localhost:3001`

**Student URL** (on network computers):
- Student Portal: `http://10.96.80.17:3001`

**Database**: 
- WampServer MySQL on `localhost:3306`
- Database name: `cbt_exam_db`

---

## What Students Need to Know

Just tell students:
1. Connect to the WiFi/network
2. Open any browser
3. Type: `http://10.96.80.17:3001`
4. Login with matric number and password

**That's all!** 🎉
