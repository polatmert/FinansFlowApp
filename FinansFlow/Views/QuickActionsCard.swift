import SwiftUI

struct QuickActionsCard: View {
    @Binding var showingAddTransaction: Bool
    @Binding var transactions: [Transaction]
    
    let actions = [
        QuickAction(title: "Gelir Ekle", icon: "plus.circle.fill", color: ThemeColors.income, type: .income),
        QuickAction(title: "Gider Ekle", icon: "minus.circle.fill", color: ThemeColors.expense, type: .expense),
        QuickAction(title: "Transfer", icon: "arrow.left.arrow.right.circle.fill", color: ThemeColors.primary, type: .income),
        QuickAction(title: "Döviz", icon: "dollarsign.circle.fill", color: Color(hex: "#3498DB"), type: .income)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Hızlı İşlemler")
                .font(.headline)
                .foregroundColor(ThemeColors.text)
            
            HStack(spacing: 20) {
                ForEach(actions) { action in
                    Button(action: {
                        showingAddTransaction = true
                    }) {
                        QuickActionView(action: action)
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

struct QuickAction: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let color: Color
    let type: TransactionType
}

struct QuickActionView: View {
    let action: QuickAction
    
    var body: some View {
        VStack {
            Image(systemName: action.icon)
                .font(.system(size: 24))
                .foregroundColor(action.color)
                .frame(width: 48, height: 48)
                .background(action.color.opacity(0.1))
                .cornerRadius(12)
            
            Text(action.title)
                .font(.caption)
                .foregroundColor(ThemeColors.text)
        }
        .frame(maxWidth: .infinity)
    }
} 