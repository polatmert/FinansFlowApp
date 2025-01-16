import Foundation

class UserSettings: ObservableObject {
    static let shared = UserSettings()
    
    @Published var monthlyLimitEnabled: Bool {
        didSet {
            UserDefaults.standard.set(monthlyLimitEnabled, forKey: "monthlyLimitEnabled")
        }
    }
    
    @Published var monthlyLimitAmount: Double {
        didSet {
            UserDefaults.standard.set(monthlyLimitAmount, forKey: "monthlyLimitAmount")
        }
    }
    
    init() {
        self.monthlyLimitEnabled = UserDefaults.standard.bool(forKey: "monthlyLimitEnabled")
        self.monthlyLimitAmount = UserDefaults.standard.double(forKey: "monthlyLimitAmount")
    }
} 