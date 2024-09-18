//
//  Instagram_02.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 14/08/24.
//

import Foundation
import UIKit

class Instagram02: UIView {
    
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
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
        let nib = UINib(nibName: "Instagram_02", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        
        // Set the corner radius for the imageView
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        
        // Load the GIF into the imageView
        imageView.loadGif(name: "LinkButton")
        
        localizeUI()
    }
    
    func localizeUI() {
        titleLable.text = NSLocalizedString("ClickKey", comment: "")
        titleLabel.text = NSLocalizedString("Buttonkey", comment: "")
    }
}


