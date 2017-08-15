//
//  UIViewController+StoryboardIdentifiable.swift
//  kaopujinfu
//
//  Created by CPX on 09/06/2017.
//  Copyright © 2017 kaopujun. All rights reserved.
//

import UIKit

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

extension UIViewController: StoryboardIdentifiable {}
