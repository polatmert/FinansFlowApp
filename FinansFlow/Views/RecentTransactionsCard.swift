import SwiftUI

struct RecentTransactionsCard: View {
    let transactions: [Transaction]
    
    private var recentTransactions: [Transaction] {
        Array(transactions.sorted { $0.date > $1.date })
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Son İşlemler")
                .font(.headline)
                .foregroundColor(ThemeColors.text)
            
            if transactions.isEmpty {
                Text("Henüz işlem bulunmuyor")
                    .foregroundColor(ThemeColors.lightText)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical)
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(recentTransactions) { transaction in
                            TransactionRow(transaction: transaction)
                            
                            if transaction.id != recentTransactions.last?.id {
                                Divider()
                            }
                        }
                    }
                }
                .frame(maxHeight: 400)
            }
        }
        .padding()
        .background(ThemeColors.cardBackground)
        .cornerRadius(16)
    }
} 