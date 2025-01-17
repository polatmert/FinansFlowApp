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
                        RecentTransactionsCard(transactions: $transactions)
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
    
    private var alertView: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(ThemeColors.expense)
            
            Text("Finansal Uyarı! 🚨")
                .font(.title2.bold())
                .foregroundColor(ThemeColors.text)
            
            VStack(spacing: 8) {
                Text("Dikkat! Finansal sağlığınız risk altında!")
                    .font(.headline)
                    .foregroundColor(ThemeColors.text)
                    .multilineTextAlignment(.center)
                
                VStack(spacing: 4) {
                    HStack {
                        Text("Mevcut bakiye:")
                            .foregroundColor(ThemeColors.text)
                        Text("₺\(String(format: "%.2f", currentBalance))")
                            .foregroundColor(ThemeColors.expense)
                            .bold()
                    }
                    
                    HStack {
                        Text("Belirlenen limit:")
                            .foregroundColor(ThemeColors.text)
                        Text("₺\(String(format: "%.2f", userSettings.monthlyLimitAmount))")
                            .foregroundColor(ThemeColors.primary)
                            .bold()
                    }
                }
                .font(.subheadline)
                
                Text("Lütfen harcamalarınızı gözden geçirin.")
                    .font(.subheadline)
                    .foregroundColor(ThemeColors.lightText)
                    .padding(.top, 8)
            }
            
            Button(action: {
                showLimitAlert = false
            }) {
                Text("Anladım")
                    .font(.headline)
                    .foregroundColor(ThemeColors.cardBackground)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(ThemeColors.primary)
                    .cornerRadius(12)
            }
            .padding(.top, 8)
        }
        .padding(24)
        .background(ThemeColors.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 10)
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
        .alert(isPresented: $showLimitAlert) {
            Alert(
                title: Text(""),
                message: Text(""),
                dismissButton: .default(Text("")) {
                    // Boş alert, custom view kullanacağız
                }
            )
        }
        .overlay {
            if showLimitAlert {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .overlay {
                        alertView
                            .padding()
                    }
            }
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
