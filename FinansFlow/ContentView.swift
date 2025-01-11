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
    @State private var selectedTransactionType: TransactionType = .income
    @Environment(\.presentationMode) var presentationMode
    @Binding var isAuthenticated: Bool
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Ana Sayfa
            NavigationView {
                ScrollView {
                    VStack(spacing: 24) {
                        // Üst Kart - Toplam Varlık
                        TotalAssetsCard(transactions: transactions)
                        
                        // Varlık Dağılımı
                        AssetDistributionCard(transactions: transactions)
                        
                        // Hızlı İşlemler
                        QuickActionsCard(showingAddTransaction: $showingAddTransaction, transactions: $transactions)
                        
                        // Son Hareketler
                        if transactions.isEmpty {
                            Text("Henüz işlem bulunmuyor")
                                .foregroundColor(ThemeColors.lightText)
                                .padding()
                        } else {
                            RecentTransactionsCard(transactions: transactions.sorted(by: { $0.date > $1.date }))
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
            AddTransactionView(isPresented: $showingAddTransaction, transactions: $transactions)
        }
    }
    
    private func logout() {
        isAuthenticated = false
    }
}

#Preview {
    ContentView(isAuthenticated: .constant(true))
}
