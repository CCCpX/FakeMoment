//
//  UIImage+Color.swift
//  WeChatTimelineDemo
//
//  Created by CPX on 16/08/2017.
//  Copyright © 2017 CPX. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    static func imageWithColor(_ color: UIColor) -> UIImage {
        let size = CGSize(width: 1, height: 1)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
