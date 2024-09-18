//
//  ShareView_04.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 20/08/24.
//

import UIKit
import SDWebImage

class ShareView04: UIView {
    
    @IBOutlet weak var shareBackground: UIImageView!
    @IBOutlet weak var cardview: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
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
        let nib = UINib(nibName: "ShareView_04", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(view)
        
        self.cardview.layer.cornerRadius = 20
        self.cardview.layer.masksToBounds = true
        
        imageView.layer.cornerRadius = imageView.layer.frame.height / 2
        imageView.clipsToBounds = true
        loadImage()
        shareBackground.image = UIImage(named: "ShareBackground04")
        
        textLabel.text = NSLocalizedString("QuestionsKey04", comment: "")
        titleLabel.text = NSLocalizedString("TitleKey04", comment: "")
        addTextBorder(to: titleLabel)
        titleLabel.font = UIFont(name: "PricedownBl-Regular", size: 40)
        titleLabel.textColor = UIColor(hex: "#FFFFFF")
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateProfileImage(notification:)), name: .profileImageUpdated, object: nil)
    }
    
    private func addTextBorder(to label: UILabel) {
        guard let text = label.text else { return }
        let attributedString = NSAttributedString(
            string: text,
            attributes: [
                .strokeColor: UIColor.black,
                .strokeWidth: -7.0,
                .font: label.font ?? UIFont.systemFont(ofSize: 40)
            ]
        )
        label.attributedText = attributedString
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


