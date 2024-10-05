//
//  PrivacyPolicyViewController.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 31/07/24.
//

import UIKit
import WebKit

class PrivacyPolicyViewController: UIViewController {
    
    @IBOutlet weak var privacyPolicyWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        if let url = URL(string: "https://lolcards.link/privacy-policy") {
            let request = URLRequest(url: url)
            privacyPolicyWebView.load(request)
        }
    }
}
