//
//  HomeViewController.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 05/08/24.
//

import UIKit
import AVFoundation
import Photos
import TTGSnackbar
import MLKitVision
import MLKitFaceDetection
import SDWebImage

class HomeViewController: UIViewController {
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var EditQuestionButton: UIButton!
    
    var cardBGImageArr = ["HomeFirst", "HomeSecond", "HomeThird", "HomeFour", "HomeFive", "HomeSix", "HomeSeven"]
    var cardQuestionArr = ["QuestionsKey01", "QuestionsKey02", "QuestionsKey03", "QuestionsKey04", "QuestionsKey05", "QuestionsKey06", "QuestionsKey07"]
    var cardTitleArr = ["TitleKey01", "TitleKey02", "TitleKey03", "TitleKey04", "TitleKey05", "TitleKey06", "TitleKey07"]
    
    let notificationMessages = [
        (title: "NotificationTitleKey01", body: "NotificationDescriptonKey01"),
        (title: "NotificationTitleKey02", body: "NotificationDescriptonKey02"),
        (title: "NotificationTitleKey03", body: "NotificationDescriptonKey03"),
        (title: "NotificationTitleKey04", body: "NotificationDescriptonKey04"),
        (title: "NotificationTitleKey05", body: "NotificationDescriptonKey05"),
        (title: "NotificationTitleKey06", body: "NotificationDescriptonKey06"),
        (title: "NotificationTitleKey07", body: "NotificationDescriptonKey07"),
        (title: "NotificationTitleKey08", body: "NotificationDescriptonKey08"),
        (title: "NotificationTitleKey09", body: "NotificationDescriptonKey09"),
        (title: "NotificationTitleKey10", body: "NotificationDescriptonKey10")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizeUI()
        requestNotificationPermission()
        self.homeCollectionView.dataSource = self
        self.homeCollectionView.delegate = self
    }
    
    func localizeUI() {
        self.navigationTitle.text = NSLocalizedString("TabbarItemKey01", comment: "")
    }
    
    @objc func profileChangeButton(_ sender: UIButton) {
        let titleString = NSAttributedString(string: NSLocalizedString("EditProfilePictureKey", comment: ""), attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)
        ])
        
        let actionSheet = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        actionSheet.setValue(titleString, forKey: "attributedTitle")
        
        let cameraAction = UIAlertAction(title: NSLocalizedString("CameraKey", comment: ""), style: .default) { _ in
            self.btnCameraTapped()
        }
        
        let galleryAction = UIAlertAction(title: NSLocalizedString("GalleryKey", comment: ""), style: .default) { _ in
            self.btnGalleryTapped()
        }
        
        let avatarAction = UIAlertAction(title: NSLocalizedString("SelectAvatarKey", comment: ""), style: .default) { _ in
            self.btnAvatarTapped()
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("CancelKey", comment: ""), style: .cancel, handler: nil)
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(galleryAction)
        actionSheet.addAction(avatarAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func btnCameraTapped() {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraAuthorizationStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.showImagePicker(for: .camera)
                    } else {
                        self.showPermissionSnackbar(for: "camera")
                    }
                }
            }
        case .authorized:
            showImagePicker(for: .camera)
        case .restricted, .denied:
            showPermissionSnackbar(for: "camera")
        @unknown default:
            fatalError("Unknown authorization status")
        }
    }
    
    func btnGalleryTapped() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    if status == .authorized {
                        self.showImagePicker(for: .photoLibrary)
                    } else {
                        self.showPermissionSnackbar(for: "photo library")
                    }
                }
            }
        case .authorized, .limited:
            showImagePicker(for: .photoLibrary)
        case .restricted, .denied:
            showPermissionSnackbar(for: "photo library")
        @unknown default:
            fatalError("Unknown authorization status")
        }
    }
    
    
    func showImagePicker(for sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = sourceType
            imagePicker.allowsEditing = true
            if sourceType == .camera {
                imagePicker.cameraDevice = .front
            }
            DispatchQueue.main.async {
                self.present(imagePicker, animated: true, completion: nil)
            }
        } else {
            print("\(sourceType) is not available")
        }
    }
    
    func showPermissionSnackbar(for feature: String) {
        let messageKey: String
        
        switch feature {
        case "camera":
            messageKey = "SnackbarCameraPermissionAccess"
        case "photo library":
            messageKey = "SnackbarGalleryPermissionAccess"
        default:
            messageKey = "SnackbarDefaultPermissionAccess"
        }
        
        let localizedMessage = NSLocalizedString(messageKey, comment: "")
        let snackbar = TTGSnackbar(message: localizedMessage, duration: .long)
        
        snackbar.actionText = NSLocalizedString("Settings", comment: "")
        snackbar.actionBlock = { (snackbar) in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings)
            }
        }
        
        snackbar.show()
    }
    
    
    func btnAvatarTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let bottomSheetVC = storyboard.instantiateViewController(withIdentifier: "AvtarBottomViewController") as! AvtarBottomViewController
        
        bottomSheetVC.onAvatarSelected = { [weak self] selectedAvatarURL in
            print("Selected avatar URL: \(selectedAvatarURL)")
            
            if let avatarURL = URL(string: selectedAvatarURL) {
                self?.updateProfileImage(with: avatarURL)
            }
        }
        
        if #available(iOS 15.0, *) {
            if let sheet = bottomSheetVC.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
            }
        }
        present(bottomSheetVC, animated: true, completion: nil)
    }
    
    func updateProfileImage(with url: URL) {
        SDWebImageManager.shared.loadImage(with: url, options: [], progress: nil) { [weak self] image, data, error, cacheType, finished, url in
            if let image = image {
                UserDefaults.standard.set(image.pngData(), forKey: ConstantValue.profile_Image)
                self?.homeCollectionView.reloadData()
                NotificationCenter.default.post(name: .profileImageUpdated, object: image)
            } else {
                print("Error loading image: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    func detectFaces(in image: UIImage) {
        let visionImage = VisionImage(image: image)
        visionImage.orientation = image.imageOrientation
        
        let options = FaceDetectorOptions()
        options.performanceMode = .accurate
        options.landmarkMode = .all
        options.contourMode = .none
        options.classificationMode = .all
        
        let faceDetector = FaceDetector.faceDetector(options: options)
        
        faceDetector.process(visionImage) { faces, error in
            if let error = error {
                print("Error detecting faces: \(error.localizedDescription)")
                return
            }
            
            if let faces = faces {
                self.handleDetectedFaces(faces: faces, in: image)
            }
        }
    }
    
    func handleDetectedFaces(faces: [Face], in image: UIImage) {
        if faces.isEmpty {
            let noFaceDetectedMessage = NSLocalizedString("SnackbarNoFaceDetected", comment: "")
            let snackbar = TTGSnackbar(message: noFaceDetectedMessage, duration: .middle)
            snackbar.show()
        } else {
            if let firstFace = faces.first {
                saveAndDisplayImage(image: image)
            }
        }
    }
    
    @IBAction func btnEditQuestionTapped(_ sender: UIButton) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "PurchaseEditViewController") as! PurchaseEditViewController
        vc.isSuccess = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

// MARK: - ImagePickerController Delegate & NavigationController Delegate Method
extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            detectFaces(in: pickedImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func saveAndDisplayImage(image: UIImage) {
        if let imageData = image.pngData() {
            UserDefaults.standard.set(imageData, forKey: ConstantValue.profile_Image)
        }
        homeCollectionView.reloadData()
        NotificationCenter.default.post(name: .profileImageUpdated, object: image)
    }
    
}

// MARK: - HomeCollectionView Delegate & DataSource & DelegateFlowLayout Method
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardBGImageArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionViewCell", for: indexPath) as! ProfileCollectionViewCell
        if indexPath.item == 0 {
            cell.cardProfileImageConstaints.constant = 35
            cell.cardprofileViewHeightConstaints.constant = 80
            cell.cardprofileViewWidthConstaints.constant = 90
            cell.cardprofileImageHeightConstaints.constant = 80
            cell.cardprofileImageWidthConstaints.constant = 80
            cell.cardButtonConstraint.constant = 52
            cell.cardButonHeightConstraint.constant = 30
            cell.cardButtonWidthConstraint.constant = 30
        } else {
            cell.cardProfileImageConstaints.constant = 14
            cell.cardprofileViewHeightConstaints.constant = 60
            cell.cardprofileViewWidthConstaints.constant = 70
            cell.cardprofileImageHeightConstaints.constant = 60
            cell.cardprofileImageWidthConstaints.constant = 60
            cell.cardButtonConstraint.constant = 40
            cell.cardButonHeightConstraint.constant = 24
            cell.cardButtonWidthConstraint.constant = 24
        }
        cell.layoutIfNeeded()
        cell.cardImageView.image = UIImage(named: cardBGImageArr[indexPath.row])
        cell.configure(with: cardQuestionArr[indexPath.row])
        cell.configure(withTitle: cardTitleArr[indexPath.row], atIndex: indexPath.row)
        if let imageData = UserDefaults.standard.data(forKey: ConstantValue.profile_Image), let image = UIImage(data: imageData) {
            cell.setProfileImage(image)
        } else {
            let defaultAvatarURL = "https://lolcards.link/api/public/images/AvatarDefault.png"
            let avatarURLString = UserDefaults.standard.string(forKey: ConstantValue.avatar_URL) ?? defaultAvatarURL
            if let avatarURL = URL(string: avatarURLString) {
                cell.profile_ImageView.sd_setImage(with: avatarURL, placeholderImage: UIImage(named: "Anonyms"))
            }
        }
        cell.profile_ChangeButton.addTarget(self, action: #selector(profileChangeButton(_:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "CardQuestionViewController") as! CardQuestionViewController
        vc.selectedIndex = indexPath.row
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 26, height: 208)
    }
}

// MARK: - Local Notification
extension HomeViewController {
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [self] granted, error in
            if granted {
                print("Notification permission granted")
                self.scheduleLocalNotification()
            } else {
                print("Notification permission denied")
            }
        }
    }
    
    func scheduleLocalNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        
        let name = UserDefaults.standard.string(forKey: ConstantValue.name) ?? ""
        
        let randomMessage = notificationMessages.randomElement()!
        
        var title = NSLocalizedString(randomMessage.title, comment: "")
        if title.contains("_______") {
            title = title.replacingOccurrences(of: "_______", with: name)
        }
        content.title = title
        content.body = NSLocalizedString(randomMessage.body, comment: "")
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 17
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: "5PMDailyReminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled for 5:00 PM daily")
            }
        }
    }
}
