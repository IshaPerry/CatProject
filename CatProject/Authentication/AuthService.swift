//
//  AuthService.swift
//  CatProject
//
//  Created by Isha Perry on 1/30/24.
//

import Foundation

import Firebase
import FirebaseFirestore
import FirebaseAuth

class AuthService {
    let db = Firestore.firestore()
    
    func checkUserExists(email: String) async throws -> Bool {
        let documentSnapshot = db.collection("users").whereField("email", isEqualTo: email).count
        let count = try await documentSnapshot.getAggregation(source: .server).count
        return Int(truncating: count) > 0
    }
    
    func login(email: String, password: String, userExists: Bool) async throws -> AuthDataResult? {
        
        guard !password.isEmpty else {return nil}
        
        if userExists {
            return try await Auth.auth().signIn(withEmail: email, password: password)
        } else {
            return try await Auth.auth().createUser(withEmail: email, password: password)
        }
    }
}
