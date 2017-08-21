//
//  KPImageView.swift
//  WeChatTimelineDemo
//
//  Created by CPX on 21/08/2017.
//  Copyright © 2017 CPX. All rights reserved.
//

import Foundation
import UIKit

class KPImageView: UIImageView {
    
    override var intrinsicContentSize: CGSize {
        if (self.image != nil) {
            return constrainedSize
        } else {
            return .zero
        }
    }
    
    var constrainedSize: CGSize = .zero {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
}
