import SwiftUI

struct LogoView: View {
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "dollarsign.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.white)
            
            Text("FinansFlow")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.white)
        }
        .padding(.top, 50)
    }
}

#Preview {
    ZStack {
        Color.blue
        LogoView()
    }
} 