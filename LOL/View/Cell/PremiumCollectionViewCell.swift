//
//  PremiumCollectionViewCell.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 21/08/24.
//

import UIKit

class PremiumCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func setupCell(_ item: PremiumModel) {
        imageView.image = item.image
        
        let titleKey = "PremiumTitleKey\(item.id)"
        let descriptionKey = "PremiumDescriptionKey\(item.id)"
        
        titleLabel.text = NSLocalizedString(titleKey, comment: "")
        descriptionLabel.text = NSLocalizedString(descriptionKey, comment: "")
        
        let (titleFontSize, descriptionFontSize) = getDynamicFontSizes()
        titleLabel.font = UIFont(name: "Lato-ExtraBold", size: titleFontSize)
        descriptionLabel.font = UIFont(name: "Lato-Regular", size: descriptionFontSize)
    }
    
    private func getDynamicFontSizes() -> (CGFloat, CGFloat) {
        let screenSize = UIScreen.main.nativeBounds.height
        
        switch screenSize {
        case 1136, 1334, 1920, 2208:
            return (20, 16)
        case 2436, 1792, 2556, 2532:
            return (22, 16)
        case 2796, 2778, 2688:
            return (27, 20)
        default:
            return (22, 16)
        }
    }
}
