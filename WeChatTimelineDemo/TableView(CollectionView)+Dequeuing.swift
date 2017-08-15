//
//  TableView(CollectionView)+Dequeuing.swift
//  kaopujinfu
//
//  Created by CPX on 10/06/2017.
//  Copyright © 2017 kaopujun. All rights reserved.
//

import UIKit

protocol CellConfigurable: class {
    associatedtype Controller
    var cellController: Controller? { get set }
}

/// Cell需遵循此协议, 才能使用下面的的`register()`方法
protocol Reuseable: class {
    static var reuseIdentifier: String { get }
}

extension Reuseable where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    static var nibName: String {
        return String(describing: self)
    }
}

/// 注册cell, 优先从nib注册
extension UITableView {
    func register<T: UITableViewCell>(_: T.Type) where T: Reuseable {
        
        let path = Bundle.main.path(forResource: T.nibName, ofType: "nib")
        if path?.isEmpty ?? true {
            register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
            return
        }
        
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReuseableCell<T: UITableViewCell>(indexPath: IndexPath) -> T where T: Reuseable {
        return self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
}

extension UICollectionView {
    func register<T: UICollectionViewCell>(_: T.Type) where T: Reuseable {
        let path = Bundle.main.path(forResource: T.nibName, ofType: "nib")
        if path?.isEmpty ?? true {
            register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
            return
        }
        
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReuseableCell<T: UICollectionViewCell>(indexPath: IndexPath) -> T where T: Reuseable {
        return self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
}
