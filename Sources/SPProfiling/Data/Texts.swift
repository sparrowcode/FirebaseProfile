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

enum Texts {
    
    public static var save: String { NSLocalizedString("save", bundle: .module, comment: "") }
    public static var cancel: String { NSLocalizedString("cancel", bundle: .module, comment: "") }
    
    // MARK: - Error
    
    enum Error {
        
        static var not_found: String { NSLocalizedString("error not found", bundle: .module, comment: "") }
        static var not_enough_permissions: String { NSLocalizedString("error not enough permissions", bundle: .module, comment: "") }
        static var not_reachable: String { NSLocalizedString("error not reachable", bundle: .module, comment: "") }
        static var unknown: String { NSLocalizedString("error unknown", bundle: .module, comment: "") }
        
        enum Auth {
            
            static var canceled: String { NSLocalizedString("error auth canceled", bundle: .module, comment: "") }
            static var cant_present: String { NSLocalizedString("error auth cant present", bundle: .module, comment: "") }
            static var cant_prepare_required_data: String { NSLocalizedString("error auth cant prepare required data", bundle: .module, comment: "") }
        }
        
        enum Profile {
            
            static var name_short: String { NSLocalizedString("error profile name short", bundle: .module, comment: "") }
            static var name_long: String { NSLocalizedString("error profile name long", bundle: .module, comment: "") }
            static var empty_name: String { NSLocalizedString("error profile empty name", bundle: .module, comment: "") }
            static var big_avatar_width: String { NSLocalizedString("error profile big avatar width", bundle: .module, comment: "") }
            static var big_avatar_size: String { NSLocalizedString("error profile big avatar size", bundle: .module, comment: "") }
        }
    }
    
    // MARK: - Auth
    
    enum Auth {
        
        static var sign_in: String { NSLocalizedString("auth sign in", bundle: .module, comment: "") }
        static var continue_anonymously: String { NSLocalizedString("auth continue anonymously", bundle: .module, comment: "") }
        static var description: String { NSLocalizedString("auth description", bundle: .module, comment: "") }
        static var footer_description: String { NSLocalizedString("auth footer description", bundle: .module, comment: "") }
    }
    
    // MARK: - Profile
    
    enum Profile {
        
        static var placeholder_name: String { NSLocalizedString("profile placeholder name", bundle: .module, comment: "") }
        
        enum Devices {
            
            static var title: String { NSLocalizedString("profile devices title", bundle: .module, comment: "") }
            static var header: String { NSLocalizedString("profile devices header", bundle: .module, comment: "") }
            static var footer: String { NSLocalizedString("profile devices footer", bundle: .module, comment: "") }
            
            static func added_date(date: Date) -> String {
                let localisedDate = date.formatted(dateStyle: .medium)
                return String(format: NSLocalizedString("profile devices added date", bundle: .module, comment: ""), localisedDate)
            }
        }
        
        enum Actions {
            
            static var email_copied: String { NSLocalizedString("profile actions email copied", bundle: .module, comment: "") }
            
            enum Rename {
                
                static var title: String { NSLocalizedString("profile actions rename title", bundle: .module, comment: "") }
                static var description: String { NSLocalizedString("profile actions rename description", bundle: .module, comment: "") }
                
                static var alert_title: String { NSLocalizedString("profile rename alert title", bundle: .module, comment: "") }
                static var alert_description: String { NSLocalizedString("profile rename alert description", bundle: .module, comment: "") }
                static var alert_placeholder: String { NSLocalizedString("profile rename alert placeholder", bundle: .module, comment: "") }
            }
            
            enum SignOut {
                
                static var title: String { NSLocalizedString("profile actions sign out title", bundle: .module, comment: "") }
                static var description: String { NSLocalizedString("profile actions sign out description", bundle: .module, comment: "") }
                
                enum Confirm {
                    
                    static var title: String { NSLocalizedString("profile actions sign out confirm title", bundle: .module, comment: "") }
                    static var description: String { NSLocalizedString("profile actions sign out confirm description", bundle: .module, comment: "") }
                }
            }
            
            enum Delete {
                
                static var title: String { NSLocalizedString("profile actions delete title", bundle: .module, comment: "") }
                static var description: String { NSLocalizedString("profile actions delete description", bundle: .module, comment: "") }
                
                enum Confirm {
                    
                    static var title: String { NSLocalizedString("profile actions delete confirm title", bundle: .module, comment: "") }
                    static var description: String { NSLocalizedString("profile actions delete confirm description", bundle: .module, comment: "") }
                }
            }
        }
        
        enum Avatar {
            
            static var open_camera: String { NSLocalizedString("profile avatar open camera", bundle: .module, comment: "") }
            static var open_photo_library: String { NSLocalizedString("profile avatar open photo library", bundle: .module, comment: "") }
            static var delete_action_title: String { NSLocalizedString("profile avatar delete action title", bundle: .module, comment: "") }
            static var actions_description: String { NSLocalizedString("profile avatar actions description", bundle: .module, comment: "") }
        }
    }
}
