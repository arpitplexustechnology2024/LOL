//
//  SettingViewController.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 12/08/24.
//

import UIKit
import Alamofire
import TTGSnackbar
import UserNotifications

class SettingViewController: UIViewController {
    
    @IBOutlet weak var pauseView: UIView!
    @IBOutlet weak var premiumView: UIView!
    @IBOutlet weak var reviewAppView: UIView!
    @IBOutlet weak var followInstagramView: UIView!
    @IBOutlet weak var shareAppView: UIView!
    @IBOutlet weak var needHelpView: UIView!
    @IBOutlet weak var privacyPolicyView: UIView!
    @IBOutlet weak var deleteAccountView: UIView!
    @IBOutlet weak var pauseLinkSwitchButton: UISwitch!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var generalPartTitle: UILabel!
    @IBOutlet weak var pauseLabel: UILabel!
    @IBOutlet weak var premiumLabel: UILabel!
    @IBOutlet weak var communityPartTitle: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var instagramLabel: UILabel!
    @IBOutlet weak var shareAppLabel: UILabel!
    @IBOutlet weak var supportPartTitle: UILabel!
    @IBOutlet weak var helpLabel: UILabel!
    @IBOutlet weak var privacyPolicyLabel: UILabel!
    @IBOutlet weak var deleteLabel: UILabel!
    
    private var viewModel: PauseLinkViewModel!
    
    init(viewModel: PauseLinkViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.viewModel = PauseLinkViewModel(apiService: PauseLinkApiService.shared)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizeUI()
        seupViewAction()
        pauseLinkAPICall()
    }
    
    func seupViewAction() {
        let views = [pauseView, premiumView, reviewAppView, followInstagramView, shareAppView, needHelpView, privacyPolicyView, deleteAccountView]
        views.forEach { addShadow(to: $0!) }
        
        let tapGestureActions: [(UIView, Selector)] = [
            (deleteAccountView, #selector(btnDeleteTapped)),
            (premiumView, #selector(btnPremiumTapped)),
            (followInstagramView, #selector(btnFollowInstagramTapped)),
            (privacyPolicyView, #selector(btnPrivacyPolicyTapped)),
            (shareAppView, #selector(btnShareAppTapped)),
            (reviewAppView, #selector(btnWriteReviewTapped)),
            (needHelpView, #selector(btnNeedHelpTapped)),
        ]
        
        tapGestureActions.forEach { view, action in
            view.isUserInteractionEnabled = true
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: action))
        }
    }
    
    func localizeUI() {
        navigationTitle.text = NSLocalizedString("TabbarItemKey04", comment: "")
        generalPartTitle.text = NSLocalizedString("SettingPart01Key", comment: "")
        pauseLabel.text = NSLocalizedString("PauseKey", comment: "")
        premiumLabel.text = NSLocalizedString("PremiumKey", comment: "")
        communityPartTitle.text = NSLocalizedString("SettingPart02Key", comment: "")
        reviewLabel.text = NSLocalizedString("ReviewKey", comment: "")
        instagramLabel.text = NSLocalizedString("InstagramKey", comment: "")
        shareAppLabel.text = NSLocalizedString("ShareAppKey", comment: "")
        supportPartTitle.text = NSLocalizedString("SettingPart03Key", comment: "")
        helpLabel.text = NSLocalizedString("HelpKey", comment: "")
        privacyPolicyLabel.text = NSLocalizedString("PrivacyPolicyKey", comment: "")
        deleteLabel.text = NSLocalizedString("DeleteAccountKey", comment: "")
    }
    
    func pauseLinkAPICall() {
        let isSwitchOn = UserDefaults.standard.bool(forKey: ConstantValue.pauseLinkSwitchState)
        pauseLinkSwitchButton.isOn = isSwitchOn
        
        viewModel.onNoInternet = { [weak self] in
            DispatchQueue.main.async {
                self?.pauseLinkSwitchButton.isOn = !self!.pauseLinkSwitchButton.isOn
                let message = NSLocalizedString("SettingNoInternetMessage", comment: "")
                let snackbar = TTGSnackbar(message: message, duration: .middle)
                snackbar.show()
            }
        }
        
        viewModel.onCompletion = { result in
            switch result {
            case .success(let response):
                print("API call successful message: \(response.message)")
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func btnPauseLinkSwitchTapped(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: ConstantValue.pauseLinkSwitchState)
        
        guard let username = UserDefaults.standard.string(forKey: ConstantValue.user_name) else {
            print("Username not found in UserDefaults")
            return
        }
        viewModel.updatePauseLink(username: username, isPaused: sender.isOn)
    }
    
    @objc func btnDeleteTapped(_ sender: UITapGestureRecognizer){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DeleteViewController") as! DeleteViewController
        
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        
        self.present(vc, animated: true)
    }
    
    @objc func btnPremiumTapped(_ sender: UITapGestureRecognizer) {
        let isPurchased = UserDefaults.standard.bool(forKey: ConstantValue.isPurchase)
        if isPurchased {
            let customAlertVC = CustomAlertViewController()
            customAlertVC.modalPresentationStyle = .overFullScreen
            customAlertVC.modalTransitionStyle = .crossDissolve
            customAlertVC.message = NSLocalizedString("PremiumCongraMessageKey", comment: "")
            customAlertVC.link = NSLocalizedString("PremiumSuccessMessageKey", comment: "")
            customAlertVC.image = UIImage(named: "CopyLink")
            
            self.present(customAlertVC, animated: true) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    customAlertVC.animateDismissal {
                        customAlertVC.dismiss(animated: false, completion: nil)
                        self.dismiss(animated: true)
                    }
                }
            }
        } else {
            if let bottomSheetVC = storyboard?.instantiateViewController(withIdentifier: "PremiumViewController") as? PremiumViewController {
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
        }
    }
    
    @objc func btnFollowInstagramTapped(_ sender: UITapGestureRecognizer) {
        let username = "lolfuncard"
        let appURL = URL(string: "instagram://user?username=\(username)")!
        let webURL = URL(string: "https://instagram.com/\(username)")!
        
        if UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
        }
    }
    
    @objc func btnPrivacyPolicyTapped(_ sender: UITapGestureRecognizer) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "PrivacyPolicyViewController") as! PrivacyPolicyViewController
        vc.modalPresentationStyle = .pageSheet
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func btnShareAppTapped(_ sender: UITapGestureRecognizer){
        let appURL = URL(string: "https://apps.apple.com/us/app/6670788272")!
        
        let activityViewController = UIActivityViewController(activityItems: [appURL], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func btnWriteReviewTapped(_ sender: UITapGestureRecognizer){
        let appID = "6670788272"
        if let url = URL(string: "https://apps.apple.com/app/id\(appID)?action=write-review") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @objc func btnNeedHelpTapped(_ sender: UITapGestureRecognizer){
        let recipientEmail = "help@lolcards.link"
        let subject = "I need help"
        let body = "I need help with..."
        
        if let url = URL(string: "mailto:\(recipientEmail)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&body=\(body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    func addShadow(to view: UIView) {
        let isDarkMode = traitCollection.userInterfaceStyle == .dark
        view.layer.shadowColor = isDarkMode ? UIColor.white.cgColor : UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = false
    }
}

extension SettingViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

class CustomPresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        return CGRect(x: 0, y: containerView.bounds.height / 2, width: containerView.bounds.width, height: containerView.bounds.height / 2)
    }
}
