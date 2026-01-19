# Android Setup Guide for Windows

## Current Status
✅ Android SDK installed (version 36.1.0)
❌ Command-line tools missing
❌ Licenses not accepted

## Quick Fix (Recommended)

### Option 1: Using Android Studio (Easiest)

1. **Open Android Studio**
   - If not installed, download from: https://developer.android.com/studio

2. **Open SDK Manager**
   - Click on "More Actions" or "Configure" on welcome screen
   - Select "SDK Manager"
   - Or go to: File → Settings → Appearance & Behavior → System Settings → Android SDK

3. **Install Command-line Tools**
   - Click on "SDK Tools" tab
   - Check ☑ "Android SDK Command-line Tools (latest)"
   - Click "Apply" or "OK"
   - Wait for installation to complete

4. **Accept Licenses**
   - Open Command Prompt or PowerShell
   - Run:
   ```bash
   flutter doctor --android-licenses
   ```
   - Type "y" and press Enter for each license

5. **Verify Setup**
   ```bash
   flutter doctor
   ```

### Option 2: Manual Installation (Advanced)

1. **Download Command-line Tools**
   - Go to: https://developer.android.com/studio#command-line-tools-only
   - Download "Command line tools only" for Windows
   - File: `commandlinetools-win-XXXXXXX_latest.zip`

2. **Extract and Install**
   - Extract the ZIP file
   - Create folder: `C:\Android\cmdline-tools\latest`
   - Move contents to the `latest` folder

3. **Set Environment Variables**
   - Open System Properties (Win + Pause/Break)
   - Click "Advanced system settings"
   - Click "Environment Variables"
   - Under "System variables", click "New"
   - Variable name: `ANDROID_HOME`
   - Variable value: `C:\Users\[YourUsername]\AppData\Local\Android\Sdk`
   - Click OK

4. **Add to PATH**
   - In Environment Variables, find "Path" under System variables
   - Click "Edit"
   - Click "New"
   - Add: `%ANDROID_HOME%\cmdline-tools\latest\bin`
   - Add: `%ANDROID_HOME%\platform-tools`
   - Click OK

5. **Accept Licenses**
   - Open NEW Command Prompt (to load new environment variables)
   - Run:
   ```bash
   flutter doctor --android-licenses
   ```
   - Type "y" for each license

6. **Verify**
   ```bash
   flutter doctor
   ```

## Step-by-Step: Android Studio Method (Detailed)

### Step 1: Launch Android Studio
- Open Android Studio
- You'll see the welcome screen

### Step 2: Access SDK Manager
**If on Welcome Screen:**
- Click "More Actions" (three dots)
- Select "SDK Manager"

**If Project is Open:**
- Go to File → Settings (or Ctrl + Alt + S)
- Navigate to: Appearance & Behavior → System Settings → Android SDK

### Step 3: Install Command-line Tools
In SDK Manager window:

1. Click on **"SDK Tools"** tab (top of window)

2. Look for **"Android SDK Command-line Tools (latest)"**
   - If unchecked, check the box ☑

3. Also verify these are installed:
   - ☑ Android SDK Build-Tools
   - ☑ Android SDK Platform-Tools
   - ☑ Android Emulator (if you want to use emulator)

4. Click **"Apply"** or **"OK"** button

5. Accept the license agreement in the popup

6. Wait for download and installation (may take a few minutes)

7. Click **"Finish"** when done

### Step 4: Accept Android Licenses

1. **Open Command Prompt or PowerShell**
   - Press Win + R
   - Type `cmd` or `powershell`
   - Press Enter

2. **Run License Command**
   ```bash
   flutter doctor --android-licenses
   ```

3. **Accept Each License**
   - You'll see several license agreements
   - Type `y` and press Enter for each one
   - Example:
   ```
   Accept? (y/N): y
   ```

4. **Wait for Completion**
   - Should see: "All SDK package licenses accepted"

### Step 5: Verify Installation

```bash
flutter doctor
```

**Expected Output:**
```
[✓] Android toolchain - develop for Android devices (Android SDK version 36.1.0)
```

## Troubleshooting

### Issue: "Android sdkmanager not found"
**Solution:** Install command-line tools via Android Studio SDK Manager

### Issue: "ANDROID_HOME not set"
**Solution:** 
1. Find your Android SDK location (usually `C:\Users\[Username]\AppData\Local\Android\Sdk`)
2. Set ANDROID_HOME environment variable
3. Restart Command Prompt

### Issue: "flutter doctor --android-licenses" doesn't work
**Solution:**
1. Make sure command-line tools are installed
2. Restart Command Prompt after installing
3. Try running as Administrator

### Issue: Can't find Android Studio
**Download from:** https://developer.android.com/studio

### Issue: Command-line tools installed but still not working
**Solution:**
1. Close all Command Prompt/PowerShell windows
2. Open a NEW window
3. Try again

## Quick Commands Reference

```bash
# Check Flutter setup
flutter doctor

# Accept Android licenses
flutter doctor --android-licenses

# Check Android SDK location
flutter config --android-sdk

# List available devices
flutter devices

# Run on Android device
flutter run

# Build Android APK
flutter build apk --release
```

## After Setup is Complete

### Test Your Setup

1. **Connect Android Device** (or start emulator)
   ```bash
   flutter devices
   ```

2. **Run the App**
   ```bash
   flutter run
   ```

3. **Build APK**
   ```bash
   flutter build apk --release
   ```

## What You'll Be Able to Do

After completing setup:
- ✅ Run app on Android devices
- ✅ Run app on Android emulator
- ✅ Build Android APK files
- ✅ Build Android App Bundle for Play Store
- ✅ Debug on Android devices

## Estimated Time

- **Using Android Studio:** 5-10 minutes
- **Manual Installation:** 15-20 minutes

## Need Help?

### Check Current Status
```bash
flutter doctor -v
```

This shows detailed information about what's missing.

### Common Paths

**Android SDK Location:**
- Windows: `C:\Users\[Username]\AppData\Local\Android\Sdk`

**Command-line Tools:**
- Should be in: `[SDK Location]\cmdline-tools\latest`

**Platform Tools:**
- Should be in: `[SDK Location]\platform-tools`

## Summary

**Easiest Method:**
1. Open Android Studio
2. Go to SDK Manager
3. Install "Android SDK Command-line Tools"
4. Run `flutter doctor --android-licenses`
5. Type "y" for each license
6. Done! ✅

**Then you can:**
```bash
flutter run              # Run on device
flutter build apk        # Build APK
```

Good luck! 🚀
