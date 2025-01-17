import SwiftUI

struct AddTransactionView: View {
    @Binding var isPresented: Bool
    @Binding var transactions: [Transaction]
    
    @State private var amount = ""
    @State private var selectedType: TransactionType
    @State private var selectedCategory: Category
    @State private var note = ""
    
    init(isPresented: Binding<Bool>, transactions: Binding<[Transaction]>, initialType: TransactionType) {
        self._isPresented = isPresented
        self._transactions = transactions
        self._selectedType = State(initialValue: initialType)
        self._selectedCategory = State(initialValue: initialType == .income ? .otherIncome : .otherExpense)
        self.amount = ""
        self.note = ""
    }
    
    var body: some View {
        NavigationView {
            TransactionFormView(
                amount: $amount,
                selectedType: $selectedType,
                selectedCategory: $selectedCategory,
                note: $note,
                isPresented: $isPresented,
                saveAction: saveTransaction
            )
            .navigationTitle("İşlem Ekle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        isPresented = false
                    }
                }
            }
        }
        .interactiveDismissDisabled()
    }
    
    private func saveTransaction() {
        guard let amountDouble = Double(amount.replacingOccurrences(of: ",", with: ".")) else { return }
        
        let transaction = Transaction(
            amount: amountDouble,
            type: selectedType,
            category: selectedCategory,
            note: note
        )
        
        transactions.append(transaction)
        isPresented = false
    }
}

private struct TransactionFormView: View {
    @Binding var amount: String
    @Binding var selectedType: TransactionType
    @Binding var selectedCategory: Category
    @Binding var note: String
    @Binding var isPresented: Bool
    let saveAction: () -> Void
    
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    AmountInputView(amount: $amount, selectedType: selectedType)
                    TransactionDetailsView(
                        selectedType: $selectedType,
                        selectedCategory: $selectedCategory,
                        note: $note
                    )
                    SaveButtonView(selectedType: selectedType, action: saveAction)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    private var backgroundColor: Color {
        selectedType == .income ? ThemeColors.income.opacity(0.1) : ThemeColors.expense.opacity(0.1)
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// Tutar girişi görünümü
private struct AmountInputView: View {
    @Binding var amount: String
    let selectedType: TransactionType
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Tutar")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(ThemeColors.text)
            
            HStack {
                Text("₺")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(selectedType == .income ? ThemeColors.income : ThemeColors.expense)
                
                TextField("0,00", text: $amount)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(selectedType == .income ? ThemeColors.income : ThemeColors.expense)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.leading)
                    .placeholder(when: amount.isEmpty) {
                        Text("0,00")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor((selectedType == .income ? ThemeColors.income : ThemeColors.expense).opacity(0.3))
                    }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
    }
}

// İşlem detayları görünümü
private struct TransactionDetailsView: View {
    @Binding var selectedType: TransactionType
    @Binding var selectedCategory: Category
    @Binding var note: String
    
    var body: some View {
        VStack(spacing: 20) {
            // İşlem Tipi
            VStack(alignment: .leading, spacing: 8) {
                Text("İşlem Tipi")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(ThemeColors.text)
                
                HStack {
                    ForEach([TransactionType.income, TransactionType.expense], id: \.self) { type in
                        Button(action: {
                            withAnimation {
                                selectedType = type
                            }
                        }) {
                            Text(type == .income ? "Gelir" : "Gider")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(selectedType == type ? .white : ThemeColors.text)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    selectedType == type ?
                                        (type == .income ? ThemeColors.income : ThemeColors.expense) :
                                        Color.white
                                )
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(4)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            }
            .padding(.horizontal)
            
            // Kategori
            VStack(alignment: .leading, spacing: 12) {
                Text("Kategori")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(ThemeColors.text)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        let categories = selectedType == .income ? Category.incomeCategories : Category.expenseCategories
                        ForEach(categories, id: \.self) { category in
                            CategoryButton(
                                category: category,
                                isSelected: selectedCategory == category,
                                type: selectedType
                            ) {
                                selectedCategory = category
                            }
                        }
                    }
                }
            }
            
            // Not
            VStack(alignment: .leading, spacing: 8) {
                Text("Not")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(ThemeColors.text)
                
                TextField("", text: $note)
                    .placeholder(when: note.isEmpty) {
                        Text("İşlem notu ekleyin...")
                            .foregroundColor(Color.gray.opacity(0.5))
                    }
                    .padding()
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(ThemeColors.text)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
            }
            .padding(.horizontal)
        }
    }
}

// Kaydet butonu görünümü
private struct SaveButtonView: View {
    let selectedType: TransactionType
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("Kaydet")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    selectedType == .income ? ThemeColors.income : ThemeColors.expense
                )
                .cornerRadius(12)
        }
        .padding()
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

// CategoryButton yapısı aynı kalacak
struct CategoryButton: View {
    let category: Category
    let isSelected: Bool
    let type: TransactionType
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: iconName(for: category))
                    .font(.system(size: 24))
                Text(category.rawValue)
                    .font(.caption)
            }
            .foregroundColor(isSelected ? .white : ThemeColors.text)
            .frame(width: 80, height: 80)
            .background(
                isSelected
                    ? (type == .income ? ThemeColors.income : ThemeColors.expense)
                    : Color.white
            )
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
    }
    
    private func iconName(for category: Category) -> String {
        category.icon
    }
}

// Placeholder için extension
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

// NavigationBar başlık rengi için extension
extension View {
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithOpaqueBackground()
        coloredAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor(color),
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
        coloredAppearance.titleTextAttributes = [
            .foregroundColor: UIColor(color),
            .font: UIFont.systemFont(ofSize: 20, weight: .bold)
        ]

        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance

        return self
    }
} 

