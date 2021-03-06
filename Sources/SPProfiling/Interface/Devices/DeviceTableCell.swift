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
import SparrowKit
import SPDiffable

class DeviceTableCell: SPTableViewCell {
    
    // MARK: - Init
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func commonInit() {
        super.commonInit()
        textLabel?.font = UIFont.preferredFont(forTextStyle: .body, weight: .medium)
        textLabel?.textColor = .label
        textLabel?.numberOfLines = .zero
        detailTextLabel?.font = UIFont.preferredFont(forTextStyle: .footnote)
        detailTextLabel?.textColor = .secondaryLabel
        detailTextLabel?.numberOfLines = .zero
        higlightStyle = .content
    }
    
    // MARK: - Public
    
    func setDevice(_ model: ProfileDeviceModel) {
        textLabel?.text = model.name
        detailTextLabel?.text = Texts.Profile.Devices.added_date(date: model.addedDate)
        let font = UIFont.preferredFont(forTextStyle: .title3, weight: .medium)
        
        imageView?.image = {
            switch model.type {
            case .phone:
                return UIImage.system("iphone", font: font)
            case .pad:
                return UIImage.system("ipad", font: font)
            case .desktop:
                return UIImage.system("laptopcomputer", font: font)
            }
        }()
        
        imageView?.tintColor = .tint
    }
    
    // MARK: - Layout
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let superSize = super.sizeThatFits(size)
        return .init(width: superSize.width, height: superSize.height + 2)
    }
}
