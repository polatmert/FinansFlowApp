import SwiftUI
import UserNotifications

struct MonthlySummaryCard: View {
    let transactions: [Transaction]
    @StateObject private var userSettings = UserSettings.shared
    
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
    
    private var monthlyBalance: Double {
        totalIncome - totalExpense
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // Aylık Bakiye
            VStack(spacing: 8) {
                Text("Aylık Bakiye")
                    .font(.subheadline)
                    .foregroundColor(ThemeColors.lightText)
                Text("₺\(totalIncome - totalExpense, specifier: "%.2f")")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(ThemeColors.text)
            }
            
            // Gelir/Gider Özeti
            HStack(spacing: 40) {
                BalanceItem(
                    title: "Gelir",
                    amount: totalIncome,
                    color: ThemeColors.income,
                    icon: "arrow.down.circle.fill"
                )
                
                BalanceItem(
                    title: "Gider",
                    amount: totalExpense,
                    color: ThemeColors.expense,
                    icon: "arrow.up.circle.fill"
                )
            }
        }
        .padding(24)
        .background(ThemeColors.cardBackground)
        .cornerRadius(16)
        .onAppear {
            checkMonthlyLimit()
        }
        .onChange(of: monthlyBalance) { _ in
            checkMonthlyLimit()
        }
    }
    
    private func checkMonthlyLimit() {
        NotificationManager.shared.checkMonthlyLimit(currentBalance: monthlyBalance, limitAmount: userSettings.monthlyLimitAmount)
    }
    
    private func sendLimitNotification(currentBalance: Double, limitAmount: Double) {
        let content = UNMutableNotificationContent()
        content.title = "Finansal Uyarı!"
        content.body = "Aylık bakiyeniz (₺\(String(format: "%.2f", currentBalance))) belirlediğiniz limit olan ₺\(String(format: "%.2f", limitAmount)) değerinin altına düştü."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
} 