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
import SPFirebaseFirestore

public enum EditProfileError: LocalizedError {
    
    case notEnoughPermissions
    case notReachable
    case unknown
    
    public var errorDescription: String? {
        switch self {
        case .notEnoughPermissions: return Texts.Error.not_enough_permissions
        case .notReachable: return Texts.Error.not_reachable
        case .unknown: return Texts.Error.unknown
        }
    }
    
    public static func convert(_ error: Error) -> EditProfileError {
        let error = SPFirebaseFirestoreError.get(by: error)
        switch error {
        case .OK: return .unknown
        case .cancelled: return .notReachable
        case .unknown: return .unknown
        case .invalidArgument: return .unknown
        case .deadlineExceeded: return .unknown
        case .notFound: return .unknown
        case .alreadyExists: return .unknown
        case .permissionDenied: return .notEnoughPermissions
        case .resourceExhausted: return .unknown
        case .failedPrecondition: return .unknown
        case .aborted: return .notReachable
        case .outOfRange: return .unknown
        case .unimplemented: return .unknown
        case .internal: return .unknown
        case .unavailable: return .notReachable
        case .dataLoss: return .notReachable
        case .unauthenticated: return .notEnoughPermissions
        }
    }
}
