import UIKit
import NativeUIKit
import SparrowKit
import Models
import Nuke

extension NativeAvatarView: Nuke_ImageDisplaying {
    
    func setAvatar(of profileModel: ProfileModel, completion: (()->Void)? = nil) {
        avatarAppearance = .loading
        profileModel.getAvatarURL { [weak self] url, error in
            guard let self = self else { return }
            var options = ImageLoadingOptions()
            options.contentModes = .init(success: .scaleAspectFill, failure: .scaleAspectFill, placeholder: .scaleAspectFill)
            loadImage(with: url, options: options, into: self, progress: nil) { result in
                switch result {
                case .success(let response):
                    self.avatarAppearance = .avatar(response.image)
                case .failure(_):
                    self.avatarAppearance = .placeholder
                }
                completion?()
            }
        }
    }
    
    open func nuke_display(image: UIImage?, data: Data?) {
        if let image = image {
            avatarAppearance = .avatar(image)
        }
    }
}
