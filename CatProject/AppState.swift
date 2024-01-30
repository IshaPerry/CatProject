//
//  AppState.swift
//  CatProject
//
//  Created by Isha Perry on 1/30/24.
//

import Foundation
import FirebaseAuth
import SwiftUI
import Firebase

class AppState: ObservableObject {
    
    @Published var currentUser: User?
    
    var isLoggedIn: Bool {
        return currentUser != nil
    }
    
    
    init(){
        FirebaseApp.configure() //configure db
        if let currentUser = Auth.auth().currentUser {
            self.currentUser = currentUser
        }
    }
    
    
}
