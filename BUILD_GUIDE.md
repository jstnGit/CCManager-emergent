# Build Guide - Platform-Specific Instructions

## 🖥️ Current System: Windows

You're running Windows, which supports building for:
- ✅ Android
- ✅ Windows Desktop
- ✅ Web
- ❌ iOS (requires macOS)

---

## 📱 Android Build (Available on Windows)

### Prerequisites
1. Install Android Studio
2. Install Android SDK
3. Accept Android licenses: `flutter doctor --android-licenses`

### Build Commands

#### Debug APK (for testing)
```bash
flutter build apk --debug
```
Output: `build/app/outputs/flutter-apk/app-debug.apk`

#### Release APK (for distribution)
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

#### App Bundle (for Google Play Store)
```bash
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab`

#### Split APKs (smaller file sizes)
```bash
flutter build apk --split-per-abi --release
```
Outputs:
- `app-armeabi-v7a-release.apk` (32-bit ARM)
- `app-arm64-v8a-release.apk` (64-bit ARM)
- `app-x86_64-release.apk` (64-bit Intel)

### Install on Device
```bash
# Install debug APK
flutter install

# Install specific APK
adb install build/app/outputs/flutter-apk/app-release.apk
```

---

## 🪟 Windows Desktop Build (Available on Windows)

### Prerequisites
- Visual Studio 2022 with Desktop development with C++

### Build Commands

#### Release Build
```bash
flutter build windows --release
```
Output: `build/windows/x64/runner/Release/`

#### Debug Build
```bash
flutter build windows --debug
```

### Run Windows App
```bash
flutter run -d windows
```

---

## 🌐 Web Build (Available on Windows)

### Build Commands

#### Release Build
```bash
flutter build web --release
```
Output: `build/web/`

#### With Web Renderer
```bash
# HTML renderer (better compatibility)
flutter build web --web-renderer html

# CanvasKit renderer (better performance)
flutter build web --web-renderer canvaskit
```

### Test Locally
```bash
flutter run -d chrome
```

### Deploy
Upload the `build/web/` folder to:
- Firebase Hosting
- GitHub Pages
- Netlify
- Vercel
- Any web server

---

## 🍎 iOS Build (Requires macOS)

### Prerequisites (Mac only)
1. macOS 12.0 or higher
2. Xcode 14.0 or higher
3. CocoaPods: `sudo gem install cocoapods`
4. Apple Developer Account (for distribution)

### Build Commands (Mac only)

#### Debug Build
```bash
flutter build ios --debug
```

#### Release Build
```bash
flutter build ios --release
```

#### Build IPA (for distribution)
```bash
flutter build ipa --release
```
Output: `build/ios/ipa/`

### Setup on Mac
```bash
# Install CocoaPods dependencies
cd ios
pod install
cd ..

# Open in Xcode
open ios/Runner.xcworkspace
```

### Sign and Deploy (in Xcode)
1. Open `ios/Runner.xcworkspace`
2. Select Runner > Signing & Capabilities
3. Select your Team
4. Archive: Product > Archive
5. Distribute to App Store or TestFlight

---

## 🔄 Alternative: Cloud Build for iOS

### Option 1: Codemagic (Recommended)

1. Sign up at https://codemagic.io
2. Connect your repository
3. Configure `codemagic.yaml`:

```yaml
workflows:
  ios-workflow:
    name: iOS Workflow
    max_build_duration: 60
    environment:
      flutter: stable
      xcode: latest
    scripts:
      - flutter pub get
      - flutter build ios --release --no-codesign
    artifacts:
      - build/ios/ipa/*.ipa
```

### Option 2: GitHub Actions

Create `.github/workflows/ios.yml`:

```yaml
name: iOS Build
on: [push]
jobs:
  build:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.0.0'
      - run: flutter pub get
      - run: flutter build ios --release --no-codesign
```

### Option 3: Bitrise

1. Sign up at https://bitrise.io
2. Add your repository
3. Select Flutter workflow
4. Configure iOS signing
5. Build automatically on push

---

## 📦 What You Can Build Right Now (Windows)

### 1. Android APK
```bash
# First, install Android Studio and SDK
# Then run:
flutter build apk --release
```

### 2. Windows Desktop App
```bash
flutter build windows --release
```

### 3. Web App
```bash
flutter build web --release
```

---

## 🚀 Recommended Next Steps

### For Testing on Windows:

1. **Build Android APK**
   ```bash
   flutter build apk --release
   ```

2. **Test on Android Emulator**
   ```bash
   flutter run
   ```

3. **Build Windows Desktop**
   ```bash
   flutter build windows --release
   ```

### For iOS (when you have Mac access):

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
   flutter build ios --release
   ```

---

## 📊 Build Comparison

| Platform | Windows | Mac | Linux | Cloud |
|----------|---------|-----|-------|-------|
| Android  | ✅      | ✅  | ✅    | ✅    |
| iOS      | ❌      | ✅  | ❌    | ✅    |
| Windows  | ✅      | ❌  | ❌    | ✅    |
| macOS    | ❌      | ✅  | ❌    | ✅    |
| Linux    | ❌      | ❌  | ✅    | ✅    |
| Web      | ✅      | ✅  | ✅    | ✅    |

---

## 💡 Tips

### For Android
- Use App Bundle (.aab) for Play Store
- Use APK (.apk) for direct distribution
- Split APKs reduce file size

### For iOS
- Need Apple Developer Account ($99/year)
- TestFlight for beta testing
- App Store Connect for distribution

### For All Platforms
- Always test release builds
- Check app size: `flutter build --analyze-size`
- Use `--release` for production
- Use `--profile` for performance testing

---

## 🆘 Troubleshooting

### Android Build Fails
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter build apk --release
```

### Windows Build Fails
```bash
flutter clean
flutter pub get
flutter build windows --release
```

### Web Build Fails
```bash
flutter clean
flutter pub get
flutter build web --release
```

---

## 📞 Need iOS Build?

Since you're on Windows, your options are:
1. Use a Mac (borrow, buy, or rent)
2. Use cloud CI/CD (Codemagic, GitHub Actions)
3. Use Mac cloud service (MacStadium, MacinCloud)
4. Partner with someone who has a Mac

For now, focus on Android and Windows builds which work great on your system!
