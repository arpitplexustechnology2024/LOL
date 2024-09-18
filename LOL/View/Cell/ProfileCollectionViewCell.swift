//
//  ProfileCollectionViewCell.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 20/07/24.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cardProfileImageConstaints: NSLayoutConstraint!
    @IBOutlet weak var cardprofileViewHeightConstaints: NSLayoutConstraint!
    @IBOutlet weak var cardprofileViewWidthConstaints: NSLayoutConstraint!
    @IBOutlet weak var cardprofileImageHeightConstaints: NSLayoutConstraint!
    @IBOutlet weak var cardprofileImageWidthConstaints: NSLayoutConstraint!
    @IBOutlet weak var cardButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardButonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardButtonWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var profile_ImageView: UIImageView!
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var questionTextLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var profile_ChangeButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        makeProfileImageViewCircular()
    }
    
    private func setupCell() {
        self.contentView.layer.cornerRadius = 20
        self.contentView.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.3
        self.layer.masksToBounds = false
    }
    
    private func makeProfileImageViewCircular() {
        profile_ImageView.layer.cornerRadius = profile_ImageView.frame.size.width / 2
        profile_ImageView.layer.masksToBounds = true
    }
    
    func configure(with cardQuestion: String) {
        questionTextLabel.text = NSLocalizedString(cardQuestion, comment: "")
    }
    
    func configure(withTitle cardTitle: String, atIndex index: Int) {
        titleLabel.text = NSLocalizedString(cardTitle, comment: "")
        configureTitleLabel(for: index)
        
        if index == 1 || index == 3 {
            addTextBorder(to: titleLabel)
        } else {
            removeTextBorder(from: titleLabel)
        }
    }
    
    func setProfileImage(_ image: UIImage?) {
        profile_ImageView.image = image
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
    
    private func removeTextBorder(from label: UILabel) {
        guard let text = label.text else { return }
        let attributedString = NSAttributedString(
            string: text,
            attributes: [
                .font: label.font ?? UIFont.systemFont(ofSize: 40)
            ]
        )
        label.attributedText = attributedString
    }
    
    private func configureTitleLabel(for index: Int) {
        switch index {
        case 1:
            titleLabel.font = UIFont(name: "RacingSansOne-Regular", size: 40)
            titleLabel.textColor = UIColor(hex: "#DAE4EC")
        case 2:
            titleLabel.font = UIFont(name: "WendyOne-Regular", size: 40)
            titleLabel.textColor = UIColor(hex: "#FFEDED")
        case 3:
            titleLabel.font = UIFont(name: "PricedownBl-Regular", size: 40)
            titleLabel.textColor = UIColor(hex: "#FFFFFF")
        case 4:
            titleLabel.font = UIFont(name: "Titan One", size: 40)
            titleLabel.textColor = UIColor(hex: "#FFFFFF")
        case 5:
            titleLabel.font = UIFont(name: "Baloo-Regular", size: 32)
            titleLabel.textColor = UIColor(hex: "#FEAA80")
        case 6:
            titleLabel.font = UIFont(name: "Timmana", size: 40)
            titleLabel.textColor = UIColor(hex: "#FFEDED")
        default:
            titleLabel.font = UIFont.systemFont(ofSize: 40)
            titleLabel.textColor = .black
        }
    }
}
