import SwiftUI

struct TotalAssetsCard: View {
    let transactions: [Transaction]
    
    init(transactions: [Transaction]) {
        self.transactions = transactions
    }
    
    // Toplam varlık hesaplama
    private var totalAssets: Double {
        let totalIncome = transactions
            .filter { $0.type == .income }
            .reduce(0) { $0 + $1.amount }
        
        let totalExpense = transactions
            .filter { $0.type == .expense }
            .reduce(0) { $0 + $1.amount }
        
        return totalIncome - totalExpense
    }
    
    // Günlük değişim hesaplama
    private var dailyChange: (amount: Double, percentage: Double) {
        let today = Calendar.current.startOfDay(for: Date())
        let todayTransactions = transactions.filter {
            Calendar.current.isDate($0.date, inSameDayAs: today)
        }
        
        let todayIncome = todayTransactions
            .filter { $0.type == .income }
            .reduce(0) { $0 + $1.amount }
        
        let todayExpense = todayTransactions
            .filter { $0.type == .expense }
            .reduce(0) { $0 + $1.amount }
        
        let change = todayIncome - todayExpense
        let percentage = totalAssets != 0 ? (change / totalAssets) * 100 : 0
        
        return (change, percentage)
    }
    
    // Aylık değişim hesaplama
    private var monthlyChange: (amount: Double, percentage: Double) {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: Date()))!
        
        let monthTransactions = transactions.filter {
            $0.date >= startOfMonth
        }
        
        let monthIncome = monthTransactions
            .filter { $0.type == .income }
            .reduce(0) { $0 + $1.amount }
        
        let monthExpense = monthTransactions
            .filter { $0.type == .expense }
            .reduce(0) { $0 + $1.amount }
        
        let change = monthIncome - monthExpense
        let percentage = totalAssets != 0 ? (change / totalAssets) * 100 : 0
        
        return (change, percentage)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Üst Kısım
            VStack(spacing: 8) {
                Text("Toplam Varlık")
                    .font(.subheadline)
                    .foregroundColor(ThemeColors.lightText)
                
                Text("₺\(totalAssets, specifier: "%.2f")")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(ThemeColors.text)
            }
            
            Divider()
            
            // Alt Kısım - Değişim
            HStack {
                // Günlük Değişim
                ChangeIndicator(
                    title: "Günlük",
                    amount: String(format: "₺%.2f", dailyChange.amount),
                    percentage: String(format: "%.2f%%", dailyChange.percentage),
                    isPositive: dailyChange.amount >= 0
                )
                
                Divider()
                
                // Aylık Değişim
                ChangeIndicator(
                    title: "Aylık",
                    amount: String(format: "₺%.2f", monthlyChange.amount),
                    percentage: String(format: "%.2f%%", monthlyChange.percentage),
                    isPositive: monthlyChange.amount >= 0
                )
            }
        }
        .padding(20)
        .background(ThemeColors.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
}

struct ChangeIndicator: View {
    let title: String
    let amount: String
    let percentage: String
    let isPositive: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(ThemeColors.lightText)
            
            Text(amount)
                .font(.headline)
                .foregroundColor(ThemeColors.text)
            
            HStack(spacing: 4) {
                Image(systemName: isPositive ? "arrow.up.right" : "arrow.down.right")
                Text(percentage)
            }
            .font(.subheadline)
            .foregroundColor(isPositive ? ThemeColors.income : ThemeColors.expense)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
