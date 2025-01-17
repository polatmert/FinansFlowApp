import SwiftUI

struct QuickAction: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let color: Color
    let type: TransactionType
    var action: (() -> Void)?
} 