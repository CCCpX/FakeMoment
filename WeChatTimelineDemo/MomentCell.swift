//
//  MomentCell.swift
//  WeChatTimelineDemo
//
//  Created by CPX on 19/08/2017.
//  Copyright © 2017 CPX. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class MomentCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var moreCommentButton: UIButton!
    
    let imageTagBuffer = 400
    /// 评论最多显示3条
    let commentLabelTagBuffer = 500
    
    var cellController: MomentCellController? {
        didSet {
            if let controller = cellController {
                //-----------头像-----------
                if let url = URL(string: controller.avatarPath) {
                    avatarImageView.kf.setImage(with: url)
                }
                //-----------名称-----------
                userNameLabel.text = controller.userName
                //-----------九宫格图片-----------
                let itemW = itemWidth(for: controller.imagePaths)
                for (index, path) in controller.imagePaths.enumerated() {
                    let imageView = viewWithTag(imageTagBuffer + index) as! UIImageView
                    imageView.isHidden = true
                    if let url = URL(string: path) {
                        KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, url) in
                            imageView.isHidden = false
                            imageView.image = image
//                            if let img = image {
//                                let height = img.size.height / img.size.width * CGFloat(itemW)
//                                imageView.heightAnchor.constraint(equalToConstant: height)
//                                if let constraint = (imageView.constraints.filter{$0.firstAttribute == .height}.first) {
//                                    constraint.constant = height
//                                }
//                                self.setNeedsLayout()
//                            }
                        })
                    }
                }
                //-----------发布的文字-----------
                contentLabel.text = controller.content
                //-----------评论-----------
                for (index, comment) in controller.comments.enumerated() {
                    if index < 3 {
                        let label = viewWithTag(commentLabelTagBuffer + index) as! UILabel
                        label.text = comment.comment
                    }
                }
                //-----------更多评论按钮-----------
                moreCommentButton.isHidden = controller.comments.count < 3
                if moreCommentButton.isHidden == false {
                    moreCommentButton.setTitle("共\(controller.comments.count)条评论, 点击查看更多 >>", for: .normal)
                }
                //-----------时间-----------
                timeLabel.text = controller.createTime
            }
        }
    }
    
    @IBAction func operationBtnDidTouchUpInside(_ sender: UIButton) {
    }
    
    @IBAction func viewMoreBtnDidTouchUpInside(_ sender: UIButton) {
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
}

extension MomentCell: Reuseable { }

final class MomentCellController {
    let avatarPath: String
    let userName: String
    let content: String
    let createTime: String
    let imagePaths: [String]
    let comments: [TimelineCommentItem]
    
    init(moment: Moment) {
        avatarPath = moment.avatar
        userName = moment.name
        content = moment.content
        imagePaths = moment.imagePaths
        comments = moment.commentArray
        createTime = moment.createTime
    }
}

extension MomentCell: CellConfigurable { }
