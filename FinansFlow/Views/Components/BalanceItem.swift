import SwiftUI

struct BalanceItem: View {
    let title: String
    let amount: Double
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(ThemeColors.lightText)
            }
            
            Text("₺\(amount, specifier: "%.2f")")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(color)
        }
    }
} 