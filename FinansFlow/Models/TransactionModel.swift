import Foundation

enum TransactionType: String, Codable, Equatable {
    case income = "Gelir"
    case expense = "Gider"
}

enum Category: String, Codable, CaseIterable, Equatable {
    case cash = "Nakit"
    case foreignCurrency = "Döviz"
    case gold = "Altın"
    case crypto = "Kripto"
    case salary = "Maaş"
    case food = "Gıda"
    case transport = "Ulaşım"
    case rent = "Kira"
    case other = "Diğer"
}

struct Transaction: Identifiable, Codable, Equatable {
    let id: UUID
    var amount: Double
    var type: TransactionType
    var category: Category
    var date: Date
    var note: String
    
    init(id: UUID = UUID(), amount: Double, type: TransactionType, category: Category, date: Date = Date(), note: String = "") {
        self.id = id
        self.amount = amount
        self.type = type
        self.category = category
        self.date = date
        self.note = note
    }
} 