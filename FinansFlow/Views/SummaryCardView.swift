import SwiftUI

struct SummaryCardView: View {
    let transactions: [Transaction]
    
    private var totalIncome: Double {
        transactions
            .filter { $0.type == .income }
            .reduce(0) { $0 + $1.amount }
    }
    
    private var totalExpense: Double {
        transactions
            .filter { $0.type == .expense }
            .reduce(0) { $0 + $1.amount }
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // Bakiye Başlığı
            VStack(spacing: 8) {
                Text("Toplam Bakiye")
                    .font(.subheadline)
                    .foregroundColor(ThemeColors.lightText)
                Text("₺\(totalIncome - totalExpense, specifier: "%.2f")")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(ThemeColors.text)
            }
            
            // Gelir/Gider Özeti
            HStack(spacing: 40) {
                BalanceItem(
                    title: "Gelir",
                    amount: totalIncome,
                    color: ThemeColors.income,
                    icon: "arrow.down.circle.fill"
                )
                
                BalanceItem(
                    title: "Gider",
                    amount: totalExpense,
                    color: ThemeColors.expense,
                    icon: "arrow.up.circle.fill"
                )
            }
        }
        .padding(24)
        .background(ThemeColors.cardBackground)
        .cornerRadius(16)
    }
}

struct BalanceItem: View {
    let title: String
    let amount: Double
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .foregroundColor(ThemeColors.lightText)
            }
            .font(.subheadline)
            
            Text("₺\(amount, specifier: "%.2f")")
                .font(.headline)
                .foregroundColor(ThemeColors.text)
        }
    }
} 