//
//  Transaction.swift
//  FinancialEntities
//
//  Created by Simon Bogutzky on 28.12.24.
//

import Foundation

struct Transaction: Identifiable, Hashable {
    var id = UUID()
    private(set) var text: String
    private(set) var amount: Double
    var created: Date
    var modified: Date?
    private(set) var category: TransactionCategory

    init(text: String, amount: Double, created: Date = Date(), modified: Date? = nil, category: TransactionCategory) {
        self.text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        self.amount = amount
        self.created = created
        self.modified = modified
        self.category = category
        var mutableCategory = category
        mutableCategory.addTransaction(self)
    }

    mutating func updateText(_ newText: String) {
        let trimmedText = newText.trimmingCharacters(in: .whitespacesAndNewlines)
        if text != trimmedText {
            text = trimmedText
            modified = Date()
        }
    }

    mutating func updateAmount(_ newAmount: Double) {
        if amount != newAmount {
            amount = newAmount
            modified = Date()
        }
    }

    mutating func updateCategory(_ newCategory: TransactionCategory) {
        if category != newCategory {
            category = newCategory
            modified = Date()
        }
    }
}
