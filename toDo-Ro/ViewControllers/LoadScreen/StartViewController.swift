//
//  StartViewController.swift
//  toDo-Ro
//
//  Created by Дмитрий Собин on 29.12.22.
//

import UIKit
import SwiftyGif

final class StartViewController: UIViewController {

    private let logoAnimationView = LogoAnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(logoAnimationView)
        self.logoAnimationView.pinEdgesToSuperView()
        self.logoAnimationView.logoGifImageView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.logoAnimationView.logoGifImageView.startAnimatingGif()
    }
}

extension StartViewController: SwiftyGifDelegate {
    func gifDidStop(sender: UIImageView) {
        self.logoAnimationView.isHidden = true
        
        //        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarcontroller") as! UITabBarController
        
        let taskVC = UINavigationController(rootViewController: TaskListViewController())
        //        UIApplication.shared.windows.first?.rootViewController = taskVC
        //        UIApplication.shared.windows.first?.makeKeyAndVisible()
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(taskVC)
    }
}
