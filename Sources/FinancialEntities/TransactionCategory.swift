//
//  TransactionCategory.swift
//  FinancialEntities
//
//  Created by Simon Bogutzky on 27.12.24.
//

import Foundation

struct TransactionCategory: Identifiable, Hashable {
    var id = UUID()
    private(set) var name: String
    var created: Date
    var modified: Date?

    init(name: String, created: Date = Date(), modified: Date? = nil) throws {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw TransactionCategoryError.emptyName
        }
        self.name = name
        self.created = created
        self.modified = modified
    }

    mutating func updateName(_ newName: String) throws {
        guard !newName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw TransactionCategoryError.emptyName
        }
        let trimmedNewName = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        if name.trimmingCharacters(in: .whitespacesAndNewlines) != trimmedNewName {
            name = trimmedNewName
            modified = Date()
        } else if name != newName {
            // Update name to match exact whitespace
            name = newName
            modified = Date()
        }
    }

    enum TransactionCategoryError: Error {
        case emptyName
    }
}
