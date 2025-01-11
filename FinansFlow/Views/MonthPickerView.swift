import SwiftUI
import Foundation

struct MonthPickerView: View {
    @Binding var selectedDate: Date
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter
    }()
    
    var body: some View {
        HStack {
            Button(action: previousMonth) {
                Image(systemName: "chevron.left")
                    .foregroundColor(ThemeColors.text)
            }
            
            Text(dateFormatter.string(from: selectedDate))
                .font(.headline)
                .foregroundColor(ThemeColors.text)
                .frame(width: 150)
            
            Button(action: nextMonth) {
                Image(systemName: "chevron.right")
                    .foregroundColor(ThemeColors.text)
            }
        }
        .padding()
        .background(ThemeColors.cardBackground)
        .cornerRadius(12)
    }
    
    private func previousMonth() {
        if let newDate = calendar.date(byAdding: .month, value: -1, to: selectedDate) {
            selectedDate = newDate
        }
    }
    
    private func nextMonth() {
        if let newDate = calendar.date(byAdding: .month, value: 1, to: selectedDate) {
            selectedDate = newDate
        }
    }
}

#Preview {
    MonthPickerView(selectedDate: .constant(Date()))
} 