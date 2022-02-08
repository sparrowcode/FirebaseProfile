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

enum Constants {
    
    enum Firebase {
        
        // MARK: Storage
        
        enum Storage {
            
            enum Paths {
                
                static var profiles: String { "profiles" }
                static var avatar_filename: String { "avatar.jpg" }
            }
        }
        
        // MARK: Firestore
        
        enum Firestore {
            
            enum Paths {
                
                static var profiles: String { "profiles" }
                static var homes: String { "homes" }
                static var checklists: String { "checklists" }
            }
            
            enum Fields {
                
                public enum Profile {
                    
                    static var profileName: String { "name" }
                    static var profileEmail: String { "email" }
                    static var profileDevices: String { "devices" }
                    static var profileCreatedDate: String { "created" }
                    
                    static var deviceID: String { "id" }
                    static var deviceName: String { "name" }
                    static var deviceType: String { "type" }
                    static var deviceFCMToken: String { "fcmToken" }
                    static var deviceLanguageCode: String { "language" }
                    static var deviceAddedDate: String { "added" }
                }
                
                public enum Home {
                    
                    static var name: String { "name" }
                    static var usersIDs: String { "usersIDs" }
                    static var users: String { "users" }
                    static var createdDate: String { "created" }
                }
                
                public enum HomeUser {
                    
                    static var access: String { "access" }
                    static var invited: String { "invited" }
                    static var inviteDate: String { "inviteDate" }
                    static var inviteAcceptedDate: String { "inviteAcceptedDate" }
                    static var invitedByUserID: String { "invitedByUserID" }
                }
                
                public enum Checklist {
                    
                    static var checklistTitle: String { "title" }
                    static var checklistIcon: String { "icon" }
                    static var checklistColor: String { "color" }
                    static var cheklistSections: String { "sections" }
                    static var checklistCreatedDate: String { "created" }
                    
                    static var sectionIndex: String { "index" }
                    static var sectionTitle: String { "title" }
                    static var sectionActions: String { "actions" }
                    
                    static var actionIndex: String { "index" }
                    static var actionTitle: String { "title" }
                    static var actionCompleteState: String { "completeState" }
                }
            }
        }
    }
}
