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
import NativeUIKit
import SparrowKit
import SPAlert

open class AuthController: NativeOnboardingFeaturesController {
    
    public var completion: ((AuthController)->Void)?
    
    // MARK: - Views
    
    public let actionToolbarView = AuthToolBarView()
    
    // MARK: - Init
    
    public init(title: String, description: String, completion: ((AuthController)->Void)? = nil) {
        super.init(
            iconImage: NativeAvatarView.generatePlaceholderImage(fontSize: 80, fontWeight: .medium),
            title: title,
            subtitle: description
        )
        self.completion = completion
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navigationController = self.navigationController as? NativeNavigationController {
            navigationController.mimicrateToolBarView = actionToolbarView
        }
        
        actionToolbarView.authButton.addTarget(self, action: #selector(self.tapAppleSignIn), for: .touchUpInside)
        actionToolbarView.skipAuthButton.addTarget(self, action: #selector(self.tapContinueAnon), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateSkipAuthButton), name: SPProfiling.didChangedAuthState, object: nil)
        
        updateSkipAuthButton()
    }
    
    // MARK: - Actions
    
    @objc func tapAppleSignIn() {
        self.actionToolbarView.setLoading(true)
        ProfileModel.signInApple(on: self) { error in
            if let error = error {
                self.actionToolbarView.setLoading(false)
                SPAlert.present(message: error.localizedDescription, haptic: .error)
            } else {
                self.completion?(self)
            }
        }
    }
    
    @objc func tapContinueAnon() {
        if ProfileModel.isAnonymous ?? false {
            self.completion?(self)
        } else {
            self.actionToolbarView.setLoading(true)
            ProfileModel.signInAnonymously() { error in
                if let error = error {
                    self.actionToolbarView.setLoading(false)
                    SPAlert.present(message: error.localizedDescription, haptic: .error)
                } else {
                    self.completion?(self)
                }
            }
        }
    }
    
    // MARK: - Private
    
    @objc func updateSkipAuthButton() {
        let allowed: Bool = {
            if ProfileModel.isAnonymous != nil {
                // Any auth already isset.
                // Not allowed anonymous auth.
                return false
            } else {
                return true
            }
        }()
        actionToolbarView.skipAuthButton.isHidden = !allowed
    }
}
