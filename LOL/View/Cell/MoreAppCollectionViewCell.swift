//
//  MoreAppCollectionViewCell.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 16/08/24.
//

import UIKit
import SDWebImage

class MoreAppCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var More_App_LogoImage: UIImageView!
    @IBOutlet weak var More_App_Label: UILabel!
    @IBOutlet weak var More_App_DownloadButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Button Corner Radius
        self.More_App_DownloadButton.setTitle(NSLocalizedString("DownloadBtnKey", comment: ""), for: .normal)
        self.More_App_DownloadButton.titleLabel?.font = UIFont(name: "Lato-SemiBold", size: 5)
        self.More_App_DownloadButton.layer.cornerRadius = More_App_DownloadButton.layer.frame.height / 2
        self.More_App_DownloadButton.layer.masksToBounds = true
        self.setupGradientButton()
        
        // Use dynamic colors that adapt to light/dark mode
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.masksToBounds = true
        self.contentView.backgroundColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor.systemGray6 : UIColor.white
        }
        self.layer.shadowColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
        }.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4.0
        self.layer.masksToBounds = false
        
        // ImageView Corner Radius
        self.More_App_LogoImage.layer.cornerRadius = 6
        self.More_App_LogoImage.clipsToBounds = true
    }
    
    func setupGradientButton() {
        
        self.More_App_DownloadButton.layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [
            UIColor(hex: "#FA5054").cgColor,
            UIColor(hex: "#FD7A42").cgColor
        ]
        
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 500, height: self.More_App_DownloadButton.frame.height)
        gradientLayer.cornerRadius = self.More_App_DownloadButton.layer.cornerRadius
        self.More_App_DownloadButton.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func configure(with moreData: MoreData) {
        More_App_Label.text = moreData.appName
        
        if let logoURL = URL(string: moreData.logo) {
            More_App_LogoImage.sd_setImage(with: logoURL, placeholderImage: UIImage(named: "placeholder"))
        } else {
            More_App_LogoImage.image = UIImage(named: "placeholder")
        }
    }
}
