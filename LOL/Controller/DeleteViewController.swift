//
//  DeleteViewController.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 12/08/24.
//

import UIKit

class DeleteViewController: UIViewController {
    
    @IBOutlet weak var deleteTitleLabel: UILabel!
    @IBOutlet weak var deleteDescriptionLabel: UILabel!
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    private var activityIndicator: UIActivityIndicatorView!
    private let viewModel = DeleteuserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        localizeUI()
    }
    
    func setupUI() {
        deleteView.layer.cornerRadius = 16
        deleteButton.layer.cornerRadius = deleteButton.frame.height / 2
        deleteButton.applyGradient(colors: [UIColor(hex: "#FA4957"), UIColor(hex: "#FD7E41")])
        cancelButton.layer.cornerRadius = cancelButton.frame.height / 2
        cancelButton.layer.borderWidth = 1.5
        if traitCollection.userInterfaceStyle == .dark {
            cancelButton.layer.borderColor = UIColor.white.cgColor
            cancelButton.setTitleColor(.white, for: .normal)
        } else {
            cancelButton.layer.borderColor = UIColor.black.cgColor
            cancelButton.setTitleColor(.black, for: .normal)
        }
    }
    
    func localizeUI() {
        deleteTitleLabel.text = NSLocalizedString("DeleteTitleKey", comment: "")
        deleteDescriptionLabel.text = NSLocalizedString("DeleteDescriptionKey", comment: "")
        deleteButton.setTitle(NSLocalizedString("DeleteBtnKey", comment: ""), for: .normal)
        cancelButton.setTitle(NSLocalizedString("CancelBtnKey", comment: ""), for: .normal)
    }
    
    @IBAction func btnCancelTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnDeleteTapped(_ sender: UIButton) {
        let username = UserDefaults.standard.string(forKey: ConstantValue.user_name)
        
        viewModel.requestDeleteUser(username: username!) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let profile):
                    print("Delete User : \(profile.message)")
                    UserDefaults.standard.set(false, forKey: ConstantValue.is_UserRegistered)
                    UserDefaults.standard.set(false, forKey: ConstantValue.profile_Image)
                    UserDefaults.standard.set(false, forKey: ConstantValue.avatar_URL)
                    UserDefaults.standard.set(false, forKey: ConstantValue.name)
                    UserDefaults.standard.set(false, forKey: ConstantValue.isPurchase)
                    UserDefaults.standard.set(false, forKey: "SubscriptionID")
                    DispatchQueue.main.async {
                        self.dismiss(animated: true) {
                            if let window = UIApplication.shared.windows.first {
                                if let rootViewController = window.rootViewController as? UINavigationController {
                                    let signupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
                                    rootViewController.pushViewController(signupVC, animated: true)
                                }
                            }
                        }
                    }
                case .failure(let error):
                    print("Delete User error: \(error.localizedDescription)")
                }
            }
        }
    }
}
