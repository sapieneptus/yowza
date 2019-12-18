
import UIKit
import HockeySDK

class SDKDetailsViewController: UIViewController {

    @IBOutlet var versionLabel: UILabel!
    @IBOutlet var configDetails: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        versionLabel.text = Config.appVersion()

        let config = Config.fetch()!

        let authTypeString: String
        switch config.authType {
        case .hockeyAppEmail:
            authTypeString = "Email"
            break
        case .device:
            authTypeString = "Device"
            break
        case .hockeyAppUser:
            authTypeString = "User"
            break
        case .webAuth:
            authTypeString = "Web"
            break
        case .anonymous:
            authTypeString = "Anonymous"
            break
        default:
            authTypeString = "UNKNOWN: \(config.authType.rawValue)"
            break
        }

        let configString = "Environment: \(config.environment)\nAuthType: \(authTypeString)\nrestrictAppUsage: \(config.restrictApplicationUsage)"

        configDetails.text = configString

        initializeSDK()
    }

    func initializeSDK() {
        let config = Config.fetch()!
        let appId = config.environment == .Training ? "962886f78bde4a239c1eca7cbf708b04" : "2973215e74ff440fbc08dd30b454acdc"
        let appSecret = config.environment == .Training ? "a80d7081b243a4a6e28618ea7faff504" : "fbfc7eb40dd8d6cbade2f063d081761d"

        BITHockeyManager.shared().configure(withIdentifier: appId)
        BITHockeyManager.shared().logLevel = BITLogLevel.verbose

        BITHockeyManager.shared().authenticator.identificationType = config.authType
        if config.authType == .hockeyAppEmail {
            BITHockeyManager.shared().authenticator.authenticationSecret = appSecret
        }
        BITHockeyManager.shared().serverURL = config.environment.rawValue
        BITHockeyManager.shared().authenticator.serverURL = config.environment.rawValue
        BITHockeyManager.shared().authenticator.webpageURL = URL(string: config.environment.rawValue)
        BITHockeyManager.shared().authenticator.restrictApplicationUsage = config.restrictApplicationUsage
        BITHockeyManager.shared().authenticator.authenticateInstallation()
        
        BITHockeyManager.shared().start()
    }
}
