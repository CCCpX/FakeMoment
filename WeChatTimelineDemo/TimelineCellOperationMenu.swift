//
//  TimelineCellOperationMenu.swift
//  WeChatTimelineDemo
//
//  Created by CPX on 15/08/2017.
//  Copyright © 2017 CPX. All rights reserved.
//

import Foundation
import UIKit

protocol TimelineCellOperationMenuDelegate {
    func likeButtonClickedOperation()
    func commentButtonClickedOperation()
}

class TimelineCellOperationMenu: UIView {
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    var delegate: TimelineCellOperationMenuDelegate?
    
    class func timelineCellOperationMenu() -> TimelineCellOperationMenu? {
        return fromNib()
    }
    
    var isShow = false {
        didSet(oldValue) {
            guard oldValue != isShow else { return }
            self.bounds.size.width = isShow ? 80 : 0
            UIView.animate(withDuration: 0.2, animations: {
                self.layoutIfNeeded()
            }, completion: nil)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
    }
    
    @IBAction func likeBtnDidTouchUpInside(_ sender: UIButton) {
        delegate?.likeButtonClickedOperation()
        isShow = false
    }
    
    @IBAction func commentBtnDidTouchUpInside(_ sender: UIButton) {
        delegate?.commentButtonClickedOperation()
        isShow = false
    }
    
}
