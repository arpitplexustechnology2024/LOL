//
//  AvatarCollectionViewCell.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 02/08/24.
//

import UIKit
import SDWebImage

class AvatarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var avtarImageView: UIImageView!
    
    private var blurEffectView: UIVisualEffectView!
    private var centeredImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
        
        self.avtarImageView.layer.cornerRadius = 10
        self.avtarImageView.clipsToBounds = true
        
        setupBlurEffectView()
        setupCenteredImageView()
    }
    
    func configure(with url: String) {
        if let imageURL = URL(string: url) {
            avtarImageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "placeholder"))
        }
        blurEffectView.isHidden = true
        centeredImageView.isHidden = true
    }
    
    func setSelected(_ selected: Bool) {
        blurEffectView.isHidden = !selected
        centeredImageView.isHidden = !selected
    }
    
    private func setupBlurEffectView() {
        let blurEffect = UIBlurEffect(style: .light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = contentView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.addSubview(blurEffectView)
        blurEffectView.isHidden = true
    }
    
    private func setupCenteredImageView() {
        centeredImageView = UIImageView()
        centeredImageView.contentMode = .center
        centeredImageView.image = UIImage(named: "yes")
        centeredImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(centeredImageView)
        
        NSLayoutConstraint.activate([
            centeredImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            centeredImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            centeredImageView.widthAnchor.constraint(equalToConstant: 25),
            centeredImageView.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
}
