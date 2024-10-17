//
//  ShareViewController.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 09/08/24.
//

import UIKit

class ShareViewController: UIViewController {
    
    @IBOutlet weak var copyLinkview: UIView!
    @IBOutlet weak var shareLinkView: UIView!
    @IBOutlet weak var copyLinkButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var copyLinkLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var shareLabel: UILabel!
    var selectedIndex: Int?
    var cardQuestion = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        localizeUI()
        adjustForDevice()
    }
    
    func setupUI() {
        self.copyLinkview.layer.cornerRadius = 27
        self.shareLinkView.layer.cornerRadius = 27
        self.shareButton.layer.cornerRadius = self.shareButton.frame.height / 2
        self.shareButton.applyGradient(colors: [UIColor(hex: "#FA4957"), UIColor(hex: "#FD7E41")])
        self.copyLinkButton.layer.cornerRadius = self.copyLinkButton.frame.height / 2
        self.copyLinkButton.layer.borderWidth = 3
        self.copyLinkButton.layer.borderColor = UIColor.boadercolor.cgColor
        
        if let userLink = UserDefaults.standard.string(forKey: ConstantValue.is_UserLink) {
            linkLabel.text = userLink
        }
    }
    
    func localizeUI() {
        copyLinkLabel.text = NSLocalizedString("CopyLabelKey", comment: "")
        shareLabel.text = NSLocalizedString("ShareLabelKey", comment: "")
        shareButton.setTitle(NSLocalizedString("ShareBtnKey", comment: ""), for: .normal)
        copyLinkButton.setTitle(NSLocalizedString("CopyBtnKey", comment: ""), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.layer.cornerRadius = 28
        view.layer.masksToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func adjustForDevice() {
        var height: CGFloat = 190
        var shareViewHeight: CGFloat = 190
        var fontSize: CGFloat = 16
        var fontTitleSize: CGFloat = 22
        if UIDevice.current.userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136, 1334, 1920, 2208:
                fontSize = 16
                fontTitleSize = 19
                height = 140
                shareViewHeight = 230
            case 2436, 2688, 1792, 2556, 2796, 2778, 2532:
                fontSize = 20
                height = 180
                shareViewHeight = 270
            default:
                fontSize = 16
                height = 170
                shareViewHeight = 260
            }
            
            linkLabel.font = UIFont(name: "Lato-Bold", size: fontSize)
            copyLinkLabel.font = UIFont(name: "Lato-ExtraBold", size: fontTitleSize)
            shareLabel.font = UIFont(name: "Lato-ExtraBold", size: fontTitleSize)
        }
        
        copyLinkview.translatesAutoresizingMaskIntoConstraints = false
        shareLinkView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            copyLinkview.heightAnchor.constraint(equalToConstant: height),
            shareLinkView.heightAnchor.constraint(equalToConstant: shareViewHeight)
        ])
    }
    
    @IBAction func btnCopyLinkTapped(_ sender: UIButton) {
        if let link = linkLabel.text {
            UIPasteboard.general.string = link
            
            let customAlertVC = CustomAlertViewController()
            customAlertVC.modalPresentationStyle = .overFullScreen
            customAlertVC.modalTransitionStyle = .crossDissolve
            customAlertVC.message = NSLocalizedString("CopyLinkKey", comment: "")
            customAlertVC.link = link
            customAlertVC.image = UIImage(named: "CopyLink")
            
            self.present(customAlertVC, animated: true) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    customAlertVC.animateDismissal {
                        customAlertVC.dismiss(animated: false, completion: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func btnShareTapped(_ sender: UIButton) {
        if let link = linkLabel.text {
            UIPasteboard.general.string = link
            
            self.dismiss(animated: true) { [self] in
                if let window = UIApplication.shared.windows.first {
                    if let rootViewController = window.rootViewController as? UINavigationController {
                        let signupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShareLinkViewController") as! ShareLinkViewController
                        signupVC.selectedIndex = selectedIndex
                        signupVC.linkLabel = "lolcards.link/arpit"
                        signupVC.modalTransitionStyle = .crossDissolve
                        signupVC.modalPresentationStyle = .overCurrentContext
                        rootViewController.present(signupVC, animated: true)
                    }
                }
            }
        }
    }
    
    @IBAction func btnOtherShareTapped(_ sender: UIButton) {
        
        if let link = linkLabel.text {
            
            let newLink = "https://\(link)"
            let sharingTxt = "Hey there! 😄 Are you ready for a challenge? Create an anonymous card for me by answering this question! 🎉 \(NSLocalizedString(cardQuestion, comment: ""))! 🤔\n Tap the link below and show off your creativity! \n👉 \(newLink)"
            
            let activityVC = UIActivityViewController(activityItems: [sharingTxt], applicationActivities: nil)
            
            if let popoverController = activityVC.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = sender.frame
            }
            
            self.present(activityVC, animated: true)
        }
    }
}
