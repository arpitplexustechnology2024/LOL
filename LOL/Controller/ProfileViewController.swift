//
//  ProfileViewController.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 31/07/24.
//

import UIKit
import TTGSnackbar
import SDWebImage
import Alamofire
import Contacts

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var AvtarImageview: UIImageView!
    @IBOutlet weak var nameTextfiled: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var selectAvtarLabel: UILabel!
    @IBOutlet weak var letsgoButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    private var activityIndicator: UIActivityIndicatorView!
    private let viewModel = RegisterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        localizeUI()
    }
    
    func setupUI() {
        
        // Avatar Image View
        self.AvtarImageview.layer.cornerRadius = AvtarImageview.frame.height / 2
        self.AvtarImageview.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectAvtarTapped(_:)))
        self.AvtarImageview.addGestureRecognizer(tapGestureRecognizer)
        
        // Let's Go button Gradient Color
        self.letsgoButton.layer.cornerRadius = letsgoButton.frame.height / 2
        self.letsgoButton.applyGradient(colors: [UIColor(hex: "#FA4957"), UIColor(hex: "#FD7E41")])
        
        // Error label
        self.errorLabel.isHidden = true
        self.errorLabel.alpha = 0
        
        // Name TextField
        self.nameTextfiled.returnKeyType = .done
        self.nameTextfiled.delegate = self
        self.hideKeyboardTappedAround()
        if traitCollection.userInterfaceStyle == .dark {
            self.nameTextfiled.layer.borderWidth = 1.5
            self.nameTextfiled.layer.cornerRadius = 5
            self.nameTextfiled.layer.borderColor = UIColor.white.cgColor
        } else {
            self.nameTextfiled.layer.borderWidth = 1.5
            self.nameTextfiled.layer.cornerRadius = 5
            self.nameTextfiled.layer.borderColor = UIColor.black.cgColor
        }
        
        // Activity Indicator Setup
        self.activityIndicator = UIActivityIndicatorView(style: .medium)
        self.activityIndicator.color = .white
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.activityIndicator.hidesWhenStopped = true
        self.letsgoButton.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: letsgoButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: letsgoButton.centerYAnchor)
        ])
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.getAndStoreOneSignalPlayerId()
        }
    }
    
    func localizeUI() {
        self.profileLabel.text = NSLocalizedString("ProfileTitleKey", comment: "")
        self.selectAvtarLabel.text = NSLocalizedString("ProfileSelectAvtarKey", comment: "")
        self.nameTextfiled.placeholder = NSLocalizedString("ProfileNameKey", comment: "")
        self.letsgoButton.setTitle(NSLocalizedString("ProfileLetsgoBtnKey", comment: ""), for: .normal)
    }
    
    // MARK: - Avatar Select
    @objc func selectAvtarTapped(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let bottomSheetVC = storyboard.instantiateViewController(withIdentifier: "AvtarBottomViewController") as! AvtarBottomViewController
        
        bottomSheetVC.onAvatarSelected = { [weak self] avatarURL in
            UserDefaults.standard.set(avatarURL, forKey: ConstantValue.avatar_URL)
            print(avatarURL)
            
            self?.AvtarImageview.sd_setImage(with: URL(string: avatarURL), placeholderImage: UIImage(named: "Anonyms"))
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            bottomSheetVC.modalPresentationStyle = .formSheet
            bottomSheetVC.preferredContentSize = CGSize(width: 540, height: 540)
        } else {
            if #available(iOS 15.0, *) {
                if let sheet = bottomSheetVC.sheetPresentationController {
                    sheet.detents = [.medium()]
                    sheet.prefersGrabberVisible = true
                }
            } else {
                bottomSheetVC.modalPresentationStyle = .custom
                bottomSheetVC.transitioningDelegate = self
            }
        }
        present(bottomSheetVC, animated: true, completion: nil)
    }
    
    private func isConnectedToInternet() -> Bool {
        let networkManager = NetworkReachabilityManager()
        return networkManager?.isReachable ?? false
    }
    
    // MARK: - Let'sgo Button
    @IBAction func btnLetsgoTapped(_ sender: UIButton) {
        if isConnectedToInternet() {
            letsgoButton.setTitle("", for: .normal)
            activityIndicator.startAnimating()
            self.errorLabel.isHidden = true
            guard let name = nameTextfiled.text, !name.isEmpty else {
                showError(message: NSLocalizedString("ProfileErrorKey", comment: ""))
                self.activityIndicator.stopAnimating()
                self.letsgoButton.setTitle(NSLocalizedString("ProfileLetsgoBtnKey", comment: ""), for: .normal)
                return
            }
            UserDefaults.standard.set(name, forKey: ConstantValue.name)
            let username = UserDefaults.standard.string(forKey: ConstantValue.user_name)
            let defaultAvatar = "https://lolcards.link/api/public/images/AvatarDefault.png"
            let avatar = UserDefaults.standard.string(forKey: ConstantValue.avatar_URL) ?? defaultAvatar
            let deviceToken = UserDefaults.standard.string(forKey: "SubscriptionID")
            
            
            viewModel.registerUser(name: nameTextfiled.text!, avatar: avatar, username: username!, deviceToken: deviceToken!) { [weak self] result in
                guard let self = self else { return }
                
                DispatchQueue.main.async { [self] in
                    self.activityIndicator.stopAnimating()
                    self.letsgoButton.setTitle(NSLocalizedString("ProfileLetsgoBtnKey", comment: ""), for: .normal)
                    
                    switch result {
                    case .success(let profile):
                        print("Registration : \(profile.data)")
                        UserDefaults.standard.set(true, forKey: ConstantValue.is_UserRegistered)
                        UserDefaults.standard.set(profile.data.link, forKey: ConstantValue.is_UserLink)
                        self.navigateToTabbarViewcontroller()
                    case .failure(let error):
                        print("Registration error: \(error.localizedDescription)")
                    }
                }
            }
        } else {
            let snackbar = TTGSnackbar(message: NSLocalizedString("AvatarNoInternetMessage", comment: ""), duration: .middle)
            snackbar.show()
        }
    }
    
    func navigateToTabbarViewcontroller() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "CustomTabbarController") as! CustomTabbarController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showError(message: String) {
        self.errorLabel.text = message
        self.errorLabel.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.errorLabel.alpha = 1
        })
    }
    
    //MARK: - Back Button
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - TextField Delegate Method
extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ProfileViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
