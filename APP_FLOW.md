# Credit Card Expense Tracker - App Flow Diagram

## User Journey Map

```
┌─────────────────────────────────────────────────────────────────┐
│                         APP LAUNCH                               │
│                                                                  │
│  1. Initialize Hive Database                                    │
│  2. Register Type Adapters                                      │
│  3. Open Hive Boxes                                             │
│  4. Initialize Providers                                        │
│  5. Load Saved Data                                             │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                      HOME SCREEN                                 │
│  ┌────────────────────────────────────────────────────────┐    │
│  │  Credit Card Summary                                    │    │
│  │  • Credit Limit: ₱10,000.00                            │    │
│  │  • Used: ₱2,500.50 | Available: ₱7,499.50            │    │
│  │  • Progress Bar                                         │    │
│  │  • Statement Date: Jan 19, 2026                        │    │
│  │  • Due Date: Feb 18, 2026                              │    │
│  │  • 29 days remaining                                   │    │
│  └────────────────────────────────────────────────────────┘    │
│                                                                  │
│  Recent Expenses (1 expense)                                    │
│  ┌────────────────────────────────────────────────────────┐    │
│  │ 🔴 Grocery Shopping              ₱2,500.50 [Unpaid]   │    │
│  │    Juan Dela Cruz                                      │    │
│  │    Jan 19, 2026                                        │    │
│  └────────────────────────────────────────────────────────┘    │
│                                                                  │
│                                              [+] FAB             │
└─────────────────────────────────────────────────────────────────┘
         │                    │                    │
         │                    │                    │
    Tap Card           Tap Settings          Tap FAB
         │                    │                    │
         ▼                    ▼                    ▼
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│ EDIT EXPENSE │    │   SETTINGS   │    │ ADD EXPENSE  │
└──────────────┘    └──────────────┘    └──────────────┘
```

## Screen Flow Details

### 1. Home Screen → Add Expense
```
Home Screen
    │
    │ User taps FAB (+)
    ▼
Add Expense Screen
    │
    │ User fills form:
    │ • Description: "Grocery Shopping"
    │ • Amount: 2500.50
    │ • Buyer: "Juan Dela Cruz"
    │ • Date: Jan 19, 2026
    │ • Status: Unpaid
    │
    │ User taps "Add Expense"
    ▼
Form Validation
    │
    │ ✅ All fields valid
    ▼
ExpenseProvider.addExpense()
    │
    │ Save to Hive
    ▼
notifyListeners()
    │
    │ UI rebuilds
    ▼
Navigate back to Home
    │
    ▼
Home Screen (Updated)
    • New expense appears in list
    • Used credit: ₱2,500.50
    • Available credit: ₱7,499.50
```

### 2. Home Screen → Edit Expense
```
Home Screen
    │
    │ User taps expense card
    ▼
Add Expense Screen (Edit Mode)
    │
    │ Form pre-filled with expense data
    │
    │ User toggles "Paid" status
    │
    │ User taps "Update Expense"
    ▼
ExpenseProvider.updateExpense()
    │
    │ Update in Hive
    ▼
notifyListeners()
    │
    │ UI rebuilds
    ▼
Navigate back to Home
    │
    ▼
Home Screen (Updated)
    • Expense shows "Paid" status
    • Used credit: ₱0.00
    • Available credit: ₱10,000.00
```

### 3. Home Screen → Settings
```
Home Screen
    │
    │ User taps settings icon (⚙️)
    ▼
Settings Screen
    │
    │ User updates credit limit to 15000
    │
    │ User taps "Update"
    ▼
CreditCardProvider.updateCreditLimit()
    │
    │ Update in Hive
    ▼
notifyListeners()
    │
    │ UI rebuilds
    ▼
Settings Screen (Updated)
    • Credit limit: ₱15,000.00
    │
    │ User taps back
    ▼
Home Screen (Updated)
    • Credit limit: ₱15,000.00
    • Available credit: ₱15,000.00
```

### 4. Delete Expense Flow
```
Edit Expense Screen
    │
    │ User taps delete icon (🗑️)
    ▼
Confirmation Dialog
    │
    │ "Are you sure?"
    │
    │ User taps "Delete"
    ▼
ExpenseProvider.deleteExpense()
    │
    │ Remove from Hive
    ▼
notifyListeners()
    │
    │ UI rebuilds
    ▼
Navigate back to Home
    │
    ▼
Home Screen (Updated)
    • Expense removed from list
    • Used credit recalculated
    • Available credit updated
```

## Data Flow Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         UI LAYER                             │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │  Home    │  │   Add    │  │ Settings │  │  Widgets │   │
│  │  Screen  │  │ Expense  │  │  Screen  │  │          │   │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘   │
└───────┼─────────────┼─────────────┼─────────────┼──────────┘
        │             │             │             │
        │ Consumer    │ Provider.of │ Consumer    │ Consumer
        │             │             │             │
┌───────▼─────────────▼─────────────▼─────────────▼──────────┐
│                   PROVIDER LAYER                             │
│  ┌──────────────────────┐  ┌──────────────────────┐        │
│  │  ExpenseProvider     │  │ CreditCardProvider   │        │
│  │  • expenses          │  │ • creditCard         │        │
│  │  • addExpense()      │  │ • updateCreditLimit()│        │
│  │  • updateExpense()   │  │ • updateSoaDate()    │        │
│  │  • deleteExpense()   │  │ • updateDueDate()    │        │
│  │  • totalUnpaidAmount │  │ • daysRemaining      │        │
│  └──────────┬───────────┘  └──────────┬───────────┘        │
└─────────────┼──────────────────────────┼────────────────────┘
              │                          │
              │ CRUD Operations          │ CRUD Operations
              │                          │
┌─────────────▼──────────────────────────▼────────────────────┐
│                    SERVICE LAYER                             │
│  ┌──────────────────────────────────────────────────────┐   │
│  │           DatabaseService                             │   │
│  │  • init()                                            │   │
│  │  • getExpenseBox()                                   │   │
│  │  • getCreditCardBox()                                │   │
│  └──────────────────────┬───────────────────────────────┘   │
└─────────────────────────┼───────────────────────────────────┘
                          │
                          │ Hive Operations
                          │
┌─────────────────────────▼───────────────────────────────────┐
│                    DATABASE LAYER                            │
│  ┌──────────────────┐         ┌──────────────────┐          │
│  │  Expense Box     │         │ CreditCard Box   │          │
│  │  (Hive)          │         │ (Hive)           │          │
│  └──────────────────┘         └──────────────────┘          │
└─────────────────────────────────────────────────────────────┘
                          │
                          │ Persist
                          │
┌─────────────────────────▼───────────────────────────────────┐
│                   LOCAL STORAGE                              │
│              (Device File System)                            │
└─────────────────────────────────────────────────────────────┘
```

## State Update Flow

```
User Action (e.g., Add Expense)
    │
    ▼
UI Event Handler
    │
    ▼
Provider Method Called
    │
    ├─► Validate Input
    │
    ├─► Create/Update Model
    │
    ├─► Save to Hive Box
    │
    └─► notifyListeners()
        │
        ▼
    Consumer Widgets Rebuild
        │
        ├─► CreditCardSummary
        │   └─► Recalculate used/available credit
        │
        ├─► ExpenseList
        │   └─► Reload expense list
        │
        └─► ExpenseCard
            └─► Update individual cards
```

## Business Logic Flow

### Used Credit Calculation
```
ExpenseProvider
    │
    ├─► Get all expenses from Hive
    │
    ├─► Filter unpaid expenses
    │   (where isPaid == false)
    │
    ├─► Sum amounts
    │   totalUnpaidAmount = Σ(unpaid.amount)
    │
    └─► Return total
        │
        ▼
CreditCardSummary
    │
    ├─► Get creditLimit from CreditCardProvider
    │
    ├─► Get usedCredit from ExpenseProvider
    │
    ├─► Calculate availableCredit
    │   availableCredit = creditLimit - usedCredit
    │
    └─► Display results
```

### Days Remaining Calculation
```
CreditCardProvider
    │
    ├─► Get dueDate from CreditCardModel
    │
    ├─► Get current date (DateTime.now())
    │
    ├─► Calculate difference
    │   daysRemaining = dueDate - currentDate
    │
    ├─► Check if overdue
    │   isOverdue = daysRemaining < 0
    │
    └─► Return results
        │
        ▼
CreditCardSummary
    │
    └─► Display with color coding
        • Green if daysRemaining > 0
        • Red if daysRemaining < 0
```

## Navigation Flow

```
                    ┌─────────────┐
                    │ Home Screen │
                    └──────┬──────┘
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
        ▼                  ▼                  ▼
┌───────────────┐  ┌───────────────┐  ┌───────────────┐
│ Add Expense   │  │ Edit Expense  │  │   Settings    │
│ (New)         │  │ (Existing)    │  │               │
└───────┬───────┘  └───────┬───────┘  └───────┬───────┘
        │                  │                  │
        │ Save             │ Update/Delete    │ Update
        │                  │                  │
        └──────────────────┼──────────────────┘
                           │
                           ▼
                    ┌─────────────┐
                    │ Home Screen │
                    │  (Updated)  │
                    └─────────────┘
```

## Error Handling Flow

```
User Input
    │
    ▼
Form Validation
    │
    ├─► Valid? ──Yes──► Continue
    │
    └─► No
        │
        ▼
    Show Error Message
        │
        ├─► "Please enter a description"
        ├─► "Please enter an amount"
        ├─► "Please enter a valid number"
        └─► "Amount must be greater than 0"
        │
        ▼
    User Corrects Input
        │
        ▼
    Try Again
```

## Lifecycle Flow

```
App Start
    │
    ▼
main()
    │
    ├─► WidgetsFlutterBinding.ensureInitialized()
    │
    ├─► DatabaseService.init()
    │   ├─► Hive.initFlutter()
    │   ├─► Register adapters
    │   └─► Open boxes
    │
    └─► runApp(MyApp())
        │
        ▼
    MultiProvider
        │
        ├─► CreditCardProvider()
        │   └─► Load credit card data
        │
        └─► ExpenseProvider()
            └─► Load expenses
            │
            ▼
        MaterialApp
            │
            ▼
        HomeScreen
            │
            ▼
        App Ready! 🚀
```

## Real-Time Update Flow

```
Expense Added/Updated/Deleted
    │
    ▼
Provider.notifyListeners()
    │
    ├─────────────────┬─────────────────┐
    │                 │                 │
    ▼                 ▼                 ▼
Consumer 1        Consumer 2        Consumer 3
(Summary)         (List)            (Card)
    │                 │                 │
    ▼                 ▼                 ▼
Rebuild           Rebuild           Rebuild
    │                 │                 │
    └─────────────────┴─────────────────┘
                      │
                      ▼
            UI Updated Instantly
```

## Summary

This app follows a clean, unidirectional data flow:

1. **User Action** → UI Event
2. **UI Event** → Provider Method
3. **Provider Method** → Database Operation
4. **Database Operation** → notifyListeners()
5. **notifyListeners()** → UI Rebuild
6. **UI Rebuild** → Updated Display

All data flows through the Provider layer, ensuring:
- ✅ Single source of truth
- ✅ Predictable state updates
- ✅ Easy debugging
- ✅ Testable code
- ✅ Reactive UI updates
