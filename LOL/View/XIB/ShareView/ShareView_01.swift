//
//  ShareView_01.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 20/08/24.
//

import UIKit
import SDWebImage

class ShareView01: UIView {
    
    @IBOutlet weak var shareBackground: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ShareView_01", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(view)
        imageView.layer.cornerRadius = imageView.layer.frame.height / 2
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.clipsToBounds = true
        loadImage()
        shareBackground.image = UIImage(named: "ShareBackground01")
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateProfileImage(notification:)), name: .profileImageUpdated, object: nil)
    }
    
    private func loadImage() {
        if let imageData = UserDefaults.standard.data(forKey: ConstantValue.profile_Image), let image = UIImage(data: imageData) {
            imageView.image = image
            
        } else if let avatarURL = URL(string: UserDefaults.standard.string(forKey: ConstantValue.avatar_URL) ?? "https://lolcards.link/api/public/images/AvatarDefault.png") {
            imageView.sd_setImage(with: avatarURL, placeholderImage: UIImage(named: "Anonyms"))
        }
    }
    
    @objc func updateProfileImage(notification: Notification) {
        if let image = notification.object as? UIImage {
            imageView.image = image
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .profileImageUpdated, object: nil)
    }
}
