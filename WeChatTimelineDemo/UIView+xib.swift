//
//  UIView+xib.swift
//  kaopujinfu
//
//  Created by CPX on 10/06/2017.
//  Copyright © 2017 kaopujun. All rights reserved.
//

import UIKit

extension UIView {
    class func fromNib<T: UIView>() -> T? {
        guard let view = Bundle.main.loadNibNamed(String(describing: T.self), owner: self, options: nil)?[0] as? T else {
            return nil
        }
        return view
    }
}
