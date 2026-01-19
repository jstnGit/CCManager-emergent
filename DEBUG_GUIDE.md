# Debug Guide - Expense Not Showing in Used/Available Credit

## Issue
When adding expenses, the Used and Available credit values are not updating in the Credit Card Summary.

## Changes Made

I've added debug logging to help identify the issue. Here's what to do:

### 1. Run the App with Debug Output

```bash
flutter run -d windows
```

Or for web:
```bash
flutter run -d chrome
```

### 2. Watch the Console Output

When you add an expense, you should see debug messages like:

```
Adding expense: Grocery Shopping, Amount: 2500.50, Paid: false
Loaded 1 expenses
Total unpaid amount: 2500.50
=== CreditCardSummary Build ===
Credit Limit: 10000.0
Used Credit: 2500.50
Available Credit: 7499.50
Total Expenses: 1
Unpaid Expenses: 1
```

### 3. Check What's Happening

#### If you see the debug messages:
- The expense IS being saved
- The provider IS calculating correctly
- The UI IS rebuilding
- **Problem**: Might be a display issue

#### If you DON'T see the debug messages:
- The expense might not be saving to Hive
- The provider might not be initialized
- **Problem**: Database or initialization issue

## Common Causes & Solutions

### Cause 1: Hive Not Initialized Properly

**Check:** Look for this error in console:
```
Error initializing ExpenseProvider: ...
```

**Solution:** Make sure `main.dart` calls `DatabaseService.init()` before `runApp()`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.init();  // ← This must complete
  runApp(const MyApp());
}
```

### Cause 2: Expense Saved as "Paid" by Default

**Check:** Look at the debug output when adding:
```
Adding expense: ..., Paid: true  ← Should be false!
```

**Solution:** In `add_expense_screen.dart`, make sure:
```dart
_isPaid = widget.expense?.isPaid ?? false;  // Default to false
```

### Cause 3: Provider Not Notifying Listeners

**Check:** You should see:
```
Loaded X expenses
Total unpaid amount: Y
```

**Solution:** Already fixed - `notifyListeners()` is called after `_loadExpenses()`

### Cause 4: Widget Not Listening to Provider

**Check:** The `CreditCardSummary` should rebuild when expenses change.

**Solution:** Already fixed - using `Provider.of<ExpenseProvider>(context)` without `listen: false`

## Step-by-Step Debugging

### Step 1: Add an Expense
1. Tap the (+) button
2. Fill in:
   - Description: "Test Expense"
   - Amount: 100
   - Buyer: "Test"
   - Date: Today
   - **Payment Status: Make sure it's UNPAID (toggle OFF)**
3. Tap "Add Expense"

### Step 2: Check Console Output
Look for these messages in order:

```
1. Adding expense: Test Expense, Amount: 100.0, Paid: false
2. Loaded 1 expenses
3. Total unpaid amount: 100.0
4. === CreditCardSummary Build ===
5. Credit Limit: 10000.0
6. Used Credit: 100.0
7. Available Credit: 9900.0
```

### Step 3: Verify in UI
- Used Credit should show: ₱100.00 (in red)
- Available Credit should show: ₱9,900.00 (in green)
- Progress bar should show a tiny bit of red

### Step 4: Check Expense List
- The expense should appear in the list below
- It should have a red left border (unpaid)
- Status badge should say "Unpaid" in red

## If Still Not Working

### Test 1: Check if Expense is Saved
1. Add an expense
2. Close the app completely
3. Reopen the app
4. **Does the expense still appear in the list?**
   - YES → Hive is working, issue is with calculation
   - NO → Hive is not saving properly

### Test 2: Check Payment Status
1. Add an expense
2. Look at the expense card in the list
3. **What color is the left border?**
   - RED → Unpaid (correct)
   - GREEN → Paid (wrong - this is the issue!)

### Test 3: Toggle Payment Status
1. Tap on an existing expense
2. Toggle the payment status to PAID
3. Tap "Update Expense"
4. **Does the Used Credit go to ₱0.00?**
   - YES → Calculation works, issue is with initial save
   - NO → Calculation is broken

## Quick Fix to Try

If the expense is being saved as "Paid" by default, edit `lib/screens/add_expense_screen.dart`:

Find this line (around line 40):
```dart
_isPaid = widget.expense?.isPaid ?? false;
```

Make absolutely sure it says `false` at the end, not `true`.

## Manual Test

Add this temporary code to `lib/widgets/credit_card_summary.dart` to force show values:

```dart
// Temporary debug display
Text('DEBUG: Expenses: ${expenseProvider.expenses.length}'),
Text('DEBUG: Unpaid: ${expenseProvider.unpaidExpenses.length}'),
Text('DEBUG: Total: ${expenseProvider.totalUnpaidAmount}'),
```

Add these lines right after the "Credit Limit" text to see raw values.

## Expected Behavior

### When Adding Unpaid Expense (₱2,500.50):
- Used Credit: ₱2,500.50 (red)
- Available Credit: ₱7,499.50 (green)
- Progress bar: ~25% filled (red)

### When Marking as Paid:
- Used Credit: ₱0.00 (red)
- Available Credit: ₱10,000.00 (green)
- Progress bar: Empty

### When Adding Multiple Unpaid Expenses:
- Used Credit: Sum of all unpaid amounts
- Available Credit: Credit Limit - Used Credit

## Contact Points

If you're still having issues, check:

1. **Console Output** - What debug messages appear?
2. **Expense List** - Do expenses appear?
3. **Expense Color** - Red border (unpaid) or green (paid)?
4. **Payment Toggle** - Does toggling paid/unpaid work?

Share the console output and I can help identify the exact issue!

## Files Modified

The following files now have debug logging:
- `lib/providers/expense_provider.dart` - Logs all expense operations
- `lib/providers/credit_card_provider.dart` - Logs credit card operations
- `lib/widgets/credit_card_summary.dart` - Logs every rebuild with values

Run the app and watch the console for these debug messages!
