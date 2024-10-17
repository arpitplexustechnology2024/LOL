//
//  CardQuestionViewController.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 08/08/24.
//

import UIKit
import Alamofire
import TTGSnackbar

class CardQuestionViewController: UIViewController {
    
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var QuestionsTitleLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var editQuestionButton: UIButton!
    @IBOutlet weak var cardQuestionCollectionView: UICollectionView!
    var selectedIndex: Int?
    var cardQuestionViewModel: CardQuestionViewModel!
    private var noDataView: NoDataView!
    private var noInternetView: NoInternetView!
    var isLoading = true
    var cardQuestion = ""
    
    init(viewModel: CardQuestionViewModel) {
        self.cardQuestionViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.cardQuestionViewModel = CardQuestionViewModel(apiService: CardQuestionApiService.shared)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        localizeUI()
        setupBindings()
        setupNoDataView()
        showSkeletonLoader()
        setupNoInternetView()
        setupGradientBackground()
        checkInternetAndFetchData()
    }
    
    func checkInternetAndFetchData() {
        if isConnectedToInternet() {
            cardQuestionViewModel.fetchCardTitles()
            noInternetView?.isHidden = true
        } else {
            showNoInternetView()
        }
    }
    
    func localizeUI() {
        navigationTitle.text = NSLocalizedString("CardQuesKey", comment: "")
        descriptionLabel.text = NSLocalizedString("CardDescriptionKey", comment: "")
        QuestionsTitleLabel.text = NSLocalizedString("FiveQuesKey", comment: "")
        shareButton.setTitle(NSLocalizedString("ShareBtnKey", comment: ""), for: .normal)
        editQuestionButton.setTitle(NSLocalizedString("EditQuesBtnKey", comment: ""), for: .normal)
    }
    
    func setupUI() {
        self.bgView.layer.masksToBounds = true
        self.bgView.layer.cornerRadius = 20
        cardQuestionCollectionView.register(SkeletonCollectionViewCell.self, forCellWithReuseIdentifier: "SkeletonCell")
        self.cardQuestionCollectionView.delegate = self
        self.cardQuestionCollectionView.dataSource = self
        // Edit Button Gradient color
        self.editQuestionButton.layer.cornerRadius = editQuestionButton.frame.height / 2
        
        // Share Button Gradient color
        self.shareButton.layer.cornerRadius = shareButton.frame.height / 2
        self.shareButton.applyGradient(colors: [UIColor(hex: "#FA4957"), UIColor(hex: "#FD7E41")])
    }
    
    func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(hex: "#FF5858").cgColor, UIColor(hex: "#FA9372").cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        gradientLayer.masksToBounds = true
        self.bgView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupNoDataView() {
        noDataView = NoDataView()
        noDataView.isHidden = true
        noDataView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(noDataView)
        
        NSLayoutConstraint.activate([
            noDataView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            noDataView.topAnchor.constraint(equalTo: navigationTitle.bottomAnchor, constant: 10),
            noDataView.leftAnchor.constraint(equalTo: view.leftAnchor),
            noDataView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
        ])
    }
    
    func setupNoInternetView() {
        noInternetView = NoInternetView()
        noInternetView.retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        noInternetView.isHidden = true
        self.view.addSubview(noInternetView)
        
        noInternetView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noInternetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noInternetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noInternetView.topAnchor.constraint(equalTo: navigationTitle.bottomAnchor, constant: 10),
            noInternetView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func retryButtonTapped() {
        if isConnectedToInternet() {
            noInternetView.isHidden = true
            noDataView.isHidden = true
            checkInternetAndFetchData()
        } else {
            let snackbar = TTGSnackbar(message: NSLocalizedString("CardNoInternetMessage", comment: ""), duration: .middle)
            snackbar.show()
        }
    }
    
    func setupBindings() {
        cardQuestionViewModel.reloadData = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.hideSkeletonLoader()
                if self.cardQuestionViewModel.cardTitles.isEmpty {
                    self.showNoDataView()
                } else {
                    self.hideNoDataView()
                    self.cardQuestionCollectionView.performBatchUpdates({
                        self.cardQuestionCollectionView.reloadSections(IndexSet(integer: 0))
                    }, completion: nil)
                }
            }
        }
        cardQuestionViewModel.showError = { [weak self] errorMessage in
            self?.showNoDataView()
        }
    }
    
    func showSkeletonLoader() {
        isLoading = true
        cardQuestionCollectionView.reloadData()
    }
    
    func hideSkeletonLoader() {
        isLoading = false
        cardQuestionCollectionView.reloadData()
    }
    
    func showNoDataView() {
        noDataView.isHidden = false
    }
    
    func hideNoDataView() {
        noDataView.isHidden = true
    }
    
    func showNoInternetView() {
        self.noInternetView.isHidden = false
    }
    
    private func isConnectedToInternet() -> Bool {
        let networkManager = NetworkReachabilityManager()
        return networkManager?.isReachable ?? false
    }
    
    @IBAction func btnEditQuestionTapped(_ sender: UIButton) {
        let isPurchased = UserDefaults.standard.bool(forKey: ConstantValue.isPurchase)
        if isPurchased {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "PurchaseEditViewController") as! PurchaseEditViewController
            vc.isSuccess = false
            vc.selectedIndex = selectedIndex
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "EditViewController") as! EditViewController
            vc.isSuccess = false
            vc.selectedIndex = selectedIndex
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnShareTapped(_ sender: UIButton) {
        if let bottomSheetVC = storyboard?.instantiateViewController(withIdentifier: "ShareViewController") as? ShareViewController {
            if UIDevice.current.userInterfaceIdiom == .pad {
                bottomSheetVC.modalPresentationStyle = .formSheet
                bottomSheetVC.preferredContentSize = CGSize(width: 540, height: 700)
            } else {
                if #available(iOS 15.0, *) {
                    
                    if let sheet = bottomSheetVC.sheetPresentationController {
                        sheet.detents = [.large() ]
                        sheet.prefersGrabberVisible = true
                    }
                } else {
                    bottomSheetVC.modalPresentationStyle = .custom
                    bottomSheetVC.transitioningDelegate = self
                }
            }
            bottomSheetVC.selectedIndex = selectedIndex
            bottomSheetVC.cardQuestion = cardQuestion
            present(bottomSheetVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "CustomTabbarController") as! CustomTabbarController
        self.navigationController?.pushViewController(vc, animated: false)
    }
}

//MARK: - cardQuestionCollectionView Delegate & DataSource & DelegateFlowLayout Method
extension CardQuestionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isLoading ? 5 : cardQuestionViewModel.cardTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isLoading {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkeletonCell", for: indexPath) as! SkeletonCollectionViewCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardQuestionCollectionViewCell", for: indexPath) as! CardQuestionCollectionViewCell
            cell.questionNoLabel.text = "\(indexPath.row + 1)."
            cell.questionLabel.text = cardQuestionViewModel.cardTitles[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
}

extension CardQuestionViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
