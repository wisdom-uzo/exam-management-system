# Fix MySQL Network Access Error

## Problem
Error: `Host 'devwiz' is not allowed to connect to this MySQL server`

This means MySQL is blocking network connections. We need to allow the 'root' user to connect from any host.

## Solution: Run SQL Commands in phpMyAdmin

### Step 1: Open phpMyAdmin
1. Click WampServer icon in system tray
2. Click **"phpMyAdmin"**
3. Login (username: `root`, password: leave blank)

### Step 2: Click "SQL" Tab
At the top of phpMyAdmin, click the **"SQL"** tab

### Step 3: Run These SQL Commands

**Copy and paste these commands ONE BY ONE:**

```sql
-- Allow root user from any host
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '';
```

Click **"Go"**, then run:

```sql
-- Grant all privileges
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
```

Click **"Go"**, then run:

```sql
-- Reload privileges
FLUSH PRIVILEGES;
```

Click **"Go"**

### Step 4: Restart MySQL
1. Click WampServer icon
2. Go to: **MySQL** → **Service** → **Restart Service**
3. Wait for icon to turn green again

---

## Alternative: Quick Fix via Command Line

If phpMyAdmin doesn't work, use MySQL command line:

1. Click WampServer icon
2. Click **"MySQL Console"** or **"MySQL" → "MySQL Console"**
3. Press Enter (no password)
4. Copy and paste these commands:

```sql
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EXIT;
```

---

## Test the Fix

After running the SQL commands:

1. **Restart both applications:**
   - Stop the running terminals (Ctrl+C)
   - Start exam_management: `npm run dev -- -H 0.0.0.0 -p 3000`
   - Start student: `npm run dev -- -H 0.0.0.0 -p 3001`

2. **Try logging in again**
   - Go to: `http://10.96.80.17:3001`
   - Login with a student account

✅ **Should work now!**

---

## What These Commands Do

- `CREATE USER 'root'@'%'` - Creates root user that can connect from ANY host (% = wildcard)
- `GRANT ALL PRIVILEGES` - Gives full database access
- `FLUSH PRIVILEGES` - Applies the changes immediately

The `%` means "any host" - so your application can connect from the network, not just localhost.
