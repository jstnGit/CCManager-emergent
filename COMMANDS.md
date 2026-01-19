# Flutter Commands Reference

## Essential Commands

### Setup & Installation
```bash
# Install dependencies
flutter pub get

# Check Flutter installation
flutter doctor

# Check for issues with verbose output
flutter doctor -v

# List all connected devices
flutter devices
```

### Running the App
```bash
# Run in debug mode (default)
flutter run

# Run on specific device
flutter run -d <device-id>

# Run in release mode
flutter run --release

# Run in profile mode (for performance testing)
flutter run --profile

# Run with hot reload enabled
flutter run --hot
```

### Building the App

#### Android
```bash
# Build APK (debug)
flutter build apk

# Build APK (release)
flutter build apk --release

# Build App Bundle for Play Store
flutter build appbundle --release

# Build APK with split per ABI (smaller size)
flutter build apk --split-per-abi
```

#### iOS (Mac only)
```bash
# Build iOS app
flutter build ios

# Build iOS app (release)
flutter build ios --release
```

### Cleaning & Maintenance
```bash
# Clean build files
flutter clean

# Clean and reinstall dependencies
flutter clean && flutter pub get

# Repair pub cache
flutter pub cache repair

# Update Flutter SDK
flutter upgrade

# Update dependencies
flutter pub upgrade

# Check for outdated packages
flutter pub outdated
```

### Code Generation (Hive)
```bash
# Generate Hive adapters (if models are modified)
flutter pub run build_runner build

# Generate with conflict resolution
flutter pub run build_runner build --delete-conflicting-outputs

# Watch for changes and auto-generate
flutter pub run build_runner watch
```

### Code Quality
```bash
# Analyze code for issues
flutter analyze

# Format all Dart files
dart format lib/

# Format specific file
dart format lib/main.dart

# Check formatting without modifying
dart format --output=none --set-exit-if-changed lib/
```

### Testing
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter drive --target=test_driver/app.dart
```

### Debugging
```bash
# Show logs
flutter logs

# Show logs with filtering
flutter logs --device-id=<device-id>

# Attach to running app
flutter attach

# Take screenshot
flutter screenshot
```

### Performance
```bash
# Run with performance overlay
flutter run --profile

# Analyze app size
flutter build apk --analyze-size

# Check for performance issues
flutter run --trace-startup
```

### Device Management
```bash
# List emulators
flutter emulators

# Launch emulator
flutter emulators --launch <emulator-id>

# Create new emulator (Android)
flutter emulators --create
```

## Hot Reload Commands (During Development)

While the app is running in debug mode:

```
r     - Hot reload (reload code changes)
R     - Hot restart (restart app)
h     - Show help
c     - Clear screen
q     - Quit
d     - Detach (keep app running)
s     - Take screenshot
w     - Dump widget hierarchy
t     - Dump rendering tree
L     - Dump layer tree
S     - Dump accessibility tree
U     - Dump semantics tree
i     - Toggle widget inspector
p     - Toggle performance overlay
P     - Toggle platform mode
o     - Simulate OS settings change
b     - Toggle brightness
```

## Project-Specific Commands

### First Time Setup
```bash
# Complete setup sequence
flutter pub get
flutter run
```

### After Modifying Models
```bash
# Regenerate Hive adapters
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

### Clean Build (If Issues Occur)
```bash
# Full clean and rebuild
flutter clean
flutter pub get
flutter run
```

### Build for Production

#### Android
```bash
# Build release APK
flutter build apk --release

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release
```

#### iOS
```bash
# Build release IPA
flutter build ios --release

# Open in Xcode for signing and distribution
open ios/Runner.xcworkspace
```

## Useful Combinations

### Complete Reset
```bash
flutter clean
flutter pub cache repair
flutter pub get
flutter run
```

### Update Everything
```bash
flutter upgrade
flutter pub upgrade
flutter pub get
```

### Check Everything
```bash
flutter doctor -v
flutter analyze
flutter test
```

### Build All Platforms
```bash
flutter build apk --release
flutter build appbundle --release
flutter build ios --release  # Mac only
```

## Platform-Specific Commands

### Android
```bash
# Check Android licenses
flutter doctor --android-licenses

# Build with specific Android version
flutter build apk --target-platform android-arm64

# Clean Android build
cd android && ./gradlew clean && cd ..
```

### iOS (Mac only)
```bash
# Install CocoaPods dependencies
cd ios && pod install && cd ..

# Clean CocoaPods
cd ios && pod deintegrate && pod install && cd ..

# Update CocoaPods
cd ios && pod update && cd ..
```

## Troubleshooting Commands

### When Build Fails
```bash
flutter clean
flutter pub cache repair
flutter pub get
flutter run
```

### When Hot Reload Doesn't Work
```bash
# Press 'R' in terminal for hot restart
# Or stop and restart:
flutter run
```

### When Dependencies Have Issues
```bash
flutter pub cache repair
flutter pub get
```

### When Gradle Fails (Android)
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter run
```

### When CocoaPods Fails (iOS)
```bash
cd ios
rm -rf Pods
rm Podfile.lock
pod install
cd ..
flutter run
```

## Environment Commands

### Check Versions
```bash
flutter --version
dart --version
```

### Check Environment
```bash
flutter doctor -v
echo $FLUTTER_ROOT
echo $ANDROID_HOME
```

### Switch Flutter Channel
```bash
# List channels
flutter channel

# Switch to stable
flutter channel stable
flutter upgrade

# Switch to beta
flutter channel beta
flutter upgrade
```

## Quick Reference

| Task | Command |
|------|---------|
| Install dependencies | `flutter pub get` |
| Run app | `flutter run` |
| Hot reload | Press `r` |
| Hot restart | Press `R` |
| Clean build | `flutter clean` |
| Build APK | `flutter build apk --release` |
| Check setup | `flutter doctor` |
| Format code | `dart format lib/` |
| Analyze code | `flutter analyze` |
| Update Flutter | `flutter upgrade` |

## Tips

1. **Always run `flutter pub get` after modifying `pubspec.yaml`**
2. **Use `flutter clean` when switching branches or after major changes**
3. **Use hot reload (`r`) for UI changes, hot restart (`R`) for logic changes**
4. **Run `flutter doctor` regularly to check for issues**
5. **Use `--release` flag for production builds**
6. **Keep Flutter and dependencies updated**
7. **Use `flutter analyze` before committing code**

## Common Workflows

### Daily Development
```bash
flutter run          # Start development
# Make changes
# Press 'r' for hot reload
# Press 'R' for hot restart
```

### Before Committing
```bash
dart format lib/
flutter analyze
flutter test
```

### Preparing for Release
```bash
flutter clean
flutter pub get
flutter analyze
flutter test
flutter build apk --release
flutter build appbundle --release
```

### Troubleshooting
```bash
flutter doctor -v
flutter clean
flutter pub cache repair
flutter pub get
flutter run
```
