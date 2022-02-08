import UIKit
import SparrowKit
import NativeUIKit
import SPDiffable
import SPAlert

extension CurrentProfileController {
    
    internal func showTextFieldToChangeName() {
        let alertController = UIAlertController(title: Texts.Profile.Actions.Rename.alert_title, message: Texts.Profile.Actions.Rename.alert_description, preferredStyle: .alert)
        let profileName = ProfileModel.currentProfile?.name
        let saveAction = UIAlertAction(title: Texts.save, style: .default) { [weak self] _ in
            guard let _ = self else { return }
            guard let textField = alertController.textFields?.first else { return }
            guard let text = textField.text else { return }
            ProfileModel.currentProfile?.setName(text, completion: { error in
                if let error = error {
                    SPAlert.present(message: error.localizedDescription, haptic: .error)
                }
            })
        }
        alertController.addAction(saveAction)
        alertController.addAction(title: Texts.cancel, style: .cancel, handler: nil)
        if #available(iOS 14, *) {
            alertController.addTextField(
                text: profileName,
                placeholder: Texts.Profile.Actions.Rename.alert_placeholder,
                action: .init(handler: { [weak self] _ in
                    guard let _ = self else { return }
                    guard let textField = alertController.textFields?.first else { return }
                    saveAction.isEnabled = ProfileModel.validProfileName(textField.text ?? .space)
                })
            )
        } else {
            alertController.addTextField(
                text: profileName,
                placeholder: Texts.Profile.Actions.Rename.alert_placeholder,
                editingChangedTarget: nil,
                editingChangedSelector: nil
            )
        }
        if let textField = alertController.textFields?.first {
            textField.keyboardType = .default
            textField.autocapitalizationType = .words
        }
        saveAction.isEnabled = false
        self.present(alertController)
    }
}
