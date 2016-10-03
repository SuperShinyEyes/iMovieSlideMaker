//
//  GeneralHelper.swift
//  iMovieWallPaper
//
//  Created by Park Seyoung on 03/10/16.
//  Copyright © 2016 Park Seyoung. All rights reserved.
//

import Foundation

struct GeneralHelper {
    //    #if DEBUG
    static func log(_ message: String, filename: String = #file, line: Int = #line, function: String = #function) {
        Swift.print("\((filename as NSString).lastPathComponent):\(line) \(function):\r\(message)")
    }
    //    #endif
}
