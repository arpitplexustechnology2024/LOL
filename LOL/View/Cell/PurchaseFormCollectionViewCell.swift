//
//  PurchaseFormCollectionViewCell.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 12/09/24.
//

import UIKit

protocol PurchaseFormCollectionViewCellDelegate: AnyObject {
    func didTapEditButton(in cell: PurchaseFormCollectionViewCell)
}

class PurchaseFormCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    weak var delegate: PurchaseFormCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    private func setupCell() {
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }
    
    @objc private func editButtonTapped() {
        delegate?.didTapEditButton(in: self)
    }
    
    func configureCell(isSelected: Bool) {
        if isSelected {
            self.contentView.backgroundColor = .white
            self.questionLabel.textColor = .black
            self.editButton.setImage(UIImage(named: "Edit.Black"), for: .normal)
        } else {
            self.contentView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 0.3)
            self.questionLabel.textColor = .white
            self.editButton.setImage(UIImage(named: "Edit.Light"), for: .normal)
        }
    }
}
