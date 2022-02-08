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
import SparrowKit
import FirebaseFirestore
import SPFirebaseFirestore

extension SPProfiling.Profile {
    
    static func getProfile(userID: String, source: SPFirebaseFirestoreSource, completion: @escaping (ProfileModel?, Error?)->Void) {
        guard let currentProfileModel = currentProfile else {
            completion(nil, GetProfileError.notEnoughPermissions)
            return
        }
        if let error = currentProfileModel.middleware(.getProfile) {
            completion(nil, error)
            return
        }
        debug("SPProfiling/Profile getting profile of userID \(userID).")
        Firestore.profile_document(userID: userID).getDocument(source: source.firestore) { documentSnapshot, error in
            if let error = error {
                if source == .cachedFirst {
                    // If cached first need to do make request
                    getProfile(userID: userID, source: .default, completion: completion)
                } else {
                    debug("SPProfiling/Profile can't get profile for \(userID), error: \(error.localizedDescription)")
                    completion(nil, GetProfileError.convert(error))
                    return
                }
            }
            guard let documentSnapshot = documentSnapshot else { return }
            if let profileModel = Converter.convertToProfile(documentSnapshot) {
                completion(profileModel, nil)
            } else {
                completion(nil, GetProfileError.unknown)
            }
        }
    }
    
    static func getProfile(email: String, source: SPFirebaseFirestoreSource, completion: @escaping (ProfileModel?, Error?)->Void) {
        guard let currentProfileModel = currentProfile else {
            completion(nil, GetProfileError.notEnoughPermissions)
            return
        }
        if let error = currentProfileModel.middleware(.getProfile) {
            completion(nil, error)
            return
        }
        debug("SPProfiling/Profile getting profile of email \(email).")
        Firestore.profiles_collection().whereField(Constants.Firebase.Firestore.Fields.Profile.profileEmail, isEqualTo: email).getDocuments(source: source.firestore) { querySnapshot, error in
            if let error = error {
                if source == .cachedFirst {
                    // If cached first need to do make request
                    getProfile(email: email, source: .default, completion: completion)
                } else {
                    debug("SPProfiling/Profile can't get profile for \(email), error: \(error.localizedDescription)")
                    completion(nil, GetProfileError.convert(error))
                    return
                }
            }
            guard let documentSnapshot = querySnapshot?.documents.first else {
                completion(nil, GetProfileError.notFound)
                return
            }
            if let profileModel = Converter.convertToProfile(documentSnapshot) {
                completion(profileModel, nil)
            } else {
                completion(nil, GetProfileError.unknown)
            }
        }
    }
    
    static func setProfileName(_ name: String, completion: ((Error?)->Void)?) {
        guard let currentProfileModel = currentProfile else {
            completion?(EditProfileError.notEnoughPermissions)
            return
        }
        if let error = currentProfileModel.middleware(.editProfile(currentProfileModel)) {
            completion?(error)
            return
        }
        
        let name = ProfileModel.cleanProfileName(name)
        if let error = ProfileModel.middlewareProfileName(name) {
            completion?(error)
            return
        }
        let data: [String : Any] = [
            Constants.Firebase.Firestore.Fields.Profile.profileName : name
        ]
        debug("SPProfiling/Profile/setProfileName called with \(data)")
        Firestore.profile_document(userID: configuredUserID).setData(data, merge: true, completion: { error in
            if let error = error {
                completion?(EditProfileError.convert(error))
            } else {
                completion?(nil)
            }
        })
    }
    
    static func setProfileEmail(_ email: String, completion: ((Error?)->Void)?) {
        guard let currentProfileModel = currentProfile else {
            completion?(EditProfileError.notEnoughPermissions)
            return
        }
        if let error = currentProfileModel.middleware(.editProfile(currentProfileModel)) {
            completion?(error)
            return
        }
        if let error = ProfileModel.middlewareProfileEmail(email) {
            completion?(error)
            return
        }
        let data: [String : Any] = [
            Constants.Firebase.Firestore.Fields.Profile.profileEmail : email
        ]
        debug("SPProfiling/Profile/setProfileEmail called with \(data)")
        Firestore.profile_document(userID: configuredUserID).setData(data, merge: true, completion: { error in
            if let error = error {
                completion?(EditProfileError.convert(error))
            } else {
                completion?(nil)
            }
        })
    }
    
    static func setProfileCreatedDate(_ date: Date, completion: ((Error?)->Void)?) {
        guard let currentProfileModel = currentProfile else {
            completion?(EditProfileError.notEnoughPermissions)
            return
        }
        if let error = currentProfileModel.middleware(.editProfile(currentProfileModel)) {
            completion?(error)
            return
        }
        let data: [String : Any] = [
            Constants.Firebase.Firestore.Fields.Profile.profileCreatedDate : Timestamp(date: date)
        ]
        debug("SPProfiling/Profile/setProfileCreatedDate called with \(data)")
        Firestore.profile_document(userID: configuredUserID).setData(data, merge: true, completion: { error in
            if let error = error {
                completion?(EditProfileError.convert(error))
            } else {
                completion?(nil)
            }
        })
    }
    
    static func saveDevice(_ deviceModel: ProfileDeviceModel, completion: ((Error?)->Void)?) {
        guard let currentProfileModel = currentProfile else {
            completion?(EditProfileError.notEnoughPermissions)
            return
        }
        if let error = currentProfileModel.middleware(.editProfile(currentProfileModel)) {
            completion?(error)
            return
        }
        let data = Converter.convertToData(deviceModel)
        debug("SPProfiling/Profile/saveDevice called with \(data)")
        Firestore.profile_document(userID: currentProfileModel.id).setData([
            Constants.Firebase.Firestore.Fields.Profile.profileDevices : [
                deviceModel.id : Converter.convertToData(deviceModel)
            ]
        ], merge: true) { error in
            if let error = error {
                completion?(EditProfileError.convert(error))
            } else {
                completion?(nil)
            }
        }
    }
}

