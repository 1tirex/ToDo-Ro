//
//  SceneDelegate.swift
//  toDo-Ro
//
//  Created by Илья on 20.12.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = UINavigationController(rootViewController: StartViewController())
        window?.makeKeyAndVisible()
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//
//        if let loggedUsername = UserDefaults.standard.string(forKey: "username") {
//            let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
//            window?.rootViewController = mainTabBarController
//        } else {
//            let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
//            window?.rootViewController = loginNavController
//        }
    }
    
    func changeRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard let window = window else { return }
        
        window.rootViewController = vc
        
        UIView.transition(with: window,
                             duration: 0.5,
                          options: [.transitionFlipFromLeft],
                             animations: nil,
                             completion: nil)
    }
}

