//
//  ChangePasswordView.swift
//  EcoInsights
//
//  Created by Sander Vanryckeghem on 23/03/2023.
//

import SwiftUI
import FirebaseAuth

struct ChangePasswordView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    let username = UserController.shared.user?.userName ?? ""
    let userEmail = UserController.shared.user?.email ?? ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var oldPassword = ""
    @State private var newPassword = ""
    @State private var confirmNewPassword = ""
    
    var body: some View {
        GeometryReader { geometryProxy in
            VStack {
                VStack{
                    Image("Tommy")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .cornerRadius(10)
                    Text(username)
                        .font(.title)
                        .padding(.top, 20)
                }
                .background(Circle()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.40784314274787903, green: 0.886274516582489, blue: 0.3176470696926117, alpha: 1)), Color(#colorLiteral(red: 0.7215686440467834, green: 0.9529411792755127, blue: 0.42352941632270813, alpha: 1))]), startPoint: .top, endPoint: .trailing))
                    .frame(width: 800, height:800)
                    .offset(x: 0, y: -280))
                Spacer()
                HStack {
                    Spacer()
                    VStack{
                        HStack{
                            Text("Old password")
                            Spacer()
                        }
                        ZStack {
                            
                            SecureField("Old Password", text: $oldPassword)
                                .foregroundColor(.black)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                    }
                    Spacer()
                }
                .padding(10)
                HStack {
                    Spacer()
                    VStack{
                        HStack{
                            Text("New Password")
                            Spacer()
                        }
                        ZStack {
                            
                            SecureField("New Password", text: $newPassword)
                                .foregroundColor(.black)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                    }
                    Spacer()
                }
                .padding(10)
                HStack {
                    Spacer()
                    VStack{
                        HStack{
                            Text("Confirm New Password")
                            Spacer()
                        }
                        ZStack {
                            
                            SecureField("Confirm New Password", text: $confirmNewPassword)
                                .foregroundColor(.black)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                    }
                    Spacer()
                }
                .padding(10)
                Spacer()
                    .frame(height: 40)
                Text("Confirm")
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .padding(.vertical, 15)
                    .frame(maxWidth:  geometryProxy.size.width - 70)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.40784314274787903, green: 0.886274516582489, blue: 0.3176470696926117, alpha: 1)), Color(#colorLiteral(red: 0.7215686440467834, green: 0.9529411792755127, blue: 0.42352941632270813, alpha: 1))]), startPoint: .leading, endPoint: .trailing)
                    )
                    .cornerRadius(10)
                    .padding(.bottom, 10)
                    .onTapGesture {
                        showAlert = false
                        
                        // Check if oldPassword == newPassword
                        guard oldPassword != newPassword else {
                            alertMessage = "New password must be different from old password"
                            showAlert = true
                            return
                        }
                        
                        // Check that the new password and confirmation match
                        guard newPassword == confirmNewPassword else {
                            alertMessage = "New password and confirmation do not match"
                            showAlert = true
                            return
                        }
                        
                        let user = Auth.auth().currentUser
                        let credential = EmailAuthProvider.credential(withEmail: user?.email ?? "", password: oldPassword)

                        user?.reauthenticate(with: credential, completion: { (result, error) in
                            if let error = error {
                                alertMessage = "Old password is incorrect"
                                showAlert = true
                            } else {
                                // User re-authenticated. Update password
                                user?.updatePassword(to: newPassword) { error in
                                    if let error = error {
                                        alertMessage = error.localizedDescription
                                        showAlert = true
                                    } else {
                                        print("Password updated successfully")
                                        self.presentationMode.wrappedValue.dismiss()
                                    }
                                }
                            }
                        })
                    }
                Spacer()
            }
            .frame(width: geometryProxy.size.width-32, height: geometryProxy.size.height-32)
            .padding()
            .background(.white)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView()
    }
}
