import SwiftUI

struct MonthlyTransactionsCard: View {
    let transactions: [Transaction]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Aylık İşlemler")
                .font(.headline)
                .foregroundColor(ThemeColors.text)
            
            if transactions.isEmpty {
                Text("Bu ay henüz işlem bulunmuyor")
                    .foregroundColor(ThemeColors.lightText)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical)
            } else {
                ForEach(transactions.sorted(by: { $0.date > $1.date })) { transaction in
                    TransactionRow(transaction: transaction)
                    if transaction.id != transactions.last?.id {
                        Divider()
                    }
                }
            }
        }
        .padding(20)
        .background(ThemeColors.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
} 