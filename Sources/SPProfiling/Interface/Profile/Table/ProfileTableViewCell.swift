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
    
    public let avatarView = NativeAvatarView().do {
        $0.isEditable = false
        $0.placeholderImage = UIImage.system("person.crop.circle.fill", font: .systemFont(ofSize: 52, weight: .medium))
        $0.avatarAppearance = .placeholder
    }
    
    // MARK: - Init
    
    open override func commonInit() {
        super.commonInit()
        higlightStyle = .content
        contentView.addSubviews(avatarView, titleLabel, descriptionLabel)
        accessoryType = .disclosureIndicator
        updateAppearance()
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
    
    open override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        let higlightContent = (higlightStyle == .content)
        if higlightContent {
            [avatarView, titleLabel, descriptionLabel].forEach({ $0?.alpha = highlighted ? 0.6 : 1 })
        }
    }
    
    // MARK: - Layout
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        avatarView.sizeToFit()
        avatarView.setXToSuperviewLeftMargin()
        avatarView.frame.origin.y = contentView.layoutMargins.top
        
        let avatarRightSpace: CGFloat = NativeLayout.Spaces.default
        let labelVerticalSpace: CGFloat = NativeLayout.Spaces.step / 2
        let labelWidth = contentView.layoutWidth - avatarView.frame.width - avatarRightSpace
        titleLabel.layoutDynamicHeight(width: labelWidth)
        descriptionLabel.layoutDynamicHeight(width: labelWidth)
        
        titleLabel.frame.origin.x = avatarView.frame.maxX + avatarRightSpace
        descriptionLabel.frame.origin.x = titleLabel.frame.origin.x
        
        let labelHeight = titleLabel.frame.height + labelVerticalSpace + descriptionLabel.frame.height
        if (avatarView.frame.origin.y + labelHeight) > avatarView.frame.maxY {
            titleLabel.frame.origin.y = contentView.layoutMargins.top
        } else {
            titleLabel.frame.origin.y = contentView.layoutMargins.top + (contentView.layoutHeight - labelHeight) / 2
        }
        
        descriptionLabel.frame.origin.y = titleLabel.frame.maxY + labelVerticalSpace
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        layoutSubviews()
        return .init(width: size.width, height: max(avatarView.frame.maxY, descriptionLabel.frame.maxY) + contentView.layoutMargins.bottom)
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
        if ProfileModel.isAuthed, let profileModel = ProfileModel.currentProfile {
            setProfile(profileModel, completion: nil)
        } else {
            setAuthAppearance()
        }
    }
    
    internal func setAuthAppearance() {
        avatarView.avatarAppearance = .placeholder
        titleLabel.text = Texts.Auth.sign_in
        titleLabel.textColor = .tint
    }
    
    internal func setProfile(_ profileModel: ProfileModel, completion: (()->())? = nil) {
        titleLabel.text = profileModel.name ?? profileModel.email ?? Texts.Profile.placeholder_name
        avatarView.setAvatar(of: profileModel) {
            completion?()
        }
    }
}
