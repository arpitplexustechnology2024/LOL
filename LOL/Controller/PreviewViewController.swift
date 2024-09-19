//
//  PreviewViewController.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 22/08/24.
//

import UIKit
import SDWebImage
import TTGSnackbar
import StoreKit

protocol PreviewViewControllerDelegate: AnyObject {
    func didDeleteItem(at indexPath: IndexPath)
    func didUpdateInbox()
}

class PreviewViewController: UIViewController {
    
    @IBOutlet weak var navigationTtitleLabel: UILabel!
    @IBOutlet weak var card_BGView: UIView!
    @IBOutlet weak var card_ImageView: UIImageView!
    @IBOutlet weak var card_ProfileImageView: UIImageView!
    @IBOutlet weak var card_textView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var showProfieButton: UIButton!
    @IBOutlet weak var instagramShareButton: UIButton!
    @IBOutlet weak var snapchatShareButton: UIButton!
    @IBOutlet weak var moreAppShareButton: UIButton!
    @IBOutlet weak var blurBGImageView: UIImageView!
    @IBOutlet weak var cardTitleBGImage: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var titleLabel01: UILabel!
    @IBOutlet weak var titleLabel02: UILabel!
    @IBOutlet weak var titleLabel03: UILabel!
    @IBOutlet weak var titleLabel04: UILabel!
    @IBOutlet weak var titleLabel05: UILabel!
    @IBOutlet weak var ansLabel01: UILabel!
    @IBOutlet weak var ansLabel02: UILabel!
    @IBOutlet weak var ansLabel03: UILabel!
    @IBOutlet weak var ansLabel04: UILabel!
    @IBOutlet weak var ansLabel05: UILabel!
    
    weak var delegate: PreviewViewControllerDelegate?
    var indexPath: IndexPath?
    var inboxData: InboxData?
    
    private var blockUserViewModel : BlockUserViewModel!
    private var deleteInboxViewModel : DeleteInboxViewModel!
    
    init(blockUserViewModel: BlockUserViewModel, deleteIndexViewModel: DeleteInboxViewModel) {
        self.blockUserViewModel = blockUserViewModel
        self.deleteInboxViewModel = deleteIndexViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.blockUserViewModel = BlockUserViewModel(apiService: BlockUserApiService.shared)
        self.deleteInboxViewModel = DeleteInboxViewModel(apiService: DeleteInboxApiService.shared)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        rateUs()
        configureWithData()
        adjustImageViewForDevice()
    }
    
    func setupUI() {
        self.card_ImageView.layer.cornerRadius = 20
        self.card_BGView.layer.cornerRadius = 20
        self.card_textView.layer.cornerRadius = 10
        self.card_BGView.layer.borderWidth = 3
        self.card_BGView.layer.borderColor = UIColor.white.cgColor
        self.card_ImageView.layer.borderWidth = 3
        self.card_ImageView.layer.borderColor = UIColor.white.cgColor
        self.showProfieButton.layer.cornerRadius = self.showProfieButton.frame.height / 2
        
    }
    
    func rateUs() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            DispatchQueue.main.async {
                SKStoreReviewController.requestReview(in: scene)
            }
        } else {
            print(" - - - - - - Rating view in not present - - - -")
        }
    }
    
    func localizeUI() {
        self.navigationTtitleLabel.text = NSLocalizedString("PreviewTitleKey", comment: "")
        self.showProfieButton.setTitle(NSLocalizedString("PreviewProfileKey", comment: ""), for: .normal)
    }
    
    func adjustImageViewForDevice() {
        var width: CGFloat = 190
        var height: CGFloat = 190
        var fontSize: CGFloat = 17
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136, 1334, 1920, 2208:
                width = 100
                height = 100
                fontSize = 10
            case 2436, 2688, 1792, 2556:
                width = 150
                height = 150
                fontSize = 13
            case 2796, 2778, 2532:
                width = 170
                height = 170
                fontSize = 15
            default:
                width = 150
                height = 150
                fontSize = 13
            }
        }
        
        card_ProfileImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            card_ProfileImageView.widthAnchor.constraint(equalToConstant: width),
            card_ProfileImageView.heightAnchor.constraint(equalToConstant: height)
        ])
        
        let titleLabels = [titleLabel01, titleLabel02, titleLabel03, titleLabel04, titleLabel05]
        for label in titleLabels {
            label?.font = UIFont(name: "Helvetica Rounded Bold", size: fontSize)
        }
        
        let answerLabels = [ansLabel01, ansLabel02, ansLabel03, ansLabel04, ansLabel05]
        for label in answerLabels {
            label?.font = UIFont(name: "Helvetica Rounded Bold", size: fontSize)
        }
    }
    
    func configureWithData() {
        guard let data = inboxData else { return }
        
        blurBGImageView.sd_setImage(with: URL(string: data.bgURL), completed: nil)
        addBlurEffect(to: blurBGImageView)
        card_ImageView.sd_setImage(with: URL(string: data.bgURL), completed: nil)
        card_ProfileImageView.sd_setImage(with: URL(string: data.avatar), completed: nil)
        
        let titles = data.selectedCardTitle.map { $0.title }
        let answers = data.selectedCardTitle.map { $0.ans }
        
        let titleLabels = [titleLabel01, titleLabel02, titleLabel03, titleLabel04, titleLabel05]
        for (index, label) in titleLabels.enumerated() {
            if index < titles.count {
                label?.text = titles[index]
            } else {
                label?.text = ""
            }
        }
        
        let answerLabels = [ansLabel01, ansLabel02, ansLabel03, ansLabel04, ansLabel05]
        for (index, label) in answerLabels.enumerated() {
            if index < answers.count {
                label?.text = ":  \(answers[index])"
            } else {
                label?.text = ""
            }
        }
        
        let imageNames = ["CardTitleBg01", "CardTitleBg02", "CardTitleBg03", "CardTitleBg04", "CardTitleBg05"]
        if let randomImageName = imageNames.randomElement() {
            cardTitleBGImage.image = UIImage(named: randomImageName)
        }
        
        let fontNames = ["BunnyFunny", "CCKillJoy Italic", "Pure Joy", "Spider Monkey_PersonalUseOnly"]
        let colors: [UIColor] = [.red, .blue, .purple, .orange]
        
        if let randomFontName = fontNames.randomElement(), let randomColor = colors.randomElement() {
            nickNameLabel.font = UIFont(name: randomFontName, size: 28)
            nickNameLabel.textColor = randomColor
        }
        
        nickNameLabel.text = data.nickname
        
        
        
        let styles: [() -> String] = [applyRoundedCorners, applyCircle]
        if let randomStyle = styles.randomElement() {
        }
    }
    
    func addBlurEffect(to imageView: UIImageView) {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = imageView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.addSubview(blurEffectView)
    }
    
    func applyRoundedCorners() -> String {
        card_ProfileImageView.layer.cornerRadius = 6
        card_ProfileImageView.layer.masksToBounds = true
        return "roundedCorners"
    }
    
    func applyCircle() -> String {
        card_ProfileImageView.layer.cornerRadius = card_ProfileImageView.frame.width / 2
        card_ProfileImageView.layer.masksToBounds = true
        return "circle"
    }
    
    @IBAction func btnBlockTapped(_ sender: UIButton) {
        let alertController = UIAlertController(
            title: "Block",
            message: "Are you sure you want to block this user?",
            preferredStyle: .alert
        )
        
        let blockAction = UIAlertAction(title: "Block", style: .destructive) { _ in
            guard let ip = self.inboxData?.ip, let indexPath = self.indexPath else { return }
            
            self.blockUserViewModel.blockUser(ip: ip) { [self] result in
                switch result {
                case .success(let blockUserResponse):
                    print("User blocked successfully: \(blockUserResponse.message)")
                    delegate?.didDeleteItem(at: indexPath)
                    self.navigationController?.popViewController(animated: true)
                    let snackbar = TTGSnackbar(message: "User blocked successfully!", duration: .middle)
                    snackbar.show()
                case .failure(let error):
                    print("Failed to block user: \(error.localizedDescription)")
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(blockAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func btnDeleteTapped(_ sender: UIButton) {
        let alertController = UIAlertController(
            title: "Delete",
            message: "Are you sure you want to delete this card?",
            preferredStyle: .alert
        )
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            guard let inboxId = self.inboxData?.id, let indexPath = self.indexPath else { return }
            
            self.deleteInboxViewModel.deleteInbox(inboxId: inboxId) { [self] result in
                switch result {
                case .success(let deleteInboxResponse):
                    print("Inbox deleted successfully: \(deleteInboxResponse.message)")
                    delegate?.didDeleteItem(at: indexPath)
                    self.navigationController?.popViewController(animated: true)
                    let snackbar = TTGSnackbar(message: "Card deleted successfully!", duration: .middle)
                    snackbar.show()
                case .failure(let error):
                    print("Failed to delete inbox: \(error.localizedDescription)")
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func btnShowProfileTapped(_ sender: UIButton) {
        let isPurchased = UserDefaults.standard.bool(forKey: ConstantValue.isPurchase)
        if isPurchased {
            if let bottomSheetVC = storyboard?.instantiateViewController(withIdentifier: "ShowProfileViewController") as? ShowProfileViewController {
                bottomSheetVC.hint = inboxData?.hint
                bottomSheetVC.location = inboxData?.location
                bottomSheetVC.country = inboxData?.country
                bottomSheetVC.time = inboxData?.time
                if #available(iOS 15.0, *) {
                    if let sheet = bottomSheetVC.sheetPresentationController {
                        sheet.detents = [.medium()]
                        sheet.prefersGrabberVisible = true
                    }
                }
                present(bottomSheetVC, animated: true, completion: nil)
            }
        } else {
            if let bottomSheetVC = storyboard?.instantiateViewController(withIdentifier: "PremiumViewController") as? PremiumViewController {
                if #available(iOS 15.0, *) {
                    if let sheet = bottomSheetVC.sheetPresentationController {
                        sheet.detents = [.medium()]
                        sheet.prefersGrabberVisible = true
                    }
                }
                present(bottomSheetVC, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func btnInstagramShareTapped(_ sender: UIButton) {
        let instagramURLScheme = URL(string: "instagram-stories://share?source_application=com.plexustechnology.LOL")!
        let instagramWebURL = URL(string: "https://www.instagram.com")!
        
        if UIApplication.shared.canOpenURL(instagramURLScheme) {
            
            let targetSize = CGSize(width: 1080, height: 1920)
            let cardBGSize = card_BGView.bounds.size
            
            let scale = min(targetSize.width / cardBGSize.width, targetSize.height / cardBGSize.height)
            let scaledCardSize = CGSize(width: cardBGSize.width * scale, height: cardBGSize.height * scale)
            
            UIGraphicsBeginImageContextWithOptions(targetSize, false, 0.0)
            
            let xOffset = (targetSize.width - scaledCardSize.width) / 2
            let yOffset = (targetSize.height - scaledCardSize.height) / 2
            card_BGView.drawHierarchy(in: CGRect(x: xOffset, y: yOffset, width: scaledCardSize.width, height: scaledCardSize.height), afterScreenUpdates: true)
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            
            if let imageData = image?.pngData() {
                let items: [String: Any] = [
                    "com.instagram.sharedSticker.backgroundImage": imageData
                ]
                
                UIPasteboard.general.setItems([items])
                UIApplication.shared.open(instagramURLScheme, options: [:], completionHandler: nil)
            }
        } else {
            UIApplication.shared.open(instagramWebURL, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func btnSnapchatShareTapped(_ sender: UIButton) {
        let snapchatURLScheme = URL(string: "snapchat://")!
        let snapchatWebURL = URL(string: "https://www.snapchat.com")!
        
        if UIApplication.shared.canOpenURL(snapchatURLScheme) {
            
            let targetSize = CGSize(width: 1080, height: 1920)
            let cardBGSize = card_BGView.bounds.size
            
            let scale = min(targetSize.width / cardBGSize.width, targetSize.height / cardBGSize.height)
            let scaledCardSize = CGSize(width: cardBGSize.width * scale, height: cardBGSize.height * scale)
            
            UIGraphicsBeginImageContextWithOptions(targetSize, false, 0.0)
            
            let xOffset = (targetSize.width - scaledCardSize.width) / 2
            let yOffset = (targetSize.height - scaledCardSize.height) / 2
            card_BGView.drawHierarchy(in: CGRect(x: xOffset, y: yOffset, width: scaledCardSize.width, height: scaledCardSize.height), afterScreenUpdates: true)
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if let image = image {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            }
            UIApplication.shared.open(snapchatURLScheme, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(snapchatWebURL, options: [:], completionHandler: nil)
        }
    }
    
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Error saving photo: \(error.localizedDescription)")
        } else {
            print("Successfully saved snapchat story Image to gallery.")
        }
    }
    
    @IBAction func btnMoreAppShareTapped(_ sender: UIButton) {
        UIGraphicsBeginImageContextWithOptions(card_BGView.bounds.size, false, 0.0)
        card_BGView.drawHierarchy(in: card_BGView.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let image = image {
            let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            activityVC.excludedActivityTypes = [.airDrop, .addToReadingList]
            
            if let popoverController = activityVC.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = sender.frame
            }
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        delegate?.didUpdateInbox()
        self.navigationController?.popViewController(animated: true)
    }
}
