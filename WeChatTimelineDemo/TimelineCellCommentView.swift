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
    
    var delegate: TimelineCellCommentViewDelegate?
    
    let tagBuffer = 400
    
    fileprivate var likeItemsArray = [TimelineLikeItem]() {
        didSet {
            /*
            let attach = NSTextAttachment()
            attach.image = UIImage.imageWithColor(.red)
            attach.bounds = CGRect(x: 0, y: -3, width: 16, height: 16)
            let likeIcon = NSAttributedString.init(attachment: attach)
            let attributedText = NSMutableAttributedString(attributedString: likeIcon)
            */
            var text = "♡ "
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
        didSet {
            let oldCommentCount = commentLabelsArray.count
            let needsToAddCount = commentItemsArray.count > oldCommentCount ? (commentItemsArray.count - oldCommentCount) : 0
            for index in 0..<needsToAddCount {
                let label = UILabel()
                label.translatesAutoresizingMaskIntoConstraints = false
                label.isUserInteractionEnabled = true
                label.tag = tagBuffer + index
                let tapComment = UITapGestureRecognizer(target: self, action: #selector(clickedCommentAction(_:)))
                label.addGestureRecognizer(tapComment)
                label.numberOfLines = 0
                label.lineBreakMode = .byWordWrapping
                label.font = UIFont.systemFont(ofSize: 14)
                label.sizeToFit()
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
    
    /// TODO: UILabel的text做格式化样式
    fileprivate let likeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.sizeToFit()
        return label
    }()
    
    fileprivate let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        return view
    }()
    
    fileprivate var commentLabelsArray = [UILabel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(bgImageView)
        addSubview(likeLabel)
        addSubview(separatorView)
    }
    
    func update(likeItems: [TimelineLikeItem], commentsItems: [TimelineCommentItem]) {
        self.likeItemsArray = [TimelineLikeItem]()
        self.commentItemsArray = [TimelineCommentItem]()
        
        self.likeItemsArray = likeItems
        self.commentItemsArray = commentsItems
        
        for label in commentLabelsArray {
//            NSLayoutConstraint.deactivate(label.constraints)
            label.isHidden = true
        }
        
        let noData = likeItems.count == 0 && commentsItems.count == 0
        
        guard noData == false else {
            if let constraint = (self.constraints.filter{$0.firstAttribute == .height}.first) {
                constraint.constant = 0
            }
            return
        }
        
        var lastTopView: UIView?
        var totalHeight: CGFloat = 0
        let fixedWidth = UIScreen.main.bounds.width - 45 - 8*4
        let margin: CGFloat = 5
        // 显示点赞部分
        if likeItems.count > 0 {
            likeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            likeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            likeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
            totalHeight = totalHeight + 0
            let height = likeLabel.text?.height(withConstrainedWidth: fixedWidth, font: UIFont.systemFont(ofSize: 14))
            if let h = height {
                totalHeight = totalHeight + h
            }
            lastTopView = likeLabel
        } else {
            likeLabel.attributedText = nil
            likeLabel.text = nil
        }
        // 显示点赞和评论之间的分割线
        if commentsItems.count > 0 && likeItems.count > 0 {
            separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            /// 顶部约束
            totalHeight = totalHeight + 0.5
            var tAnchor: NSLayoutYAxisAnchor = self.topAnchor
            if let topView = lastTopView {
                tAnchor = topView.bottomAnchor
            }
            separatorView.topAnchor.constraint(equalTo: tAnchor, constant: margin).isActive = true
            totalHeight = totalHeight + margin
            lastTopView = separatorView
            
//            if let constraint = (separatorView.constraints.filter{$0.firstAttribute == .height}.first) {
//                constraint.constant = 0.5
//            } else {
//                
//            }
            separatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        } else {
//            if let constraint = (separatorView.constraints.filter{$0.firstAttribute == .height}.first) {
//                constraint.constant = 0
//            } else {
//                separatorView.heightAnchor.constraint(equalToConstant: 0).isActive = true
//            }
            separatorView.heightAnchor.constraint(equalToConstant: 0).isActive = true
//            separatorView.isHidden = true
        }
        // 显示评论列
        for index in 0..<commentItemsArray.count {
            let label = commentLabelsArray[index]
            label.isHidden = false
            let topMargin: CGFloat = (index == 0 && likeItemsArray.count == 0) ? 0 : margin
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            
            var yAnchor: NSLayoutYAxisAnchor = self.topAnchor
            if let topView = lastTopView {
                yAnchor = topView.bottomAnchor
            }
            let tAnchor = label.topAnchor.constraint(equalTo: yAnchor, constant: topMargin)
            tAnchor.priority = 1000
            tAnchor.isActive = true
            totalHeight = totalHeight + topMargin
            
            let height = label.text?.height(withConstrainedWidth: fixedWidth, font: UIFont.systemFont(ofSize: 14))
            if let h = height {
                totalHeight = totalHeight + h
            }
            lastTopView = label
        }
        
        if let constraint = (self.constraints.filter{$0.firstAttribute == .height}.first) {
            constraint.constant = totalHeight
//            print("commentH:\(totalHeight)")
        }
    }
    
    @objc private func clickedCommentAction(_ gesture: UIGestureRecognizer) {
        guard let index = gesture.view?.tag else { return }
        delegate?.click(comment: commentItemsArray[index-tagBuffer])
    }
}
