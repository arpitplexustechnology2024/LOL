//
//  PremiumViewController.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 21/08/24.
//

import UIKit
import StoreKit
import TTGSnackbar
import Alamofire

class PremiumViewController: UIViewController, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var unlockButton: UIButton!
    @IBOutlet weak var proFeaturesLabel: UILabel!
    @IBOutlet weak var restoreButton: UILabel!
    @IBOutlet weak var proView: UIView!
    @IBOutlet weak var proLabel: UILabel!
    @IBOutlet weak var privacyPolicyButton: UILabel!
    @IBOutlet weak var privacyPolicyBottomConstraint: NSLayoutConstraint!
    
    let productID = "com.lol.anonymousfeatures"
    
    private var premiumSlider: [PremiumModel] = []
    private var currentPage = 0 {
        didSet {
            updateCurrentPage()
        }
    }
    
    private var product: SKProduct?
    private var isRestoringPurchases = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.layer.cornerRadius = 28
        view.layer.masksToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private var viewModel: PurchaseViewModel!
    
    init(viewModel: PurchaseViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.viewModel = PurchaseViewModel(apiService: PurchaseApiService.shared)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        adjustForDevice()
        fetchProductInfo()
        privacyPolicyButton.isUserInteractionEnabled = true
        let tapGestureRecognize = UITapGestureRecognizer(target: self, action: #selector(privacyPolicyTapped(_:)))
        self.privacyPolicyButton.addGestureRecognizer(tapGestureRecognize)
        self.unlockButton.layer.cornerRadius = self.unlockButton.frame.height / 2
        self.unlockButton.applyGradient(colors: [UIColor(hex: "#FA4957"), UIColor(hex: "#FD7E41")])
        restoreButton.text = NSLocalizedString("RestorePurchaseKey", comment: "")
        restoreButton.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(btnRestoreTapped(_:)))
        self.restoreButton.addGestureRecognizer(tapGestureRecognizer)
        self.proView.layer.masksToBounds = true
        self.proView.layer.cornerRadius = 4
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(hex: "#FA4957").cgColor,
            UIColor(hex: "#FD7E41").cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = proView.bounds
        proView.layer.insertSublayer(gradientLayer, at: 0)
        unlockButton.setTitle(NSLocalizedString("UnlockBtnKey", comment: ""), for: .normal)
        SKPaymentQueue.default().add(self)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            privacyPolicyBottomConstraint.constant = 16
        }
    }
    
    // MARK: - Privacy Policy URL Open
    @objc func privacyPolicyTapped(_ sender: UITapGestureRecognizer) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "PrivacyPolicyViewController") as! PrivacyPolicyViewController
        vc.modalPresentationStyle = .pageSheet
        self.present(vc, animated: true, completion: nil)
    }
    
    private func setupUI() {
        premiumSlider = [
            PremiumModel(id: 1, title: "Reveal Sender Info",
                         description: "Get hints like their location, country and time...",
                         image: UIImage(named: "Premium_first")!),
            PremiumModel(id: 2, title: "Viewers Hints",
                         description: "Get some funny hint who creates your funny card?",
                         image: UIImage(named: "Premium_Third")!),
            PremiumModel(id: 3, title: "Edit Card Questions",
                         description: "You can edit the card's questions when you ask questions to create a card!",
                         image: UIImage(named: "Premium_Second")!)
        ]
        
        pageControl.numberOfPages = premiumSlider.count
    }
    
    private func updateCurrentPage() {
        pageControl.currentPage = currentPage
    }
    
    private func isConnectedToInternet() -> Bool {
        let networkManager = NetworkReachabilityManager()
        return networkManager?.isReachable ?? false
    }
    
    private func fetchProductInfo() {
        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest(productIdentifiers: Set([productID]))
            request.delegate = self
            request.start()
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if let product = response.products.first {
            self.product = product
            DispatchQueue.main.async {
                self.updateProFeaturesLabel()
            }
        }
    }
    
    private func updateProFeaturesLabel() {
        if let product = self.product {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .currency
            numberFormatter.locale = product.priceLocale
            if let formattedPrice = numberFormatter.string(from: product.price) {
                let localizedFormat = NSLocalizedString("PremiumFeaturesKey", comment: "Format string for pro features with price for lifetime")
                let attributedString = NSMutableAttributedString(string: String(format: localizedFormat, formattedPrice))
                if let range = attributedString.string.range(of: formattedPrice) {
                    let nsRange = NSRange(range, in: attributedString.string)
                    attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: nsRange)
                }
                self.proFeaturesLabel.attributedText = attributedString
            }
        }
    }
    
    // MARK: - Purchase Restore
    @objc func btnRestoreTapped(_ sender: UITapGestureRecognizer) {
        if !isConnectedToInternet() {
            let snackbar = TTGSnackbar(message: NSLocalizedString("PremiumNoInternetMessage", comment: ""), duration: .middle)
            snackbar.show()
            return
        }
        
        isRestoringPurchases = true
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    // MARK: - Purchase Premium Features
    @IBAction func btnUnlockTapped(_ sender: UIButton) {
        if !isConnectedToInternet() {
            let snackbar = TTGSnackbar(message: NSLocalizedString("PremiumNoInternetMessage", comment: ""), duration: .middle)
            snackbar.show()
            return
        }
        if SKPaymentQueue.canMakePayments() {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productID
            SKPaymentQueue.default().add(paymentRequest)
        } else {
            print("User unable to make payments")
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if transaction.transactionState == .purchased {
                print("Purchase Successfully")
                SKPaymentQueue.default().finishTransaction(transaction)
                showPremiumSuccessAlert()
                
            } else if transaction.transactionState == .failed {
                print("Purchase or Restore Failed")
                SKPaymentQueue.default().finishTransaction(transaction)
                handleFailedPurchaseOrRestore(transaction: transaction)
                
            } else if transaction.transactionState == .restored {
                print("Restore Successful")
                SKPaymentQueue.default().finishTransaction(transaction)
                handleSuccessfulRestore(transaction: transaction)
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        isRestoringPurchases = false
        if queue.transactions.isEmpty {
            let snackbar = TTGSnackbar(message: NSLocalizedString("NoPreviousPurchaseMessage", comment: ""), duration: .middle)
            snackbar.show()
            self.dismiss(animated: true)
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        isRestoringPurchases = false
        showFailureAlert()
    }
    
    private func handleSuccessfulRestore(transaction: SKPaymentTransaction) {
        if isRestoringPurchases {
            showPremiumSuccessAlert()
        }
    }
    
    private func handleFailedPurchaseOrRestore(transaction: SKPaymentTransaction) {
        if isRestoringPurchases {
            showFailureAlert()
        } else {
            showFailureAlert()
        }
    }
    
    // MARK: - Show Premium Successfully Alert
    private func showPremiumSuccessAlert() {
        DispatchQueue.main.async { [self] in
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
            viewModel.updatePurchase { result in
                switch result {
                case .success(_):
                    print("You have purchased successfully!")
                case .failure(let error):
                    print("Error : \(error.localizedDescription)")
                }
            }
            UserDefaults.standard.set(true, forKey: ConstantValue.isPurchase)
        }
    }
    
    // MARK: - Show Failed Alert
    private func showFailureAlert() {
        DispatchQueue.main.async {
            let customAlertVC = AlertViewController()
            customAlertVC.modalPresentationStyle = .overFullScreen
            customAlertVC.modalTransitionStyle = .crossDissolve
            customAlertVC.message = NSLocalizedString("PremiumFailedMessageKey", comment: "")
            customAlertVC.link = NSLocalizedString("PremiumFailedPaymentKey", comment: "")
            customAlertVC.image = UIImage(named: "PurchaseFailed")
            
            self.present(customAlertVC, animated: true) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    customAlertVC.animateDismissal {
                        customAlertVC.dismiss(animated: false, completion: nil)
                        self.dismiss(animated: true)
                    }
                }
            }
        }
    }
    
//    private func moveToNext() {
//        if currentPage < premiumSlider.count - 1 {
//            currentPage += 1
//        } else {
//            currentPage = 0
//        }
//        let indexPath = IndexPath(item: currentPage, section: 0)
//        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//    }
    
    func adjustForDevice() {
        var height: CGFloat = 245
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136, 1334, 1920, 2208:
                height = 185
            case 2436, 1792, 2556, 2532:
                height = 245
            case 2796, 2778, 2688:
                height = 300
            default:
                height = 235
            }
        }
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalToConstant: height)
        ])
    }
}

//MARK: - UICollectionView DataSource
extension PremiumViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return premiumSlider.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PremiumCollectionViewCell", for: indexPath) as! PremiumCollectionViewCell
        cell.setupCell(premiumSlider[indexPath.row])
        return cell
    }
}

////MARK: - UICollectionView Delegates
//extension PremiumViewController: UICollectionViewDelegate {
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let width = scrollView.frame.width
//        currentPage = Int(scrollView.contentOffset.x / width)
//    }
//}

//MARK: - UICollectionView Delegate FlowLayout
extension PremiumViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
