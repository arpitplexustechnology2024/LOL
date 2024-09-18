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
        case shareAction       = "ShareAction"
    }
    
    var window: UIWindow?
    var savedShortCutItem: UIApplicationShortcutItem!
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        ApplicationDelegate.shared.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
        if let shortcutItem = connectionOptions.shortcutItem {
            savedShortCutItem = shortcutItem
        }
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        for urlContext in URLContexts {
            ApplicationDelegate.shared.application(UIApplication.shared, open: urlContext.url, options: [:])
        }
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
            case .shareAction:
                self.triggerShareSheet()
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
    
    func triggerShareSheet() {
        let appURL = URL(string: "https://apps.apple.com/app/id639191551")!
        let shareController = UIActivityViewController(activityItems: [appURL], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let tempWindow = UIWindow(windowScene: windowScene)
            tempWindow.rootViewController = UIViewController()
            tempWindow.windowLevel = UIWindow.Level.alert + 1
            tempWindow.makeKeyAndVisible()
            
            tempWindow.rootViewController?.present(shareController, animated: true, completion: {
                shareController.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in
                    tempWindow.isHidden = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil)
                    }
                }
            })
        }
    }
}
