import Foundation

enum TransactionType: String, Codable, Equatable {
    case income = "Gelir"
    case expense = "Gider"
}

struct Transaction: Identifiable, Codable, Equatable {
    let id: UUID
    var amount: Double
    var type: TransactionType
    var category: Category
    var date: Date
    var note: String
    
    enum CodingKeys: String, CodingKey {
        case id, amount, type, category, date, note
    }
    
    init(id: UUID = UUID(), amount: Double, type: TransactionType, category: Category, date: Date = Date(), note: String = "") {
        self.id = id
        self.amount = amount
        self.type = type
        self.category = category
        self.date = date
        self.note = note
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        amount = try container.decode(Double.self, forKey: .amount)
        type = try container.decode(TransactionType.self, forKey: .type)
        category = try container.decode(Category.self, forKey: .category)
        date = try container.decode(Date.self, forKey: .date)
        note = try container.decode(String.self, forKey: .note)
    }
} 