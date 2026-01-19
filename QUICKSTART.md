# Quick Start Guide

## Running the App

### Option 1: Using Command Line

```bash
# Get dependencies
flutter pub get

# Run on connected device/emulator
flutter run

# Run on specific device
flutter devices  # List available devices
flutter run -d <device-id>
```

### Option 2: Using VS Code
1. Open the project in VS Code
2. Press `F5` or click "Run > Start Debugging"
3. Select your target device

### Option 3: Using Android Studio
1. Open the project in Android Studio
2. Select your target device from the dropdown
3. Click the "Run" button (▶️)

## Testing the App

### Initial State
- Credit limit: ₱10,000.00
- Used credit: ₱0.00
- Available credit: ₱10,000.00
- Default dates set to current date and 30 days ahead

### Test Scenario 1: Add Unpaid Expense
1. Tap the (+) button
2. Enter:
   - Description: "Grocery Shopping"
   - Amount: 2500.50
   - Buyer: "Juan Dela Cruz"
   - Date: Today
   - Status: Unpaid (toggle off)
3. Tap "Add Expense"
4. **Expected**: Used credit shows ₱2,500.50, Available shows ₱7,499.50

### Test Scenario 2: Mark Expense as Paid
1. Tap on the expense card
2. Toggle "Payment Status" to ON (Paid)
3. Tap "Update Expense"
4. **Expected**: Used credit returns to ₱0.00, Available returns to ₱10,000.00

### Test Scenario 3: Update Credit Limit
1. Tap the settings icon (⚙️) on the credit card
2. Change credit limit to 15000
3. Tap "Update"
4. **Expected**: Credit limit shows ₱15,000.00, calculations update

### Test Scenario 4: Update Dates
1. Go to Settings
2. Tap on Statement Date
3. Select a date
4. Tap on Due Date
5. Select a date 30 days ahead
6. **Expected**: Days remaining updates on home screen

### Test Scenario 5: Delete Expense
1. Tap on an expense card
2. Tap the delete icon (🗑️)
3. Confirm deletion
4. **Expected**: Expense removed, calculations update

## Troubleshooting

### Issue: App won't build
**Solution**: Run `flutter clean && flutter pub get`

### Issue: Hive errors
**Solution**: The .g.dart files are already generated. If you modify models, run:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue: No devices available
**Solution**: 
- For Android: Start an emulator from Android Studio
- For iOS: Open Simulator from Xcode (Mac only)
- For physical device: Enable USB debugging and connect via USB

### Issue: Hot reload not working
**Solution**: Press `R` in terminal or use full restart with `Shift + R`

## Building for Production

### Android APK
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (for Play Store)
```bash
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab`

### iOS (Mac only)
```bash
flutter build ios --release
```

## Performance Tips

- The app uses Hive for fast local storage
- All operations are synchronous and instant
- No network calls = no loading states needed
- Data persists automatically on every change

## Next Steps

1. Customize the theme colors in `lib/main.dart`
2. Add more expense categories
3. Implement filtering and search
4. Add data export functionality
5. Support multiple credit cards
