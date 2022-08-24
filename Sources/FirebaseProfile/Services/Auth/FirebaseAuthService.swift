import FirebaseAuth

class FirebaseAuthService {
    
    // MARK: - Data
    
    static var userID: String? { Auth.auth().currentUser?.uid }
    static var userName: String? { Auth.auth().currentUser?.displayName }
    static var userEmail: String? { Auth.auth().currentUser?.email }
    static var isAnonymous: Bool? { Auth.auth().currentUser?.isAnonymous }
    
    // MARK: - Init
    
    static func configure(authDidChangedWork: @escaping ()->Void) {
        if let observer = shared.observer {
            Auth.auth().removeStateDidChangeListener(observer)
        }
        shared.observer = Auth.auth().addStateDidChangeListener { auth, user in
            authDidChangedWork()
        }
    }
    
    // MARK: - Actions
    
    static func signIn(credential: AuthCredential, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(with: credential) { (result, error) in
            completion(error)
        }
    }
    
    static func signInAnonymously(comlection: @escaping (Error?) -> Void) {
        Auth.auth().signInAnonymously { authResult, error in
            comlection(error)
        }
    }
    
    static func signOut(completion: @escaping (Error?)->Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    static func delete(completion: @escaping (Error?)->Void) {
        let user = Auth.auth().currentUser
        user?.delete(completion: { error in
            completion(error)
        })
    }
    
    // MARK: - Credential
    
    static func appleCredential(identityToken: String) -> AuthCredential {
        return OAuthProvider.credential(withProviderID: AuthService.Provider.apple.id, idToken: identityToken, rawNonce: nil)
    }
    
    // MARK: - Singltone
    
    private var observer: AuthStateDidChangeListenerHandle?
    private static let shared = FirebaseAuthService()
    
    private init() {}
}
