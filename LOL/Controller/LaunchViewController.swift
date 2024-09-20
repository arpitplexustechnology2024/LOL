//
//  LaunchViewController.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 18/09/24.
//

import UIKit
import Lottie
import FBSDKCoreKit
import UserNotifications

class LaunchViewController: UIViewController {
    
    @IBOutlet weak var loadingView: LottieAnimationView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var passedActionKey: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLoadingView()
        setupGradientBackground()
    }
    
    func setupUI() {
        let backgroundImageName = traitCollection.userInterfaceStyle == .dark ? "LaunchScreenBGDark" : "LaunchScreenBGLight"
        self.backgroundImageView.image = UIImage(named: backgroundImageName)
    }
    
    func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [
            UIColor(hex: "#FA4957").cgColor,
            UIColor(hex: "#FD7E41").cgColor
        ]
        
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setupLoadingView() {
        self.loadingView.contentMode = .scaleAspectFit
        self.loadingView.loopMode = .loop
        self.loadingView.play()
        
        Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false) { _ in
            self.loadingView.stop()
            self.loadingView.isHidden = true
            
            if let actionKey = self.passedActionKey {
                switch actionKey {
                case "MoreActionKey":
                    self.navigateToMoreAppVC()
                case "InboxActionKey":
                    self.navigateToInboxVC()
                case "SendMessageActionKey":
                    self.navigateToHomeVC()
                default:
                    self.defaultNavigation()
                }
            } else {
                self.defaultNavigation()
            }
        }
    }
    
    func defaultNavigation() {
        let isUserRegistered = UserDefaults.standard.bool(forKey: ConstantValue.is_UserRegistered)
        let identifier = isUserRegistered ? "CustomTabbarController" : "SignupViewController"
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: identifier)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToHomeVC() {
        let isUserRegistered = UserDefaults.standard.bool(forKey: ConstantValue.is_UserRegistered)
        
        if isUserRegistered {
            if let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomTabbarController") as? CustomTabbarController {
                
                if let moreAppViewController = tabBarController.viewControllers?.first(where: { $0.restorationIdentifier == "HomeViewController" }) {
                    
                    tabBarController.selectedViewController = moreAppViewController
                    self.navigationController?.pushViewController(tabBarController, animated: true)
                }
            }
        } else {
            let signupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SignupViewController")
            self.navigationController?.pushViewController(signupVC, animated: true)
        }
    }
    
    func navigateToMoreAppVC() {
        let isUserRegistered = UserDefaults.standard.bool(forKey: ConstantValue.is_UserRegistered)
        
        if isUserRegistered {
            if let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomTabbarController") as? CustomTabbarController {
                
                if let moreAppViewController = tabBarController.viewControllers?.first(where: { $0.restorationIdentifier == "MoreAppViewController" }) {
                    
                    tabBarController.selectedViewController = moreAppViewController
                    self.navigationController?.pushViewController(tabBarController, animated: true)
                }
            }
        } else {
            let signupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SignupViewController")
            self.navigationController?.pushViewController(signupVC, animated: true)
        }
    }
    
    func navigateToInboxVC() {
        let isUserRegistered = UserDefaults.standard.bool(forKey: ConstantValue.is_UserRegistered)
        
        if isUserRegistered {
            if let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomTabbarController") as? CustomTabbarController {
                
                if let inboxViewController = tabBarController.viewControllers?.first(where: { $0.restorationIdentifier == "InboxViewController" }) {
                    
                    tabBarController.selectedViewController = inboxViewController
                    self.navigationController?.pushViewController(tabBarController, animated: true)
                }
            }
        } else {
            let signupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SignupViewController")
            self.navigationController?.pushViewController(signupVC, animated: true)
        }
    }
}

