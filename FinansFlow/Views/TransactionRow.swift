import SwiftUI

struct TransactionRow: View {
    let transaction: Transaction
    var onDelete: () -> Void
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(transaction.category.rawValue)
                        .font(.headline)
                        .foregroundColor(ThemeColors.text)
                    
                    Text(dateFormatter.string(from: transaction.date))
                        .font(.caption)
                        .foregroundColor(ThemeColors.lightText)
                }
                
                if !transaction.note.isEmpty {
                    Text(transaction.note)
                        .font(.subheadline)
                        .foregroundColor(ThemeColors.lightText)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            Text("₺\(transaction.amount, specifier: "%.2f")")
                .font(.headline)
                .foregroundColor(transaction.type == .income ? ThemeColors.income : ThemeColors.expense)
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(ThemeColors.expense)
            }
            .padding(.leading, 8)
        }
        .padding(.vertical, 8)
    }
} 