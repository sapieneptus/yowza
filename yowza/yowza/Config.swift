
import Foundation
import HockeySDK

class Config: NSObject {
    enum Environment : String {
        case Training = "https://training.hockeyapp.net/"
        case Rink = "https://rink.hockeyapp.net/"
    }

    let authType: BITAuthenticatorIdentificationType
    let restrictApplicationUsage: Bool
    let environment: Environment

    init(authType: BITAuthenticatorIdentificationType, restrictApplicationUsage: Bool, environment: Environment) {
        self.authType = authType
        self.restrictApplicationUsage = restrictApplicationUsage
        self.environment = environment
    }

    static func save(authType: BITAuthenticatorIdentificationType, restrictApplicationUsage: Bool, environment: Environment) {
        let defaults = UserDefaults.standard

        defaults.set(authType.rawValue, forKey: "authType")
        defaults.set(restrictApplicationUsage, forKey: "restrictApplicationUsage")
        defaults.set(environment.rawValue, forKey: "environment")

        defaults.synchronize()
    }

    static func fetch() -> Config? {
        let defaults = UserDefaults.standard
        guard let authTypeRaw = defaults.value(forKey: "authType") as? UInt,
            let authType = BITAuthenticatorIdentificationType.init(rawValue: authTypeRaw),
            let restrictApplicationUsage = defaults.value(forKey: "restrictApplicationUsage") as? Bool,
            let environmentRaw = defaults.value(forKey: "environment") as? String,
            let environment = Environment.init(rawValue: environmentRaw) else {
            return nil
        }

        return Config(authType: authType, restrictApplicationUsage: restrictApplicationUsage, environment: environment)
    }

    static func exists() -> Bool {
        return fetch() != nil
    }

    static func appVersion() -> String {
        let shortVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        let bundleVersion: String = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
        return "Version: \(shortVersion) (\(bundleVersion))"
    }
}
