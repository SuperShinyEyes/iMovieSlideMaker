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

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate, UIGestureRecognizerDelegate, HSBColorPickerDelegate, ColorPickerControllerDelegate {
    
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
        
        /// Set UITabBarControllerDelegate
        self.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tap.delegate = self
        view.addGestureRecognizer(tap)
        
    }
    
    func tapped(sender: AnyObject) {
        setTabBarVisible(visible: !tabBarIsVisible(), animated: true)
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
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        GeneralHelper.log("Selected: \(selectedIndex)")
        if selectedIndex == 1 {
            takeScreenShot(view: canvasView)
        }
    }
    
}

extension UIViewController {
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer, uvc: UIViewController) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func takeScreenShot(view: UIView) {
        let screenShot = UIImage(view: view)
        //        let data = UIImagePNGRepresentation(screenShot)
        //        let documentsDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        UIImageWriteToSavedPhotosAlbum(screenShot, self, #selector(image), nil)
        //        let writePath = NSURL(fileURLWithPath: documentsDir).appendingPathComponent("myimage.png")
        //        do {
        //            try data!.write(to: writePath!, options: .atomic)
        //        } catch let error as NSError {
        //            GeneralHelper.log(error.localizedDescription)
        //        }
        
    }
}

extension UITabBarController {
    
    func setTabBarVisible(visible:Bool, animated:Bool) {
        
        // bail if the current state matches the desired state
        if (tabBarIsVisible() == visible) { return }
        
        // get a frame calculation ready
        let frame = self.tabBar.frame
        let height = frame.size.height
        let offsetY = (visible ? -height : height)
        
        // animate the tabBar
        UIView.animate(withDuration: animated ? 0.3 : 0.0) {
            self.tabBar.frame = frame.offsetBy(dx: 0, dy: offsetY)
            self.view.frame = CGRect(x:0, y:0, width: self.view.frame.width, height: self.view.frame.height + offsetY)
            self.view.setNeedsDisplay()
            self.view.layoutIfNeeded()
        }
    }
    
    func tabBarIsVisible() ->Bool {
        return self.tabBar.frame.origin.y < self.view.frame.maxY
    }
}
