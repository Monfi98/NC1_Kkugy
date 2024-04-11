//
//  TabBarViewController.swift
//  Kkugy
//
//  Created by 신승재 on 4/11/24.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.barTintColor = UIColor.white
        self.tabBar.isTranslucent = true
        self.tabBar.backgroundColor = UIColor.white.withAlphaComponent(0.65)
    }

}
