@testable import FinancialEntities
import Foundation
import Testing

struct AccountTests {
    @Test func initialization() throws {
        // Arrange
        let name = "Checking"
        let created = Date()

        // Act
        let account = try Account(name: name, created: created)

        // Assert
        #expect(account.name == name)
        #expect(account.created == created)
        #expect(account.modified == nil)
        #expect(account.id != UUID())
        #expect(account.transactions.isEmpty)
    }

    @Test func equality() throws {
        // Arrange
        let date = Date()
        let account1 = try Account(name: "Savings", created: date)
        let account2 = try Account(name: "Savings", created: date)

        // Act & Assert
        #expect(account1 != account2, "Accounts with different IDs should not be equal")
    }

    @Test func hashability() throws {
        // Arrange
        let account1 = try Account(name: "Investment", created: Date())
        let account2 = try Account(name: "Investment", created: Date())

        // Act
        let set: Set<Account> = [account1, account2]

        // Assert
        #expect(set.count == 2, "Both accounts should be in the set since they have different IDs")
    }

    @Test func modifiedDate() throws {
        // Arrange
        var account = try Account(name: "Credit Card", created: Date())

        // Act
        let modifiedDate = Date()
        account.modified = modifiedDate

        // Assert
        #expect(account.modified == modifiedDate)
    }

    @Test func initializationWithEmptyNameThrowsError() {
        // Arrange
        let name = ""

        // Act & Assert
        #expect(throws: Account.AccountError.emptyName) {
            _ = try Account(name: name)
        }
    }

    @Test func updateName() throws {
        // Arrange
        var account = try Account(name: "Checking")
        let newName = "Primary Checking"

        // Act
        try account.updateName(newName)

        // Assert
        #expect(account.name == newName)
        #expect(account.modified != nil)
    }

    @Test func updateNameWithWhitespaceChanges() throws {
        // Arrange
        var account = try Account(name: "Savings")
        let originalModified = account.modified
        let newName = "  Savings  "

        // Act
        try account.updateName(newName)

        // Assert
        #expect(account.name == "Savings")
        #expect(account.modified == originalModified)
    }

    @Test func initializationWithWhitespaces() throws {
        // Arrange
        let name = "  Investment  "

        // Act
        let account = try Account(name: name)

        // Assert
        #expect(account.name == "Investment")
    }

    @Test func updateNameWithEmptyStringThrowsError() throws {
        // Arrange
        var account = try Account(name: "Credit Card")

        // Act & Assert
        #expect(throws: Account.AccountError.emptyName) {
            try account.updateName("")
        }
    }

    @Test func addTransaction() throws {
        // Arrange
        var account = try Account(name: "Checking")
        let category = try TransactionCategory(name: "Income")
        let transaction = Transaction(
            text: "Salary",
            amount: 1500.0,
            created: Date(),
            category: category
        )

        // Act
        account.addTransaction(transaction)

        // Assert
        #expect(account.transactions.count == 1)
        #expect(account.transactions.first?.id == transaction.id)
        #expect(account.modified != nil)
    }

    @Test func removeTransaction() throws {
        // Arrange
        var account = try Account(name: "Savings")
        let category = try TransactionCategory(name: "Income")
        let transaction = Transaction(
            text: "Interest",
            amount: 5.0,
            created: Date(),
            category: category
        )
        account.addTransaction(transaction)

        // Act
        account.removeTransaction(transaction)

        // Assert
        #expect(account.transactions.isEmpty)
        #expect(account.modified != nil)
    }

    @Test func balanceWithNoTransactions() throws {
        // Arrange
        let account = try Account(name: "Checking")

        // Act & Assert
        #expect(account.balance == 0.0)
    }

    @Test func balanceWithPositiveTransactions() throws {
        // Arrange
        var account = try Account(name: "Savings")
        let category = try TransactionCategory(name: "Income")
        let transactions = [
            Transaction(text: "Salary", amount: 1500.0, created: Date(), category: category),
            Transaction(text: "Bonus", amount: 300.0, created: Date(), category: category)
        ]
        transactions.forEach { account.addTransaction($0) }

        // Act & Assert
        #expect(account.balance == 1800.0)
    }

    @Test func balanceWithNegativeTransactions() throws {
        // Arrange
        var account = try Account(name: "Checking")
        let category = try TransactionCategory(name: "Expense")
        let transactions = [
            Transaction(text: "Rent", amount: -800.0, created: Date(), category: category),
            Transaction(text: "Groceries", amount: -150.0, created: Date(), category: category)
        ]
        transactions.forEach { account.addTransaction($0) }

        // Act & Assert
        #expect(account.balance == -950.0)
    }

    @Test func balanceWithMixedTransactions() throws {
        // Arrange
        var account = try Account(name: "Investment")
        let incomeCategory = try TransactionCategory(name: "Income")
        let expenseCategory = try TransactionCategory(name: "Expense")
        let transactions = [
            Transaction(text: "Salary", amount: 2000.0, created: Date(), category: incomeCategory),
            Transaction(text: "Rent", amount: -800.0, created: Date(), category: expenseCategory),
            Transaction(text: "Groceries", amount: -150.0, created: Date(), category: expenseCategory),
            Transaction(text: "Bonus", amount: 500.0, created: Date(), category: incomeCategory)
        ]
        transactions.forEach { account.addTransaction($0) }

        // Act & Assert
        #expect(account.balance == 1550.0)
    }
}
