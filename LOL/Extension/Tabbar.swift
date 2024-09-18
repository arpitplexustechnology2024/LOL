//
//  CustomTabBar.swift
//  CustomTabbarController
//
//  Created by Arpit iOS Dev. on 13/07/24.
//

import UIKit

class CustomTabBar: UITabBar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 61
        return sizeThatFits
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var frame = self.frame
        frame.origin.y = self.superview!.frame.height - frame.height - 33.5
        frame.origin.x = 22
        frame.size.width = self.superview!.frame.width - 43
        self.frame = frame
        
        applyGradient(colors: [UIColor(hex: "#FA4957").cgColor, UIColor(hex: "#FD7E41").cgColor])
        
        roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 30)
        
        let screenHeight = UIScreen.main.nativeBounds.height
        let numberOfItems = CGFloat(items?.count ?? 1)
        var totalSpacing: CGFloat = 24 * (numberOfItems - 1)
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            switch screenHeight {
            case 1136, 1334, 1920, 2208:
                totalSpacing = 24 * (numberOfItems - 1)
            case 2436, 1792, 2556, 2532:
                totalSpacing = 26 * (numberOfItems - 1)
            case 2796, 2778, 2688:
                totalSpacing = 40 * (numberOfItems - 1)
            default:
                totalSpacing = 24 * (numberOfItems - 1)
            }
        }
        
        let tabBarItemWidth = (self.frame.width - totalSpacing) / numberOfItems
        
        var index = 0
        for item in subviews where item is UIControl {
            let xPosition = CGFloat(index) * (tabBarItemWidth + totalSpacing / (numberOfItems - 1))
            item.frame = CGRect(x: xPosition, y: item.frame.origin.y, width: tabBarItemWidth, height: item.frame.height)
            index += 1
        }
    }
    
    func applyGradient(colors: [CGColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
}

class CustomTabbarController : UITabBarController {
    
}
