//
//  CustomTabBarController.swift
//  iMovieWallPaper
//
//  Created by Park Seyoung on 04/10/16.
//  Copyright © 2016 Park Seyoung. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let canvasViewController = CanvasViewController()
        viewControllers = [canvasViewController]
    }
}
