
import UIKit
import HockeySDK

class ConfigViewController: UIViewController {
    @IBOutlet var environmentControl: UISegmentedControl!
    @IBOutlet var authControl: UISegmentedControl!
    @IBOutlet var restrictAppUsageControl: UISegmentedControl!
    @IBOutlet var versionLabel: UILabel!

    static let AuthTypes: [BITAuthenticatorIdentificationType] = [.anonymous, .hockeyAppUser, .hockeyAppEmail, .device, .webAuth]
    static let Environments: [Config.Environment] = [.Training, .Rink]
    static let RestrictAppUsageOptions: [Bool] = [false, true]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.versionLabel.text = Config.appVersion()
    }

    override func viewDidAppear(_ animated: Bool) {
        if Config.exists() {
            showDetailsView()
        }
    }

    @IBAction func go(_ sender: Any) {
        let envIndex = environmentControl.selectedSegmentIndex
        let authIndex = authControl.selectedSegmentIndex
        let restrictAppUsageIndex = restrictAppUsageControl.selectedSegmentIndex

        let env = ConfigViewController.Environments[envIndex]
        let auth = ConfigViewController.AuthTypes[authIndex]
        let restrictAppUsage = ConfigViewController.RestrictAppUsageOptions[restrictAppUsageIndex]

        Config.save(authType: auth, restrictApplicationUsage: restrictAppUsage, environment: env)
        showDetailsView()
    }

    func showDetailsView() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailsViewController")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

