// The MIT License (MIT)
// Copyright © 2022 Ivan Vorobei (hello@ivanvorobei.by)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit
import SparrowKit
import SPFirebaseAuth

class Auth {
    
    // MARK: - Public
    
    static func configure() {
        debug("SPProfiling/Auth configure.")
        SPFirebaseAuth.configure(authDidChangedWork: {
            NotificationCenter.default.post(name: SPProfiling.didChangedAuthState)
        })
    }
    
    @available(iOS 13.0, *)
    static func signInApple(on controller: UIViewController, completion: @escaping (SPFirebaseAuthData?, AuthError?)->Void) {
        let oldUserID = userID
        debug("SPProfiling/Auth event, start Sign in with Apple. Old user ID is \(oldUserID ?? "nil").")
        SPFirebaseAuth.signInApple(on: controller) { data, error in
            if let error = error {
                completion(data, AuthError.convert(error))
            } else {
                completion(data, nil)
            }
        }
    }
    
    @available(iOS 13.0, *)
    static func signInAppleForConfirm(on controller: UIViewController, completion: @escaping (AuthError?) -> Void) {
        SPFirebaseAuth.signInApple(on: controller) { data, error in
            if let error = error {
                completion(AuthError.convert(error))
            } else {
                completion(nil)
            }
        }
    }
    
    static func signInAnonymously(completion: @escaping (AuthError?)->Void) {
        SPFirebaseAuth.signInAnonymously(completion: { error in
            if let error = error {
                completion(AuthError.convert(error))
            } else {
                completion(nil)
            }
        })
    }
    
    static func signOut(completion: @escaping (AuthError?)->Void) {
        SPFirebaseAuth.signOut(completion: { error in
            if let error = error {
                completion(AuthError.convert(error))
            } else {
                signInAnonymously() { error in
                    completion(error)
                }
            }
        })
    }
    
    // MARK: - Data
    
    static var userID: String? { SPFirebaseAuth.userID }
    static var isAnonymous: Bool? { SPFirebaseAuth.isAnonymous }
    static var isAuthed: Bool { SPFirebaseAuth.userID != nil }
    
    // MARK: - Singltone
    
    private static var shared = Auth()
    private init() {}
}
