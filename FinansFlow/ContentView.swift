//
//  ContentView.swift
//  FinansFlow
//
//  Created by Mert Polat on 4.01.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var transactions: [Transaction] = []
    @State private var showingAddTransaction = false
    @State private var selectedTab = 0
    @State private var selectedDate = Date()
    @Binding var isAuthenticated: Bool
    
    private var currentMonthTransactions: [Transaction] {
        let calendar = Calendar.current
        return transactions.filter { transaction in
            calendar.isDate(transaction.date, equalTo: selectedDate, toGranularity: .month)
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                ScrollView {
                    VStack(spacing: 24) {
                        // Ay Seçici
                        MonthPickerView(selectedDate: $selectedDate)
                            .padding(.horizontal)
                        
                        // Toplam Varlık
                        TotalAssetsCard(transactions: currentMonthTransactions)
                        
                        // Varlık Dağılımı
                        AssetDistributionCard(transactions: currentMonthTransactions)
                        
                        // Hızlı İşlemler
                        QuickActionsCard(
                            showingAddTransaction: $showingAddTransaction,
                            transactions: $transactions
                        )
                        
                        // Son İşlemler
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
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack {
                            Button(action: { showingAddTransaction = true }) {
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
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Ana Sayfa")
            }
            .tag(0)
        }
        .sheet(isPresented: $showingAddTransaction) {
            AddTransactionView(
                isPresented: $showingAddTransaction,
                transactions: $transactions,
                initialType: .income
            )
        }
    }
    
    private func logout() {
        isAuthenticated = false
    }
}

#Preview {
    ContentView(isAuthenticated: .constant(true))
}
