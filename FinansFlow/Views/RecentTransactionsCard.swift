import SwiftUI

struct RecentTransactionsCard: View {
    @Binding var transactions: [Transaction]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Son İşlemler")
                .font(.headline)
                .foregroundColor(ThemeColors.text)
            
            ForEach(transactions.sorted(by: { $0.date > $1.date })) { transaction in
                TransactionRow(
                    transaction: transaction,
                    onDelete: { deleteTransaction(transaction) }
                )
                if transaction.id != transactions.last?.id {
                    Divider()
                }
            }
        }
        .padding(20)
        .background(ThemeColors.cardBackground)
        .cornerRadius(16)
    }
    
    private func deleteTransaction(_ transaction: Transaction) {
        withAnimation {
            if let index = transactions.firstIndex(where: { $0.id == transaction.id }) {
                transactions.remove(at: index)
            }
        }
    }
} 