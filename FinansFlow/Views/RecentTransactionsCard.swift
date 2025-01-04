import SwiftUI

struct RecentTransactionsCard: View {
    let transactions: [Transaction]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Son Hareketler")
                .font(.headline)
                .foregroundColor(ThemeColors.text)
            
            ForEach(transactions.prefix(5)) { transaction in
                TransactionRow(transaction: transaction)
                if transaction.id != transactions.last?.id {
                    Divider()
                }
            }
        }
        .padding(20)
        .background(ThemeColors.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
}

struct TransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        HStack {
            // İkon
            Image(systemName: transaction.type == .income ? "arrow.down.circle.fill" : "arrow.up.circle.fill")
                .foregroundColor(transaction.type == .income ? ThemeColors.income : ThemeColors.expense)
                .font(.title2)
            
            // İşlem detayları
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.category.rawValue)
                    .foregroundColor(ThemeColors.text)
                if !transaction.note.isEmpty {
                    Text(transaction.note)
                        .font(.subheadline)
                        .foregroundColor(ThemeColors.lightText)
                }
            }
            
            Spacer()
            
            // Tutar
            Text(transaction.type == .income ? 
                 String(format: "+₺%.2f", transaction.amount) :
                 String(format: "-₺%.2f", transaction.amount))
                .foregroundColor(transaction.type == .income ? ThemeColors.income : ThemeColors.expense)
        }
    }
} 