//
//  ContentView.swift
//  FinansFlow
//
//  Created by Mert Polat on 4.01.2025.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    @State private var transactions: [Transaction] = []
    @State private var showingAddTransaction = false
    @State private var selectedTab = 0
    @State private var selectedDate = Date()
    @State private var showLimitSettings = false
    @State private var showLimitAlert = false
    @State private var selectedTransactionType: TransactionType = .income
    @Binding var isAuthenticated: Bool
    @StateObject private var userSettings = UserSettings.shared
    
    private var currentMonthTransactions: [Transaction] {
        let calendar = Calendar.current
        return transactions.filter { transaction in
            calendar.isDate(transaction.date, equalTo: selectedDate, toGranularity: .month)
        }
    }
    
    private var totalIncome: Double {
        transactions
            .filter { $0.type == .income }
            .reduce(0) { $0 + $1.amount }
    }
    
    private var totalExpense: Double {
        transactions
            .filter { $0.type == .expense }
            .reduce(0) { $0 + $1.amount }
    }
    
    private var currentBalance: Double {
        totalIncome - totalExpense
    }
    
    // Ana sayfa view'ı
    private var homeView: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    MonthPickerView(selectedDate: $selectedDate)
                        .padding(.horizontal)
                    
                    TotalAssetsCard(transactions: currentMonthTransactions)
                    AssetDistributionCard(transactions: currentMonthTransactions)
                    QuickActionsCard(
                        showingAddTransaction: $showingAddTransaction,
                        transactions: $transactions,
                        selectedTransactionType: $selectedTransactionType
                    )
                    
                    if transactions.isEmpty {
                        Text("Henüz işlem bulunmuyor")
                            .foregroundColor(ThemeColors.lightText)
                            .padding()
                    } else {
                        RecentTransactionsCard(transactions: currentMonthTransactions)
                    }
                }
                .padding()
            }
            .background(ThemeColors.background.ignoresSafeArea())
            .navigationTitle("Varlıklarım")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                toolbarContent
            }
        }
    }
    
    // Toolbar içeriği
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            HStack {
                Button(action: {
                    selectedTransactionType = .income
                    showingAddTransaction = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(ThemeColors.primary)
                }
                
                Button(action: logout) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.title2)
                        .foregroundColor(ThemeColors.expense)
                }
            }
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            homeView
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Ana Sayfa")
                }
                .tag(0)
            
            NavigationView {
                MonthlyLimitView()
            }
            .tabItem {
                Image(systemName: "chart.line.downtrend.xyaxis")
                Text("Limit Ayarları")
            }
            .tag(1)
        }
        .sheet(isPresented: $showingAddTransaction) {
            AddTransactionView(
                isPresented: $showingAddTransaction,
                transactions: $transactions,
                initialType: selectedTransactionType
            )
        }
        .sheet(isPresented: $showLimitSettings) {
            MonthlyLimitSettingsView()
        }
        .onAppear {
            if !UserDefaults.standard.bool(forKey: "hasShownInitialLimitSettings") {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showLimitSettings = true
                    UserDefaults.standard.set(true, forKey: "hasShownInitialLimitSettings")
                }
            }
            _ = NotificationManager.shared
        }
        .onChange(of: transactions) { newTransactions in
            checkMonthlyLimit()
        }
        .alert("Finansal Uyarı! 🚨", isPresented: $showLimitAlert) {
            Button("Tamam", role: .cancel) { }
        } message: {
            Text("""
                Dikkat! Finansal sağlığınız risk altında!
                Mevcut bakiyeniz: ₺\(String(format: "%.2f", currentBalance))
                Belirlediğiniz limit: ₺\(String(format: "%.2f", userSettings.monthlyLimitAmount))
                
                Lütfen harcamalarınızı gözden geçirin.
                """)
        }
    }
    
    private func logout() {
        isAuthenticated = false
    }
    
    private func checkMonthlyLimit() {
        if currentBalance < userSettings.monthlyLimitAmount && userSettings.monthlyLimitEnabled {
            showLimitAlert = true
            NotificationManager.shared.sendLimitNotification(
                currentBalance: currentBalance,
                limitAmount: userSettings.monthlyLimitAmount
            )
        }
    }
}

#Preview {
    ContentView(isAuthenticated: .constant(true))
}
