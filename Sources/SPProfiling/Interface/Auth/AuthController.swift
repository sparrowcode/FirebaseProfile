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

public class AuthController: NativeOnboardingFeaturesController {
    
    private var completion: ()->Void
    
    // MARK: - Views
    
    let actionToolbarView = NativeAppleAuthToolBarView()
    
    // MARK: - Init
    
    init(title: String, description: String, completion: @escaping ()->Void) {
        self.completion = completion
        super.init(
            iconImage: NativeAvatarView.generatePlaceholderImage(fontSize: 80, fontWeight: .medium),
            title: title,
            subtitle: description
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navigationController = self.navigationController as? NativeNavigationController {
            navigationController.mimicrateToolBarView = actionToolbarView
        }
        
        actionToolbarView.authButton.addTarget(self, action: #selector(self.tapSignInApple), for: .touchUpInside)
    }
    
    @objc func tapSignInApple() {
        ProfileModel.signInApple(on: self) { error in
            if let error = error {
                SPAlert.present(message: error.localizedDescription, haptic: .error)
            } else {
                self.completion()
            }
        }
    }
}
