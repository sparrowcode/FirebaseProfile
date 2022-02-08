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
        textLabel?.font = UIFont.preferredFont(forTextStyle: .title3, weight: .semibold).rounded
        textLabel?.textColor = .label
        textLabel?.numberOfLines = .zero
        detailTextLabel?.font = UIFont.preferredFont(forTextStyle: .footnote)
        detailTextLabel?.textColor = .secondaryLabel
        detailTextLabel?.numberOfLines = .zero
    }
}
