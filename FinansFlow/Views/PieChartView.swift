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
        case .cash: return ThemeColors.primary
        case .foreignCurrency: return Color(hex: "#3498DB")
        case .gold: return Color(hex: "#F1C40F")
        case .crypto: return Color(hex: "#E67E22")
        default: return ThemeColors.secondary
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