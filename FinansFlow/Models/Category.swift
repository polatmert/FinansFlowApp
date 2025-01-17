enum Category: String, Codable, CaseIterable, Equatable {
    // Gelir Kategorileri
    case salary = "Maaş"
    case investment = "Yatırım Geliri"
    case rental = "Kira Geliri"
    case bonus = "Prim/Bonus"
    case freelance = "Serbest Çalışma"
    case interest = "Faiz Geliri"
    case gift = "Hediye/Bağış"
    case refund = "İade/Geri Ödeme"
    case otherIncome = "Diğer Gelir"
    
    // Gider Kategorileri
    case rent = "Kira"
    case bills = "Faturalar"
    case groceries = "Market"
    case dining = "Yeme/İçme"
    case transportation = "Ulaşım"
    case shopping = "Alışveriş"
    case health = "Sağlık"
    case education = "Eğitim"
    case entertainment = "Eğlence"
    case travel = "Seyahat"
    case insurance = "Sigorta"
    case creditCard = "Kredi Kartı"
    case loan = "Kredi Ödemesi"
    case maintenance = "Bakım/Onarım"
    case otherExpense = "Diğer Gider"
    
    static var incomeCategories: [Category] {
        [.salary, .investment, .rental, .bonus, .freelance, .interest, .gift, .refund, .otherIncome]
    }
    
    static var expenseCategories: [Category] {
        [.rent, .bills, .groceries, .dining, .transportation, .shopping, .health, .education, .entertainment, .travel, .insurance, .creditCard, .loan, .maintenance, .otherExpense]
    }
    
    var icon: String {
        switch self {
        // Gelir İkonları
        case .salary: return "dollarsign.circle.fill"
        case .investment: return "chart.line.uptrend.xyaxis"
        case .rental: return "house.fill"
        case .bonus: return "star.fill"
        case .freelance: return "briefcase.fill"
        case .interest: return "percent"
        case .gift: return "gift.fill"
        case .refund: return "arrow.counterclockwise.circle.fill"
        case .otherIncome: return "plus.circle.fill"
            
        // Gider İkonları
        case .rent: return "house.circle.fill"
        case .bills: return "doc.text.fill"
        case .groceries: return "cart.fill"
        case .dining: return "fork.knife"
        case .transportation: return "car.fill"
        case .shopping: return "bag.fill"
        case .health: return "heart.fill"
        case .education: return "book.fill"
        case .entertainment: return "tv.fill"
        case .travel: return "airplane"
        case .insurance: return "shield.fill"
        case .creditCard: return "creditcard.fill"
        case .loan: return "banknote.fill"
        case .maintenance: return "wrench.fill"
        case .otherExpense: return "minus.circle.fill"
        }
    }
} 