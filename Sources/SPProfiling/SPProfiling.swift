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
import Firebase
import SPFirebase
import SPFirebaseAuth

public class SPProfiling {
    
    public static func configure(firebaseOptions: FirebaseOptions) {
        
        // Start Firebase
        SPFirebase.configure(with: firebaseOptions)
        
        // Start Services
        Auth.configure()
        
        // Data services can be reset if auth changed.
        // So using special func for all data services.
        configureDataServices()
        
        // Other
        shared.setObservers()
    }
    
    // MARK: - Shared Actions
    
    @available(iOS 13.0, *)
    static func signInApple(on controller: UIViewController, completion: @escaping (AuthError?)->Void) {
        authProcess = true
        Auth.signInApple(on: controller, completion: { data, error in
            
            if let error = error {
                completion(error)
                return
            }
            
            guard let profileModel = Profile.currentProfile else { fatalError() }
            completion(nil)
            
            // Get actuall data of profile and update if need.
            // No need wait when it completed.
            Profile.getProfile(userID: profileModel.id, source: .actuallyOnly) { validProfileModel, error  in
                guard let validProfileModel = validProfileModel else { return }
                if let name = data?.name, validProfileModel.name != name {
                    SPProfiling.Profile.setProfileName(name, completion: nil)
                }
                if let email = data?.email, validProfileModel.email != email {
                    SPProfiling.Profile.setProfileEmail(email, completion: nil)
                }
                if validProfileModel.createdDate == nil {
                    SPProfiling.Profile.setProfileCreatedDate(Date.current, completion: nil)
                }
            }
        })
    }
    
    static func signInAnonymously(completion: @escaping (AuthError?)->Void) {
        authProcess = true
        Auth.signInAnonymously(completion: { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
            authProcess = false
        })
    }
    
    static func signOut(completion: @escaping (AuthError?)->Void) {
        Auth.signOut { error in
            if let error = error {
                completion(error)
            } else {
                signInAnonymously() { error in
                    completion(error)
                }
            }
        }
    }
    
    static func deleteProfile(on controller: UIViewController, completion: @escaping (Error?)->Void) {
        
        let deleteAction = {
            SPProfiling.Profile.deleteProfile { error in
                if let error = error {
                    completion(error)
                } else {
                    Auth.delete { error in
                        completion(error)
                    }
                }
            }
        }
        
        if Auth.isAnonymous ?? true {
            deleteAction()
        } else {
            Auth.signInAppleForConfirm(on: controller) { error in
                if let error = error {
                    completion(error)
                } else {
                    deleteAction()
                }
            }
        }
    }
    
    // MARK: - Private
    
    private static func configureDataServices() {
        if Auth.isAuthed, let userID = Auth.userID {
            Profile.configure(userID: userID)
        } else {
            Profile.reset()
        }
    }
    
    // MARK: - Private
    
    private func setObservers() {
        NotificationCenter.default.addObserver(forName: SPProfiling.didChangedAuthState, object: nil, queue: nil) { notification in
            debug("Logic/Notification: Handled notification about changed auth state.")
            Self.configureDataServices()
        }
    }
    
    // MARK: - Singltone
    
    private var authProcess: Bool = false
    private static let shared = SPProfiling()
    private init() {}
    
    // MARK: Access
    
    internal static var authProcess: Bool {
        get { SPProfiling.shared.authProcess }
        set { SPProfiling.shared.authProcess = newValue }
    }
}
