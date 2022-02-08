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
import SPFirebaseMessaging

extension SPProfiling.Profile {
    
    class Device {
        
        static func configure(deviceDidChangedWork: @escaping ()->Void) {
            SPFirebaseMessaging.addFCMTokenDidChangeListener { fcmToken in
                if UserDefaults.Values.firebase_fcm_token != fcmToken {
                    UserDefaults.Values.firebase_fcm_token = fcmToken
                    debug("SPProfiling/Profile/Device got new FCM token: \(fcmToken ?? "nil")")
                    deviceDidChangedWork()
                }
            }
        }
        
        static func reset() {
            SPFirebaseMessaging.removeFCMTokenDidChangeListener()
        }
        
        #warning("fill language by locale")
        static func makeCurrentDevice() -> ProfileDeviceModel {
            return .init(
                id: deviceID,
                name: deviceName,
                type: deviceType,
                fcmToken: fcmToken,
                languageCode: "en",
                addedDate: Date()
            )
        }
        
        static var deviceID: String {
            UIDevice.current.identifierForVendor?.uuidString ?? "invalid_device_id"
        }
        
        static var deviceName: String {
            UIDevice.current.name
        }
        
        static var fcmToken: String? {
            UserDefaults.Values.firebase_fcm_token
        }
        
        static var deviceType: ProfileDeviceModel.DeviceType {
            switch UIDevice.current.userInterfaceIdiom {
            case .phone: return .phone
            case .pad: return .pad
            case .mac: return .desktop
            default: return .phone
            }
        }
        
        // MARK: - Singltone
        
        private static var shared = Device()
        private init() {}
    }
}
