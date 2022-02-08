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

extension SPProfiling {
    
    class Profile {
        
        // MARK: - Public
        
        static func configure(userID: String) {
            debug("SPProfiling/Profile configure with userID \(userID).")
            shared.userID = userID
            Observer.observeProfile(userID: userID, profileDidChangedWork: {
                NotificationCenter.default.post(name: SPProfiling.didReloadedProfile)
                self.checkCurrentDevice()
            })
            Device.configure(deviceDidChangedWork: {
                self.checkCurrentDevice()
            })
        }
        
        static func reset() {
            if shared.userID == nil { return }
            debug("SPProfiling/Profile reset.")
            Observer.stopObserving()
            shared.userID = nil
            Device.reset()
        }
        
        // MARK: - Data
        
        static var currentProfile: ProfileModel? {
            guard let userID = shared.userID else {
                debug("SPProfiling/Profile Profile don't configured, return nil for current profile.")
                return nil
            }
            if let observedProfile = Observer.getCachedProfile() {
                if observedProfile.id == userID {
                    return observedProfile
                }
            }
            return ProfileModel(id: userID, devices: [])
        }
        
        // MARK: - Actions
        
        private static func checkCurrentDevice() {
            let validDevice = Device.makeCurrentDevice()
            guard let savedDevice = currentProfile?.devices.first(where: { $0.id == Device.deviceID }) else {
                debug("SPProfiling/Profile current device not in list, adding it.")
                saveDevice(validDevice, completion: nil)
                return
            }
            let shoudUpdate: Bool = {
                if savedDevice.name != validDevice.name { return true }
                if savedDevice.languageCode != validDevice.languageCode { return true }
                if savedDevice.fcmToken != validDevice.fcmToken { return true }
                if savedDevice.type != validDevice.type { return true }
                return false
            }()
            if shoudUpdate {
                debug("SPProfiling/Profile current device changed, updating to new.")
                saveDevice(validDevice, completion: nil)
            }
        }
        
        // MARK: - Singltone
        
        private var userID: String? = nil
        private var cachedAvatarURLs: [(userID: String, url: URL?)] = []
        private static var shared = Profile()
        private init() {}
        
        // MARK: - Access
        
        internal static var configuredUserID: String { Profile.shared.userID! }
        
        internal static var cachedAvatarURLs: [CachedAvatar] {
            get { shared.cachedAvatarURLs }
            set { shared.cachedAvatarURLs = newValue }
        }
        
        typealias CachedAvatar = (userID: String, url: URL?)
    }
}
