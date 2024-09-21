//
//  ShareLinkViewController.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 13/08/24.
//

import UIKit
import TTGSnackbar

class ShareLinkViewController: UIViewController {
    
    @IBOutlet weak var Insta_Snap_segmentView: UIView!
    @IBOutlet var Insta_Snap_segmentController: GradientSegmentedControl!
    @IBOutlet weak var ShareLinkPopup: UIView!
    @IBOutlet weak var ShareLinkLabel: UILabel!
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var gifView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var linkLabel: String?
    private var blurEffectView: UIVisualEffectView!
    private var instagramViews: [UIView] = []
    private var snapchatViews: [UIView] = []
    private var currentPage = 0
    var selectedIndex: Int?
    private let stackView = UIStackView()
    private var numberLabels: [UILabel] = []
    private var pageNumbers = ["1", "2", "3", "4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        localizeUI()
        setupSegment()
        setupGifView()
        setupBlurEffect()
        setupPageControl()
        setupGradientBackground()
        
        updateSelectedPage(0)
    }
    
    private func setupBlurEffect() {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurEffectView, at: 0)
    }
    
    func localizeUI() {
        ShareLinkLabel.text = NSLocalizedString("ShareLinkLabelKey", comment: "")
    }
    
    func setupUI() {
        self.textView.layer.cornerRadius = 24
        self.textView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.textView.layer.masksToBounds = true
        self.ShareLinkPopup.layer.cornerRadius = 24
        self.nextButton.layer.cornerRadius = nextButton.frame.height / 2
        self.nextButton.frame = CGRect(x: (view.frame.width - 159) / 2, y: view.center.y - 20, width: 159, height: 45)
        self.nextButton.applyGradient(colors: [UIColor(hex: "#FA4957"), UIColor(hex: "#FD7E41")])
        if traitCollection.userInterfaceStyle == .dark {
            self.cancelButton.layer.cornerRadius = cancelButton.frame.height / 2
            self.cancelButton.layer.borderWidth = 1.5
            self.cancelButton.layer.borderColor = UIColor.white.cgColor
            self.cancelButton.setTitleColor(.white, for: .normal)
        } else {
            self.cancelButton.layer.cornerRadius = cancelButton.frame.height / 2
            self.cancelButton.layer.borderWidth = 1.5
            self.cancelButton.layer.borderColor = UIColor.black.cgColor
            self.cancelButton.setTitleColor(.black, for: .normal)
        }
    }
    
    private func setupGifView() {
        let instagram01 = Instagram01()
        let instagram02 = Instagram02()
        let instagram03 = Instagram03()
        let instagram04 = Instagram04()
        instagramViews = [instagram01, instagram02, instagram03, instagram04]
        
        let snapchat01 = Snapchat01()
        let snapchat02 = Snapchat02()
        let snapchat03 = Snapchat03()
        let snapchat04 = Snapchat04()
        let snapchat05 = Snapchat05()
        snapchatViews = [snapchat01, snapchat02, snapchat03, snapchat04, snapchat05]
        
        updateGifView(for: currentPage, isInstagram: true)
    }
    
    func setupPageControl() {
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 15),
            stackView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        updatePageControlLabels()
    }
    
    private func updatePageControlLabels() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        numberLabels.removeAll()
        
        let isInstagram = Insta_Snap_segmentController.selectedSegmentIndex == 0
        pageNumbers = isInstagram ? ["1", "2", "3", "4"] : ["1", "2", "3", "4", "5"]
        
        for (index, number) in pageNumbers.enumerated() {
            let label = UILabel()
            label.text = number
            label.textAlignment = .center
            label.font = UIFont(name: "Lato-ExtraBold", size: 16)
            label.textColor = .black
            label.backgroundColor = .customGray
            label.layer.cornerRadius = 20
            label.layer.masksToBounds = true
            label.translatesAutoresizingMaskIntoConstraints = false
            
            label.widthAnchor.constraint(equalToConstant: 40).isActive = true
            label.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handlePageControlTap(_:)))
            label.isUserInteractionEnabled = true
            label.tag = index
            label.addGestureRecognizer(tapGesture)
            
            numberLabels.append(label)
            stackView.addArrangedSubview(label)
        }
    }
    
    private func updateGifView(for index: Int, isInstagram: Bool) {
        gifView.subviews.forEach { $0.removeFromSuperview() }
        let viewsToUse = isInstagram ? instagramViews : snapchatViews
        let viewToAdd = viewsToUse[index]
        gifView.addSubview(viewToAdd)
        viewToAdd.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewToAdd.topAnchor.constraint(equalTo: gifView.topAnchor),
            viewToAdd.leadingAnchor.constraint(equalTo: gifView.leadingAnchor),
            viewToAdd.trailingAnchor.constraint(equalTo: gifView.trailingAnchor),
            viewToAdd.bottomAnchor.constraint(equalTo: gifView.bottomAnchor)
        ])
    }
    
    func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [
            UIColor(hex: "#FD7E41").cgColor,
            UIColor(hex: "#FA4957").cgColor
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = self.view.bounds
        gradientLayer.masksToBounds = true
        self.textView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setupSegment() {
        let items = ["Instagram", "Snapchat"]
        Insta_Snap_segmentController = GradientSegmentedControl(items: items)
        Insta_Snap_segmentController.setImage(UIImage(named: "instagram_icon"), forSegmentAt: 0)
        Insta_Snap_segmentController.setImage(UIImage(named: "snapchat_icon"), forSegmentAt: 1)
        
        Insta_Snap_segmentController.backgroundColor = .lightGray
        Insta_Snap_segmentController.selectedSegmentTintColor = .clear
        Insta_Snap_segmentController.selectedSegmentIndex = 0
        
        Insta_Snap_segmentView.layer.cornerRadius = Insta_Snap_segmentView.frame.height / 2
        Insta_Snap_segmentView.layer.masksToBounds = true
        Insta_Snap_segmentView.layer.borderWidth = 1
        Insta_Snap_segmentView.layer.borderColor = UIColor.lightGray.cgColor
        
        Insta_Snap_segmentView.addSubview(Insta_Snap_segmentController)
        
        Insta_Snap_segmentController.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        
        Insta_Snap_segmentController.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            Insta_Snap_segmentController.leadingAnchor.constraint(equalTo: Insta_Snap_segmentView.leadingAnchor),
            Insta_Snap_segmentController.trailingAnchor.constraint(equalTo: Insta_Snap_segmentView.trailingAnchor),
            Insta_Snap_segmentController.topAnchor.constraint(equalTo: Insta_Snap_segmentView.topAnchor),
            Insta_Snap_segmentController.bottomAnchor.constraint(equalTo: Insta_Snap_segmentView.bottomAnchor)
        ])
    }
    
    @objc private func segmentChanged(_ sender: GradientSegmentedControl) {
        let isInstagram = sender.selectedSegmentIndex == 0
        currentPage = 0
        updateGifView(for: currentPage, isInstagram: isInstagram)
        updatePageControlLabels()
        updateSelectedPage(currentPage)
    }
    
    @objc private func handlePageControlTap(_ sender: UITapGestureRecognizer) {
        if let label = sender.view as? UILabel {
            let pageIndex = label.tag
            currentPage = pageIndex
            let isInstagram = Insta_Snap_segmentController.selectedSegmentIndex == 0
            updateGifView(for: pageIndex, isInstagram: isInstagram)
            updateSelectedPage(pageIndex)
        }
    }
    
    @IBAction func btnNextTapped(_ sender: UIButton) {
        let isInstagram = Insta_Snap_segmentController.selectedSegmentIndex == 0
        let maxPage = isInstagram ? instagramViews.count - 1 : snapchatViews.count - 1
        
        if currentPage < maxPage {
            currentPage += 1
        } else {
            if isInstagram {
                shareInstagramStory()
            } else {
                shareToSnapchat()
            }
            return
        }
        updateGifView(for: currentPage, isInstagram: isInstagram)
        updateSelectedPage(currentPage)
    }
    
    private func shareInstagramStory() {
        guard let selectedIndex = selectedIndex else { return }
        
        if let urlScheme = URL(string: "instagram-stories://share?source_application=com.fun.lol.card") {
            if UIApplication.shared.canOpenURL(urlScheme) {
                
                let screenSize = UIScreen.main.bounds.size
                let targetAspectRatio: CGFloat = 9.0 / 16.0
                let screenAspectRatio = screenSize.width / screenSize.height
                
                var targetSize: CGSize
                
                if screenAspectRatio > targetAspectRatio {
                    targetSize = CGSize(width: screenSize.height * targetAspectRatio, height: screenSize.height)
                } else {
                    targetSize = CGSize(width: screenSize.width, height: screenSize.width / targetAspectRatio)
                }
                
                let shareView: UIView
                switch selectedIndex {
                case 0:
                    shareView = ShareView01(frame: CGRect(origin: .zero, size: targetSize))
                case 1:
                    shareView = ShareView02(frame: CGRect(origin: .zero, size: targetSize))
                case 2:
                    shareView = ShareView03(frame: CGRect(origin: .zero, size: targetSize))
                case 3:
                    shareView = ShareView04(frame: CGRect(origin: .zero, size: targetSize))
                case 4:
                    shareView = ShareView05(frame: CGRect(origin: .zero, size: targetSize))
                case 5:
                    shareView = ShareView06(frame: CGRect(origin: .zero, size: targetSize))
                case 6:
                    shareView = ShareView07(frame: CGRect(origin: .zero, size: targetSize))
                default:
                    shareView = ShareView01(frame: CGRect(origin: .zero, size: targetSize))
                }
                
                shareView.center = CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)
                shareView.layoutIfNeeded()
                UIGraphicsBeginImageContextWithOptions(targetSize, false, UIScreen.main.scale)
                guard let context = UIGraphicsGetCurrentContext() else { return }
                shareView.layer.render(in: context)
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                if let imageData = image?.pngData() {
                    let items: [String: Any] = [
                        "com.instagram.sharedSticker.backgroundImage": imageData
                    ]
                    let snackbar = TTGSnackbar(message: linkLabel!, duration: .middle)
                    snackbar.show()
                    UIPasteboard.general.string = linkLabel
                    UIPasteboard.general.setItems([items])
                    UIApplication.shared.open(urlScheme, options: [:], completionHandler: nil)
                }
                self.dismiss(animated: true)
            } else {
                let snackbar = TTGSnackbar(message: NSLocalizedString("InstagramSnackbarError", comment: ""), duration: .middle)
                snackbar.show()
            }
        }
    }
    
    private func shareToSnapchat() {
        
        guard let selectedIndex = selectedIndex else { return }
        
        let snapchatURL = URL(string: "snapchat://")
        if let url = snapchatURL, UIApplication.shared.canOpenURL(url) {
            
            let shareView: UIView
            switch selectedIndex {
            case 0:
                shareView = ShareView01(frame: view.bounds)
            case 1:
                shareView = ShareView02(frame: view.bounds)
            case 2:
                shareView = ShareView03(frame: view.bounds)
            case 3:
                shareView = ShareView04(frame: view.bounds)
            case 4:
                shareView = ShareView05(frame: view.bounds)
            case 5:
                shareView = ShareView06(frame: view.bounds)
            case 6:
                shareView = ShareView07(frame: view.bounds)
            default:
                shareView = ShareView01(frame: view.bounds)
            }
            UIGraphicsBeginImageContextWithOptions(shareView.bounds.size, false, 0)
            shareView.layer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if let image = image {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            self.dismiss(animated: true)
        } else {
            let snackbar = TTGSnackbar(message: NSLocalizedString("SnapchatSnackbarError", comment: ""), duration: .middle)
            snackbar.show()
        }
    }
    
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Error saving photo: \(error.localizedDescription)")
        } else {
            print("Successfully saved snapchat story Image to gallery.")
        }
    }
    
    private func updateSelectedPage(_ pageIndex: Int) {
        numberLabels.enumerated().forEach { (index, label) in
            if index == pageIndex {
                label.backgroundColor = UIColor(red: 252/255, green: 103/255, blue: 74/255, alpha: 1)
                label.textColor = .white
            } else {
                label.backgroundColor = .customGray
                label.textColor = .black
            }
        }
    }
    
    @IBAction func btnCancelTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

