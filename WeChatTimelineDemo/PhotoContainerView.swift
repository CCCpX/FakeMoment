//
//  PhotoContainerView.swift
//  WeChatTimelineDemo
//
//  Created by CPX on 15/08/2017.
//  Copyright © 2017 CPX. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class PhotoContainerView: UIView {
    
    /// [对外接口]
    var picPathArray: [String]? {
        didSet {
            if let picArr = picPathArray {
                for index in picArr.count..<imageViewArray.count {
                    let imageView = imageViewArray[index]
                    imageView.isHidden = true
                }
            }
            
            guard let picPathArray = picPathArray, picPathArray.count > 0 else {
//                self.isHidden = true
                if let constraintH = (self.constraints.filter{$0.firstAttribute == .height}.first) {
                    constraintH.constant = 0
                }
                if let constraintW = (self.constraints.filter{$0.firstAttribute == .width}.first) {
                    constraintW.constant = 0
                }
                return
            }
            NSLayoutConstraint.activate(self.constraints)
            self.isHidden = false
            
            let itemW = itemWidth(for: picPathArray)
            var itemH: CGFloat = 0
            if picPathArray.count == 1 {
                if let url = URL(string: picPathArray[0]) {
                    KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, url) in
                        if let img = image {
                            let height = img.size.height / img.size.width * CGFloat(itemW)
                            itemH = height
                        }
                    })
                }
            } else {
                itemH = CGFloat(itemW)
            }
            
            let perRowItemCount = perRowCount(for: picPathArray)
            let margin: CGFloat = 5
            
            for (idx, path) in picPathArray.enumerated() {
                let columnIndex: CGFloat = CGFloat(idx % perRowItemCount)
                let rownIndex: CGFloat = CGFloat(idx / perRowItemCount)
                let imageView = imageViewArray[idx]
                imageView.isHidden = false
                if let url = URL(string: path) {
                    KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, url) in
                        imageView.image = image
                        imageView.frame = CGRect(x: columnIndex * (CGFloat(itemW) + margin), y: rownIndex * (itemH + margin), width: CGFloat(itemW), height: itemH)
                    })
                }
            }
            let count = CGFloat(perRowItemCount)
            let w: CGFloat = count * CGFloat(itemW) + (count - CGFloat(1)) * margin
            let columnCount = CGFloat(ceilf(Float(picPathArray.count) / Float(perRowItemCount)))
            let h = columnCount * itemH + (columnCount - CGFloat(1)) * margin
//            print("photoContainerH:\(h), photoContainerW:\(w)")
            if let constraintH = (self.constraints.filter{$0.firstAttribute == .height}.first) {
                constraintH.constant = h
            }
            if let constraintW = (self.constraints.filter{$0.firstAttribute == .width}.first) {
                constraintW.constant = w
            }
        }
    }
    
    fileprivate var imageViewArray = [UIImageView]()    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        translatesAutoresizingMaskIntoConstraints = false
        setUp()
        self.heightAnchor.constraint(equalToConstant: 0).isActive = true
        self.widthAnchor.constraint(equalToConstant: 0).isActive = true
    }
    
    private func setUp() {
        var temp = [UIImageView]()
        for index in 0..<9 {
            let imageView = UIImageView()
            addSubview(imageView)
            imageView.isUserInteractionEnabled = true
            imageView.tag = index
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapImageView(_:)))
            imageView.addGestureRecognizer(tap)
            temp.append(imageView)
        }
        imageViewArray = temp
    }
    
    @objc private func tapImageView(_ gesture: UITapGestureRecognizer) {
        if let imageView = gesture.view as? UIImageView {
            print("tapped imageView with index\(imageView.tag)")
        }
    }
    
    /// 缩略图显示大小
    private func itemWidth(for picArray: [String]) -> Float {
        if picArray.count == 1 {
            return 120
        } else {
            let w: Float = UIScreen.main.bounds.size.width > 320 ? 80 : 70
            return w
        }
    }
    /// 九宫格图片排列规则
    private func perRowCount(for picArray: [String]) -> Int {
        if picArray.count < 3 {
            return picArray.count
        } else if picArray.count <= 4 {
            return 2
        } else {
            return 3
        }
    }
    
}
