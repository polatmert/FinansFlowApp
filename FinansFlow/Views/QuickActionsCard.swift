import SwiftUI
import SafariServices

// BinanceWebView yapısı
struct BinanceWebView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

struct QuickActionsCard: View {
    @Binding var showingAddTransaction: Bool
    @Binding var transactions: [Transaction]
    @Binding var selectedTransactionType: TransactionType
    @State private var showingBinanceWebView = false
    @State private var binanceURL = URL(string: "https://www.binance.com/tr")!
    
    var actions: [QuickAction] {
        [
            QuickAction(title: "Gelir Ekle", icon: "plus.circle.fill", color: ThemeColors.income, type: .income),
            QuickAction(title: "Gider Ekle", icon: "minus.circle.fill", color: ThemeColors.expense, type: .expense),
            QuickAction(title: "Binance", icon: "bitcoinsign.circle.fill", color: Color(hex: "#F3BA2F"), type: .income),
            QuickAction(title: "Döviz", icon: "dollarsign.circle.fill", color: Color(hex: "#3498DB"), type: .income)
        ]
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Hızlı İşlemler")
                .font(.headline)
                .foregroundColor(ThemeColors.text)
            
            HStack(spacing: 20) {
                ForEach(actions) { action in
                    Button(action: {
                        handleActionTap(action)
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
        .sheet(isPresented: $showingBinanceWebView) {
            SafariView(url: binanceURL)
                .edgesIgnoringSafeArea(.all)
        }
    }
    
    private func handleActionTap(_ action: QuickAction) {
        switch action.title {
        case "Binance":
            showingBinanceWebView = true
        default:
            selectedTransactionType = action.type
            showingAddTransaction = true
        }
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = false
        config.barCollapsingEnabled = true
        
        let safariViewController = SFSafariViewController(url: url, configuration: config)
        safariViewController.preferredControlTintColor = UIColor(ThemeColors.primary)
        return safariViewController
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
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