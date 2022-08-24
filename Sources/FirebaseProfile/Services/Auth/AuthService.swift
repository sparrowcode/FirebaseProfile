import UIKit
import SwiftBoost
import FirebaseAuth

class AuthService {
    
    // MARK: - Public
    
    static func configure() {
        debug("FirebaseProfile/AuthService configure.")
    }
    
    static func signInApple(provider: Provider, on controller: UIViewController, completion: @escaping (AuthError?)->Void) {
        switch provider {
        case .apple:
            guard let window = controller.view.window else {
                completion(.cantPresent)
                return
            }
            AppleAuthService.signIn(on: window) { data in
                guard let identityToken = data?.identityToken else {
                    completion(.faild)
                    return
                }
                let credential = FirebaseAuthService.appleCredential(identityToken: identityToken)
                FirebaseAuthService.signIn(credential: credential) { error in
                    if let _ = error {
                        // More detailed error here
                        // https://firebase.google.com/docs/auth/ios/errors
                        completion(.faild)
                    } else {
                        completion(nil)
                    }
                }
            }
        case .anon:
            FirebaseAuthService.signInAnonymously { error in
                if let _ = error {
                    // More detailed error here
                    // https://firebase.google.com/docs/auth/ios/errors
                    completion(.faild)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    // MARK: - Data
    
    static var userID: String? { FirebaseAuthService.userID }
    static var isAnonymous: Bool? { FirebaseAuthService.isAnonymous }
    static var isAuthed: Bool { FirebaseAuthService.userID != nil }
    
    // MARK: - Singltone
    
    private static var shared = AuthService()
    private init() {}
    
    // MARK: - Models
    
    enum Provider {
        
        case apple
        case anon
        
        var id: String {
            switch self {
            case .apple: return "apple"
            case .anon: return "anon"
            }
        }
    }
}
