//
//  CanvasView.swift
//  iMovieWallPaper
//
//  Created by Park Seyoung on 04/10/16.
//  Copyright © 2016 Park Seyoung. All rights reserved.
//

import UIKit

class CanvasView: UIView {
    
    
    init(frame: CGRect, gestureDelegate: CustomTabBarController) {
        let HDRatio: CGFloat = 16/9
        var HDframe: CGRect
        if 1080.0 / frame.width * frame.height > 1920.0 {
            GeneralHelper.log("If")
            HDframe = CGRect(x: 0, y: 0, width: frame.height / HDRatio , height: frame.height)
        } else {
            GeneralHelper.log("else: \(1080.0 / frame.width * frame.height == 1920.0)")
            HDframe = CGRect(x: 0, y: 0, width: frame.width , height: HDRatio * frame.width)
        }
        
        super.init(frame: HDframe)
        
        let tap = UITapGestureRecognizer(target: gestureDelegate, action: #selector(gestureDelegate.tapped))
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

