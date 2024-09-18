//
//  InboxCollectionViewCell.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 22/08/24.
//

import UIKit
import SDWebImage

class InboxCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var inboxImageView: UIImageView!
    @IBOutlet weak var inboxBGImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 16
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let gradientLayer = self.contentView.layer.sublayers?.first(where: { $0 is CAGradientLayer }) as? CAGradientLayer {
            gradientLayer.frame = self.bounds
        }
    }
    
    func configure(with data: InboxData) {
        if data.read {
            self.inboxImageView.image = UIImage(named: "InboxSeen")
            if traitCollection.userInterfaceStyle == .dark {
                self.inboxBGImageView.image = UIImage(named: "InboxSeenData.Dark")
            } else {
                self.inboxBGImageView.image = UIImage(named: "InboxSeenData.Light")
            }
            self.contentView.layer.borderWidth = 0
        } else {
            self.inboxImageView.image = UIImage(named: "InboxAnonyms")
            self.inboxBGImageView.image = UIImage(named: "InboxNewData")
            self.contentView.layer.borderWidth = 3
            self.contentView.layer.borderColor = UIColor(hex: "#F6CACB").cgColor
        }
    }
}
