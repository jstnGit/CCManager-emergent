# App Structure Overview

## Architecture Pattern

```
┌─────────────────────────────────────────────────┐
│                   UI Layer                       │
│  (Screens & Widgets - Stateless/Stateful)       │
└────────────────┬────────────────────────────────┘
                 │
                 │ Consumer/Provider.of
                 │
┌────────────────▼────────────────────────────────┐
│              State Management                    │
│         (Provider - ChangeNotifier)              │
└────────────────┬────────────────────────────────┘
                 │
                 │ CRUD Operations
                 │
┌────────────────▼────────────────────────────────┐
│            Database Service                      │
│              (Hive Boxes)                        │
└────────────────┬────────────────────────────────┘
                 │
                 │ Persist/Retrieve
                 │
┌────────────────▼────────────────────────────────┐
│           Local Storage                          │
│        (Device File System)                      │
└──────────────────────────────────────────────────┘
```

## Component Breakdown

### 1. Models (Data Layer)
```
ExpenseModel
├── id: String
├── description: String
├── amount: double
├── buyer: String
├── date: DateTime
└── isPaid: bool

CreditCardModel
├── creditLimit: double
├── soaDate: DateTime
└── dueDate: DateTime
```

### 2. Providers (State Management)
```
ExpenseProvider
├── expenses: List<ExpenseModel>
├── unpaidExpenses: List<ExpenseModel>
├── paidExpenses: List<ExpenseModel>
├── totalUnpaidAmount: double
├── addExpense()
├── updateExpense()
├── deleteExpense()
└── togglePaidStatus()

CreditCardProvider
├── creditCard: CreditCardModel
├── daysRemaining: int
├── isOverdue: bool
├── updateCreditLimit()
├── updateSoaDate()
└── updateDueDate()
```

### 3. Services
```
DatabaseService
├── init() - Initialize Hive
├── getExpenseBox() - Get expense storage
├── getCreditCardBox() - Get credit card storage
└── close() - Close database
```

### 4. Screens
```
HomeScreen
├── AppBar (Title + Icon)
├── CreditCardSummary Widget
├── ExpenseList Widget
└── FloatingActionButton

AddExpenseScreen
├── Form with validation
├── Description field
├── Amount field
├── Buyer field
├── Date picker
├── Payment status toggle
└── Save/Update button

SettingsScreen
├── Credit limit editor
├── SOA date picker
└── Due date picker
```

### 5. Widgets
```
CreditCardSummary
├── Credit limit display
├── Used/Available credit
├── Progress bar
├── Statement date
├── Due date
└── Days remaining indicator

ExpenseList
├── Header with count
├── ListView.builder
└── Empty state

ExpenseCard
├── Status indicator (circle)
├── Description
├── Buyer name
├── Date
├── Amount
└── Paid/Unpaid badge
```

## Data Flow Examples

### Adding an Expense
```
User taps FAB
    ↓
Navigate to AddExpenseScreen
    ↓
User fills form and taps "Add Expense"
    ↓
Form validation
    ↓
ExpenseProvider.addExpense()
    ↓
Save to Hive box
    ↓
notifyListeners()
    ↓
UI rebuilds (Consumer widgets)
    ↓
HomeScreen shows new expense
    ↓
CreditCardSummary updates used credit
```

### Marking Expense as Paid
```
User taps expense card
    ↓
Navigate to AddExpenseScreen (edit mode)
    ↓
User toggles payment status
    ↓
ExpenseProvider.updateExpense()
    ↓
Update in Hive box
    ↓
notifyListeners()
    ↓
UI rebuilds
    ↓
Used credit recalculates (excludes paid)
    ↓
Available credit updates
```

### Updating Credit Limit
```
User taps settings icon
    ↓
Navigate to SettingsScreen
    ↓
User enters new limit and taps "Update"
    ↓
CreditCardProvider.updateCreditLimit()
    ↓
Update in Hive box
    ↓
notifyListeners()
    ↓
UI rebuilds
    ↓
CreditCardSummary shows new limit
    ↓
Available credit recalculates
```

## Key Design Decisions

### Why Hive?
- ✅ Fast and lightweight
- ✅ No native dependencies
- ✅ Type-safe with code generation
- ✅ Works on all platforms
- ✅ No SQL knowledge required

### Why Provider?
- ✅ Official Flutter recommendation
- ✅ Simple and intuitive
- ✅ Good performance
- ✅ Easy to test
- ✅ Minimal boilerplate

### Why Offline-First?
- ✅ No internet dependency
- ✅ Instant operations
- ✅ Privacy (data stays on device)
- ✅ No backend costs
- ✅ Works anywhere

## File Dependencies

```
main.dart
├── imports DatabaseService
├── imports Providers
└── imports HomeScreen
    ├── imports CreditCardSummary
    │   └── imports both Providers
    ├── imports ExpenseList
    │   └── imports ExpenseCard
    │       └── imports ExpenseProvider
    └── imports AddExpenseScreen
        └── imports ExpenseProvider
```

## State Management Flow

```
MultiProvider (main.dart)
├── CreditCardProvider
│   └── Consumed by:
│       ├── CreditCardSummary
│       └── SettingsScreen
└── ExpenseProvider
    └── Consumed by:
        ├── CreditCardSummary (for used credit)
        ├── ExpenseList
        ├── ExpenseCard
        └── AddExpenseScreen
```

## Business Logic Location

| Logic | Location | Reason |
|-------|----------|--------|
| Used credit calculation | ExpenseProvider | Depends on expense data |
| Available credit calculation | CreditCardSummary | Combines both providers |
| Days remaining calculation | CreditCardProvider | Depends on credit card data |
| Form validation | AddExpenseScreen | UI-specific logic |
| Date formatting | Widgets | Presentation logic |

## Testing Strategy

### Unit Tests
- Test ExpenseProvider methods
- Test CreditCardProvider methods
- Test business logic calculations

### Widget Tests
- Test individual widgets render correctly
- Test user interactions
- Test form validation

### Integration Tests
- Test complete user flows
- Test data persistence
- Test navigation

## Performance Considerations

- Hive operations are synchronous and fast
- Provider only rebuilds consuming widgets
- ListView.builder for efficient scrolling
- No unnecessary rebuilds (const constructors)
- Minimal widget tree depth
