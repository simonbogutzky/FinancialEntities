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
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else {
            throw TransactionCategoryError.emptyName
        }
        self.name = trimmedName
        self.created = created
        self.modified = modified
    }

    mutating func updateName(_ newName: String) throws {
        let trimmedNewName = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedNewName.isEmpty else {
            throw TransactionCategoryError.emptyName
        }
        if name != trimmedNewName {
            name = trimmedNewName
            modified = Date()
        }
    }

    enum TransactionCategoryError: Error {
        case emptyName
    }
}
