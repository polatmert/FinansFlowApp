import SwiftUI

struct MonthlyLimitView: View {
    @StateObject private var userSettings = UserSettings.shared
    @State private var limitAmount = ""
    @State private var showingSaveAlert = false
    @State private var selectedTab = 0
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Üst Kart
                    VStack(spacing: 16) {
                        Image(systemName: "bell.badge.fill")
                            .font(.system(size: 50))
                            .foregroundColor(ThemeColors.primary)
                        
                        Text("Limit Bildirimleri")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(ThemeColors.text)
                        
                        Text("Aylık bakiyeniz belirlediğiniz limitin altına düştüğünde bildirim alın")
                            .multilineTextAlignment(.center)
                            .foregroundColor(ThemeColors.lightText)
                            .padding(.horizontal)
                    }
                    .padding(24)
                    .background(ThemeColors.cardBackground)
                    .cornerRadius(16)
                    
                    // Ayarlar Kartı
                    VStack(alignment: .leading, spacing: 20) {
                        Toggle("Limit Bildirimlerini Etkinleştir", isOn: $userSettings.monthlyLimitEnabled)
                            .foregroundColor(ThemeColors.text)
                            .tint(ThemeColors.primary)
                        
                        if userSettings.monthlyLimitEnabled {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Minimum Bakiye Limiti")
                                    .font(.headline)
                                    .foregroundColor(ThemeColors.text)
                                
                                HStack {
                                    Text("₺")
                                        .font(.title2)
                                        .foregroundColor(ThemeColors.primary)
                                    
                                    TextField("0,00", text: $limitAmount)
                                        .font(.title2)
                                        .keyboardType(.decimalPad)
                                        .focused($isTextFieldFocused)
                                        .foregroundColor(ThemeColors.text)
                                        .onChange(of: limitAmount) { newValue in
                                            let filtered = newValue.filter { "0123456789,".contains($0) }
                                            if filtered != newValue {
                                                limitAmount = filtered
                                            }
                                            
                                            if let commaIndex = filtered.firstIndex(of: ",") {
                                                let decimals = filtered[filtered.index(after: commaIndex)...]
                                                if decimals.count > 2 {
                                                    limitAmount = String(filtered.prefix(through: commaIndex)) + decimals.prefix(2)
                                                }
                                            }
                                        }
                                }
                                .padding()
                                .background(ThemeColors.cardBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(ThemeColors.primary.opacity(0.3), lineWidth: 1)
                                )
                                .cornerRadius(12)
                            }
                        }
                    }
                    .padding(24)
                    .background(ThemeColors.cardBackground)
                    .cornerRadius(16)
                    
                    // Kaydet Butonu
                    Button(action: {
                        if let amount = Double(limitAmount.replacingOccurrences(of: ",", with: ".")) {
                            userSettings.monthlyLimitAmount = amount
                            showingSaveAlert = true
                            isTextFieldFocused = false
                        }
                    }) {
                        Text("Kaydet")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(ThemeColors.primary)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                }
                .padding()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                isTextFieldFocused = false
            }
            .background(ThemeColors.background.ignoresSafeArea())
            .navigationTitle("Limit Ayarları")
            .navigationBarTitleDisplayMode(.large)
            .alert("Limit Güncellendi", isPresented: $showingSaveAlert) {
                Button("Tamam", role: .cancel) { 
                    isTextFieldFocused = false
                }
            } message: {
                Text("Aylık limit başarıyla güncellendi.")
            }
        }
        .onAppear {
            limitAmount = String(format: "%.2f", userSettings.monthlyLimitAmount)
                .replacingOccurrences(of: ".", with: ",")
        }
    }
} 