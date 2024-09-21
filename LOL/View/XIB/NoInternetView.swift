//
//  NoInternetView.swift
//  CustomeDataAPICalling
//
//  Created by Arpit iOS Dev. on 07/06/24.
//

import Foundation
import UIKit

class NoInternetView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var retryButtonTopConstraint: NSLayoutConstraint!
    
    var onRetry: (() -> Void)?
    
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
        let nib = UINib(nibName: "NoInternetView", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        
        adjustConstraints()
        
        localizeUI()
    }
    
    func localizeUI() {
        titleLabel.text = NSLocalizedString("NoInternetTitleKey", comment: "")
        messageLabel.text = NSLocalizedString("NoInternetDescriptionKey", comment: "")
    }
    
    private func adjustConstraints() {
        let screenHeight = UIScreen.main.nativeBounds.height
        if UIDevice.current.userInterfaceIdiom == .phone {
            switch screenHeight {
            case 1136, 1334, 1920, 2208:
                imageViewHeightConstraint.constant = 225
                labelTopConstraint.constant = 30
                imageViewTopConstraint.constant = 50
                retryButtonTopConstraint.constant = 30
            case 2436, 1792, 2556, 2532:
                imageViewHeightConstraint.constant = 287
                labelTopConstraint.constant = 50
                imageViewTopConstraint.constant = 70
                retryButtonTopConstraint.constant = 60
            case 2796, 2778, 2688:
                imageViewHeightConstraint.constant = 287
                labelTopConstraint.constant = 50
                imageViewTopConstraint.constant = 70
                retryButtonTopConstraint.constant = 60
            default:
                imageViewHeightConstraint.constant = 235
                labelTopConstraint.constant = 30
                imageViewTopConstraint.constant = 50
                retryButtonTopConstraint.constant = 30
            }
        }
    }
}
