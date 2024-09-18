//
//  InboxView.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 22/08/24.
//

import Foundation
import UIKit

class InboxView: UIView {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var senderButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "InboxView", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    
        self.senderButton.layer.cornerRadius = senderButton.layer.frame.height / 2
        
        localizeUI()
        
    }
        func localizeUI() {
            titleLabel.text = NSLocalizedString("InboxTitleKey", comment: "")
            messageLabel.text = NSLocalizedString("InboxDescriptionKey", comment: "")
            senderButton.setTitle(NSLocalizedString("InboxGetMessageBtnKey", comment: ""), for: .normal)
        }
}

