import SwiftUI
import Foundation

struct MonthlyLimitSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var userSettings = UserSettings.shared
    @State private var limitAmount = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Aylık Limit Ayarları")) {
                    Toggle("Aylık Limit Bildirimi", isOn: $userSettings.monthlyLimitEnabled)
                    
                    if userSettings.monthlyLimitEnabled {
                        HStack {
                            Text("Minimum Bakiye")
                            Spacer()
                            TextField("₺0,00", text: $limitAmount)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .onChange(of: limitAmount) { newValue in
                                    if let amount = Double(newValue.replacingOccurrences(of: ",", with: ".")) {
                                        userSettings.monthlyLimitAmount = amount
                                    }
                                }
                        }
                    }
                }
                
                Section(footer: Text("Aylık bakiyeniz belirlediğiniz limitin altına düştüğünde bildirim alacaksınız.")) {
                    EmptyView()
                }
            }
            .navigationTitle("Limit Ayarları")
            .navigationBarItems(trailing: Button("Tamam") {
                presentationMode.wrappedValue.dismiss()
            })
        }
        .onAppear {
            limitAmount = String(format: "%.2f", userSettings.monthlyLimitAmount)
        }
    }
} 