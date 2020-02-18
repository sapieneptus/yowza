
import UIKit
import HockeySDK

class ConfigViewController: UIViewController {
    @IBOutlet var environmentControl: UISegmentedControl!
    @IBOutlet var authControl: UISegmentedControl!
    @IBOutlet var versionLabel: UILabel!
    @IBOutlet var appIdTextField: UITextField!
    @IBOutlet var appSecretTextField: UITextField!
    @IBOutlet weak var restrictAppUsageControl: UISwitch!
    
    static let AuthTypes: [BITAuthenticatorIdentificationType] = [.anonymous, .hockeyAppUser, .hockeyAppEmail, .device, .webAuth]
    static let Environments: [Config.Environment] = [.Training, .Rink]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.versionLabel.text = Config.appVersion()
        
        let config = Config.fetch()
        self.environmentControl.selectedSegmentIndex = ConfigViewController.Environments.firstIndex(of: config.environment) ?? 0
        self.appIdTextField.text = config.appId
        self.appSecretTextField.text = config.appSecret
        self.authControl.selectedSegmentIndex = ConfigViewController.AuthTypes.firstIndex(of: config.authType) ?? 0
        self.restrictAppUsageControl.isOn = config.restrictApplicationUsage
    }
    
    @IBAction func environmentChanged(_ sender: UISegmentedControl) {
        let environment = ConfigViewController.Environments[sender.selectedSegmentIndex]
        self.appIdTextField.text = Config.defaultAppId(environment: environment)
        self.appSecretTextField.text = Config.defaultAppSecret(environment: environment)
    }
    
    @IBAction func goButtonTapped(_ sender: Any) {
        let envIndex = environmentControl.selectedSegmentIndex
        let authIndex = authControl.selectedSegmentIndex

        let appId = appIdTextField.text ?? ""
        let appSecret = appSecretTextField.text ?? ""
        let env = ConfigViewController.Environments[envIndex]
        let auth = ConfigViewController.AuthTypes[authIndex]
        let restrictAppUsage = restrictAppUsageControl.isOn

        if auth != Config.fetch().authType {
            BITHockeyManager.shared().authenticator.cleanupInternalStorage()
        }
        
        Config.save(appId: appId, appSecret: appSecret, authType: auth, restrictApplicationUsage: restrictAppUsage, environment: env)
        showDetailsView()
    }

    func showDetailsView() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailsViewController")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

}

