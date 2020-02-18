
import Foundation
import HockeySDK

class Config {
    enum Environment : String {
        case Training = "https://training.hockeyapp.net/"
        case Rink = "https://rink.hockeyapp.net/"
    }

    let appId: String
    let appSecret: String
    let authType: BITAuthenticatorIdentificationType
    let restrictApplicationUsage: Bool
    let environment: Environment

    init(appId: String, appSecret: String, authType: BITAuthenticatorIdentificationType, restrictApplicationUsage: Bool, environment: Environment) {
        self.appId = appId
        self.appSecret = appSecret
        self.authType = authType
        self.restrictApplicationUsage = restrictApplicationUsage
        self.environment = environment
    }

    static func save(appId: String, appSecret: String, authType: BITAuthenticatorIdentificationType, restrictApplicationUsage: Bool, environment: Environment) {
        let defaults = UserDefaults.standard

        defaults.set(appId, forKey: "appId")
        defaults.set(appSecret, forKey: "appSecret")
        defaults.set(authType.rawValue, forKey: "authType")
        defaults.set(restrictApplicationUsage, forKey: "restrictApplicationUsage")
        defaults.set(environment.rawValue, forKey: "environment")
    }

    static func fetch() -> Config {
        let defaults = UserDefaults.standard
        
        defaults.register(defaults: [
            "environment": Environment.Rink.rawValue,
            "authType": BITAuthenticatorIdentificationType.anonymous.rawValue,
            "restrictApplicationUsage": false
        ])
        
        let environmentRaw = defaults.value(forKey: "environment") as! String
        let environment = Environment.init(rawValue: environmentRaw)!
        let appId = defaults.value(forKey: "appId") as? String ?? defaultAppId(environment: environment)
        let appSecret = defaults.value(forKey: "appSecret") as? String ?? defaultAppSecret(environment: environment)
        let authTypeRaw = defaults.value(forKey: "authType") as! UInt
        let authType = BITAuthenticatorIdentificationType.init(rawValue: authTypeRaw)!
        let restrictApplicationUsage = defaults.value(forKey: "restrictApplicationUsage") as! Bool
        
       
        return Config(appId: appId, appSecret: appSecret , authType: authType, restrictApplicationUsage: restrictApplicationUsage, environment: environment)
    }

    
    static func defaultAppId(environment: Environment) -> String {
        switch environment {
        case .Training:
            return "962886f78bde4a239c1eca7cbf708b04"
        case .Rink:
            return "2973215e74ff440fbc08dd30b454acdc"
        }
    }

    static func defaultAppSecret(environment: Environment) -> String {
        switch environment {
        case .Training:
            return "a80d7081b243a4a6e28618ea7faff504"
        case .Rink:
            return "fbfc7eb40dd8d6cbade2f063d081761d"
        }
    }
    
    static func appVersion() -> String {
        let shortVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        let bundleVersion: String = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
        return "Version: \(shortVersion) (\(bundleVersion))"
    }
}
