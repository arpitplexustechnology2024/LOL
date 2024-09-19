//
//  AlertViewController.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 09/08/24.
//

import UIKit

// MARK: - Copy Link Alert
class CustomAlertViewController: UIViewController {
    
    var message: String?
    var link: String?
    var image: UIImage?
    
    private let containerView = UIView()
    private let imageView = UIImageView()
    private let messageLabel = UILabel()
    private let linkLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        setupContainerView()
        setupImageView()
        setupMessageLabel()
        setupLinkLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animatePresentation()
    }
    
    private func setupContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .systemGray6 : .white
        }
        containerView.layer.cornerRadius = 16
        containerView.layer.masksToBounds = true
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 230),
            containerView.heightAnchor.constraint(equalToConstant: 164)
        ])
    }
    
    private func setupImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        if let image = image {
            imageView.image = image
        }
        containerView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 22),
            imageView.widthAnchor.constraint(equalToConstant: 55),
            imageView.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    private func setupMessageLabel() {
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.textColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .white : .black
        }
        messageLabel.font = UIFont(name: "Lato-Bold", size: 18)
        containerView.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 17),
            messageLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15)
        ])
    }
    
    private func setupLinkLabel() {
        linkLabel.translatesAutoresizingMaskIntoConstraints = false
        linkLabel.text = link
        linkLabel.numberOfLines = 0
        linkLabel.textAlignment = .center
        linkLabel.font = UIFont(name: "Lato-SemiBold", size: 18)
        linkLabel.textColor = UIColor.gray
        containerView.addSubview(linkLabel)
        
        NSLayoutConstraint.activate([
            linkLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 5),
            linkLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            linkLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            linkLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15)
        ])
    }
    
    private func animatePresentation() {
        containerView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        containerView.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.containerView.alpha = 1
            self.containerView.transform = CGAffineTransform.identity
        })
    }
    
    func animateDismissal(completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.3, animations: {
            self.containerView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.containerView.alpha = 0
        }) { _ in
            completion?()
        }
    }
}

// MARK: - Purchase Failed Alert
class AlertViewController: UIViewController {
    
    var message: String?
    var link: String?
    var image: UIImage?
    
    private let containerView = UIView()
    private let imageView = UIImageView()
    private let messageLabel = UILabel()
    private let linkLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        setupContainerView()
        setupImageView()
        setupMessageLabel()
        setupLinkLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animatePresentation()
    }
    
    private func setupContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .systemGray6 : .white
        }
        containerView.layer.cornerRadius = 16
        containerView.layer.masksToBounds = true
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 230),
            containerView.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
    
    private func setupImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        if let image = image {
            imageView.image = image
        }
        containerView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 22),
            imageView.widthAnchor.constraint(equalToConstant: 55),
            imageView.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    private func setupMessageLabel() {
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.textColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .white : .black
        }
        messageLabel.font = UIFont(name: "Lato-Bold", size: 18)
        containerView.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 17),
            messageLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15)
        ])
    }
    
    private func setupLinkLabel() {
        linkLabel.translatesAutoresizingMaskIntoConstraints = false
        linkLabel.text = link
        linkLabel.numberOfLines = 0
        linkLabel.textAlignment = .center
        linkLabel.font = UIFont(name: "Lato-SemiBold", size: 18)
        linkLabel.textColor = UIColor.gray
        containerView.addSubview(linkLabel)
        
        NSLayoutConstraint.activate([
            linkLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 5),
            linkLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            linkLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            linkLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15)
        ])
    }
    
    private func animatePresentation() {
        containerView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        containerView.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.containerView.alpha = 1
            self.containerView.transform = CGAffineTransform.identity
        })
    }
    
    func animateDismissal(completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.3, animations: {
            self.containerView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.containerView.alpha = 0
        }) { _ in
            completion?()
        }
    }
}

