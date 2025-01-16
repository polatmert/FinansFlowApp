import UserNotifications

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    private var lastNotificationDate: Date?
    
    private init() {
        requestAuthorization()
    }
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Bildirim izni verildi")
            } else if let error = error {
                print("Bildirim izni hatası: \(error.localizedDescription)")
            }
        }
    }
    
    func checkMonthlyLimit(currentBalance: Double, limitAmount: Double) {
        guard UserSettings.shared.monthlyLimitEnabled else { return }
        
        // Son bildirimi kontrol et
        if let lastDate = lastNotificationDate {
            let calendar = Calendar.current
            let minutesSinceLastNotification = calendar.dateComponents([.minute], from: lastDate, to: Date()).minute ?? 0
            if minutesSinceLastNotification < 30 { // 30 dakika içinde tekrar bildirim gönderme
                return
            }
        }
        
        if currentBalance < limitAmount {
            sendLimitNotification(currentBalance: currentBalance, limitAmount: limitAmount)
            lastNotificationDate = Date()
        }
    }
    
    func sendLimitNotification(currentBalance: Double, limitAmount: Double) {
        let content = UNMutableNotificationContent()
        content.title = "Finansal Uyarı! 🚨"
        content.body = """
        Dikkat! Finansal sağlığınız risk altında!
        Mevcut bakiyeniz: ₺\(String(format: "%.2f", currentBalance))
        Belirlediğiniz limit: ₺\(String(format: "%.2f", limitAmount))
        """
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleNotification(title: String, body: String, hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyReminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
} 