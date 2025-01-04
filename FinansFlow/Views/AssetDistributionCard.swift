import SwiftUI

struct AssetDistributionCard: View {
    let transactions: [Transaction]
    @State private var selectedPage = 0
    
    init(transactions: [Transaction]) {
        self.transactions = transactions
    }
    
    private var incomeDistribution: [Category: Double] {
        var distribution: [Category: Double] = [:]
        for transaction in transactions where transaction.type == .income {
            distribution[transaction.category, default: 0] += transaction.amount
        }
        return distribution
    }
    
    private var expenseDistribution: [Category: Double] {
        var distribution: [Category: Double] = [:]
        for transaction in transactions where transaction.type == .expense {
            distribution[transaction.category, default: 0] += transaction.amount
        }
        return distribution
    }
    
    private var totalIncome: Double {
        incomeDistribution.values.reduce(0, +)
    }
    
    private var totalExpense: Double {
        expenseDistribution.values.reduce(0, +)
    }
    
    private var displayedIncomeAssets: [(category: Category, amount: Double)] {
        Category.allCases
            .filter { category in
                incomeDistribution[category, default: 0] > 0
            }
            .map { category in
                (category: category, amount: incomeDistribution[category, default: 0])
            }
            .sorted { $0.amount > $1.amount }
    }
    
    private var displayedExpenseAssets: [(category: Category, amount: Double)] {
        Category.allCases
            .filter { category in
                expenseDistribution[category, default: 0] > 0
            }
            .map { category in
                (category: category, amount: expenseDistribution[category, default: 0])
            }
            .sorted { $0.amount > $1.amount }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Varlık Dağılımı")
                .font(.headline)
                .foregroundColor(ThemeColors.text)
            
            // Gelir/Gider Özeti
            HStack(spacing: 20) {
                // Gelir Özeti
                VStack(alignment: .leading, spacing: 4) {
                    Text("Toplam Gelir")
                        .font(.subheadline)
                        .foregroundColor(ThemeColors.lightText)
                    Text("₺\(totalIncome, specifier: "%.2f")")
                        .font(.headline)
                        .foregroundColor(ThemeColors.income)
                }
                
                Divider()
                
                // Gider Özeti
                VStack(alignment: .leading, spacing: 4) {
                    Text("Toplam Gider")
                        .font(.subheadline)
                        .foregroundColor(ThemeColors.lightText)
                    Text("₺\(totalExpense, specifier: "%.2f")")
                        .font(.headline)
                        .foregroundColor(ThemeColors.expense)
                }
            }
            .padding(.vertical, 8)
            
            // Pasta Grafikleri
            TabView(selection: $selectedPage) {
                // Gelir Grafiği
                VStack {
                    Text("Gelir Dağılımı")
                        .font(.subheadline)
                        .foregroundColor(ThemeColors.income)
                    
                    if !displayedIncomeAssets.isEmpty {
                        ChartView(
                            assets: displayedIncomeAssets,
                            total: totalIncome,
                            type: .income
                        )
                    } else {
                        EmptyChartView(message: "Henüz gelir kaydı yok")
                    }
                }
                .tag(0)
                
                // Gider Grafiği
                VStack {
                    Text("Gider Dağılımı")
                        .font(.subheadline)
                        .foregroundColor(ThemeColors.expense)
                    
                    if !displayedExpenseAssets.isEmpty {
                        ChartView(
                            assets: displayedExpenseAssets,
                            total: totalExpense,
                            type: .expense
                        )
                    } else {
                        EmptyChartView(message: "Henüz gider kaydı yok")
                    }
                }
                .tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .frame(height: 300)
        }
        .padding(20)
        .background(ThemeColors.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
}

struct ChartView: View {
    let assets: [(category: Category, amount: Double)]
    let total: Double
    let type: TransactionType
    
    var body: some View {
        VStack(spacing: 16) {
            // Pasta Grafik
            ZStack {
                ForEach(0..<assets.count, id: \.self) { index in
                    let asset = assets[index]
                    let percentage = (asset.amount / total) * 100
                    
                    PieSliceView(
                        startAngle: .degrees(startAngle(for: index)),
                        endAngle: .degrees(startAngle(for: index) + (percentage * 3.6)),
                        color: colorForCategory(asset.category)
                    )
                }
            }
            .frame(height: 150)
            .padding(.vertical)
            
            // Kategori Listesi
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(assets, id: \.category) { asset in
                        HStack(spacing: 12) {
                            Circle()
                                .fill(colorForCategory(asset.category))
                                .frame(width: 12, height: 12)
                            
                            Text(asset.category.rawValue)
                                .font(.subheadline)
                                .foregroundColor(ThemeColors.text)
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 2) {
                                Text("₺\(asset.amount, specifier: "%.2f")")
                                    .font(.subheadline)
                                    .foregroundColor(type == .income ? ThemeColors.income : ThemeColors.expense)
                                
                                Text(String(format: "%.1f%%", (asset.amount / total) * 100))
                                    .font(.caption)
                                    .foregroundColor(ThemeColors.lightText)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
    }
    
    private func startAngle(for index: Int) -> Double {
        var angle: Double = 0
        for i in 0..<index {
            let percentage = (assets[i].amount / total) * 100
            angle += percentage * 3.6
        }
        return angle
    }
    
    private func colorForCategory(_ category: Category) -> Color {
        switch category {
        case .cash:
            return Color(hex: "#2ECC71") // Yeşil
        case .foreignCurrency:
            return Color(hex: "#3498DB") // Mavi
        case .gold:
            return Color(hex: "#F1C40F") // Altın
        case .crypto:
            return Color(hex: "#9B59B6") // Mor
        case .salary:
            return Color(hex: "#E67E22") // Turuncu
        case .food:
            return Color(hex: "#E74C3C") // Kırmızı
        case .transport:
            return Color(hex: "#1ABC9C") // Turkuaz
        case .rent:
            return Color(hex: "#34495E") // Lacivert
        case .other:
            return Color(hex: "#95A5A6") // Gri
        }
    }
}

struct EmptyChartView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "chart.pie")
                .font(.system(size: 40))
                .foregroundColor(ThemeColors.lightText)
            Text(message)
                .foregroundColor(ThemeColors.lightText)
        }
        .frame(maxWidth: .infinity, maxHeight: 200)
    }
}

// PieSliceView yapısı aynı kalacak
struct PieSliceView: View {
    let startAngle: Angle
    let endAngle: Angle
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                let radius = min(geometry.size.width, geometry.size.height) / 2
                
                path.move(to: center)
                path.addArc(
                    center: center,
                    radius: radius,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: false
                )
                path.closeSubpath()
            }
            .fill(color)
        }
    }
} 