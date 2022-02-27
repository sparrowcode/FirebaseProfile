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
import FirebaseStorage

extension SPProfiling.Profile {

    public static func getAvatarURL(of profileModel: ProfileModel, completion: @escaping (URL?, Error?)->Void) {
        guard let currentProfileModel = currentProfile else {
            completion(nil, GetAvatarError.notEnoughPermissions)
            return
        }
        if let error = currentProfileModel.middleware(.getProfilveAvatar) {
            completion(nil, error)
            return
        }
        let userID = profileModel.id
        if let data = getCachedURL(userID: userID) {
            completion(data.url, nil)
        } else {
            let avatarStorageReference = Storage.profile_avatar(userID: profileModel.id)
            avatarStorageReference.downloadURL { url, error in
                self.cleanCachedAvatarURLs(userID: userID)
                self.cacheAvatar(url: url, userID: userID)
                completion(url, error == nil ? nil : GetAvatarError.notReachable)
            }
        }
    }
    
    public static func setAvatar(_ image: UIImage, completion: ((Error?)->Void)?) {
        guard let currentProfileModel = currentProfile else {
            completion?(SetAvatarError.notEnoughPermissions)
            return
        }
        if let error = currentProfileModel.middleware(.setProfilveAvatar(currentProfileModel)) {
            completion?(error)
            return
        }
        let cleanAvatar = ProfileModel.cleanAvatar(image: image) ?? image
        if let error = ProfileModel.middlewareAvatar(cleanAvatar) {
            completion?(error)
            return
        }
        guard let avatarData = cleanAvatar.jpegData(compressionQuality: 1) else {
            completion?(SetAvatarError.invalidData)
            return
        }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let avatarStorageReference = Storage.profile_avatar(userID: configuredUserID)
        avatarStorageReference.putData(avatarData, metadata: metadata) { metadata, error in
            self.cleanCachedAvatarURLs(userID: configuredUserID)
            if let _ = error {
                completion?(SetAvatarError.notReachable)
            } else {
                completion?(nil)
            }
        }
    }
    
    public static func deleteAvatar(completion: ((DeleteAvatarError?)->Void)?) {
        let avatarStorageReference = Storage.profile_avatar(userID: configuredUserID)
        avatarStorageReference.delete { error in
            self.cleanCachedAvatarURLs(userID: configuredUserID)
            if let _ = error {
                completion?(.notReachable)
                return
            } else {
                completion?(nil)
            }
        }
    }
    
    // MARK: - Cache
    
    private static func getCachedURL(userID: String) -> CachedAvatar? {
        cachedAvatarURLs.first(where: { $0.userID == userID })
    }
    
    private static func cacheAvatar(url: URL?, userID: String) {
        cachedAvatarURLs.append((userID: userID, url: url))
    }
    
    private static func cleanCachedAvatarURLs(userID: String) {
        cachedAvatarURLs = cachedAvatarURLs.filter({ $0.userID != userID })
    }
}
