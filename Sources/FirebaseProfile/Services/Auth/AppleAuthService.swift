import UIKit
import AuthenticationServices

class AppleAuthService: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    static func signIn(on window: UIWindow, completion: ((AppleAuthData?) -> Void)?) {
        shared.completion = completion
        shared.window = window
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = shared
        authorizationController.presentationContextProvider = shared
        authorizationController.performRequests()
    }
    
    // MARK: - ASAuthorizationControllerDelegate
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        guard let identityToken = appleCredential.identityToken else { return }
        guard let token = String(data: identityToken, encoding: .utf8) else { return }
        let name: String? = {
            guard let fullName = appleCredential.fullName else { return nil }
            let familyName = fullName.familyName
            let givenName = fullName.givenName
            if familyName != nil && givenName != nil {
                return givenName! + " " + familyName!
            }
            if familyName != nil {
                return familyName
            }
            if givenName != nil {
                return givenName
            }
            return nil
        }()
        let data = AppleAuthData(
            identityToken: token,
            name: name,
            email: appleCredential.email
        )
        completion?(data)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        completion?(nil)
    }
    
    // MARK: - ASAuthorizationControllerPresentationContextProviding
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let window = self.window else { fatalError("Can't get root window") }
        return window
    }
    
    // MARK: - Singltone
    
    private weak var window: UIWindow?
    private var completion: ((AppleAuthData?) -> Void)?
    
    static let shared = AppleAuthService()
    private override init() {}
    
    // MARK: - Models
    
    struct AppleAuthData {
        
        public let identityToken: String
        public let name: String?
        public let email: String?
    }
}
