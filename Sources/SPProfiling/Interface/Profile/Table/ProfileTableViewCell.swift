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

open class ProfileTableViewCell: SPTableViewCell {
    
    // MARK: - Views
    
    public let profileLabelsView = ProfileLabelsView()
    
    public let authLabelsView = AuthLabelsView()
    
    public let avatarView = NativeAvatarView().do {
        $0.isEditable = false
        $0.placeholderImage = NativeAvatarView.generatePlaceholderImage(fontSize: 46, fontWeight: .medium)
        $0.avatarAppearance = .placeholder
    }
    
    // MARK: - Init
    
    open override func commonInit() {
        super.commonInit()
        higlightStyle = .content
        contentView.addSubviews(avatarView, profileLabelsView, authLabelsView)
        accessoryType = .disclosureIndicator
        updateAppearance()
        configureObservers()
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        configureObservers()
        updateAppearance()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Ovveride
    
    #warning("change to subbiews")
    open override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        let higlightContent = (higlightStyle == .content)
        if higlightContent {
            [avatarView, profileLabelsView, authLabelsView].forEach({ $0?.alpha = highlighted ? 0.6 : 1 })
        }
    }
    
    // MARK: - Layout
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        avatarView.sizeToFit()
        avatarView.setXToSuperviewLeftMargin()
        avatarView.frame.origin.y = contentView.layoutMargins.top
        
        let visibleLabelsView = profileLabelsView.isHidden ? authLabelsView : profileLabelsView
        let avatarRightSpace: CGFloat = NativeLayout.Spaces.default
        let labelsWidth = contentView.layoutWidth - avatarView.frame.width - avatarRightSpace
        visibleLabelsView.frame.setWidth(labelsWidth)
        visibleLabelsView.sizeToFit()
        visibleLabelsView.frame.origin.x = avatarView.frame.maxX + avatarRightSpace
        
        if (avatarView.frame.origin.y + visibleLabelsView.frame.height) > avatarView.frame.maxY {
            visibleLabelsView.frame.origin.y = contentView.layoutMargins.top
        } else {
            visibleLabelsView.frame.origin.y = contentView.layoutMargins.top + (contentView.layoutHeight - visibleLabelsView.frame.height) / 2
        }
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        layoutSubviews()
        let visibleLabelsView = profileLabelsView.isHidden ? authLabelsView : profileLabelsView
        return .init(width: size.width, height: max(avatarView.frame.maxY, visibleLabelsView.frame.maxY) + contentView.layoutMargins.bottom)
    }
    
    // MARK: - Internal
    
    internal func configureObservers() {
        // Clean
        NotificationCenter.default.removeObserver(self)
        
        // Configure New
        NotificationCenter.default.addObserver(forName: SPProfiling.didChangedAuthState, object: nil, queue: nil) { [weak self] _ in
            guard let self = self else { return }
            self.updateAppearance()
        }
        
        NotificationCenter.default.addObserver(forName: SPProfiling.didReloadedProfile, object: nil, queue: nil) { [weak self] _ in
            guard let self = self else { return }
            self.updateAppearance()
        }
    }
    
    internal func updateAppearance() {
        let profileModel = ProfileModel.currentProfile
        authLabelsView.titleLabel.text = Texts.Auth.sign_in
        profileLabelsView.titleLabel.text = profileModel?.name ?? profileModel?.email ?? Texts.Profile.placeholder_name
        
        if ProfileModel.isAnonymous ?? true {
            avatarView.avatarAppearance = .placeholder
            authLabelsView.isHidden = false
            profileLabelsView.isHidden = true
        } else {
            guard let profileModel = ProfileModel.currentProfile else { return }
            avatarView.setAvatar(of: profileModel)
            authLabelsView.isHidden = true
            profileLabelsView.isHidden = false
        }
        
        layoutSubviews()
    }
    
    // MARK: - Views
    
    public class ProfileLabelsView: SPView {
        
        public let titleLabel = SPLabel().do {
            $0.numberOfLines = 1
            $0.font = UIFont.preferredFont(forTextStyle: .title2, weight: .semibold)
            $0.textColor = .label
        }
        
        public let descriptionLabel = SPLabel().do {
            $0.numberOfLines = 1
            $0.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .regular)
            $0.textColor = .secondaryLabel
        }
        
        public override func commonInit() {
            super.commonInit()
            layoutMargins = .zero
            addSubview(titleLabel)
            addSubview(descriptionLabel)
        }
        
        public override func layoutSubviews() {
            super.layoutSubviews()
            titleLabel.layoutDynamicHeight(x: .zero, y: .zero, width: frame.width)
            descriptionLabel.layoutDynamicHeight(x: .zero, y: titleLabel.frame.maxY + 2, width: frame.width)
        }
        
        public override func sizeThatFits(_ size: CGSize) -> CGSize {
            layoutSubviews()
            return .init(width: size.width, height: descriptionLabel.frame.maxY)
        }
    }
    
    public class AuthLabelsView: ProfileLabelsView {
        
        public override func commonInit() {
            super.commonInit()
            titleLabel.textColor = .tint
        }
    }
}
