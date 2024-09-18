//
//  PrivacyPolicyViewController.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 31/07/24.
//

import UIKit

class PrivacyPolicyViewController: UIViewController {
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var privacyPolicyTextView: UITextView!
    
    @IBOutlet weak var privacyPolicyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        
        // Privacy Policy Text setup
        self.privacyPolicyTextView.text = privacyPolicyTextSet().privacyPolicyText
        
        // Done Button Gradient Color
        self.doneButton.layer.cornerRadius = doneButton.frame.height / 2
        self.doneButton.applyGradient(colors: [UIColor(hex: "#FA4957"), UIColor(hex: "#FD7E41")])
        
        // Localize UI elements
        localizeUI()
    }
    
    func localizeUI() {
        self.privacyPolicyLabel.text = NSLocalizedString("PrivacyTitleKey", comment: "")
        self.doneButton.setTitle(NSLocalizedString("PrivacyDoneBtnKey", comment: ""), for: .normal)
    }
    
    @IBAction func btnDoneTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
