//
//  UIStoryboard+Storyboards.swift
//  kaopujinfu
//
//  Created by CPX on 09/06/2017.
//  Copyright © 2017 kaopujun. All rights reserved.
//

import UIKit

extension UIStoryboard {
    enum Storyboard: String {
        case main
        case tools
        
        var filename: String {
            return rawValue.capitalized
        }
    }
    
    convenience init(storybard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storybard.filename, bundle: bundle)
    }
    
    class func storyboard(_ storyboard: Storyboard, bundle: Bundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: storyboard.filename, bundle: bundle)
    }
    
    func instantiateViewController<T: UIViewController>() -> T where T: StoryboardIdentifiable {
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier)")
        }
        return viewController
    }
}
