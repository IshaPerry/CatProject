//
//  AuthViewModel.swift
//  CatProject
//
//  Created by Isha Perry on 1/30/24.
//

import Foundation

class AuthViewModel: ObservableObject {
    @Published var emailText: String = ""
    @Published var passwordText: String = ""
    
    @Published var isLoading = false
    @Published var isPasswordVisible = false
    @Published var userExists = false
    
    let authService = AuthService()
    
    func authenticate(appState: AppState) {
        isLoading = true
        
        //create Task to run async functions
        Task {
            do{
                if isPasswordVisible {
                    let result = try await authService.login(email: emailText, password: passwordText, userExists: userExists)
                    await MainActor.run(body: {
                        guard let result = result else {return}
                        //update App State
                        appState.currentUser = result.user
                    })
                } else {
                    userExists = try await authService.checkUserExists(email: emailText)
                    isPasswordVisible = true
                }
                isLoading = false
            } catch {
                print(error)
                await MainActor.run {
                    isLoading = false
                }
                
            }
        }
    }
}
