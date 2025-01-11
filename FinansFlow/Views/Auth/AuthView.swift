import SwiftUI

struct AuthView: View {
    @State private var isShowingLogin = true
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var phoneNumber = ""
    @State private var birthDate = Date()
    @State private var gender = 0
    @State private var isAuthenticated = false
    @State private var showDatePicker = false
    @State private var showSplashScreen = false
    
    let genderOptions = ["Erkek", "Kadın", "Diğer"]
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(hex: "#6C63FF"), Color(hex: "#4CAF50")]),
                             startPoint: .topLeading,
                             endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Logo ve başlık
                        LogoView()
                        
                        // Giriş/Kayıt toggle
                        Picker("", selection: $isShowingLogin) {
                            Text("Giriş").tag(true)
                            Text("Kayıt").tag(false)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal, 50)
                        
                        // Form alanları
                        VStack(spacing: 20) {
                            if isShowingLogin {
                                // Sadece giriş ekranı
                                LoginFormView(email: $email, password: $password)
                            } else {
                                // Kayıt ekranı
                                RegisterFormView(
                                    email: $email,
                                    password: $password,
                                    confirmPassword: $confirmPassword,
                                    firstName: $firstName,
                                    lastName: $lastName,
                                    phoneNumber: $phoneNumber,
                                    birthDate: $birthDate,
                                    gender: $gender,
                                    showDatePicker: $showDatePicker,
                                    dateFormatter: dateFormatter,
                                    genderOptions: genderOptions
                                )
                            }
                        }
                        .padding(.horizontal, 30)
                        
                        // Giriş/Kayıt butonu
                        Button(action: handleAuth) {
                            Text(isShowingLogin ? "Giriş Yap" : "Kayıt Ol")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(12)
                        }
                        .padding(.horizontal, 30)
                    }
                    .padding(.vertical, 20)
                }
            }
        }
        .fullScreenCover(isPresented: $showSplashScreen) {
            SplashScreenView()
        }
        .fullScreenCover(isPresented: $isAuthenticated) {
            ContentView(isAuthenticated: $isAuthenticated)
        }
    }
    
    private func handleAuth() {
        if !isShowingLogin {
            // Kayıt işlemi için basit kontrol
            guard password == confirmPassword else { return }
        }
        // Başarılı giriş/kayıt sonrası
        isAuthenticated = true
    }
} 