import Foundation

class MonthlyTransactionManager: ObservableObject {
    @Published var transactions: [String: [Transaction]] = [:]
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter
    }()
    
    func addTransaction(_ transaction: Transaction) {
        let key = dateFormatter.string(from: transaction.date)
        if transactions[key] == nil {
            transactions[key] = []
        }
        transactions[key]?.append(transaction)
    }
    
    func getTransactions(for date: Date) -> [Transaction] {
        let key = dateFormatter.string(from: date)
        return transactions[key] ?? []
    }
    
    func monthlyTotal(for date: Date) -> (income: Double, expense: Double) {
        let monthTransactions = getTransactions(for: date)
        let income = monthTransactions.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
        let expense = monthTransactions.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
        return (income, expense)
    }
} 