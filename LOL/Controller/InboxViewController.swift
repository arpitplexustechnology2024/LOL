//
//  InboxViewController.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 09/08/24.
//

import UIKit
import Alamofire
import TTGSnackbar

class InboxViewController: UIViewController, PreviewViewControllerDelegate {
    
    @IBOutlet weak var navigationLabel: UILabel!
    
    @IBOutlet weak var senderButton: UIButton!
    @IBOutlet weak var EditQuestionButton: UIButton!
    @IBOutlet weak var InboxCollectionView: UICollectionView!
    private var noDataView: InboxView!
    private var noInternetView: NoInternetView!
    var isLoading = true
    private var inboxViewModel: InboxViewModel!
    private let refreshControl = UIRefreshControl()
    
    init(viewModel: InboxViewModel) {
        self.inboxViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.inboxViewModel = InboxViewModel(apiService: InboxApiService.shared)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        localizeUI()
        setupBindings()
        setupNoDataView()
        showSkeletonLoader()
        setupNoInternetView()
        checkInternetAndFetchData()
    }
    
    func checkInternetAndFetchData() {
        if isConnectedToInternet() {
            inboxViewModel.fetchCardTitles()
            noInternetView?.isHidden = true
        } else {
            showNoInternetView()
        }
    }
    
    func setupUI() {
        self.InboxCollectionView.dataSource = self
        self.InboxCollectionView.delegate = self
        self.senderButton.isHidden = true
        self.senderButton.layer.cornerRadius = senderButton.layer.frame.height / 2
        self.InboxCollectionView.register(SkeletonInboxCollectionViewCell.self, forCellWithReuseIdentifier: "SkeletonCell")
        self.InboxCollectionView.refreshControl = refreshControl
        self.refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    func localizeUI() {
        navigationLabel.text = NSLocalizedString("TabbarItemKey02", comment: "")
    }
    
    func setupBindings() {
        inboxViewModel.reloadData = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.hideSkeletonLoader()
                if self.inboxViewModel.inboxData.isEmpty {
                    self.showNoDataView()
                } else {
                    let isPurchased = UserDefaults.standard.bool(forKey: ConstantValue.isPurchase)
                    if isPurchased {
                        self.senderButton.isHidden = true
                    } else {
                        self.senderButton.isHidden = false
                    }
                    self.hideNoDataView()
                    UIView.animate(withDuration: 0.3, animations: {
                        self.InboxCollectionView.performBatchUpdates({
                            self.InboxCollectionView.reloadSections(IndexSet(integer: 0))
                        }, completion: nil)
                    })
                }
            }
        }
        inboxViewModel.showError = { [weak self] errorMessage in
            self?.showNoDataView()
            self?.InboxCollectionView.isHidden = true
        }
    }
    
    @objc private func refreshData() {
        if isConnectedToInternet() {
            inboxViewModel.fetchCardTitles()
            noInternetView?.isHidden = true
        } else {
            showNoInternetView()
        }
        refreshControl.endRefreshing()
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
            noInternetView.topAnchor.constraint(equalTo: navigationLabel.bottomAnchor, constant: 10),
            noInternetView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func retryButtonTapped() {
        if isConnectedToInternet() {
            noInternetView.isHidden = true
            noDataView.isHidden = true
            checkInternetAndFetchData()
        } else {
            let snackbar = TTGSnackbar(message: NSLocalizedString("InboxNoInternetMessage", comment: ""), duration: .middle)
            snackbar.show()
        }
    }
    
    func showSkeletonLoader() {
        isLoading = true
        InboxCollectionView.reloadData()
    }
    
    func hideSkeletonLoader() {
        isLoading = false
        InboxCollectionView.reloadData()
    }
    
    func showNoInternetView() {
        self.noInternetView.isHidden = false
        self.noDataView.isHidden = true
    }
    
    private func isConnectedToInternet() -> Bool {
        let networkManager = NetworkReachabilityManager()
        return networkManager?.isReachable ?? false
    }
    
    func showNoDataView() {
        noDataView.isHidden = false
    }
    
    func hideNoDataView() {
        noDataView.isHidden = true
    }
    
    private func setupNoDataView() {
        noDataView = InboxView()
        noDataView.isHidden = true
        noDataView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(noDataView)
        
        NSLayoutConstraint.activate([
            noDataView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            noDataView.topAnchor.constraint(equalTo: navigationLabel.bottomAnchor, constant: 10),
            noDataView.leftAnchor.constraint(equalTo: view.leftAnchor),
            noDataView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
        ])
        noDataView.senderButton.addTarget(self, action: #selector(btnGetMessageTapped), for: .touchUpInside)
    }
    
    @objc func btnGetMessageTapped() {
        if let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomTabbarController") as? CustomTabbarController {
            if let homeViewController = tabBarController.viewControllers?.first(where: { $0.restorationIdentifier == "HomeViewController" }) {
                tabBarController.selectedViewController = homeViewController
                self.navigationController?.pushViewController(tabBarController, animated: true)
            }
        }
    }
    
    @IBAction func btnSenderTapped(_ sender: UIButton) {
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
    
    @IBAction func btnEditQuestionTapped(_ sender: UIButton) {
        let isPurchased = UserDefaults.standard.bool(forKey: ConstantValue.isPurchase)
        if isPurchased {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "PurchaseEditViewController") as! PurchaseEditViewController
            vc.isSuccess = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "EditViewController") as! EditViewController
            vc.isSuccess = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func didDeleteItem(at indexPath: IndexPath) {
        inboxViewModel.fetchCardTitles()
    }
    
    func didUpdateInbox() {
        inboxViewModel.fetchCardTitles()
    }
}

extension InboxViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isLoading ? 12 : inboxViewModel.inboxData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isLoading {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkeletonCell", for: indexPath) as! SkeletonInboxCollectionViewCell
            cell.isUserInteractionEnabled = false
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InboxCollectionViewCell", for: indexPath) as! InboxCollectionViewCell
            let data = inboxViewModel.inboxData[indexPath.item]
            cell.configure(with: data)
            cell.isUserInteractionEnabled = true
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !isLoading else { return }
        let selectedData = inboxViewModel.inboxData[indexPath.item]
        let inboxId = selectedData.id
        if isConnectedToInternet() {
            inboxViewModel.updateInboxStatus(inboxId: inboxId) { [weak self] result in
                switch result {
                case .success(_):
                    let previewVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "PreviewViewController") as! PreviewViewController
                    previewVC.inboxData = selectedData
                    previewVC.indexPath = indexPath
                    previewVC.delegate = self
                    self?.navigationController?.pushViewController(previewVC, animated: true)
                case .failure(let error):
                    let snackbar = TTGSnackbar(message: error.localizedDescription, duration: .middle)
                    snackbar.show()
                }
            }
        } else {
            let message = NSLocalizedString("InboxNoInternetMessage", comment: "")
            let snackbar = TTGSnackbar(message: message, duration: .middle)
            snackbar.show()
         }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCellsPerRow: CGFloat = 3
        let spacing: CGFloat = 16
        let totalSpacing = spacing * (numberOfCellsPerRow - 1)
        let width = (collectionView.bounds.width - totalSpacing) / numberOfCellsPerRow
        return CGSize(width: width, height: 141)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
