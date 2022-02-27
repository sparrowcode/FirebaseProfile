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

extension ProfileModel {

    public static func middleware(_ profileModel: ProfileModel) -> Error? {
        if let name = profileModel.name, let error = middlewareProfileName(name) {  return error }
        if let email = profileModel.email, let error = middlewareProfileEmail(email) { return error }
        return nil
    }
    
    // MARK: - Name
    
    public static func cleanProfileName(_ name: String) -> String {
        return name.trim
    }
    
    public static func validProfileName(_ name: String) -> Bool {
        return middlewareProfileName(name) == nil
    }
    
    public static func middlewareProfileName(_ name: String) -> Error? {
        if name.isEmptyContent { return ProfileMiddlewareError.emptyName }
        if name.count < Self.minimum_profile_name_length {
            return ProfileMiddlewareError.nameShort
        }
        if name.count > Self.maximum_profile_name_length {
            return ProfileMiddlewareError.nameLong
        }
        return nil
    }
    
    // MARK: - Email
    
    public static func validProfileEmail(_ string: String) -> Bool {
        return middlewareProfileEmail(string) == nil
    }

    public static func middlewareProfileEmail(_ email: String) -> Error? {
        guard email.isValidEmail else {
            return ProfileMiddlewareError.invalidEmail
        }
        return nil
    }
    
    // MARK: - Avatar
    
    public static func cleanAvatar(image: UIImage) -> UIImage? {
        let maximmumWidth = CGFloat(Self.avatar_maximum_width)
        let comressFactor = CGFloat(Self.avatar_compress_factor)
        var compressedImage = image.compresse(quality: comressFactor) ?? image
        if compressedImage.size.width > maximmumWidth {
            compressedImage = compressedImage.resize(newWidth: maximmumWidth)
        }
        return compressedImage
    }
    
    public static func middlewareAvatar(_ image: UIImage) -> Error? {
        if image.size.width > Self.avatar_maximum_width { return ProfileMiddlewareError.avatarBigWidth }
        if image.bytesSize > Self.avatar_maximum_bytes { return ProfileMiddlewareError.avatarBigSize }
        return nil
    }
    
    // MARK: - Constants
    
    public static var minimum_profile_name_length: Int { 2 }
    public static var maximum_profile_name_length: Int { 50 }
    public static var avatar_maximum_width: CGFloat { 100 }
    public static var avatar_compress_factor: Float { 0.5 }
    public static var avatar_maximum_bytes: Int64 { 10 * 1024 * 1024 }
}
