import SwiftUI

struct NotificationSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedHour = 20
    @State private var selectedMinute = 0
    @State private var isNotificationsEnabled = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Günlük Hatırlatıcı")) {
                    Toggle("Bildirimleri Etkinleştir", isOn: $isNotificationsEnabled)
                    
                    if isNotificationsEnabled {
                        HStack {
                            Picker("Saat", selection: $selectedHour) {
                                ForEach(0..<24) { hour in
                                    Text("\(hour)").tag(hour)
                                }
                            }
                            Text(":")
                            Picker("Dakika", selection: $selectedMinute) {
                                ForEach(0..<60) { minute in
                                    Text("\(minute)").tag(minute)
                                }
                            }
                        }
                        
                        Button("Kaydet") {
                            scheduleNotification()
                            presentationMode.wrappedValue.dismiss()
                        }
                        .foregroundColor(ThemeColors.primary)
                    }
                }
            }
            .navigationTitle("Bildirim Ayarları")
            .navigationBarItems(trailing: Button("Kapat") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private func scheduleNotification() {
        NotificationManager.shared.scheduleNotification(
            title: "FinansFlow Hatırlatıcı",
            body: "Günlük finansal işlemlerinizi kaydetmeyi unutmayın!",
            hour: selectedHour,
            minute: selectedMinute
        )
    }
} 