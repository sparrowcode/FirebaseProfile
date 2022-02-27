// The MIT License (MIT)
// Copyright © 2022 Ivan Vorobei (hello@ivanvorobei.io)
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
import NativeUIKit
import SPFirebaseFirestore

extension ProfileModel {
    
    public static var isAuthed: Bool { Auth.isAuthed }
    public static var isAnonymous: Bool? { Auth.isAnonymous }
    public static var currentProfile: ProfileModel? { SPProfiling.Profile.currentProfile }
    
    public static func getProfile(userID: String, source: SPFirebaseFirestoreSource, completion: @escaping (ProfileModel?, Error?)->Void) {
        SPProfiling.Profile.getProfile(userID: userID, source: source, completion: completion)
    }
    
    public static func getProfile(email: String, source: SPFirebaseFirestoreSource, completion: @escaping (ProfileModel?, Error?)->Void) {
        SPProfiling.Profile.getProfile(email: email, source: source, completion: completion)
    }
    
    // MARK: - Auth
    
    @available(iOS 13.0, *)
    public static func signInApple(on controller: UIViewController, completion: @escaping (AuthError?)->Void) {
        SPProfiling.signInApple(on: controller, completion: completion)
    }
    
    public static func signInAnonymously(completion: @escaping (AuthError?)->Void) {
        SPProfiling.signInAnonymously(completion: completion)
    }
    
    public func signOut(completion: @escaping (AuthError?)->Void) {
        SPProfiling.signOut(completion: completion)
    }
    
    public func delete(on controller: UIViewController, completion: @escaping (Error?)->Void) {
        SPProfiling.deleteProfile(on: controller, completion: completion)
    }
    
    // MARK: - Data
    
    public func setName(_ value: String, completion: ((Error?)->Void)?) {
        SPProfiling.Profile.setProfileName(value, completion: completion)
    }
    
    public func getAvatarURL(completion: @escaping (URL?, Error?)->Void) {
        SPProfiling.Profile.getAvatarURL(of: self, completion: completion)
    }
    
    public func setAvatar(_ image: UIImage, completion: ((Error?)->Void)?) {
        SPProfiling.Profile.setAvatar(image, completion: completion)
    }
    
    public func deleteAvatar(completion: ((DeleteAvatarError?)->Void)?) {
        SPProfiling.Profile.deleteAvatar(completion: completion)
    }
    
    // MARK: - Interface
    
    public static func showCurrentProfile(on viewController: UIViewController) {
        guard currentProfile != nil else { return }
        
        let controller = ProfileController()
        let navigationController = controller.wrapToNavigationController(prefersLargeTitles: false)
        controller.navigationItem.rightBarButtonItem = controller.closeBarButtonItem
        
        let horizontalMargin: CGFloat = NativeLayout.Spaces.Margins.modal_screen_horizontal
        controller.modalPresentationStyle = .formSheet
        controller.preferredContentSize = .init(width: 540, height: 620)
        controller.view.layoutMargins.left = horizontalMargin
        controller.view.layoutMargins.right = horizontalMargin
        
        navigationController.inheritLayoutMarginsForNavigationBar = true
        navigationController.inheritLayoutMarginsForСhilds = true
        navigationController.viewDidLayoutSubviews()
        
        viewController.present(navigationController)
    }
    
    public static func showAuth(
        title: String,
        description: String,
        features: [NativeOnboardingFeatureView.FeatureModel],
        on presentingController: UIViewController
    ) {
        let authController = AuthController(title: title, description: description, completion: { authController in
            guard ProfileModel.isAuthed else { return }
            authController.dismiss(animated: true) {
                if !(ProfileModel.isAnonymous ?? true) {
                    ProfileModel.showCurrentProfile(on: presentingController)
                }
            }
        })
        authController.setFeatures(features)
        let navigationController = NativeNavigationController(rootViewController: authController)
        authController.navigationItem.rightBarButtonItem = authController.closeBarButtonItem
        
        let horizontalMargin: CGFloat = NativeLayout.Spaces.Margins.modal_screen_horizontal
        authController.modalPresentationStyle = .formSheet
        authController.preferredContentSize = .init(width: 540, height: 620)
        authController.view.layoutMargins.left = horizontalMargin
        authController.view.layoutMargins.right = horizontalMargin
        
        navigationController.inheritLayoutMarginsForNavigationBar = true
        navigationController.inheritLayoutMarginsForСhilds = true
        navigationController.viewDidLayoutSubviews()
        
        presentingController.present(navigationController)
    }
    
    
    // MARK: - Middleware
    
    public func canExecute(_ action: ProfileAction) -> Bool {
        let error = middleware(action)
        return error == nil
    }
    
    public func middleware(_ action: ProfileAction) -> Error? {
        switch action {
        case .getProfile:
            return nil
        case .getProfilveAvatar:
            return nil
        case .editProfile(let profileModel):
            return self.id == profileModel.id ? nil : EditProfileError.notEnoughPermissions
        case .deleteProfile(let profileModel):
            return self.id == profileModel.id ? nil : EditProfileError.notEnoughPermissions
        case .setProfilveAvatar(let profileModel):
            return self.id == profileModel.id ? nil : SetAvatarError.notEnoughPermissions
        }
    }
}
