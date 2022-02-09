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
import SPDiffable
import Models
import Texts

class DeviceTableCell: SPTableViewCell {
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func commonInit() {
        super.commonInit()
        textLabel?.font = UIFont.preferredFont(forTextStyle: .title3, weight: .semibold, addPoints: -2).rounded
        textLabel?.textColor = .label
        textLabel?.numberOfLines = .zero
        detailTextLabel?.font = UIFont.preferredFont(forTextStyle: .footnote)
        detailTextLabel?.textColor = .secondaryLabel
        detailTextLabel?.numberOfLines = .zero
    }
    
    // MARK: - Public
    
    func setDevice(_ model: ProfileDeviceModel) {
        textLabel?.text = model.name
        detailTextLabel?.text = Texts.Profile.Devices.added_date(date: model.addedDate)
        let font = UIFont.preferredFont(forTextStyle: .title3, weight: .semibold).rounded
        imageView?.image = UIImage.system("iphone", font: font)
        imageView?.tintColor = .tint
    }
}
