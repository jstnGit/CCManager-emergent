# iOS Build Instructions (Windows Users)

## ❌ Cannot Build on Windows

You're on **Windows**, and iOS builds **require macOS with Xcode**. This is an Apple requirement.

## ✅ Your Options to Build iOS

### Option 1: GitHub Actions (FREE) ⭐ RECOMMENDED

I've created the workflow file for you!

**Steps:**

1. **Push your code to GitHub**
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
   git push -u origin main
   ```

2. **GitHub will automatically build iOS**
   - Go to your repo on GitHub
   - Click "Actions" tab
   - See the iOS build running
   - Wait ~10-15 minutes

3. **Download the IPA**
   - Click on the completed workflow
   - Scroll to "Artifacts"
   - Download "ios-app-unsigned"
   - Extract the IPA file

4. **Install on iPhone**
   - Use AltStore, Sideloadly, or Xcode
   - See instructions below

**File Created:** `.github/workflows/ios-build.yml`

---

### Option 2: Codemagic (FREE TIER)

I've created the config file for you!

**Steps:**

1. **Sign up at Codemagic**
   - Go to: https://codemagic.io
   - Sign up with GitHub account

2. **Connect your repository**
   - Click "Add application"
   - Select your GitHub repo
   - Codemagic detects `codemagic.yaml`

3. **Configure (if needed)**
   - Add Apple Developer credentials (optional)
   - Or build without signing

4. **Start build**
   - Click "Start new build"
   - Wait ~10-15 minutes
   - Download IPA from artifacts

**File Created:** `codemagic.yaml`

---

### Option 3: Use a Mac

**Borrow or rent a Mac:**

1. **On Mac, install Xcode**
   ```bash
   xcode-select --install
   ```

2. **Install CocoaPods**
   ```bash
   sudo gem install cocoapods
   ```

3. **Build iOS**
   ```bash
   cd your_project
   flutter pub get
   cd ios
   pod install
   cd ..
   flutter build ios --release
   ```

4. **Create IPA**
   ```bash
   flutter build ipa --release
   ```

5. **Output:**
   ```
   build/ios/ipa/credit_card_tracker.ipa
   ```

---

## 📱 Installing IPA on iPhone

### Method 1: AltStore (No Mac)

1. **Download AltStore**
   - https://altstore.io
   - Install on Windows PC

2. **Install AltServer on iPhone**
   - Connect iPhone via USB
   - Follow AltStore setup

3. **Install IPA**
   - Open AltStore on iPhone
   - Tap "+" 
   - Select IPA file
   - App installs!

**Note:** App expires after 7 days, need to refresh

---

### Method 2: Sideloadly (No Mac)

1. **Download Sideloadly**
   - https://sideloadly.io
   - Install on Windows

2. **Connect iPhone**
   - USB connection
   - Trust computer

3. **Install IPA**
   - Drag IPA to Sideloadly
   - Enter Apple ID
   - Click "Start"

**Note:** App expires after 7 days

---

### Method 3: Xcode (Mac Required)

1. **Connect iPhone to Mac**
2. **Open Xcode**
3. **Window → Devices and Simulators**
4. **Select iPhone**
5. **Click "+" under Installed Apps**
6. **Select IPA file**
7. **App installs!**

---

### Method 4: TestFlight (Best)

**Requirements:**
- Apple Developer Account ($99/year)
- App uploaded to App Store Connect

**Benefits:**
- No expiration
- Easy distribution
- Professional

**Steps:**
1. Upload IPA to App Store Connect
2. Add to TestFlight
3. Invite testers
4. Install via TestFlight app

---

## 🚀 Quick Start: GitHub Actions

### 1. Initialize Git (if not already)
```bash
git init
git add .
git commit -m "Add iOS build workflow"
```

### 2. Create GitHub Repository
- Go to: https://github.com/new
- Create new repository
- Copy the repository URL

### 3. Push Code
```bash
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
git branch -M main
git push -u origin main
```

### 4. Check Actions
- Go to your repo on GitHub
- Click "Actions" tab
- See "iOS Build" workflow running
- Wait for completion (~10-15 minutes)

### 5. Download IPA
- Click on completed workflow
- Scroll to "Artifacts"
- Download "ios-app-unsigned"
- Extract the IPA file

### 6. Install on iPhone
- Use AltStore or Sideloadly
- Follow instructions above

---

## 📊 Comparison

| Method | Cost | Time | Mac Needed | Best For |
|--------|------|------|------------|----------|
| GitHub Actions | Free | 10-15 min | No | Most users |
| Codemagic | Free tier | 10-15 min | No | Professional |
| Borrow Mac | Free | 5 min | Yes | Quick test |
| Rent Mac Cloud | $30/mo | 5 min | No | Regular builds |
| Buy Mac Mini | $300-600 | 5 min | No | Long-term |

---

## ⚠️ Important Notes

### About Unsigned IPA
- GitHub Actions builds **unsigned IPA**
- Can install via AltStore/Sideloadly
- Expires after 7 days (free Apple ID)
- Need to refresh weekly

### About Signing
- For App Store: Need Apple Developer ($99/year)
- For personal use: Free Apple ID works
- For TestFlight: Need Apple Developer

### About Expiration
- Free Apple ID: 7 days
- Apple Developer: No expiration
- Refresh via AltStore to extend

---

## 🎯 Recommended Path for You

Since you're on Windows:

### Immediate (Free):
1. ✅ **Push code to GitHub**
2. ✅ **Let GitHub Actions build iOS**
3. ✅ **Download IPA**
4. ✅ **Install via AltStore**

### Steps:
```bash
# 1. Initialize git
git init
git add .
git commit -m "Initial commit"

# 2. Create repo on GitHub, then:
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
git push -u origin main

# 3. Go to GitHub → Actions → Wait for build
# 4. Download IPA from Artifacts
# 5. Install via AltStore
```

---

## 📝 Files Created

I've created these files for you:

1. **`.github/workflows/ios-build.yml`**
   - GitHub Actions workflow
   - Builds iOS automatically
   - Free for public repos

2. **`codemagic.yaml`**
   - Codemagic configuration
   - Alternative to GitHub Actions
   - Free tier available

3. **`IOS_BUILD_INSTRUCTIONS.md`**
   - This file
   - Complete instructions

---

## ✅ Summary

**You cannot build iOS on Windows directly.**

**Best solution:**
1. Push code to GitHub
2. GitHub Actions builds iOS (free)
3. Download IPA
4. Install via AltStore

**Alternative:**
- Use Codemagic
- Borrow/rent a Mac
- Use cloud Mac service

**For distribution:**
- Get Apple Developer Account ($99/year)
- Use TestFlight
- No expiration, professional

---

## 🆘 Need Help?

### If GitHub Actions fails:
- Check the Actions log
- Make sure workflow file is in `.github/workflows/`
- Ensure Flutter version is correct

### If IPA won't install:
- Use AltStore (easiest)
- Make sure iPhone trusts computer
- Check Apple ID is correct

### If app expires:
- Open AltStore on iPhone
- Tap "Refresh All"
- Extends for another 7 days

---

## 🎉 Next Steps

1. **Push your code to GitHub**
2. **Wait for iOS build to complete**
3. **Download the IPA**
4. **Install on your iPhone**
5. **Test your app!**

Your Credit Card Expense Tracker will work perfectly on iOS! 🚀

---

## 📞 Support

- GitHub Actions: https://docs.github.com/en/actions
- Codemagic: https://docs.codemagic.io
- AltStore: https://altstore.io
- Flutter iOS: https://flutter.dev/docs/deployment/ios

Good luck! 📱
