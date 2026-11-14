# Banking Application — Complete Java Project

This is a console Java application based on the supplied UML and assignment requirements. It includes the seven UML classes plus `CustomerList` (serialization wrapper) and `Input` (shared console input).

## Important: upload and run in GitHub Codespaces

**Do not upload only this README or the ZIP without extracting it.**

1. Download `BankingApp_REDO.zip` and extract it on your computer.
2. In GitHub Codespaces, open the Explorer sidebar. Right-click the **repository root folder** (for example `bkt`) and select **Upload**. Select **all nine `.java` files**, `README.md`, and optionally `run.sh` from the extracted folder. You can also drag the extracted files into the Explorer.
3. Open a terminal at the folder containing `Bank.java` and run:

```bash
ls *.java
javac *.java
java Bank
```

**Capitalization matters:** `java Bank` works; `java bank` does not.

If `javac *.java` reports `file not found`, you're not in the folder containing the Java files. Run `pwd`, `ls`, and `find /workspaces -name Bank.java` to locate them, then `cd` to the containing folder.

Alternative: after uploading the ZIP itself to the repository root, run:

```bash
unzip -o BankingApp_REDO.zip
javac *.java
java Bank
```

The ZIP intentionally places Java files **at the root**, not in an extra subfolder.

## Included files

- `HasMenu.java`: menu/start interface
- `CheckingAccount.java`: balance, deposits, withdrawals
- `SavingsAccount.java`: checking subclass, 5% interest
- `User.java`: abstract serializable user, login, name, PIN
- `Customer.java`: user subclass, checking and savings accounts
- `Admin.java`: user subclass, menu, default login `admin` / `0000`
- `Bank.java`: application entry point, menus, logins, reports, adding users, interest, persistence
- `CustomerList.java`: serializable typed list of customers
- `Input.java`: input helpers (static Scanner; not stored in serialized objects)
- `run.sh`: optional compile-and-run helper

## Sample logins

| Type | Username | PIN | Starting checking | Starting savings |
|---|---|---|---|---|
| Admin | admin | 0000 | — | — |
| Customer | Alice | 1111 | $1,000.00 | $1,000.00 |
| Customer | Bob | 2222 | $0.00 | $0.00 |
| Customer | Cindy | 3333 | $0.00 | $0.00 |

On first launch, sample customers are created if `customers.dat` does not exist. Later launches load saved customers. `customers.dat` is created automatically in the current working directory. To reset sample data during testing, delete `customers.dat` before running again (this deletes saved customer changes).

## Pseudocode and algorithms

### Bank constructor
1. Create an `Admin` with default credentials.
2. Create an empty `CustomerList`.
3. Load serialized customers from file; if no file exists, create and save sample customers.
4. Call the main bank `start()` menu.
5. Save customer list on exit.

### Bank menu / start
1. Print menu: 0 Exit, 1 Admin, 2 Customer.
2. Read a numeric choice.
3. On 0, return; on 1, prompt for admin login and, if successful, call `startAdmin()`; on 2, call `loginAsCustomer()`.
4. For an invalid choice, print a message.
5. Repeat until exit.

### Admin constructor / menu / start
1. Call superclass constructor with `admin` and `0000`.
2. Menu returns options: exit, report, add user, apply interest.
3. `start()` intentionally performs no actions; Bank handles admin actions.
4. `getReport()` returns admin details (not used by Bank).

### Bank startAdmin / adminStart
1. Print the admin menu.
2. Read a choice.
3. Exit on 0; call `fullCustomerReport()` on 1; `addUser()` on 2; `applyInterest()` on 3.
4. Repeat until exit. `adminStart()` is an alias for `startAdmin()`.

### Bank fullCustomerReport
1. Print a report heading.
2. For each customer in the list, call `getReport()` and print it.

### Bank addUser
1. Ask for name; reject empty, reserved, or duplicate names.
2. Ask for a four-digit PIN; reject invalid input.
3. Construct a new Customer with zero-balance accounts.
4. Add customer to list.
5. Save list and confirm creation.

### Bank applyInterest
1. Print interest heading.
2. Loop over customers.
3. Call `calcInterest()` on each savings account.
4. Save updated customer list.

### Bank loginAsCustomer
1. Prompt for username and PIN.
2. Start with no matching customer.
3. Loop through customers and compare credentials using `login(name,pin)`.
4. If matched, call that customer's `start()` menu and save on return.
5. Otherwise print login failure.

### Bank loadSampleCustomers
1. Create a fresh CustomerList.
2. Add Alice with checking and savings each set to 1000.
3. Add Bob and Cindy with zero balances.

### Bank saveCustomers
1. Open temporary file for serialized output.
2. Write the CustomerList object.
3. Close stream.
4. Move temporary file to `customers.dat`.
5. Report file errors.

### Bank loadCustomers
1. If no data file exists, load and save sample customers.
2. Otherwise open serialized input stream.
3. Read an object and verify it is a CustomerList.
4. Assign it to Bank's customer list.
5. If loading fails, report error and do not silently overwrite existing data.

### User constructor / login / setters / getters
1. Store username and PIN in instance variables.
2. `login()` prompts for both values, then delegates to `login(name,pin)`.
3. `login(name,pin)` returns true only when both values match.
4. Getters return corresponding values; setters replace them.
5. Subclasses implement abstract `getReport()`.

### Customer constructor / menu / start
1. Call User constructor to store credentials.
2. Construct checking and savings accounts.
3. Display customer menu in a loop.
4. On checking or savings selection, call the corresponding account's `start()`.
5. On report, print `getReport()`; on PIN change, call `changePIN()`; on exit, return.

### Customer changePIN / getReport
1. Ask for existing PIN and verify it.
2. Ask for a new four-digit PIN and validate it.
3. Update PIN if valid.
4. `getReport()` combines username, formatted checking balance, and formatted savings balance.

### CheckingAccount constructor / menu / start
1. Initialize nonnegative balance (default zero).
2. Loop printing account options.
3. On balance, call `checkBalance()`; on deposit, call `makeDeposit()`; on withdrawal, call `makeWithdrawal()`; on exit, return.

### CheckingAccount deposit / withdrawal / helpers
1. Read a positive, finite amount via `getDouble()`.
2. Deposit adds amount to balance; withdrawal first checks sufficient funds.
3. Update balance and print formatted balance.
4. `setBalance()` rejects invalid amounts; `getBalance()` returns balance; `getBalanceString()` formats currency.

### SavingsAccount constructor / menu / start / interest
1. Call CheckingAccount constructor to initialize balance.
2. Initialize interest rate to 0.05 unless specified otherwise.
3. Offer balance, deposit, withdrawal, and interest-rate display.
4. `calcInterest()` multiplies balance by `(1 + interestRate)` and prints the new balance.
5. Interest-rate setter validates finite nonnegative rate; getter returns it.

### CustomerList and Input
1. CustomerList extends `ArrayList<Customer>` and declares a serialization version ID.
2. Input holds a static Scanner (not serialized), reads text, parses integers, and validates positive money amounts.

## Testing checklist

- [ ] `javac *.java` completes with no compiler errors.
- [ ] `java Bank` shows Bank Menu.
- [ ] Admin login accepts `admin` / `0000` and rejects wrong PIN.
- [ ] Full report shows Alice at $1,000.00 checking and savings.
- [ ] Add Dave / `4444` through admin menu.
- [ ] Apply interest once; Alice's savings becomes $1,050.00.
- [ ] Report shows Dave and updated Alice balance.
- [ ] Log in as Alice / `1111` and make a deposit and withdrawal.
- [ ] Exit, rerun `java Bank`, and verify changes persist.

## Personal style and beyond-basics features

Extra work beyond the core UML: friendly confirmation and error messages; four-digit PIN validation; duplicate username prevention; a customer change-PIN option; a savings interest-rate display; checks against negative or non-finite transactions; a temporary-file save to reduce partial writes. These are optional extensions and clearly identified here for the rubric.

This is a classroom demo, **not** secure banking software: PINs are stored as plain text in the serialized file. Do not use real account credentials or customer data.
