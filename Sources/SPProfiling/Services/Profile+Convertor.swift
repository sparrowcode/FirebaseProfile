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

import Foundation
import FirebaseFirestore

extension SPProfiling.Profile {
    
    class Converter {
        
        // MARK: - Profile
        
        static func convertToProfile(_ snapshot: DocumentSnapshot) -> ProfileModel? {
            let profileID = snapshot.documentID
            let name = snapshot.get(Constants.Firebase.Firestore.Fields.Profile.profileName) as? String
            let email = snapshot.get(Constants.Firebase.Firestore.Fields.Profile.profileEmail) as? String
            let createdDate = (snapshot.get(Constants.Firebase.Firestore.Fields.Profile.profileCreatedDate) as? Timestamp)?.dateValue()
            let devices: [ProfileDeviceModel] = {
                guard let devicesData = snapshot.get(Constants.Firebase.Firestore.Fields.Profile.profileDevices) as? [String : [String : Any]] else { return [] }
                var devices: [ProfileDeviceModel] = []
                for deviceData in devicesData {
                    if let deviceModel = convertToDevice(deviceData) {
                        devices.append(deviceModel)
                    }
                }
                return devices
            }()
            let profileModel = ProfileModel.init(id: profileID, name: name, email: email, createdDate: createdDate, devices: devices)
            return profileModel
        }
        
        static func convertToData(_ model: ProfileModel) -> [String: Any] {
            var profileData: [String: Any] = [:]
            if let name = model.name {
                profileData[Constants.Firebase.Firestore.Fields.Profile.profileName] = name
            }
            if let email = model.email {
                let formattedEmail = email.lowercased()
                profileData[Constants.Firebase.Firestore.Fields.Profile.profileEmail] = formattedEmail
            }
            if let createdDate = model.createdDate {
                profileData[Constants.Firebase.Firestore.Fields.Profile.profileCreatedDate] = Timestamp(date: createdDate)
            }
            var devicesData: [String : Any] = [:]
            for deviceModel in model.devices {
                devicesData[deviceModel.id] = convertToData(deviceModel)
            }
            if !devicesData.isEmpty {
                profileData[Constants.Firebase.Firestore.Fields.Profile.profileDevices] = devicesData
            }
            return profileData
        }
        
        // MARK: - Device
        
        static func convertToDevice(_ deviceData: Dictionary<String, [String : Any]>.Element) -> ProfileDeviceModel? {
            let deviceID = deviceData.key
            guard let deviceName = deviceData.value[Constants.Firebase.Firestore.Fields.Profile.deviceName] as? String else { return nil }
            guard let deviceTypeID = deviceData.value[Constants.Firebase.Firestore.Fields.Profile.deviceType] as? String else { return nil }
            guard let deviceType = ProfileDeviceModel.DeviceType(rawValue: deviceTypeID) else { return nil }
            let fcmToken = deviceData.value[Constants.Firebase.Firestore.Fields.Profile.deviceFCMToken] as? String
            guard let languageCode = deviceData.value[Constants.Firebase.Firestore.Fields.Profile.deviceLanguageCode] as? String else { return nil }
            guard let addedDate = (deviceData.value[Constants.Firebase.Firestore.Fields.Profile.deviceAddedDate] as? Timestamp)?.dateValue() else { return nil }
            return ProfileDeviceModel(id: deviceID, name: deviceName, type: deviceType, fcmToken: fcmToken, languageCode: languageCode, addedDate: addedDate)
        }
        
        static func convertToData(_ deviceModel: ProfileDeviceModel) -> [String: Any] {
            var data: [String : Any] = [:]
            data[Constants.Firebase.Firestore.Fields.Profile.deviceName] = deviceModel.name
            data[Constants.Firebase.Firestore.Fields.Profile.deviceType] = deviceModel.type.id
            if let fcmToken = deviceModel.fcmToken {
                data[Constants.Firebase.Firestore.Fields.Profile.deviceFCMToken] = fcmToken
            }
            data[Constants.Firebase.Firestore.Fields.Profile.deviceLanguageCode] = deviceModel.languageCode
            data[Constants.Firebase.Firestore.Fields.Profile.deviceAddedDate] = Timestamp(date: deviceModel.addedDate)
            return data
        }
    }
}
