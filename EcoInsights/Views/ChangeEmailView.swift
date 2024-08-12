//
//  ChangeEmailView.swift
//  EcoInsights
//
//  Created by Sander Vanryckeghem on 23/03/2023.
//

import SwiftUI

struct ChangeUsernameView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var oldUsername = UserController.shared.user?.userName ?? ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var newUsername = ""
    
    var body: some View {
        GeometryReader { geometryProxy in
            VStack {
                VStack{
                    Image("Tommy")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .cornerRadius(10)
                    Text(oldUsername)
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
                            Text("Old Username")
                            Spacer()
                        }
                        ZStack {
                            TextField("Old Username", text: $oldUsername)
                                .foregroundColor(.gray)
                                .disabled(true)
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
                            Text("New Username")
                            Spacer()
                        }
                        ZStack {
                            TextField("New Username", text: $newUsername)
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

                        // Check if newUsername == oldUsername
                        guard newUsername != oldUsername else {
                            alertMessage = "Username is already the same"
                            showAlert = true
                            return
                        }
                        
                        UserController.shared.updateUsername(username: newUsername)
                        self.presentationMode.wrappedValue.dismiss()
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
struct ChangeEmailView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeUsernameView()
    }
}
