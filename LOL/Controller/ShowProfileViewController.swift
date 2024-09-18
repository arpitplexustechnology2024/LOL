//
//  ShowProfileViewController.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 10/09/24.
//

import UIKit

class ShowProfileViewController: UIViewController {
    
    @IBOutlet var views: [UIView]!
    @IBOutlet var imageViews: [UIImageView]!
    @IBOutlet var labelViews: [UIView]!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var hint: String?
    var location: String?
    var country: String?
    var time: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hintLabel.text = hint
        locationLabel.text = location
        countryLabel.text = country
        timeLabel.text = time
        
        for view in views {
            view.layer.cornerRadius = 12
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOpacity = 0.2
            view.layer.shadowOffset = CGSize(width: 0, height: 2)
            view.layer.shadowRadius = 4
        }
        
        for imageView in imageViews {
            imageView.layer.cornerRadius = 12
            imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            imageView.clipsToBounds = true
        }
        
        for labelView in labelViews {
            labelView.layer.cornerRadius = 12
            labelView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            labelView.clipsToBounds = true
        }
    }
}
