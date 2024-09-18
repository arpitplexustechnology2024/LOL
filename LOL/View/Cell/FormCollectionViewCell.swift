//
//  FormCollectionViewCell.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 09/08/24.
//

import UIKit

protocol FormCollectionViewCellDelegate: AnyObject {
    func formCollectionViewCell(_ cell: FormCollectionViewCell, didTapCheckBox button: UIButton)
}

class FormCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var checkBox: UIButton!
    
    weak var delegate: FormCollectionViewCellDelegate?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    private func setupCell() {
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
        checkBox.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)
    }
    
    @objc private func checkBoxTapped() {
        if let indexPath = indexPath {
            delegate?.formCollectionViewCell(self, didTapCheckBox: checkBox)
        }
    }
    
    func configureCell(isSelected: Bool) {
        if isSelected {
            self.contentView.backgroundColor = .white
            self.questionLabel.textColor = .black
            self.checkBox.setImage(UIImage(named: "CheckBoxForm_Fill"), for: .normal)
        } else {
            self.contentView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 0.3)
            self.questionLabel.textColor = .white
            self.checkBox.setImage(UIImage(named: "CheckBoxForm"), for: .normal)
        }
    }
}
