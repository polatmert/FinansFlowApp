import SwiftUI

struct RecentTransactionsCard: View {
    let transactions: [Transaction]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Son İşlemler")
                .font(.headline)
                .foregroundColor(ThemeColors.text)
            
            VStack(spacing: 12) {
                ForEach(transactions.prefix(5)) { transaction in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            // Kategori ve Tutar
                            VStack(alignment: .leading) {
                                Text(transaction.category.rawValue)
                                    .font(.headline)
                                    .foregroundColor(ThemeColors.text)
                                
                                Text("₺\(transaction.amount, specifier: "%.2f")")
                                    .font(.subheadline)
                                    .foregroundColor(transaction.type == .income ? ThemeColors.income : ThemeColors.expense)
                            }
                            
                            Spacer()
                            
                            // Tarih
                            Text(formatDate(transaction.date))
                                .font(.caption)
                                .foregroundColor(ThemeColors.lightText)
                        }
                        
                        // Not alanı (eğer varsa)
                        if !transaction.note.isEmpty {
                            Text(transaction.note)
                                .font(.subheadline)
                                .foregroundColor(ThemeColors.lightText)
                                .lineLimit(2)
                        }
                    }
                    .padding()
                    .background(ThemeColors.cardBackground)
                    .cornerRadius(12)
                    
                    if transaction.id != transactions.prefix(5).last?.id {
                        Divider()
                    }
                }
            }
        }
        .padding()
        .background(ThemeColors.cardBackground)
        .cornerRadius(16)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
} 