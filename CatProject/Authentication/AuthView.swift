//
//  AuthView.swift
//  CatProject
//
//  Created by Isha Perry on 1/30/24.
//

import SwiftUI

struct AuthView: View {
    @ObservedObject var viewModel : AuthViewModel = AuthViewModel()
    @EnvironmentObject var appState: AppState
    
    
    var body: some View {
        VStack {
            
        Text("ChatGPT Mobile")
        .font(.title)
        .bold()
        
        
        TextField("Email", text: $viewModel.emailText)
        .customStyle()
        
        if viewModel.isPasswordVisible{
            SecureField("Password", text: $viewModel.passwordText)
                .customStyle()
        }
            if viewModel.isLoading{
                ProgressView()
            } else {
                Button{
                    viewModel.authenticate(appState: appState)
                } label: {
                    Text(viewModel.userExists ? "Login": "Create User")
                }
                    .padding()
                    .foregroundStyle(.white)
                    .background(Color.blue.opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous ))
                
                }
            
            
            }
        
       
                
        
        .padding()
        
    }
}
extension View {
    func customStyle() -> some View {
        self.modifier(CustomStylingModifier())
    }
}



struct CustomStylingModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .foregroundColor(.blue)
            .font(.headline)
            .textInputAutocapitalization(.never)
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct AuthView_Preview: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
