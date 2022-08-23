import Foundation
import SwiftBoost
import UIKit

class AuthService {
    
    // MARK: - Public
    
    static func configure() {
        debug("FirebaseProfile/AuthService configure.")
    }
    
    static func signInApple(on controller: UIViewController, completion: @escaping (Any?, AuthError?)->Void) {}
    static func signInAppleForConfirm(on controller: UIViewController, completion: @escaping (AuthError?) -> Void) {}
    static func signInAnonymously(completion: @escaping (AuthError?)->Void) {}
    
    // MARK: - Data
    
    static var userID: String? { return nil }
    static var isAnonymous: Bool? { return nil }
    static var isAuthed: Bool { return false }
    
    // MARK: - Singltone
    
    private static var shared = AuthService()
    private init() {}
}
