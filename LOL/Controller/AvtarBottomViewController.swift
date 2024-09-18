//
//  AvtarBottomViewController.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 02/08/24.
//

import UIKit
import TTGSnackbar
import Alamofire

class AvtarBottomViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var avatarLabel: UILabel!
    
    private var noDataView: NoDataBottomBarView!
    private var noInternetView: NoInternetBottombarView!
    
    private var avatarViewModel = AvatarViewModel()
    var onAvatarSelected: ((String) -> Void)?
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avatarAPI()
        localizeUI()
    }
    
    func localizeUI() {
        self.avatarLabel.text = NSLocalizedString("AvatarKey", comment: "")
    }
    
    // Avatar API Call
    func avatarAPI() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.isHidden = true
        
        self.activityIndicator.startAnimating()
        self.activityIndicator.style = .large
        
        setupNoDataView()
        setupNoInternetView()
        
        avatarViewModel.onAvatarsFetched = { [weak self] in
            self?.activityIndicator.stopAnimating()
            if let avatars = self?.avatarViewModel.avatars, !avatars.isEmpty {
                self?.collectionView.isHidden = false
                self?.collectionView.reloadData()
                self?.noDataView.isHidden = true
            } else {
                self?.collectionView.isHidden = true
                self?.noDataView.isHidden = false
            }
        }
        
        avatarViewModel.onFetchError = { [weak self] error in
            self?.activityIndicator.stopAnimating()
            self?.collectionView.isHidden = true
            self?.noDataView.isHidden = true
            self?.noInternetView.isHidden = true
            if let nsError = error as NSError?, nsError.code == -1009 {
                self?.noInternetView.isHidden = false
            } else {
                self?.noDataView.isHidden = false
            }
            print("Failed to fetch avatars: \(error.localizedDescription)")
        }
        
        noDataView.isHidden = true
        noInternetView.isHidden = true
        
        avatarViewModel.fetchAvatars()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.layer.cornerRadius = 28
        view.layer.masksToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func setupNoDataView() {
        noDataView = NoDataBottomBarView(frame: view.bounds)
        noDataView.isHidden = true
        view.addSubview(noDataView)
    }
    
    private func setupNoInternetView() {
        noInternetView = NoInternetBottombarView(frame: view.bounds)
        noInternetView.isHidden = true
        noInternetView.onRetry = { [weak self] in
            guard let self = self else { return }
            
            if NetworkManager.shared.isConnectedToInternet {
                self.noInternetView.isHidden = true
                self.activityIndicator.startAnimating()
                self.avatarViewModel.fetchAvatars()
            } else {
                let snackbar = TTGSnackbar(message: NSLocalizedString("AvatarNoInternetMessage", comment: ""), duration: .middle)
                snackbar.show()
            }
        }
        view.addSubview(noInternetView)
    }
    
    deinit {
        NetworkManager.shared.stopMonitoring()
    }
}

//MARK: - CollectionView Delegate & DataSource & DelegateFlowLayout Method
extension AvtarBottomViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avatarViewModel.avatars.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvatarCollectionViewCell", for: indexPath) as! AvatarCollectionViewCell
        let avatar = avatarViewModel.avatars[indexPath.item]
        cell.configure(with: avatar.avatarURL)
        cell.setSelected(indexPath == selectedIndexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let previousIndexPath = selectedIndexPath {
            let previousCell = collectionView.cellForItem(at: previousIndexPath) as? AvatarCollectionViewCell
            previousCell?.setSelected(false)
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! AvatarCollectionViewCell
        cell.setSelected(true)
        selectedIndexPath = indexPath
        
        let selectedAvatarURL = avatarViewModel.avatars[indexPath.item].avatarURL
        onAvatarSelected?(selectedAvatarURL)
        
        dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.bounds.width
        
        return CGSize(width: collectionWidth / 2 - 28, height: collectionWidth / 2 - 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
