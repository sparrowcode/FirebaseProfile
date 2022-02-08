import UIKit
import NativeUIKit
import SparrowKit
import SPDiffable
import SFSymbols
import SPAlert

extension CurrentProfileController {
    
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
        headerView.namePlaceholderLabel.text = Texts.Profile.name_didnt_set
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
