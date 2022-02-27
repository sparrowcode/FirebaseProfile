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

public struct ProfileDeviceModel: Equatable {
    
    public let id: String
    public let name: String
    public let type: DeviceType
    public let fcmToken: String?
    public let languageCode: String
    public let addedDate: Date
    
    public init(id: String, name: String, type: DeviceType, fcmToken: String?, languageCode: String, addedDate: Date) {
        self.id = id
        self.name = name
        self.type = type
        self.fcmToken = fcmToken
        self.languageCode = languageCode
        self.addedDate = addedDate
    }
    
    // MARK: - Models
    
    public enum DeviceType: String {
        
        case phone
        case pad
        case desktop
        
        public var id: String { rawValue }
    }
}
