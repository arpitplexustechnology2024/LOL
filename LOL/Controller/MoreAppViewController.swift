//
//  MoreAppViewController.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 12/08/24.
//

import UIKit
import Alamofire
import TTGSnackbar

class MoreAppViewController: UIViewController {
    
    @IBOutlet weak var navigationLabel: UILabel!
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var EditQuestionButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var comingSoonView: ComingSoonView!
    private var noInternetView: NoInternetView!
    private let viewModel = MoreDataViewModel()
    private var moreDataArray: [MoreData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        localizeUI()
        setupComingSoonView()
        setupNoInternetView()
        checkInternetAndFetchData()
    }
    
    func checkInternetAndFetchData() {
        if isConnectedToInternet() {
            self.fetchMoreData()
            self.noInternetView?.isHidden = true
        } else {
            self.showNoInternetView()
        }
    }
    
    func setupUI() {
        self.collectionview.delegate = self
        self.collectionview.dataSource = self
        self.activityIndicator.style = .large
    }
    
    func localizeUI() {
        navigationLabel.text = NSLocalizedString("TabbarItemKey03", comment: "")
    }
    
    private func fetchMoreData() {
        let packageName = "id1487614236"
        self.activityIndicator.startAnimating()
        viewModel.fetchMoreData(packageName: packageName) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let moreDataArray):
                    self.moreDataArray = moreDataArray
                    DispatchQueue.main.async {
                        self.hideLoader()
                        self.comingSoonView.isHidden = true
                        self.collectionview.reloadData()
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self.hideLoader()
                    self.comingSoonView.isHidden = false
                }
            }
        }
    }
    
    @objc private func appIDButtonClicked(_ sender: UIButton) {
        let index = sender.tag
        let moreData = moreDataArray[index]
        
        let appStoreURL = "https://apps.apple.com/app/id\(moreData.appID)"
        
        if let url = URL(string: appStoreURL) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
    
    private func setupComingSoonView() {
        comingSoonView = ComingSoonView()
        comingSoonView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        comingSoonView.isHidden = true
        self.view.addSubview(comingSoonView)
        
        comingSoonView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            comingSoonView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            comingSoonView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            comingSoonView.topAnchor.constraint(equalTo: navigationLabel.bottomAnchor, constant: 10),
            comingSoonView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
            noInternetView.topAnchor.constraint(equalTo: navigationLabel.bottomAnchor, constant: 10),
            noInternetView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func retryButtonTapped() {
        if isConnectedToInternet() {
            noInternetView.isHidden = true
            comingSoonView.isHidden = true
            checkInternetAndFetchData()
        } else {
            let snackbar = TTGSnackbar(message: NSLocalizedString("MoreNoInternetMessage", comment: ""), duration: .middle)
            snackbar.show()
        }
    }
    
    func hideLoader() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
    }
    
    func showNoInternetView() {
        self.noInternetView.isHidden = false
    }
    
    private func isConnectedToInternet() -> Bool {
        let networkManager = NetworkReachabilityManager()
        return networkManager?.isReachable ?? false
    }
}

extension MoreAppViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moreDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoreAppCollectionViewCell", for: indexPath) as! MoreAppCollectionViewCell
        let moreData = moreDataArray[indexPath.item]
        
        cell.configure(with: moreData)
        cell.More_App_DownloadButton.tag = indexPath.item
        cell.More_App_DownloadButton.addTarget(self, action: #selector(appIDButtonClicked(_:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 26, height: 65)
    }
}
