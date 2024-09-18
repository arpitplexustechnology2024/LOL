//
//  Skeleton.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 10/08/24.
//

import UIKit

class SkeletonCollectionViewCell: UICollectionViewCell {
    
    private let smallImageView = UIView()
    private let largeImageView = UIView()
    private let gradientLayerSmall = CAGradientLayer()
    private let gradientLayerLarge = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSkeleton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSkeleton()
    }
    
    private func setupSkeleton() {
        // Setup the small image view
        smallImageView.backgroundColor = UIColor.systemGray4.withAlphaComponent(0.5)
        smallImageView.clipsToBounds = true
        contentView.addSubview(smallImageView)
        
        // Setup the large image view
        largeImageView.backgroundColor = UIColor.systemGray4.withAlphaComponent(0.5)
        largeImageView.clipsToBounds = true
        contentView.addSubview(largeImageView)
        
        // Layout constraints for small image view
        smallImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            smallImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            smallImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            smallImageView.widthAnchor.constraint(equalToConstant: 35),
            smallImageView.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        // Layout constraints for large image view
        largeImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            largeImageView.leadingAnchor.constraint(equalTo: smallImageView.trailingAnchor, constant: 10),
            largeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            largeImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            largeImageView.heightAnchor.constraint(equalToConstant: 35),
        ])
        
        // Setup gradient layers for shimmer effect
        setupGradient(for: smallImageView, gradientLayer: gradientLayerSmall)
        setupGradient(for: largeImageView, gradientLayer: gradientLayerLarge)
    }
    
    private func setupGradient(for view: UIView, gradientLayer: CAGradientLayer) {
        gradientLayer.colors = [
            UIColor.systemGray4.withAlphaComponent(0.5).cgColor,
            UIColor.white.withAlphaComponent(0.5).cgColor,
            UIColor.systemGray4.withAlphaComponent(0.5).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.frame = view.bounds
        gradientLayer.add(createShimmerAnimation(), forKey: "shimmer")
        view.layer.addSublayer(gradientLayer)
    }
    
    private func createShimmerAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.0, 0.25]
        animation.toValue = [0.75, 1.0, 1.0]
        animation.duration = 1.5
        animation.repeatCount = .infinity
        return animation
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Ensure gradient layers are resized properly
        gradientLayerSmall.frame = smallImageView.bounds
        gradientLayerLarge.frame = largeImageView.bounds
    }
}

class SkeletonInboxCollectionViewCell: UICollectionViewCell {
    
    private let largeImageView = UIView()
    private let gradientLayerLarge = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSkeleton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSkeleton()
    }
    
    private func setupSkeleton() {
        
        // Setup the large image view
        largeImageView.backgroundColor = UIColor.systemGray4.withAlphaComponent(0.5)
        largeImageView.clipsToBounds = true
        largeImageView.layer.cornerRadius = 16
        contentView.addSubview(largeImageView)
        
        // Layout constraints for large image view
        largeImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            largeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            largeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            largeImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            largeImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        setupGradient(for: largeImageView, gradientLayer: gradientLayerLarge)
    }
    
    private func setupGradient(for view: UIView, gradientLayer: CAGradientLayer) {
        gradientLayer.colors = [
            UIColor.systemGray4.withAlphaComponent(0.5).cgColor,
            UIColor.white.withAlphaComponent(0.5).cgColor,
            UIColor.systemGray4.withAlphaComponent(0.5).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.frame = view.bounds
        gradientLayer.add(createShimmerAnimation(), forKey: "shimmer")
        view.layer.addSublayer(gradientLayer)
    }
    
    private func createShimmerAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.0, 0.25]
        animation.toValue = [0.75, 1.0, 1.0]
        animation.duration = 1.5
        animation.repeatCount = .infinity
        return animation
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayerLarge.frame = largeImageView.bounds
    }
}

