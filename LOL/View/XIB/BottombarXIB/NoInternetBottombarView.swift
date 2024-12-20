//
//  NoInternetBottombarView.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 02/08/24.
//

import UIKit

class NoInternetBottombarView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
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
    
    private func commonInit() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "NoInternetBottombarView", bundle: bundle)
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
                imageViewTopConstraint.constant = 30
                imageViewHeightConstraint.constant = 160
                imageViewWidthConstraint.constant = 160
                labelTopConstraint.constant = 0
                retryButtonTopConstraint.constant = 20
            case 2436, 1792, 2556, 2532:
                imageViewTopConstraint.constant = 40
                imageViewHeightConstraint.constant = 200
                imageViewWidthConstraint.constant = 200
                labelTopConstraint.constant = 20
                retryButtonTopConstraint.constant = 30
            case 2796, 2778, 2688:
                imageViewTopConstraint.constant = 40
                imageViewHeightConstraint.constant = 230
                imageViewWidthConstraint.constant = 230
                labelTopConstraint.constant = 20
                retryButtonTopConstraint.constant = 30
            default:
                imageViewTopConstraint.constant = 40
                imageViewHeightConstraint.constant = 200
                imageViewWidthConstraint.constant = 200
                labelTopConstraint.constant = 20
                retryButtonTopConstraint.constant = 30
            }
        }
    }
    
    @IBAction func retryButtonTapped(_ sender: UIButton) {
        onRetry?()
    }
}
