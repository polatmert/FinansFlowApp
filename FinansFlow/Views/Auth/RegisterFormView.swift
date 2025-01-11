import SwiftUI

struct RegisterFormView: View {
    @Binding var email: String
    @Binding var password: String
    @Binding var confirmPassword: String
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var phoneNumber: String
    @Binding var birthDate: Date
    @Binding var gender: Int
    @Binding var showDatePicker: Bool
    let dateFormatter: DateFormatter
    let genderOptions: [String]
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("", text: $firstName)
                .placeholder(when: firstName.isEmpty) {
                    Text("Ad").foregroundColor(.white.opacity(0.7))
                }
                .textFieldStyle(AuthTextFieldStyle())
            
            TextField("", text: $lastName)
                .placeholder(when: lastName.isEmpty) {
                    Text("Soyad").foregroundColor(.white.opacity(0.7))
                }
                .textFieldStyle(AuthTextFieldStyle())
            
            TextField("", text: $phoneNumber)
                .placeholder(when: phoneNumber.isEmpty) {
                    Text("Telefon").foregroundColor(.white.opacity(0.7))
                }
                .textFieldStyle(AuthTextFieldStyle())
                .keyboardType(.phonePad)
            
            VStack(alignment: .leading) {
                Text("Doğum Tarihi")
                    .font(.subheadline)
                    .foregroundColor(.white)
                
                Button(action: { showDatePicker.toggle() }) {
                    HStack {
                        Text(dateFormatter.string(from: birthDate))
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "calendar")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(12)
                }
            }
            
            Picker("Cinsiyet", selection: $gender) {
                ForEach(0..<genderOptions.count, id: \.self) { index in
                    Text(genderOptions[index]).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
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
            
            SecureField("", text: $confirmPassword)
                .placeholder(when: confirmPassword.isEmpty) {
                    Text("Şifre Tekrar").foregroundColor(.white.opacity(0.7))
                }
                .textFieldStyle(AuthTextFieldStyle())
        }
    }
} 