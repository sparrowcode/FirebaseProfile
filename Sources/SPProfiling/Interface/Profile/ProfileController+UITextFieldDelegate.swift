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
import NativeUIKit
import SparrowKit
import SPDiffable
import SPSafeSymbols
import SPAlert

extension ProfileController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let nameTextField: UITextField? = {
            guard let indexPath = diffableDataSource?.getIndexPath(id: Item.name.id) else { return nil }
            guard let cell = tableView.cellForRow(at: indexPath) as? SPDiffableTextFieldTitleTableViewCell else { return nil }
            return cell.textField
        }()
        
        switch textField {
        case nameTextField:
            let text = textField.text ?? .empty
            self.profileModel.setName(text, completion: { error in
                if let error = error {
                    SPAlert.present(message: error.localizedDescription, haptic: .error)
                }
                nameTextField?.text = self.profileModel.name
            })
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
