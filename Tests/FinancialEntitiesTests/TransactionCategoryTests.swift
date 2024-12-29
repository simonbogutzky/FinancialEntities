@testable import FinancialEntities
import Foundation
import Testing

struct TransactionCategoryTests {
    @Test func initialization() throws {
        // Arrange
        let name = "Salary"
        let created = Date()

        // Act
        let category = try TransactionCategory(name: name, created: created)

        // Assert
        #expect(category.name == name)
        #expect(category.created == created)
        #expect(category.modified == nil)
        #expect(category.id != UUID())
    }

    @Test func equality() throws {
        // Arrange
        let date = Date()
        let category1 = try TransactionCategory(name: "Rent", created: date)
        let category2 = try TransactionCategory(name: "Rent", created: date)

        // Act & Assert
        #expect(category1 != category2, "Categories with different IDs should not be equal")
    }

    @Test func hashability() throws {
        // Arrange
        let category1 = try TransactionCategory(name: "Groceries", created: Date())
        let category2 = try TransactionCategory(name: "Groceries", created: Date())

        // Act
        let set: Set<TransactionCategory> = [category1, category2]

        // Assert
        #expect(set.count == 2, "Both categories should be in the set since they have different IDs")
    }

    @Test func modifiedDate() throws {
        // Arrange
        var category = try TransactionCategory(name: "Utilities", created: Date())

        // Act
        let modifiedDate = Date()
        category.modified = modifiedDate

        // Assert
        #expect(category.modified == modifiedDate)
    }

    @Test func initializationWithEmptyNameThrowsError() {
        // Arrange
        let name = ""

        // Act & Assert
        #expect(throws: TransactionCategory.TransactionCategoryError.emptyName) {
            _ = try TransactionCategory(name: name)
        }
    }

    @Test func updateName() throws {
        // Arrange
        var category = try TransactionCategory(name: "Utilities")
        let newName = "Updated Utilities"

        // Act
        try category.updateName(newName)

        // Assert
        #expect(category.name == newName)
        #expect(category.modified != nil)
    }

    @Test func updateNameWithWhitespaceChanges() throws {
        // Arrange
        var category = try TransactionCategory(name: "Utilities")
        let originalModified = category.modified
        let newName = "  Utilities  "

        // Act
        try category.updateName(newName)

        // Assert
        #expect(category.name == "Utilities")
        #expect(category.modified == originalModified)
    }

    @Test func initializationWithWhitespaces() throws {
        // Arrange
        let name = "  Salary  "

        // Act
        let category = try TransactionCategory(name: name)

        // Assert
        #expect(category.name == "Salary")
    }

    @Test func updateNameWithEmptyStringThrowsError() throws {
        // Arrange
        var category = try TransactionCategory(name: "Utilities")

        // Act & Assert
        #expect(throws: TransactionCategory.TransactionCategoryError.emptyName) {
            try category.updateName("")
        }
    }

    @Test func addTransaction() throws {
        // Arrange
        var category = try TransactionCategory(name: "Income")
        let transaction = Transaction(
            text: "Salary",
            amount: 1500.0,
            created: Date(),
            category: category
        )

        // Act
        category.addTransaction(transaction)

        // Assert
        #expect(category.transactions.count == 1)
        #expect(category.transactions.first?.id == transaction.id)
        #expect(category.modified != nil)
    }

    @Test func removeTransaction() throws {
        // Arrange
        var category = try TransactionCategory(name: "Income")
        let transaction = Transaction(
            text: "Salary",
            amount: 1500.0,
            created: Date(),
            category: category
        )
        category.addTransaction(transaction)

        // Act
        category.removeTransaction(transaction)

        // Assert
        #expect(category.transactions.isEmpty)
        #expect(category.modified != nil)
    }

    @Test func balanceWithNoTransactions() throws {
        // Arrange
        let category = try TransactionCategory(name: "Income")

        // Act & Assert
        #expect(category.balance == 0.0)
    }

    @Test func balanceWithPositiveTransactions() throws {
        // Arrange
        var category = try TransactionCategory(name: "Income")
        let transactions = [
            Transaction(text: "Salary", amount: 1500.0, created: Date(), category: category),
            Transaction(text: "Bonus", amount: 300.0, created: Date(), category: category)
        ]
        transactions.forEach { category.addTransaction($0) }

        // Act & Assert
        #expect(category.balance == 1800.0)
    }

    @Test func balanceWithNegativeTransactions() throws {
        // Arrange
        var category = try TransactionCategory(name: "Expense")
        let transactions = [
            Transaction(text: "Rent", amount: -800.0, created: Date(), category: category),
            Transaction(text: "Groceries", amount: -150.0, created: Date(), category: category)
        ]
        transactions.forEach { category.addTransaction($0) }

        // Act & Assert
        #expect(category.balance == -950.0)
    }

    @Test func balanceWithMixedTransactions() throws {
        // Arrange
        var category = try TransactionCategory(name: "Mixed")
        let transactions = [
            Transaction(text: "Income", amount: 2000.0, created: Date(), category: category),
            Transaction(text: "Expense", amount: -800.0, created: Date(), category: category),
            Transaction(text: "Refund", amount: 500.0, created: Date(), category: category),
            Transaction(text: "Fee", amount: -150.0, created: Date(), category: category)
        ]
        transactions.forEach { category.addTransaction($0) }

        // Act & Assert
        #expect(category.balance == 1550.0)
    }
}
