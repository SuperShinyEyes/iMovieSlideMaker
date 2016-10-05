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
    
    var canvasView: CanvasView! { get set }
}

class ColorPickerController: UIViewController {

    var colorPicker: HSBColorPicker?
    var canvasView: CanvasView?
    var delegate: ColorPickerControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadColorPicker()
        delegate?.setColorPickerDelegate(colorPicker: colorPicker)
    }
    
    func loadColorPicker() {
        let width = view.bounds.width * 0.6
        let height = view.bounds.height * 0.6
        let frame = CGRect(origin:  CGPoint(x: (view.bounds.width - width) / 2, y: (view.bounds.height - height) / 2),
               size: CGSize(width: width, height: height))
        
        colorPicker = HSBColorPicker(frame: frame)
        view.addSubview(colorPicker!)

    }

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
