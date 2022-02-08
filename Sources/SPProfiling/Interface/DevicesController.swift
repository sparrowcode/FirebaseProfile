import UIKit
import SparrowKit
import SPDiffable
import Models
import Texts

class DevicesController: SPDiffableTableController {
    
    internal var profileModel = ProfileModel.currentProfile
    
    // MARK: - Init
    
    init() {
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Texts.Profile.Devices.title
        tableView.register(DeviceTableCell.self)
        
        configureDiffable(sections: content, cellProviders: [
            .init(clouser: { tableView, indexPath, item in
                guard let deviceModel = (item as? SPDiffableWrapperItem)?.model as? ProfileDeviceModel else { return nil }
                let cell = self.tableView.dequeueReusableCell(withClass: DeviceTableCell.self, for: indexPath)
                cell.textLabel?.text = deviceModel.name
                cell.detailTextLabel?.text = deviceModel.addedDate.formatted(dateStyle: .medium)
                return cell
            })
        ])
        
        NotificationCenter.default.addObserver(forName: SPProfiling.didReloadedProfile, object: nil, queue: nil) { [weak self] _ in
            guard let self = self else { return }
            if let profileModel = ProfileModel.currentProfile {
                self.profileModel = profileModel
                self.diffableDataSource?.set(self.content, animated: true)
            }
        }
    }
    
    // MARK: - Diffable
    
    enum Section: String {
        
        case devices
        
        var id: String { rawValue }
    }
    
    internal var content: [SPDiffableSection] {
        
        let devices = profileModel?.devices ?? []
        
        return [
            .init(
                id: Section.devices.id,
                header: SPDiffableTextHeaderFooter(text: Texts.Profile.Devices.header),
                footer: SPDiffableTextHeaderFooter(text: Texts.Profile.Devices.footer),
                items: devices.map({ SPDiffableWrapperItem(id: $0.id, model: $0) })
            )
        ]
    }
}
