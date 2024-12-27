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
}
