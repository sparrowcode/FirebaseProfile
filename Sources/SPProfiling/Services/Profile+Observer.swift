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

import Foundation
import SparrowKit
import FirebaseFirestore

extension SPProfiling.Profile {
    
    class Observer {
        
        // MARK: - Public
        
        static var isObserving: Bool {
            return shared.observer != nil
        }
        
        static func observeProfile(userID: String, profileDidChangedWork: @escaping ()->Void) {
            if isObserving { stopObserving() }
            debug("SPProfiling/Profile/Observer configure with userID \(userID). Start observing.")
            shared.observer = SPProfiling.Profile.Firestore.profile_document(userID: userID).addSnapshotListener({ documentSnapshot, error in
                if let error = error {
                    debug("SPProfiling/Profile/Observer can't get profile, error: \(error.localizedDescription)")
                    return
                }
                guard let documentSnapshot = documentSnapshot else { return }
                if let profileModel = SPProfiling.Profile.Converter.convertToProfile(documentSnapshot) {
                    shared.cachedProfile = profileModel
                    profileDidChangedWork()
                }
            })
        }
        
        static func stopObserving() {
            guard isObserving else { return }
            debug("SPProfiling/Profile/Observer stop Profile observing.")
            shared.observer?.remove()
            shared.observer = nil
            shared.cachedProfile = nil
        }
        
        static func getCachedProfile() -> ProfileModel? {
            return shared.cachedProfile
        }
        
        // MARK: - Singltone
        
        private var observer: ListenerRegistration?
        private var cachedProfile: ProfileModel?
        private static var shared = Observer()
        private init() {}
    }
}
