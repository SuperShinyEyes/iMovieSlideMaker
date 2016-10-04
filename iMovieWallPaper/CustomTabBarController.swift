//
//  CustomTabBarController.swift
//  iMovieWallPaper
//
//  Created by Park Seyoung on 04/10/16.
//  Copyright © 2016 Park Seyoung. All rights reserved.
//

import UIKit

protocol ColorPickerControllerDelegate {
    func setColorPickerDelegate(colorPicker: HSBColorPicker?)
}

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate, HSBColorPickerDelegate, ColorPickerControllerDelegate {
    
    var canvasView: CanvasView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let colorPickerController = loadColorPickerController()
        colorPickerController.tabBarItem = UITabBarItem(title: "colors", image: UIImage(named: "colors"), tag: 0)
        
        let uv = UIViewController()
        uv.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
//        let navController = UINavigationController(rootViewController: colorPickerController)
//        
//        navController.tabBarItem.image = UIImage(named: "colors")
        viewControllers = [colorPickerController, uv]
        loadCanvasView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    fileprivate func loadColorPickerController() -> ColorPickerController {
        let colorPickerController = ColorPickerController()
        colorPickerController.delegate = self
//        if let cp = colorPickerController.colorPicker {
//            cp.delegate = self
//            print("SUCCESS")
//        } else {
//            GeneralHelper.log("   >>> FAIL")
//        }
        return colorPickerController
    }
    
    fileprivate func loadCanvasView() {
        canvasView = CanvasView(frame: view.bounds)
        canvasView.backgroundColor = UIColor.black
        view.addSubview(canvasView!)
        view.sendSubview(toBack: canvasView)
    }
    
    func setColorPickerDelegate(colorPicker: HSBColorPicker?) {
        if let cp = colorPicker {
            cp.delegate = self
            print("SUCCESS")
        } else {
            GeneralHelper.log("   >>> FAIL")
        }
        
//        colorPicker.delegate = self
    }
    
    func HSBColorColorPickerTouched(sender:HSBColorPicker, color:UIColor, point:CGPoint, state:UIGestureRecognizerState) {
        //        self.view.backgroundColor = color
        //        colorPicker!.removeFromSuperview()
        GeneralHelper.log("change color")
        canvasView.backgroundColor = color
    }
}
