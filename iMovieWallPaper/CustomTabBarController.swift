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

class CustomTabBarController: UITabBarController, HSBColorPickerDelegate, ColorPickerControllerDelegate {
    
    var canvasView: CanvasView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        let colorPickerController = loadColorPickerController()
        viewControllers = [colorPickerController]
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
