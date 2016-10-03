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

@IBDesignable
class HSBColorPicker : UIView {
    /*
     This: http://stackoverflow.com/questions/27208386/simple-swift-color-picker-popover-ios
     Other: https://github.com/Christian1313/iOS_Swift_ColorPicker
     */
    
    weak internal var delegate: HSBColorPickerDelegate?
    let saturationExponentTop:Float = 2.0
    let saturationExponentBottom:Float = 1.3

    @IBInspectable var elementSize: CGFloat = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    fileprivate func initialize() {
        GeneralHelper.log("   HSBColorPicker.initialize()")
        self.clipsToBounds = true
        let touchGesture = UILongPressGestureRecognizer(target: self, action: #selector(touchedColor))
        touchGesture.minimumPressDuration = 0
        touchGesture.allowableMovement = CGFloat.greatestFiniteMagnitude
        self.addGestureRecognizer(touchGesture)
        GeneralHelper.log("   HSBColorPicker.initialize() done")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        GeneralHelper.log("   HSBColorPicker.init() done")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        for y in stride(from: (0 as CGFloat), to: rect.height, by: elementSize) {
            
            var saturation = y < rect.height / 2.0 ? CGFloat(2 * y) / rect.height : 2.0 * CGFloat(rect.height - y) / rect.height
            saturation = CGFloat(powf(Float(saturation), y < rect.height / 2.0 ? saturationExponentTop : saturationExponentBottom))
            let brightness = y < rect.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(rect.height - y) / rect.height
            
            for x in stride(from: (0 as CGFloat), to: rect.width, by: elementSize) {
                let hue = x / rect.width
                let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
                context!.setFillColor(color.cgColor)
                context!.fill(CGRect(x:x, y:y, width:elementSize,height:elementSize))
            }
        }
    }
    
    func getColorAtPoint(point:CGPoint) -> UIColor {
        let roundedPoint = CGPoint(x:elementSize * CGFloat(Int(point.x / elementSize)),
                                   y:elementSize * CGFloat(Int(point.y / elementSize)))
        var saturation = roundedPoint.y < self.bounds.height / 2.0 ? CGFloat(2 * roundedPoint.y) / self.bounds.height
            : 2.0 * CGFloat(self.bounds.height - roundedPoint.y) / self.bounds.height
        saturation = CGFloat(powf(Float(saturation), roundedPoint.y < self.bounds.height / 2.0 ? saturationExponentTop : saturationExponentBottom))
        let brightness = roundedPoint.y < self.bounds.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(self.bounds.height - roundedPoint.y) / self.bounds.height
        let hue = roundedPoint.x / self.bounds.width
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
    
    func getPointForColor(color:UIColor) -> CGPoint {
        var hue:CGFloat=0;
        var saturation:CGFloat=0;
        var brightness:CGFloat=0;
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil);
        
        var yPos:CGFloat = 0
        let halfHeight = (self.bounds.height / 2)
        
        if (brightness >= 0.99) {
            let percentageY = powf(Float(saturation), 1.0 / saturationExponentTop)
            yPos = CGFloat(percentageY) * halfHeight
        } else {
            //use brightness to get Y
            yPos = halfHeight + halfHeight * (1.0 - brightness)
        }
        
        let xPos = hue * self.bounds.width
        
        return CGPoint(x: xPos, y: yPos)
    }
    
    func touchedColor(gestureRecognizer: UILongPressGestureRecognizer){
        let point = gestureRecognizer.location(in: self)
        let color = getColorAtPoint(point: point)
        
        self.delegate?.HSBColorColorPickerTouched(sender: self, color: color, point: point, state:gestureRecognizer.state)
    }
}

class CanvasView: UIView {
    
    
    override init(frame: CGRect) {
        let HDRatio: CGFloat = 16/9
        var HDframe: CGRect
        if 1080.0 / frame.width * frame.height > 1920.0 {
            HDframe = CGRect(x: 0, y: 0, width: frame.height / HDRatio , height: frame.height)
        } else {
            HDframe = CGRect(x: 0, y: 0, width: frame.width , height: HDRatio * frame.width)
        }
        
//        super.init(frame: HDframe)
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CanvasViewController: UIViewController, HSBColorPickerDelegate {

    var colorPicker: HSBColorPicker?
    var colorCanvasView: CanvasView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadColorPicker()
        loadButton()
        loadColorCanvasView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        GeneralHelper.log("Width: \(view.bounds.width)\t Height: \(view.bounds.height)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadColorCanvasView() {
        colorCanvasView = CanvasView()
        colorCanvasView?.backgroundColor = UIColor.black
        view.addSubview(colorCanvasView!)
        view.bringSubview(toFront: colorCanvasView!)
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
        
        
        if let colorPicker = colorPicker {
            colorPicker.delegate = self
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
        colorCanvasView!.backgroundColor = color
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
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
    
    func takeScreenShot() {
        let screenShot = UIImage(view: view)
        let data = UIImagePNGRepresentation(screenShot)
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

extension UIImage {
    convenience init(view: UIView) {
        let scale = UIScreen.main.scale
        view.frame.width
        GeneralHelper.log("width: \(view.frame.width)\t height: \(view.frame.height)\t scale: \(scale)")
        UIGraphicsBeginImageContextWithOptions(view.frame.size, true, 00.0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
    }
}
