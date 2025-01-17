import SwiftUI

struct PieChartView: View {
    let slices: [(category: Category, percentage: Double)]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<slices.count, id: \.self) { index in
                    PieSlice(
                        startAngle: startAngle(for: index),
                        endAngle: endAngle(for: index),
                        color: colorForCategory(slices[index].category)
                    )
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.width)
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    private func startAngle(for index: Int) -> Double {
        let precedingTotal = slices[..<index].reduce(0) { $0 + $1.percentage }
        return precedingTotal * 360 / 100
    }
    
    private func endAngle(for index: Int) -> Double {
        let total = startAngle(for: index) + (slices[index].percentage * 360 / 100)
        return total
    }
    
    private func colorForCategory(_ category: Category) -> Color {
        switch category {
        case .salary:
            return Color(hex: "#2ECC71")
        case .investment:
            return Color(hex: "#3498DB")
        case .rental:
            return Color(hex: "#F1C40F")
        case .bonus:
            return Color(hex: "#9B59B6")
        case .freelance:
            return Color(hex: "#1ABC9C")
        case .interest:
            return Color(hex: "#E67E22")
        case .gift:
            return Color(hex: "#27AE60")
        case .refund:
            return Color(hex: "#16A085")
        case .otherIncome:
            return Color(hex: "#2980B9")
        case .rent:
            return Color(hex: "#C0392B")
        case .bills:
            return Color(hex: "#E74C3C")
        case .groceries:
            return Color(hex: "#D35400")
        case .dining:
            return Color(hex: "#922B21")
        case .transportation:
            return Color(hex: "#CB4335")
        case .shopping:
            return Color(hex: "#A93226")
        case .health:
            return Color(hex: "#B03A2E")
        case .education:
            return Color(hex: "#943126")
        case .entertainment:
            return Color(hex: "#8B2C1C")
        case .travel:
            return Color(hex: "#922B21")
        case .insurance:
            return Color(hex: "#C0392B")
        case .creditCard:
            return Color(hex: "#E74C3C")
        case .loan:
            return Color(hex: "#D35400")
        case .maintenance:
            return Color(hex: "#CB4335")
        case .otherExpense:
            return Color(hex: "#95A5A6")
        }
    }
}

struct PieSlice: Shape {
    let startAngle: Double
    let endAngle: Double
    let color: Color
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        path.move(to: center)
        path.addArc(
            center: center,
            radius: radius,
            startAngle: .degrees(startAngle - 90),
            endAngle: .degrees(endAngle - 90),
            clockwise: false
        )
        path.closeSubpath()
        
        return path
    }
} 