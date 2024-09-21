//
//  SceneDelegate.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 31/07/24.
//

import UIKit
import FBSDKCoreKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    enum ActionType: String {
        case sendMessageAction = "SendMessageAction"
        case InboxAction       = "InboxAction"
        case moreAction        = "MoreAction"
    }
    
    var window: UIWindow?
    var savedShortCutItem: UIApplicationShortcutItem!
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        if let shortcutItem = connectionOptions.shortcutItem {
            savedShortCutItem = shortcutItem
        }
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        
        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        if savedShortCutItem != nil {
            _ = handleShortCutItem(shortcutItem: savedShortCutItem)
            savedShortCutItem = nil
        }
        // Call checkForUpdate when the scene becomes active
        (UIApplication.shared.delegate as? AppDelegate)?.checkForUpdate()
    }
    
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        let handled = handleShortCutItem(shortcutItem: shortcutItem)
        completionHandler(handled)
    }
    
    func handleShortCutItem(shortcutItem: UIApplicationShortcutItem) -> Bool {
        if let actionTypeValue = ActionType(rawValue: shortcutItem.type) {
            switch actionTypeValue {
            case .sendMessageAction:
                self.navigateToLaunchVC(actionKey: "SendMessageActionKey")
            case .InboxAction:
                self.navigateToLaunchVC(actionKey: "InboxActionKey")
            case .moreAction:
                self.navigateToLaunchVC(actionKey: "MoreActionKey")
            }
        }
        return true
    }
    
    func navigateToLaunchVC(actionKey: String) {
        if let navVC = window?.rootViewController as? UINavigationController,
           let launchVC = navVC.viewControllers.first as? LaunchViewController {
            launchVC.passedActionKey = actionKey
        }
    }
}
