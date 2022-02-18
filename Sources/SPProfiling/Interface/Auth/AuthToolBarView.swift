// The MIT License (MIT)
// Copyright © 2021 Ivan Vorobei (hello@ivanvorobei.by)
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
import AuthenticationServices

open class AuthToolBarView: NativeMimicrateToolBarView {
    
    // MARK: - Views
    
    public let activityIndicatorView = UIActivityIndicatorView()
    
    public let authButton = ASAuthorizationAppleIDButton().do {
        $0.roundCorners(radius: NativeLargeActionButton.defaultCornerRadius)
        $0.layer.masksToBounds = true
    }
    
    public let skipAuthButton = SPDimmedButton().do {
        $0.setTitle(Texts.Auth.continue_anonymously)
        $0.applyDefaultAppearance(with: .tintedContent)
        $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline, addPoints: -1)
    }
    
    // MARK: - Init
    
    open override func commonInit() {
        super.commonInit()
        addSubview(activityIndicatorView)
        addSubview(authButton)
        addSubview(skipAuthButton)
    }
    
    // MARK: - Actions
    
    open func setLoading(_ state: Bool) {
        if state {
            activityIndicatorView.startAnimating()
            authButton.isHidden = true
            skipAuthButton.isHidden = true
        } else {
            activityIndicatorView.stopAnimating()
            authButton.isHidden = false
            skipAuthButton.isHidden = false
        }
    }
    
    // MARK: - Layout
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        let authButtonWidth = min(readableWidth, NativeLayout.Sizes.actionable_area_maximum_width)
        authButton.frame.setWidth(authButtonWidth)
        authButton.frame.setHeight(NativeLargeActionButton.defaultHeight)
        authButton.setXCenter()
        authButton.frame.origin.y = layoutMargins.top
        
        skipAuthButton.setWidthAndFit(width: layoutWidth)
        skipAuthButton.frame.origin.y = authButton.frame.maxY + 12
        skipAuthButton.setXCenter()
        
        let contentHeight: CGFloat = skipAuthButton.frame.maxY
        activityIndicatorView.setXCenter()
        activityIndicatorView.center.y = contentHeight / 2
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        layoutSubviews()
        if skipAuthButton.isHidden {
            return .init(width: size.width, height: authButton.frame.maxY + layoutMargins.bottom)
        } else {
            return .init(width: size.width, height: skipAuthButton.frame.maxY + layoutMargins.bottom)
        }
    }
}
