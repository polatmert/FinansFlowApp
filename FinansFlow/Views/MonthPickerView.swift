import SwiftUI

struct MonthPickerView: View {
    @Binding var selectedDate: Date
    @State private var showDatePicker = false
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter
    }()
    
    var body: some View {
        Button(action: { showDatePicker = true }) {
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(ThemeColors.primary)
                Text(dateFormatter.string(from: selectedDate))
                    .foregroundColor(ThemeColors.text)
            }
            .padding()
            .background(ThemeColors.cardBackground)
            .cornerRadius(12)
        }
        .sheet(isPresented: $showDatePicker) {
            NavigationView {
                VStack {
                    DatePicker("Tarih Seçin", 
                             selection: $selectedDate,
                             displayedComponents: [.date])
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .padding()
                        .environment(\.locale, Locale(identifier: "tr_TR"))
                    
                    Button("Seç") {
                        showDatePicker = false
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(ThemeColors.primary)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding()
                }
                .navigationTitle("Ay Seçin")
                .navigationBarItems(trailing: Button("Kapat") {
                    showDatePicker = false
                })
            }
        }
    }
}

#Preview {
    MonthPickerView(selectedDate: .constant(Date()))
} 