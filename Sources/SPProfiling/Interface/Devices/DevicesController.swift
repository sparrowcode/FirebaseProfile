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
