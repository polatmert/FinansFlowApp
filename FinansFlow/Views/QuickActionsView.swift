import SwiftUI

struct QuickActionsView: View {
    @Binding var showingAddTransaction: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Hızlı İşlemler")
                .font(.headline)
                .foregroundColor(ThemeColors.text)
            
            HStack(spacing: 20) {
                QuickActionButton(
                    title: "Gelir Ekle",
                    icon: "plus.circle.fill",
                    color: ThemeColors.income
                ) {
                    showingAddTransaction = true
                }
                
                QuickActionButton(
                    title: "Gider Ekle",
                    icon: "minus.circle.fill",
                    color: ThemeColors.expense
                ) {
                    showingAddTransaction = true
                }
            }
        }
        .padding()
        .background(ThemeColors.cardBackground)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: icon)
                    .font(.system(size: 30))
                Text(title)
                    .font(.caption)
            }
            .foregroundColor(color)
            .frame(maxWidth: .infinity)
            .padding()
            .background(color.opacity(0.1))
            .cornerRadius(8)
        }
    }
} 