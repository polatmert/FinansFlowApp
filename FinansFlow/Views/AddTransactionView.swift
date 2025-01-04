import SwiftUI

struct AddTransactionView: View {
    @Binding var isPresented: Bool
    @Binding var transactions: [Transaction]
    @State private var amount: String = ""
    @State private var selectedType: TransactionType = .income
    @State private var selectedCategory: Category = .cash
    @State private var note: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                // Tutar
                Section(header: Text("Tutar")) {
                    TextField("₺0.00", text: $amount)
                        .keyboardType(.decimalPad)
                }
                
                // İşlem Tipi
                Section(header: Text("İşlem Tipi")) {
                    Picker("Tip", selection: $selectedType) {
                        Text("Gelir").tag(TransactionType.income)
                        Text("Gider").tag(TransactionType.expense)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                // Kategori
                Section(header: Text("Kategori")) {
                    Picker("Kategori", selection: $selectedCategory) {
                        ForEach(Category.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                }
                
                // Not
                Section(header: Text("Not")) {
                    TextField("İşlem notu...", text: $note)
                }
            }
            .navigationTitle("Yeni İşlem")
            .navigationBarItems(
                leading: Button("İptal") {
                    isPresented = false
                },
                trailing: Button("Kaydet") {
                    saveTransaction()
                }
            )
        }
    }
    
    private func saveTransaction() {
        guard let amountValue = Double(amount.replacingOccurrences(of: ",", with: ".")) else { return }
        
        let newTransaction = Transaction(
            amount: amountValue,
            type: selectedType,
            category: selectedCategory,
            date: Date(),
            note: note
        )
        
        // Yeni işlemi transactions dizisine ekle
        transactions.append(newTransaction)
        
        // Form'u temizle
        amount = ""
        note = ""
        
        // Görünümü kapat
        isPresented = false
    }
} 