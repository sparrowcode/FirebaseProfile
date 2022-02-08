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
