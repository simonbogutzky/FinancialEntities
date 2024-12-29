@testable import FinancialEntities
import Foundation
import Testing

struct TransactionTests {
    @Test func initialization() throws {
        // Arrange
        let text = "Salary"
        let amount = 1500.0
        let created = Date()
        let category = try TransactionCategory(name: "Income")

        // Act
        let transaction = Transaction(
            text: text,
            amount: amount,
            created: created,
            category: category
        )

        // Assert
        #expect(transaction.text == text)
        #expect(transaction.amount == amount)
        #expect(transaction.created == created)
        #expect(transaction.modified == nil)
        #expect(transaction.category == category)
        #expect(transaction.id != UUID())
    }

    @Test func equality() throws {
        // Arrange
        let date = Date()
        let category = try TransactionCategory(name: "Expense")
        let transaction1 = Transaction(
            text: "Groceries",
            amount: 50.0,
            created: date,
            category: category
        )
        let transaction2 = Transaction(
            text: "Groceries",
            amount: 50.0,
            created: date,
            category: category
        )

        // Act & Assert
        #expect(transaction1 != transaction2, "Transactions with different IDs should not be equal")
    }

    @Test func hashability() throws {
        // Arrange
        let category = try TransactionCategory(name: "Transport")
        let transaction1 = Transaction(
            text: "Bus Ticket",
            amount: 2.5,
            created: Date(),
            category: category
        )
        let transaction2 = Transaction(
            text: "Bus Ticket",
            amount: 2.5,
            created: Date(),
            category: category
        )

        // Act
        let set: Set<Transaction> = [transaction1, transaction2]

        // Assert
        #expect(set.count == 2, "Both transactions should be in the set since they have different IDs")
    }

    @Test func modifiedDate() throws {
        // Arrange
        let category = try TransactionCategory(name: "Utilities")
        var transaction = Transaction(
            text: "Electricity",
            amount: 75.0,
            created: Date(),
            category: category
        )

        // Act
        let modifiedDate = Date()
        transaction.modified = modifiedDate

        // Assert
        #expect(transaction.modified == modifiedDate)
    }

    @Test func initializationWithWhitespaceText() throws {
        // Arrange
        let text = "  Salary  "
        let category = try TransactionCategory(name: "Income")

        // Act
        let transaction = Transaction(
            text: text,
            amount: 1500.0,
            created: Date(),
            category: category
        )

        // Assert
        #expect(transaction.text == "Salary")
    }

    @Test func initializationWithEmptyText() throws {
        // Arrange
        let text = "   "
        let category = try TransactionCategory(name: "Income")

        // Act
        let transaction = Transaction(
            text: text,
            amount: 1500.0,
            created: Date(),
            category: category
        )

        // Assert
        #expect(transaction.text.isEmpty)
    }

    @Test func initializationWithNegativeAmount() throws {
        // Arrange
        let category = try TransactionCategory(name: "Expense")

        // Act
        let transaction = Transaction(
            text: "Refund",
            amount: -50.0,
            created: Date(),
            category: category
        )

        // Assert
        #expect(transaction.amount == -50.0)
    }

    @Test func initializationWithZeroAmount() throws {
        // Arrange
        let category = try TransactionCategory(name: "Income")

        // Act
        let transaction = Transaction(
            text: "Gift",
            amount: 0.0,
            created: Date(),
            category: category
        )

        // Assert
        #expect(transaction.amount == 0.0)
    }

    @Test func updateText() throws {
        // Arrange
        var transaction = try Transaction(
            text: "Original",
            amount: 100.0,
            created: Date(),
            category: TransactionCategory(name: "Expense")
        )
        let newText = "Updated"

        // Act
        transaction.updateText(newText)

        // Assert
        #expect(transaction.text == newText)
        #expect(transaction.modified != nil)
    }

    @Test func updateTextWithWhitespace() throws {
        // Arrange
        var transaction = try Transaction(
            text: "Original",
            amount: 100.0,
            created: Date(),
            category: TransactionCategory(name: "Expense")
        )
        let originalModified = transaction.modified

        // Act
        transaction.updateText("  Original  ")

        // Assert
        #expect(transaction.text == "Original")
        #expect(transaction.modified == originalModified)
    }

    @Test func updateAmount() throws {
        // Arrange
        var transaction = try Transaction(
            text: "Salary",
            amount: 1000.0,
            created: Date(),
            category: TransactionCategory(name: "Income")
        )
        let newAmount = 1200.0

        // Act
        transaction.updateAmount(newAmount)

        // Assert
        #expect(transaction.amount == newAmount)
        #expect(transaction.modified != nil)
    }

    @Test func updateAmountSameValue() throws {
        // Arrange
        var transaction = try Transaction(
            text: "Salary",
            amount: 1000.0,
            created: Date(),
            category: TransactionCategory(name: "Income")
        )
        let originalModified = transaction.modified

        // Act
        transaction.updateAmount(1000.0)

        // Assert
        #expect(transaction.amount == 1000.0)
        #expect(transaction.modified == originalModified)
    }

    @Test func updateCategory() throws {
        // Arrange
        var transaction = try Transaction(
            text: "Salary",
            amount: 1000.0,
            created: Date(),
            category: TransactionCategory(name: "Income")
        )
        let newCategory = try TransactionCategory(name: "Bonus")

        // Act
        transaction.updateCategory(newCategory)

        // Assert
        #expect(transaction.category == newCategory)
        #expect(transaction.modified != nil)
    }

    @Test func updateCategorySameValue() throws {
        // Arrange
        let category = try TransactionCategory(name: "Income")
        var transaction = Transaction(
            text: "Salary",
            amount: 1000.0,
            created: Date(),
            category: category
        )
        let originalModified = transaction.modified

        // Act
        transaction.updateCategory(category)

        // Assert
        #expect(transaction.category == category)
        #expect(transaction.modified == originalModified)
    }
}
