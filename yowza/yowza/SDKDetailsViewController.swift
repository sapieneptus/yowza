
import UIKit
import HockeySDK

class SDKDetailsViewController: UIViewController {

    @IBOutlet var versionLabel: UILabel!
    @IBOutlet var configDetails: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        versionLabel.text = Config.appVersion()

        let config = Config.fetch()

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

    @IBAction func crashButtonTapped(_ sender: UIButton) {
        BITHockeyManager.shared().crashManager.generateTestCrash()
    }
    
    func initializeSDK() {
        let config = Config.fetch()

        BITHockeyManager.shared().configure(withIdentifier: config.appId)
        BITHockeyManager.shared().logLevel = BITLogLevel.verbose

        BITHockeyManager.shared().authenticator.identificationType = config.authType
        if config.authType == .hockeyAppEmail {
            BITHockeyManager.shared().authenticator.authenticationSecret = config.appSecret
        }

        BITHockeyManager.shared().serverURL = config.environment.rawValue
        BITHockeyManager.shared().authenticator.modalPresentationStyle = .fullScreen
        BITHockeyManager.shared().authenticator.serverURL = config.environment.rawValue
        BITHockeyManager.shared().authenticator.webpageURL = URL(string: config.environment.rawValue)
        BITHockeyManager.shared().authenticator.restrictApplicationUsage = config.restrictApplicationUsage
        BITHockeyManager.shared().authenticator.authenticateInstallation()
        BITHockeyManager.shared().authenticator.restrictionEnforcementFrequency = .onAppActive
        
        BITHockeyManager.shared().start()
    }
}
