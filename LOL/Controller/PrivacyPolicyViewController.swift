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
        localizeUI()
    }
    
    func setupUI() {
        self.privacyPolicyTextView.text = privacyPolicyTextSet().privacyPolicyText
        self.doneButton.layer.cornerRadius = doneButton.frame.height / 2
        self.doneButton.applyGradient(colors: [UIColor(hex: "#FA4957"), UIColor(hex: "#FD7E41")])
    }
    
    func localizeUI() {
        self.privacyPolicyLabel.text = NSLocalizedString("PrivacyTitleKey", comment: "")
        self.doneButton.setTitle(NSLocalizedString("PrivacyDoneBtnKey", comment: ""), for: .normal)
    }
    
    // MARK: - Done Button
    @IBAction func btnDoneTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Back Button
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
