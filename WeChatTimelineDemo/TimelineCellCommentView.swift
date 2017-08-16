//
//  TimelineCellCommentView.swift
//  WeChatTimelineDemo
//
//  Created by CPX on 15/08/2017.
//  Copyright © 2017 CPX. All rights reserved.
//

import Foundation
import UIKit
import ActiveLabel

protocol TimelineCellCommentViewDelegate {
    func click(comment: TimelineCommentItem)
}

class TimelineCellCommentView: UIView {
    
    var delegate: TimelineCellOperationMenuDelegate?
    
    private let label: ActiveLabel = {
        let label = ActiveLabel()
        label.numberOfLines = 0
        label.enabledTypes = [.mention, .url]
        label.textColor = .black
//        let tap = UITapGestureRecognizer(target: self, action: #selector())
        return label
    }()
    
    fileprivate var likeItemsArray = [TimelineLikeItem]() {
        didSet {
            /*
            let attach = NSTextAttachment()
            attach.image = UIImage.imageWithColor(.red)
            attach.bounds = CGRect(x: 0, y: -3, width: 16, height: 16)
            let likeIcon = NSAttributedString.init(attachment: attach)
            let attributedText = NSMutableAttributedString(attributedString: likeIcon)
            */
            var text = "♡"
            for index in 0..<likeItemsArray.count {
                let likeItem = likeItemsArray[index]
                if index > 0 {
//                    let attrStr = NSAttributedString(string: ", ")
//                    attributedText.append(attrStr)
                    text.append(", ")
                }
//                let commentStr = NSAttributedString(string: likeItem.name)
//                attributedText.append(commentStr)
                text.append(likeItem.name)
            }
//            likeLabel.text = nil
//            likeLabel.attributedText = attributedText
            likeLabel.text = text
        }
    }
    
    fileprivate var commentItemsArray = [TimelineCommentItem]() {
        didSet(oldValue) {
            let needsToAddCount = commentItemsArray.count > oldValue.count ? (commentLabelsArray.count - oldValue.count) : 0
            for _ in 0..<needsToAddCount {
                let label = ActiveLabel()
                addSubview(label)
                commentLabelsArray.append(label)
            }
            
            for index in 0..<commentItemsArray.count {
                let label = commentLabelsArray[index]
                let commentItem = commentItemsArray[index]
                label.text = "@" + commentItem.author + ": " + commentItem.comment
            }
        }
    }
    
    fileprivate let bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.imageWithColor(.cyan)
        return imageView
    }()
    
    /// TODO: UILabel的text做格式化样式
    fileprivate let likeLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.numberOfLines = 0
        label.enabledTypes = [.mention]
        return label
    }()
    
    fileprivate let separatorView: UIView = {
        let view = UIView()
        return view
    }()
    
    fileprivate var commentLabelsArray = [ActiveLabel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(bgImageView)
        bgImageView.frame = bounds
        addSubview(likeLabel)
        addSubview(separatorView)
    }
    
    func update(likeItems: [TimelineLikeItem], commentsItems: [TimelineCommentItem]) {
        self.likeItemsArray = likeItems
        self.commentItemsArray = commentsItems
        
        for label in commentLabelsArray {
            label.isHidden = true
        }
        
        if commentsItems.count == 0 && likeItems.count == 0 {
            bounds.size.height = 0
        }
        
        var lastTopView: UIView?
        
        if likeItems.count > 0 {
            likeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            likeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            likeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
            lastTopView = likeLabel
        } else {
            likeLabel.attributedText = nil
            likeLabel.text = nil
            likeLabel.isHidden = true
        }
        
        if commentsItems.count > 0 && likeItems.count > 0 {
            separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
            if let topView = lastTopView {
                separatorView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 5).isActive = true
            }
            lastTopView = separatorView
        } else {
            separatorView.isHidden = true
        }
        
        for index in 0..<commentItemsArray.count {
            let label = commentLabelsArray[index]
            label.isHidden = false
            let topMargin: CGFloat = (index == 0 && likeItemsArray.count == 0) ? 10 : 5
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            if let topView = lastTopView {
                label.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: topMargin).isActive = true
            }
            lastTopView = label
        }
    }
    
}

