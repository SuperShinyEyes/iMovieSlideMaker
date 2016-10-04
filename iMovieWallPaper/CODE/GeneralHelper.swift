//
//  GeneralHelper.swift
//  iMovieWallPaper
//
//  Created by Park Seyoung on 03/10/16.
//  Copyright © 2016 Park Seyoung. All rights reserved.
//

import Foundation
import CoreGraphics

struct GeneralHelper {
    //    #if DEBUG
    static func log(_ message: String, filename: String = #file, line: Int = #line, function: String = #function) {
        Swift.print("\((filename as NSString).lastPathComponent):\(line) \(function):\r\(message)")
    }
    //    #endif
}

enum AspectRatio {
    case HD(CGSize)
    case FullHD(CGSize)
    case UHD4K(CGSize)
    
    
    /// scale is for the third parameter in UIGraphicsBeginImageContextWithOptions
    var scale: CGFloat {
        get {
            switch self {
            case .HD(let size):
                return 720 / size.width
            case .FullHD(let size):
                return 1080 / size.width
            case .UHD4K(let size):
                return 2160 / size.width
            }
        }
    }
    
}
