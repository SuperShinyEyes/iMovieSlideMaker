//
//  ViewController.swift
//  iMovieWallPaper
//
//  Created by Park Seyoung on 03/10/16.
//  Copyright © 2016 Park Seyoung. All rights reserved.
//

import UIKit

protocol HSBColorPickerDelegate : NSObjectProtocol {
    func HSBColorColorPickerTouched(sender:HSBColorPicker, color:UIColor, point:CGPoint, state:UIGestureRecognizerState)
}

class ColorPickerController: UIViewController, HSBColorPickerDelegate {

    var colorPicker: HSBColorPicker?
    var canvasView: CanvasView?
    var delegate: ColorPickerControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        loadCanvasView()
        loadColorPicker()
        loadButton()
        delegate?.setColorPickerDelegate(colorPicker: colorPicker)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        GeneralHelper.log("Width: \(view.bounds.width)\t Height: \(view.bounds.height)")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadCanvasView() {
        canvasView = CanvasView(frame: view.bounds)
        canvasView?.backgroundColor = UIColor.black
        view.addSubview(canvasView!)
//        view.bringSubview(toFront: colorCanvasView!)
//        colorCanvasView.
    }
    
    func loadColorPicker() {
        let width = view.bounds.width * 0.6
        let height = view.bounds.height * 0.6
        
        let frame = CGRect(origin:  CGPoint(x: (view.bounds.width - width) / 2, y: (view.bounds.height - height) / 2),
               size: CGSize(width: width, height: height))
        
        GeneralHelper.log("Initialize color picker")
        colorPicker = HSBColorPicker(frame: frame)
        GeneralHelper.log("color picker Initialized")
        
//        
        if let colorPicker = colorPicker {
//            colorPicker.delegate = self
            view.addSubview(colorPicker)
            print("SUCCESS")
        } else {
            print(">>> FAIL")
        }
    }
    
    func loadButton() {
        let width = view.bounds.width * 0.3
        let height = view.bounds.height * 0.1
        let frame = CGRect(origin:  CGPoint(x: (view.bounds.width - width) / 2, y: view.bounds.height - height * 2),
                           size: CGSize(width: width, height: height))
        let button = UIButton(frame: frame)
        button.setTitle("Save", for: .normal)
        button.addTarget(self, action: #selector(takeScreenShot), for: .touchUpInside)
        button.backgroundColor = UIColor.blue
        view.addSubview(button)
    }

    func HSBColorColorPickerTouched(sender:HSBColorPicker, color:UIColor, point:CGPoint, state:UIGestureRecognizerState) {
//        self.view.backgroundColor = color
//        colorPicker!.removeFromSuperview()
        GeneralHelper.log("change color")
        canvasView!.backgroundColor = color
    }
    
//    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
//        if let error = error {
//            // we got back an error!
//            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .default))
//            present(ac, animated: true)
//        } else {
//            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .default))
//            present(ac, animated: true)
//        }
//    }
//    
//    func takeScreenShot() {
//        let screenShot = UIImage(view: canvasView!)
////        let data = UIImagePNGRepresentation(screenShot)
////        let documentsDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//        
//        UIImageWriteToSavedPhotosAlbum(screenShot, self, #selector(image), nil)
////        let writePath = NSURL(fileURLWithPath: documentsDir).appendingPathComponent("myimage.png")
////        do {
////            try data!.write(to: writePath!, options: .atomic)
////        } catch let error as NSError {
////            GeneralHelper.log(error.localizedDescription)
////        }
//
//    }
}




extension UIImage {
    convenience init(view: UIView) {

        let scale = AspectRatio.HD(view.frame.size).scale
        GeneralHelper.log("width: \(view.frame.width)\t height: \(view.frame.height)\t scale: \(scale) \nwidth: \(view.frame.width * scale)\t height: \(view.frame.height * scale)")
        
        UIGraphicsBeginImageContextWithOptions(view.frame.size, true, scale)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
    }
}
