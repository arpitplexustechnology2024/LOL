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
    
    private let defaultAvatarURL = "https://lolcards.link/api/public/images/AvatarDefault.png"
    private var hasSelectedAvatar: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        localizeUI()
        setupKeyboardObservers()
        
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
            guard let self = self else { return }
            self.hasSelectedAvatar = true
            UserDefaults.standard.set(avatarURL, forKey: ConstantValue.avatar_URL)
            self.AvtarImageview.sd_setImage(with: URL(string: avatarURL), placeholderImage: UIImage(named: "Anonyms"))
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
            let avatar: String
            if hasSelectedAvatar {
                avatar = UserDefaults.standard.string(forKey: ConstantValue.avatar_URL) ?? defaultAvatarURL
            } else {
                avatar = defaultAvatarURL
                UserDefaults.standard.set(defaultAvatarURL, forKey: ConstantValue.avatar_URL)
            }
            
            let deviceToken = UserDefaults.standard.string(forKey: "SubscriptionID")
            
            viewModel.registerUser(name: name, avatar: avatar, username: username!, deviceToken: deviceToken!) { [weak self] result in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
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
                        self.showError(message: NSLocalizedString("RegistrationErrorKey", comment: ""))
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
    
    // MARK: - Keyboard Handling
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let keyboardHeight = keyboardFrame.height
        let textViewBottomY = nameTextfiled.convert(nameTextfiled.bounds, to: view).maxY
        let overlap = textViewBottomY - (view.frame.height - keyboardHeight)
        
        let additionalSpace: CGFloat = 50
        
        if overlap > 0 {
            UIView.animate(withDuration: 0.3) {
                self.view.frame.origin.y = -(overlap + additionalSpace)
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
