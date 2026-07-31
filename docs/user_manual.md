# Vittix Expense Tracker User Manual

This manual covers the current local-first, wallet-scoped feature set in the app.

## 1. What the app is for

Vittix Expense Tracker is a personal and family finance app for:

- tracking income and expenses
- managing accounts and balances
- creating budgets and monitoring spending
- setting financial goals
- handling recurring transactions and bills
- splitting expenses between members
- managing allowances, settlements, and commitments
- importing transactions from SMS on Android
- reviewing reports, trends, and attention items
- working with wallet-based collaboration

The app stores data locally first and organizes shared data by wallet.

## 2. Core concept: Wallets

A wallet is the main data boundary in the app.

- Personal use works inside a personal wallet.
- Shared use works inside a family or group wallet.
- Transactions, budgets, goals, accounts, recurring items, settlements, and collaboration data belong to a wallet.
- Switching wallets changes what data you see and edit.

If you use multiple wallets, always confirm you are in the correct one before adding or editing data.

## 3. Getting started

When you open the app for the first time, the main flow is usually:

1. Create or select a wallet.
2. Add accounts.
3. Add categories.
4. Enter your first transaction.
5. Optionally set up budgets, goals, recurring items, and SMS import.

The dashboard is designed to help you understand:

- account balances
- recent activity
- upcoming or overdue work
- spending trends and summaries

## 4. Dashboard

The dashboard is the home screen.

Common sections include:

- account summary
- recent transactions
- spending insights
- budget overview
- family or shared finance summaries
- attention needed cards
- upcoming commitments
- wallet activity and collaboration summaries

Use the dashboard to check what needs action without opening every module individually.

## 5. Transactions

Transactions are the main record of money movement.

### Add transaction

Use the Add Transaction screen to create a new entry.

Fields typically include:

- transaction type
- amount
- account
- category
- date
- note

### Transaction type

- Expense reduces available money.
- Income increases available money.

### Category

Categories help organize spending and income.

- You can choose from top-level categories.
- Subcategories can appear indented under a parent category.
- If available, the app remembers your last selected category.

### Account

Pick the account the money came from or went to.

- Cash
- Bank account
- Card
- Liability or other tracked account types, depending on setup

### Date

Use the date field to choose when the transaction happened.

### Note

Add an optional note for context such as merchant name, purpose, or reference details.

### Edit transaction

Open an existing transaction to change:

- amount
- date
- note
- type
- category
- account

### Delete transaction

Remove a transaction from its detail or list item action menu, if available.

## 6. Accounts

Accounts represent places where money is held or owed.

Typical account types include:

- cash
- bank
- card
- liability

Account management usually supports:

- adding accounts
- editing account details
- tracking balances
- viewing account-specific reports

Use separate accounts when you want a clearer picture of where money is stored or owed.

## 7. Categories

Categories organize transactions into useful groups.

You can usually:

- add categories
- edit categories
- delete categories
- create parent and child category structures
- assign icons and colors

Recommended category structure:

- Food
  - Groceries
  - Dining Out
- Transport
  - Fuel
  - Public Transit
- Bills
  - Electricity
  - Internet

Good category design makes budgets and reports much more useful.

## 8. Budgets

Budgets track spending limits for a period or category.

Budget features commonly include:

- creating a budget amount
- selecting the category it applies to
- viewing spent versus remaining amount
- seeing rollover or deficit behavior when supported
- editing or deleting a budget

Use budgets for categories you want to control closely, such as groceries, travel, or subscriptions.

## 9. Recurring transactions

Recurring transactions are for entries that repeat on a schedule.

Examples:

- rent
- salary
- streaming subscriptions
- loan EMIs
- recurring savings transfers

Recurring transaction management typically lets you:

- add a repeating rule
- choose amount, category, account, and note
- define the schedule
- edit or remove the recurrence
- process upcoming items when needed

This is useful for keeping monthly finance records complete without manual re-entry.

## 10. Reports and trends

Reporting helps you understand where money is going.

Available report surfaces include:

- trend reports
- category reports
- account reports
- monthly summaries

What to look for:

- high-spend categories
- income versus expense balance
- month-over-month changes
- account-level concentration

Reports are most useful when your categories and accounts are kept consistent.

## 11. Budget and spending insights

The app includes summary widgets and insight surfaces that highlight:

- budget usage
- overspending risk
- remaining budget
- spending concentration
- recent movement in spending

Use these views as a quick health check before opening detailed reports.

## 12. Goals

Goals represent money you want to save or accumulate for a purpose.

Examples:

- emergency fund
- vacation
- car repair
- house down payment

Goal features typically include:

- target amount
- current amount
- progress tracking
- adding and editing goals

Use goals to separate long-term savings from daily spending accounts.

## 13. Bills and commitments

The app supports family or shared finance commitments such as:

- bills
- scheduled contributions
- goal-linked commitments

These features help you understand what is coming up and what needs payment or contribution.

You can use them to track:

- due dates
- upcoming obligations
- overdue items
- contribution progress

## 14. Allowances

Allowances are wallet-scoped payments or allocations for members.

Typical uses:

- child allowance
- weekly pocket money
- monthly support
- custom schedule payments

Allowance features include:

- creating allowance plans
- editing or suspending them
- recording payments
- viewing allowance detail and summaries

This helps families track repeat support amounts and payment history.

## 15. Expense splitting

Expense splitting is for shared purchases.

Supported split styles include:

- equal split
- percentage split
- fixed amount split

What you can do:

- create a split expense
- review who owes what
- edit or delete a split
- record settlements
- view settlement history

Use this when one person pays for everyone and the cost should be reconciled later.

## 16. Settlements

Settlements record repayment between members.

Use settlements to:

- settle a split balance
- track who paid whom
- reduce outstanding peer balances
- keep a local history of repayments

Settlement views usually show:

- amount
- from member
- to member
- date
- status or history

## 17. Member balances

Member balance summaries show net positions in shared wallets.

They help answer:

- who owes money
- who is owed money
- whether a group balance is settled

These summaries are derived from split and settlement data.

## 18. Wallet members and collaboration

Shared wallets can include members with roles.

Common roles:

- owner
- admin
- member
- viewer

Role behavior generally follows these rules:

- owners have full control
- admins can manage most operational data
- members can participate in day-to-day usage
- viewers have read-only access

Wallet member tools typically let you:

- view members
- change roles
- remove members
- review collaboration activity

## 19. Invitations

Wallet invitations are used to bring another person into a shared wallet.

Invitation flow usually includes:

- creating an invite
- sharing a code or QR representation
- accepting the invitation locally
- assigning the invited member a role
- viewing pending, accepted, revoked, or expired state

If an invite is invalid or expired, the app should reject it cleanly.

### Wallet sharing vs account sharing

Sharing is wallet-scoped, not global account sharing.

- A wallet is the collaboration boundary for family members or other collaborators.
- An account is the person who logs in and uses the app.
- One account can belong to multiple wallets.
- One wallet can include multiple accounts as members.

When you invite someone, the app asks for an account ID because the invitation is attached to a specific account and then linked to the current wallet as a member. The wallet itself stays the sharing container.

If you create multiple wallets, you can switch the active wallet from the dashboard using the wallet name in the top-right corner, or from Settings.

## 20. Wallet activity feed

The activity feed shows important wallet events such as:

- member changes
- budget changes
- wallet rename events
- transaction create and update events
- split and settlement actions
- allowance actions
- commitment changes

Use the feed when you need a timeline of what changed in a shared wallet.

## 21. Notifications and action center

The notification layer surfaces reminders and attention items.

It can include:

- bills coming due
- overdue commitments
- allowance reminders
- settlement reminders
- invitation-related events
- wallet activity alerts

The action center groups items into categories such as:

- unread
- upcoming
- dismissed

Use this screen to work through outstanding finance tasks.

## 22. SMS import

On Android, the app can import transaction candidates from SMS.
It also listens for new incoming SMS on-device and caches them for the next import scan.

The import flow is review-first:

1. Read eligible SMS messages.
2. Merge any newly captured SMS from the Android receiver queue.
3. Parse possible transaction details.
4. Review the extracted entries.
5. Accept or reject each item.
6. Import accepted transactions.

SMS import often tries to detect:

- amount
- merchant
- bank or UPI pattern
- duplicate candidates
- confidence level

Only import messages you trust. Review the data before accepting.

## 23. Feedback and beta observation

The app contains local feedback and observation tooling for product quality.

These features are mainly for monitoring and support:

- submit feedback
- review SMS parsing issues
- inspect beta metrics
- view onboarding and workflow friction
- inspect observation summaries

If you are a normal end user, you will mostly use these screens only when troubleshooting or reporting problems.

## 24. Security and lock screen

The app includes local security features such as:

- PIN lock
- biometric unlock, where supported

Use these when you want to protect finance data on a shared device.

## 25. Backup, restore, and export

The app includes local-first data safety options such as:

- export
- backup
- restore, where supported by the current build

Before changing devices or reinstalling, verify that your backup/export workflow is working for your platform.

## 26. Sync

The app includes a sync scaffold in Settings, but it is not a full production multi-device sync feature yet.

- Simulated sync stores server state locally for testing.
- Real sync sends the active wallet payload to a configured sync URL.
- The current sync path is wallet-scoped and does not yet cover every collaboration table.

Use backup and restore if you need a dependable way to move data between devices today.

### Local LAN sync test

If you want to test two phones on the same Wi-Fi network, run the local sync server on your PC and point both phones at it.

1. Start the server:

```bash
python tools/local_sync_server.py --host 0.0.0.0 --port 8080
```

2. Find your PC's LAN IP address, for example `192.168.1.25`.
3. On both phones, turn off `Simulate Cloud Sync`.
4. Set `Sync URL` to `http://192.168.1.25:8080/sync`.
5. Tap `Synchronize Now` on one phone, then on the other.

The same server state file will be shared by both devices, so this is a good way to test wallet sync on a local network.

## 27. Settings

Settings is where you usually manage:

- app preferences
- currency and display behavior
- wallet selection
- security options
- notifications
- collaboration settings
- family finance features
- SMS import setup
- backup and export options

If a feature is hard to find, settings is the first place to check.

## 28. Practical workflows

### Record a daily expense

1. Open Add Transaction.
2. Select Expense.
3. Enter the amount.
4. Choose the correct account.
5. Select the category.
6. Add a note if needed.
7. Save.

### Track monthly bills

1. Create a recurring transaction or bill item.
2. Set the amount and schedule.
3. Choose the related account and category.
4. Review upcoming reminders.
5. Mark payments or settlements when completed.

### Set a monthly budget

1. Open budgets.
2. Create a budget for a category.
3. Enter the limit.
4. Review usage during the month.
5. Adjust if your spending pattern changes.

### Split a shared expense

1. Open split expense.
2. Enter the total amount.
3. Choose participants.
4. Select equal, percentage, or fixed split.
5. Save the split.
6. Record settlements later.

### Import SMS transactions

1. Open SMS import on Android.
2. Grant the required permission.
3. Review the detected items.
4. Reject anything suspicious or duplicate.
5. Accept valid items.

## 29. Tips

- Keep accounts and categories consistent.
- Review imported SMS entries before saving.
- Use notes for context you will want later.
- Use separate wallets for separate financial groups.
- Check dashboards and reports regularly instead of only at month-end.
- Use recurring items for anything that repeats on a schedule.

## 30. Troubleshooting

### I do not see data I expected

- Check whether you are in the correct wallet.
- Confirm the account or category filters.
- Verify the date range in the report or list.

### An import looks wrong

- Reject the candidate.
- Verify the SMS parsing result manually.
- Edit the transaction after import if needed.

### A budget seems off

- Confirm the right budget category.
- Check whether rollover or deficit behavior applies.
- Make sure transactions were entered in the correct wallet.

### A shared balance seems incorrect

- Review the original split.
- Check settlement history.
- Confirm members were included correctly.

## 31. Feature summary

At a glance, the app currently supports:

- wallets and wallet switching
- transactions
- accounts
- categories
- budgets
- recurring transactions
- reports and trend analysis
- goals
- bills and commitments
- allowances
- split expenses
- settlements
- member balances
- collaboration roles and invitations
- activity feeds
- notifications and action center
- SMS import
- security lock
- feedback and beta observation
- backup and export
- sync scaffold
