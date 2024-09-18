//
//  CustomSegment.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 30/07/24.
//

import UIKit

class GradientSegmentedControl: UISegmentedControl {
    
    private let gradientView = GradientView()
    
    override init(items: [Any]?) {
        super.init(items: items)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        selectedSegmentIndex = 0
        
        gradientView.isUserInteractionEnabled = false
        addSubview(gradientView)
        sendSubviewToBack(gradientView)
        
        setBackgroundImage(imageWithColor(color: .clear), for: .normal, barMetrics: .default)
        setBackgroundImage(imageWithColor(color: .clear), for: .selected, barMetrics: .default)
        setDividerImage(imageWithColor(color: .clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        
        updateGradientPosition()
    }
    
    @objc private func segmentChanged() {
        updateGradientPosition()
    }
    
    private func updateGradientPosition() {
        guard numberOfSegments > 0 else { return }
        
        let segmentWidth = bounds.width / CGFloat(numberOfSegments)
        let selectedSegmentIndex = CGFloat(self.selectedSegmentIndex)
        let xPos = segmentWidth * selectedSegmentIndex
        
        UIView.animate(withDuration: 0.3) {
            self.gradientView.frame = CGRect(x: xPos, y: 0, width: segmentWidth, height: self.bounds.height)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientPosition()
        gradientView.layer.cornerRadius = 0
        gradientView.clipsToBounds = false
    }
    
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
}


class GradientView: UIView {
    
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }
    
    private func setupGradient() {
        let startColor = UIColor(hex: "#FA4C56")
        let endColor = UIColor(hex: "#FC6949")
        
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
