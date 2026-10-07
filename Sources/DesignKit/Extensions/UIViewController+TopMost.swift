//
//  UIViewController+TopMost.swift
//  DesignKit
//

import UIKit

extension UIViewController {
    static func topMostViewController() -> UIViewController? {
        if let keyWindowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            let keyWindow = keyWindowScene.windows.first(where: { $0.isKeyWindow })
            return keyWindow?.rootViewController?.topMostViewController()
        }
        return nil
    }
    func topMostViewController() -> UIViewController? {
        if let navigationController = self as? UINavigationController {
            return navigationController.topViewController?.topMostViewController()
        }
        else if let tabBarController = self as? UITabBarController {
            if let selectedViewController = tabBarController.selectedViewController {
                return selectedViewController.topMostViewController()
            }
            
            return tabBarController.topMostViewController()
        }
        else if let presentedViewController = self.presentedViewController {
            return presentedViewController.topMostViewController()
        }
        else {
            return self
        }
    }
}
