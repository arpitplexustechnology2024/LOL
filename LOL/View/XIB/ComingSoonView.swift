//
//  ComingSoonView.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 13/08/24.
//

import Foundation
import UIKit

class ComingSoonView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
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
        let nib = UINib(nibName: "ComingSoonView", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        
        localizeUI()
    }
    
    func localizeUI() {
        titleLabel.text = NSLocalizedString("MoreTitleKey", comment: "")
        messageLabel.text = NSLocalizedString("MoreDescriptionKey", comment: "")
    }
}

