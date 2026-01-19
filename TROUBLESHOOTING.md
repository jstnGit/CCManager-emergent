# Troubleshooting Guide

## Common Issues and Solutions

### Build Issues

#### Issue: "Packages get failed"
```
Error: pub get failed
```
**Solution:**
```bash
flutter clean
flutter pub cache repair
flutter pub get
```

#### Issue: "Version solving failed"
```
Error: version solving failed
```
**Solution:**
1. Check your Flutter version: `flutter --version`
2. Upgrade Flutter: `flutter upgrade`
3. Try again: `flutter pub get`

#### Issue: "Build failed with Gradle error" (Android)
```
Error: Gradle build failed
```
**Solution:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Hive Issues

#### Issue: "HiveError: Box not found"
```
HiveError: Box has already been closed
```
**Solution:**
The app initializes Hive in `main.dart`. Make sure:
1. `DatabaseService.init()` is called before `runApp()`
2. You're not closing boxes manually
3. Restart the app

#### Issue: "Type adapter not registered"
```
HiveError: Cannot read, unknown typeId
```
**Solution:**
The adapters are already generated. If you modified models:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

#### Issue: "Cannot write to Hive"
```
HiveError: This box is read-only
```
**Solution:**
Check that you're using the correct box methods:
- Use `put()` not `add()` for updates
- Use `delete()` for removals

### Provider Issues

#### Issue: "Provider not found"
```
Error: Could not find the correct Provider<T>
```
**Solution:**
Make sure `MultiProvider` is set up in `main.dart`:
```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => CreditCardProvider()),
    ChangeNotifierProvider(create: (_) => ExpenseProvider()),
  ],
  child: MaterialApp(...),
)
```

#### Issue: "setState called during build"
```
Error: setState() called during build
```
**Solution:**
Use `listen: false` when calling provider methods:
```dart
Provider.of<ExpenseProvider>(context, listen: false).addExpense(expense);
```

### UI Issues

#### Issue: "RenderFlex overflowed"
```
Error: A RenderFlex overflowed by X pixels
```
**Solution:**
This shouldn't happen with the current implementation, but if it does:
1. Wrap the widget in `SingleChildScrollView`
2. Use `Expanded` or `Flexible` widgets
3. Check for hardcoded heights

#### Issue: "Keyboard covers input fields"
```
Problem: Keyboard hides text fields
```
**Solution:**
Already handled with `SingleChildScrollView` in forms. If issue persists:
```dart
Scaffold(
  resizeToAvoidBottomInset: true,
  body: SingleChildScrollView(...),
)
```

#### Issue: "Date picker not showing"
```
Problem: showDatePicker doesn't appear
```
**Solution:**
Make sure you're using `async/await`:
```dart
final DateTime? picked = await showDatePicker(...);
```

### Data Issues

#### Issue: "Expenses not showing after restart"
```
Problem: Data disappears after closing app
```
**Solution:**
1. Check that Hive is initialized: `await Hive.initFlutter()`
2. Check that boxes are opened: `await Hive.openBox<ExpenseModel>('expenses')`
3. Verify data is being saved: Add debug prints in provider methods

#### Issue: "Used credit not updating"
```
Problem: Used credit shows wrong amount
```
**Solution:**
1. Check that `notifyListeners()` is called after updates
2. Verify the calculation in `ExpenseProvider.totalUnpaidAmount`
3. Make sure paid expenses have `isPaid = true`

#### Issue: "Duplicate expenses appearing"
```
Problem: Same expense shows multiple times
```
**Solution:**
Check that you're using unique IDs:
```dart
id: DateTime.now().millisecondsSinceEpoch.toString()
```

### Navigation Issues

#### Issue: "Navigator operation failed"
```
Error: Navigator operation requested with a context that does not include a Navigator
```
**Solution:**
Make sure you're using the correct context:
```dart
Navigator.push(
  context,  // Use the context from build method
  MaterialPageRoute(builder: (context) => AddExpenseScreen()),
);
```

#### Issue: "Screen doesn't update after navigation"
```
Problem: Changes don't show after going back
```
**Solution:**
Already handled with Provider. If issue persists:
1. Check that `Consumer` widgets are used
2. Verify `notifyListeners()` is called
3. Use `listen: true` (default) when reading provider

### Performance Issues

#### Issue: "App is slow or laggy"
```
Problem: UI feels sluggish
```
**Solution:**
1. Use `const` constructors where possible
2. Avoid rebuilding entire widget tree
3. Use `Consumer` instead of `Provider.of` for specific widgets
4. Check for infinite loops in build methods

#### Issue: "ListView not scrolling smoothly"
```
Problem: Scroll performance is poor
```
**Solution:**
Already using `ListView.builder` which is optimized. If issue persists:
1. Reduce widget complexity in list items
2. Use `RepaintBoundary` for complex items
3. Check for expensive operations in build methods

### Platform-Specific Issues

#### Android

**Issue: "App crashes on startup"**
```
Solution:
1. Check minSdkVersion in android/app/build.gradle (should be 21+)
2. Run: flutter clean && flutter pub get
3. Rebuild: flutter run
```

**Issue: "Permission denied errors"**
```
Solution:
This app doesn't need any permissions. If you see this:
1. Check android/app/src/main/AndroidManifest.xml
2. Remove any unnecessary permissions
```

#### iOS

**Issue: "CocoaPods error"**
```
Solution:
cd ios
pod deintegrate
pod install
cd ..
flutter run
```

**Issue: "Signing error"**
```
Solution:
1. Open ios/Runner.xcworkspace in Xcode
2. Select Runner > Signing & Capabilities
3. Select your development team
```

### Development Issues

#### Issue: "Hot reload not working"
```
Problem: Changes don't appear after hot reload
```
**Solution:**
Some changes require hot restart:
- Model changes
- Provider changes
- main.dart changes

Press `Shift + R` for hot restart or:
```bash
flutter run --hot
```

#### Issue: "VS Code not detecting device"
```
Problem: No devices shown in VS Code
```
**Solution:**
1. Run `flutter devices` in terminal
2. Restart VS Code
3. Check USB debugging is enabled (Android)
4. Check device is trusted (iOS)

### Testing Issues

#### Issue: "Cannot run tests"
```
Error: Test failed to run
```
**Solution:**
Tests are not included in this version. To add tests:
1. Create `test/` directory
2. Add test dependencies to `pubspec.yaml`
3. Write tests using `flutter_test` package

## Debug Mode

### Enable Debug Logging

Add to providers to see what's happening:
```dart
void addExpense(ExpenseModel expense) async {
  print('Adding expense: ${expense.description}');
  await _expenseBox.put(expense.id, expense);
  print('Expense added successfully');
  _loadExpenses();
}
```

### Check Hive Data

Add to `DatabaseService`:
```dart
static void printAllExpenses() {
  final box = getExpenseBox();
  print('Total expenses: ${box.length}');
  for (var expense in box.values) {
    print('${expense.description}: ₱${expense.amount} - ${expense.isPaid ? "Paid" : "Unpaid"}');
  }
}
```

### Verify Provider State

Add to widgets:
```dart
@override
Widget build(BuildContext context) {
  final expenseProvider = Provider.of<ExpenseProvider>(context);
  print('Total expenses: ${expenseProvider.expenses.length}');
  print('Unpaid amount: ${expenseProvider.totalUnpaidAmount}');
  return ...;
}
```

## Getting Help

If you're still stuck:

1. **Check Flutter Doctor**
   ```bash
   flutter doctor -v
   ```

2. **Check Logs**
   ```bash
   flutter logs
   ```

3. **Clean and Rebuild**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

4. **Verify Flutter Installation**
   ```bash
   flutter --version
   dart --version
   ```

5. **Check Dependencies**
   ```bash
   flutter pub outdated
   ```

## Useful Commands

```bash
# Check Flutter installation
flutter doctor

# List connected devices
flutter devices

# Run in debug mode
flutter run

# Run in release mode
flutter run --release

# Build APK
flutter build apk

# Clean build files
flutter clean

# Get dependencies
flutter pub get

# Update dependencies
flutter pub upgrade

# Analyze code
flutter analyze

# Format code
dart format lib/

# Check for outdated packages
flutter pub outdated
```

## Still Having Issues?

1. Make sure you're using Flutter 3.0.0 or higher
2. Make sure Dart SDK is 3.0.0 or higher
3. Try on a different device/emulator
4. Check the official Flutter documentation: https://flutter.dev/docs
5. Check Hive documentation: https://docs.hivedb.dev/
