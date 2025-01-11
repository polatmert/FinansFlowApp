import SwiftUI

struct LoginFormView: View {
    @Binding var email: String
    @Binding var password: String
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("", text: $email)
                .placeholder(when: email.isEmpty) {
                    Text("E-posta").foregroundColor(.white.opacity(0.7))
                }
                .textFieldStyle(AuthTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            
            SecureField("", text: $password)
                .placeholder(when: password.isEmpty) {
                    Text("Şifre").foregroundColor(.white.opacity(0.7))
                }
                .textFieldStyle(AuthTextFieldStyle())
        }
    }
}

#Preview {
    ZStack {
        Color.blue
        LoginFormView(email: .constant(""), password: .constant(""))
    }
} 