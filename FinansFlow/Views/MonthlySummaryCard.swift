import SwiftUI

struct MonthlySummaryCard: View {
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
            // Aylık Bakiye
            VStack(spacing: 8) {
                Text("Aylık Bakiye")
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