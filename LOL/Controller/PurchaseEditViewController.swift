//
//  PurchaseEditViewController.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 12/09/24.
//

import UIKit
import SDWebImage
import Alamofire
import TTGSnackbar

class PurchaseEditViewController: UIViewController {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var saveCardButton: UIButton!
    @IBOutlet weak var formCollectionView: UICollectionView!
    @IBOutlet weak var formImageView: UIImageView!
    @IBOutlet weak var navigationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var selectQuestionLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    var isLoading = true
    var isSuccess: Bool = false
    var isPurchaseSuccess: Bool = false
    var editTitleViewModel: EditViewModel!
    private var noDataView: NoDataView!
    private var noInternetView: NoInternetView!
    private let maxSelectableItems = 5
    
    init(viewModel: EditViewModel) {
        self.editTitleViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.editTitleViewModel = EditViewModel(apiService: EditTitleApiService.shared)
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
        formCollectionView.allowsMultipleSelection = true
    }
    
    func checkInternetAndFetchData() {
        if isConnectedToInternet() {
            editTitleViewModel.fetchCardTitles()
            noInternetView?.isHidden = true
        } else {
            showNoInternetView()
        }
    }
    
    @objc func updateProfileImage(notification: Notification) {
        if let image = notification.object as? UIImage {
            formImageView.image = image
        }
    }
    
    func localizeUI() {
        nameLabel.text = NSLocalizedString("EditNickNameKey", comment: "")
        navigationLabel.text = NSLocalizedString("EditTitleKey", comment: "")
        descriptionLabel.text = NSLocalizedString("EditDescriptionKey", comment: "")
        selectQuestionLabel.text = NSLocalizedString("EditSelectQuesKey", comment: "")
        saveCardButton.setTitle(NSLocalizedString("EditSaveCardBtnKey", comment: ""), for: .normal)
    }
    
    func setupUI() {
        self.bgView.layer.masksToBounds = true
        self.bgView.layer.cornerRadius = 28
        
        self.hideKeyboardTappedAround()
        self.formImageView.layer.cornerRadius = formImageView.layer.frame.height / 2
        self.saveCardButton.layer.cornerRadius = saveCardButton.frame.height / 2
        self.saveCardButton.frame = CGRect(x: (view.frame.width - 398) / 2, y: view.center.y - 25, width: 398, height: 50)
        self.saveCardButton.applyGradient(colors: [UIColor(hex: "#FA4957"), UIColor(hex: "#FD7E41")])
        self.formCollectionView.delegate = self
        self.formCollectionView.dataSource = self
        formCollectionView.register(SkeletonCollectionViewCell.self, forCellWithReuseIdentifier: "SkeletonCell")
        
        if let imageData = UserDefaults.standard.data(forKey: ConstantValue.profile_Image), let image = UIImage(data: imageData) {
            formImageView.image = image
        } else if let avatarURL = URL(string: UserDefaults.standard.string(forKey: ConstantValue.avatar_URL) ?? "https://lolcards.link/api/public/images/AvatarDefault.png") {
            self.formImageView.sd_setImage(with: avatarURL, placeholderImage: UIImage(named: "Anonyms"))
        }
        NotificationCenter.default.addObserver(self, selector: #selector(updateProfileImage(notification:)), name: .profileImageUpdated, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: .profileImageUpdated, object: nil)
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
            noDataView.topAnchor.constraint(equalTo: navigationLabel.bottomAnchor, constant: 10),
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
            let snackbar = TTGSnackbar(message: NSLocalizedString("SnackbarPleaseTurnOnInternet", comment: ""), duration: .middle)
            snackbar.show()
        }
    }
    
    func setupBindings() {
        editTitleViewModel.reloadData = { [weak self] in
            DispatchQueue.main.async {
                self?.hideSkeletonLoader()
                if self?.editTitleViewModel.cardTitles.isEmpty ?? true {
                    self?.showNoDataView()
                } else {
                    self?.hideNoDataView()
                    self?.formCollectionView.performBatchUpdates({
                        self?.formCollectionView.reloadSections(IndexSet(integer: 0))
                    }, completion: nil)
                }
            }
        }
        editTitleViewModel.showError = { [weak self] errorMessage in
            self?.showNoDataView()
        }
    }
    
    func showSkeletonLoader() {
        isLoading = true
        formCollectionView.reloadData()
    }
    
    func hideSkeletonLoader() {
        isLoading = false
        formCollectionView.reloadData()
    }
    
    func showNoDataView() {
        self.noDataView.isHidden = false
    }
    
    func hideNoDataView() {
        self.noDataView.isHidden = true
    }
    
    func showNoInternetView() {
        self.noInternetView.isHidden = false
    }
    
    private func isConnectedToInternet() -> Bool {
        let networkManager = NetworkReachabilityManager()
        return networkManager?.isReachable ?? false
    }
    
    private func addUnderlineToNameLabel() {
        let attributedString = NSMutableAttributedString(string: nameLabel.text ?? "")
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        nameLabel.attributedText = attributedString
    }
    
    @IBAction func btnSaveCardTapped(_ sender: UIButton) {
        guard editTitleViewModel.selectedIndices.count == maxSelectableItems else {
            let snackbar = TTGSnackbar(message: NSLocalizedString("SnackbarPleaseSelect5Questions", comment: ""), duration: .middle)
            snackbar.show()
            return
        }
        self.callUpdateCardTitleAPI()
        self.callSelectedCardTitleAPI()
    }
    
    private func callSelectedCardTitleAPI() {
        // MARK: - SelectedCardTitle
        editTitleViewModel.selecteCardTitle { [self] result in
            switch result {
            case .success(_):
                if isSuccess {
                    let snackbar = TTGSnackbar(message: NSLocalizedString("SnackbarCardTitlesUpdated", comment: ""), duration: .middle)
                    snackbar.show()
                } else {
                    let snackbar = TTGSnackbar(message: NSLocalizedString("SnackbarCardTitlesUpdated", comment: ""), duration: .middle)
                    snackbar.show()
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "CardQuestionViewController") as! CardQuestionViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print("Error : \(error.localizedDescription)")
            }
        }
    }
    
    private func callUpdateCardTitleAPI() {
        // MARK: - UpdateCardTitle
        editTitleViewModel.updateCardTitle { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    print("Successfully Update CardTitle")
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        if isPurchaseSuccess {
            if let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomTabbarController") as? CustomTabbarController {
                if let homeViewController = tabBarController.viewControllers?.first(where: { $0.restorationIdentifier == "HomeViewController" }) {
                    tabBarController.selectedViewController = homeViewController
                    self.navigationController?.pushViewController(tabBarController, animated: false)
                }
            }
            
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

//MARK: - FormCollectionView Delegate & DataSource & DelegateFlowLayout Method
extension PurchaseEditViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isLoading ? 8 : editTitleViewModel.cardTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isLoading {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkeletonCell", for: indexPath) as! SkeletonCollectionViewCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PurchaseFormCollectionViewCell", for: indexPath) as! PurchaseFormCollectionViewCell
            let isSelected = editTitleViewModel.selectedIndices.contains("\(indexPath.row)")
            cell.configureCell(isSelected: isSelected)
            cell.questionLabel.text = editTitleViewModel.cardTitles[indexPath.row]
            cell.delegate = self
            if isSelected {
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            } else {
                collectionView.deselectItem(at: indexPath, animated: false)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedItems = collectionView.indexPathsForSelectedItems, selectedItems.count <= maxSelectableItems else {
            collectionView.deselectItem(at: indexPath, animated: true)
            let snackbar = TTGSnackbar(message: NSLocalizedString("SnackbarSelectUpTo5QuestionsOnly", comment: ""), duration: .middle)
            snackbar.show()
            return
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as? PurchaseFormCollectionViewCell
        cell?.configureCell(isSelected: true)
        editTitleViewModel.selectedIndices.append("\(indexPath.row)")
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? PurchaseFormCollectionViewCell
        cell?.configureCell(isSelected: false)
        editTitleViewModel.selectedIndices.removeAll { $0 == "\(indexPath.row)" }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 62)
    }
}

extension PurchaseEditViewController: PurchaseFormCollectionViewCellDelegate {
    func didTapEditButton(in cell: PurchaseFormCollectionViewCell) {
        guard let indexPath = formCollectionView.indexPath(for: cell) else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let editQuestionPopup = storyboard.instantiateViewController(withIdentifier: "EditQuestionPopup") as? EditQuestionPopup {
            editQuestionPopup.currentQuestionText = cell.questionLabel.text
            editQuestionPopup.updateAction = { [weak self] newQuestionText in
                cell.questionLabel.text = newQuestionText
                self?.editTitleViewModel.updateEditedTitle(at: indexPath.row, with: newQuestionText)
            }
            editQuestionPopup.modalTransitionStyle = .crossDissolve
            editQuestionPopup.modalPresentationStyle = .overCurrentContext
            self.present(editQuestionPopup, animated: true, completion: nil)
        }
    }
}

