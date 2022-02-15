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
import SPDiffable
import SPSafeSymbols
import SPAlert

extension ProfileController {
    
    internal func configureHeader() {
        setProfile(profileModel, completion: { [weak self] in
            guard let self = self else { return }
            self.configureAvatarActions()
        })
    }
    
    internal func configureAvatarActions() {
        
        let processPickedImage: ((UIImage) -> Void) = { image in
            self.headerView.avatarView.avatarAppearance = .loading
            self.profileModel.setAvatar(image) { [weak self] error in
                if let error = error {
                    SPAlert.present(message: error.localizedDescription, haptic: .error, completion: nil)
                }
                self?.configureHeader()
            }
        }
        
        var actions: [UIAction] = []
        let openCameraAction = UIAction.init(title: Texts.Profile.Avatar.open_camera, image: .init(.camera), handler: { [weak self] _ in
            guard let self = self else { return }
            SPImagePicker.pick(sourceType: .camera, on: self) { pickedImage in
                if let image = pickedImage {
                    processPickedImage(image)
                }
            }
        })
        actions.append(openCameraAction)
        
        let openPhotoLibraryAction = UIAction.init(title: Texts.Profile.Avatar.open_photo_library, image: .init(.photo), handler: { [weak self] _ in
            guard let self = self else { return }
            SPImagePicker.pick(sourceType: .photoLibrary, on: self) { pickedImage in
                if let image = pickedImage {
                    processPickedImage(image)
                }
            }
        })
        actions.append(openPhotoLibraryAction)
        
        if headerView.avatarView.hasAvatar {
            let removeAvatarAction = UIAction.init(title: Texts.Profile.Avatar.delete_action_title, image: .init(.trash), attributes: [.destructive]) { [weak self] _ in
                guard let self = self else { return }
                self.headerView.avatarView.avatarAppearance = .loading
                self.profileModel.deleteAvatar { [weak self] error in
                    if let error = error {
                        SPAlert.present(message: error.localizedDescription, haptic: .error)
                    } else {
                        guard let self = self else { return }
                        self.configureHeader()
                    }
                }
            }
            actions.append(removeAvatarAction)
        }
        
        if #available(iOS 14.0, *) {
            let menu = UIMenu.init(title: Texts.Profile.Avatar.actions_description, children: actions)
            for button in [headerView.avatarView.indicatorButton, headerView.avatarView.placeholderButton, headerView.avatarView.avatarButton] {
                button.showsMenuAsPrimaryAction = true
                button.menu = menu
            }
        } else {
            #warning("add support ios 13 with alert")
        }
        
        headerView.avatarView.isEditable = true
    }
    
    internal func setProfile(_ profileModel: ProfileModel, completion: (()->())? = nil) {
        headerView.nameLabel.text = profileModel.name
        headerView.namePlaceholderLabel.text = Texts.Profile.placeholder_name
        if let email = profileModel.email { headerView.emailButton.setTitle(email) }
        headerView.layoutSubviews()
        
        headerView.emailButton.removeTargetsAndActions()
        headerView.emailButton.addTarget(self, action: #selector(didTapEmailButton), for: .touchUpInside)
        
        headerView.avatarView.setAvatar(of: profileModel) {
            completion?()
        }
    }
    
    @objc func didTapEmailButton() {
        SPAlert.present(title: Texts.Profile.Actions.email_copied, message: nil, preset: .done, completion: nil)
        UIPasteboard.general.string = profileModel.email
    }
}
