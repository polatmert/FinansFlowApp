import SwiftUI

struct TransactionListView: View {
    let transactions: [Transaction]
    
    var body: some View {
        List(transactions) { transaction in
            HStack {
                VStack(alignment: .leading) {
                    Text(transaction.category.rawValue)
                        .font(.headline)
                    Text(transaction.note)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text("₺\(transaction.amount, specifier: "%.2f")")
                    .foregroundColor(transaction.type == .income ? .green : .red)
            }
        }
    }
} 