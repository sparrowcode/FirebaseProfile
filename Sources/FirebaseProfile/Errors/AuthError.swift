import Foundation

public enum AuthError: LocalizedError {
  
    case canceled
    case cantPresent
    
    #warning("localise it")
    public var errorDescription: String? {
        switch self {
        case .canceled: return "canceled"
        case .cantPresent: return "can't present"
        }
    }
}
