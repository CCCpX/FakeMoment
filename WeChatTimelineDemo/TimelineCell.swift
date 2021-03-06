//
//  TimelineCell.swift
//  WeChatTimelineDemo
//
//  Created by CPX on 15/08/2017.
//  Copyright © 2017 CPX. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

protocol TimelineCellDelegate {
    /// 显示更多
    func showMoreAction(indexPath: IndexPath)
    /// 预览图片
    func select(imagePaths: [String], with index: Int, at indexPath: IndexPath)
    /// 点赞
    func clickedLikeButton(cell: TimelineCell)
    /// 评论
    func clickedCommentButton(cell: TimelineCell)
    /// 点击评论回复
    func reply(to commentID: String)
}

class TimelineCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var mediaContentView: PhotoContainerView!
    @IBOutlet weak var operationContentView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var operationButton: UIButton!
    @IBOutlet weak var commentContentView: TimelineCellCommentView!
    
    @IBOutlet weak var operationMenu: UIView!
    @IBOutlet weak var operationMenuWidth: NSLayoutConstraint! //==0或>0
    @IBOutlet weak var commentContentViewHeight: NSLayoutConstraint!
    
    var delegate: TimelineCellDelegate?
    
    var indexPath: IndexPath!
    
    var cellController: TimelineCellController? {
        didSet {
            if let controller = cellController {
                //-----------头像-----------
                if let url = URL(string: controller.avatar) {
                    avatarImageView.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
                }
                //-----------名称-----------
                nameLabel.text = controller.name
                //-----------发布的文字-----------
                contentLabel.text = controller.content
                /// TODO: 定义content label的高度
                //-----------是否显示全文按钮-----------
                moreButton.isHidden = !controller.more
                if controller.more {
                    if controller.isOpen {
                        moreButton.setTitle("收起", for: .normal)
                        contentLabel.numberOfLines = 0
                    } else {
                        moreButton.setTitle("全文", for: .normal)
                        contentLabel.numberOfLines = 6
                    }
                }
                //-----------发布的富文本内容(目前为图片)-----------
                mediaContentView.picPathArray = controller.imagePaths
                mediaContentView.delegate = self
                //-----------时间-----------
                timeLabel.text = controller.createTime
                //-----------显示点赞及评论内容-----------
                commentContentView.update(likeItems: controller.likeArray, commentsItems: controller.commentArray)
                commentContentView.delegate = self
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        operationMenuWidth.constant = 0
        commentContentViewHeight.constant = 0
    }
    
    @IBAction func operationBtnDidTouchUpInside(_ sender: UIButton) {
        let constant = operationMenuWidth.constant
        operationMenuWidth.constant = constant == 0 ? 120 : 0
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
        })
    }
    
    @IBAction func showMoreBtnDidTouchUpInside(_ sender: UIButton) {
        
        delegate?.showMoreAction(indexPath: indexPath)
    }
    
    @IBAction func clickLikeAction(_ sender: UIButton) {
        hideMenu()
    }
    
    @IBAction func clickCommentAction(_ sender: UIButton) {
        hideMenu()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if operationMenuWidth.constant > 0 {
            hideMenu()
        }
    }
    
    private func hideMenu() {
        operationMenuWidth.constant = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
        })
    }
}

extension TimelineCell: PhotoContainerViewDelegate {
    func tappedPhoto(at index: Int) {
        guard let paths = mediaContentView.picPathArray else { return }
        delegate?.select(imagePaths: paths, with: index, at: indexPath)
    }
}

extension TimelineCell: TimelineCellCommentViewDelegate {
    func click(comment: TimelineCommentItem) {
        print(comment.author)
    }
}

extension TimelineCell: Reuseable {}

struct TimelineCellController {
    let avatar: String
    let name: String
    let content: String
    let imagePaths: [String]
    let isLike: Bool
    let more: Bool
    let isOpen: Bool
    let likeArray: [TimelineLikeItem]
    let commentArray: [TimelineCommentItem]
    let createTime: String
    
    init(timeline: Timeline) {
        avatar = timeline.avatar
        name = timeline.name
        content = timeline.content
        imagePaths = timeline.imagePaths
        isLike = timeline.isLike
        more = timeline.shouldShowMoreBtn()
        isOpen = timeline.isOpen
        likeArray = timeline.likeArray
        commentArray = timeline.commentArray
        createTime = timeline.createTime
    }
}

extension TimelineCell: CellConfigurable { }
