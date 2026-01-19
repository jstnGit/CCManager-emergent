# Credit Card Expense Tracker

A Flutter mobile application for tracking credit card expenses using offline-first architecture with local device storage.

## Features

✅ **Credit Card Dashboard**
- Display credit limit, used credit, and available credit
- Real-time updates when expenses are added/modified
- Visual progress bar showing credit utilization

✅ **Statement & Payment Dates**
- Editable SOA (Statement of Account) date
- Editable due date with date picker
- Days remaining counter with overdue indicator

✅ **Expense Management**
- Add, edit, and delete expenses
- Mark expenses as paid/unpaid
- Color-coded status indicators (🔴 Unpaid, 🟢 Paid)
- Scrollable expense list

✅ **Offline-First**
- All data stored locally using Hive
- No internet dependency
- Data persists across app restarts

## Tech Stack

- **Framework**: Flutter (latest stable)
- **Language**: Dart (null-safe)
- **Local Database**: Hive
- **State Management**: Provider
- **Date Formatting**: intl package

## Project Structure

```
lib/
├── models/
│   ├── expense_model.dart
│   ├── expense_model.g.dart
│   ├── credit_card_model.dart
│   └── credit_card_model.g.dart
├── providers/
│   ├── expense_provider.dart
│   └── credit_card_provider.dart
├── screens/
│   ├── home_screen.dart
│   ├── add_expense_screen.dart
│   └── settings_screen.dart
├── services/
│   └── database_service.dart
├── widgets/
│   ├── credit_card_summary.dart
│   ├── expense_list.dart
│   └── expense_card.dart
└── main.dart
```

## Setup Instructions

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / VS Code with Flutter extensions
- Android/iOS device or emulator

### Installation

1. **Clone or create the project**
   ```bash
   flutter create credit_card_tracker
   cd credit_card_tracker
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## Usage

### Adding an Expense
1. Tap the floating action button (+) on the home screen
2. Fill in the expense details:
   - Description (required)
   - Amount (required)
   - Buyer name (required)
   - Purchase date (date picker)
   - Payment status (toggle)
3. Tap "Add Expense"

### Editing an Expense
1. Tap on any expense card in the list
2. Modify the details
3. Tap "Update Expense"

### Deleting an Expense
1. Tap on an expense card
2. Tap the delete icon in the app bar
3. Confirm deletion

### Updating Credit Card Settings
1. Tap the settings icon (⚙️) on the credit card summary
2. Update:
   - Credit limit
   - Statement date
   - Due date
3. Changes are saved automatically

## Business Logic

- **Used Credit** = Sum of all unpaid expenses
- **Available Credit** = Credit Limit - Used Credit
- **Paid expenses** do NOT count toward used credit
- All calculations update in real-time

## Data Models

### ExpenseModel
- `id`: Unique identifier
- `description`: Expense description
- `amount`: Expense amount
- `buyer`: Person who made the purchase
- `date`: Purchase date
- `isPaid`: Payment status (true/false)

### CreditCardModel
- `creditLimit`: Maximum credit limit
- `soaDate`: Statement of account date
- `dueDate`: Payment due date

## UI/UX Features

- Material 3 design with dark theme
- Clean and minimal layout
- Responsive design
- Color-coded status indicators
- Smooth animations and transitions
- Form validation
- Confirmation dialogs for destructive actions

## Future Enhancements

- [ ] Monthly expense summary
- [ ] Filter expenses (Paid/Unpaid)
- [ ] Search functionality
- [ ] Dark/Light mode toggle
- [ ] Currency selection
- [ ] Multiple credit cards support
- [ ] Export data to CSV
- [ ] Expense categories
- [ ] Charts and analytics

## License

This project is open source and available under the MIT License.
# CCManager-emergent
