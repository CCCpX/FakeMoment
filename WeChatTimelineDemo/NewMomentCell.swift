//
//  NewMomentCell.swift
//  WeChatTimelineDemo
//
//  Created by CPX on 21/08/2017.
//  Copyright © 2017 CPX. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

protocol NewMomentCellDelegate {
    func showMoreAction()
    func likeAction()
    func commentAction()
}

class NewMomentCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var mediaView: UIView!
    @IBOutlet weak var moreContentBtn: UIButton!
    @IBOutlet weak var operationBtn: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var commentCountBtn: UIButton!
    @IBOutlet weak var mediaHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var operationMenuWidthConstraint: NSLayoutConstraint!
    
    fileprivate let imageViewTagBuffer = 400
    fileprivate let labelTagBuffer = 500
    
    var imageViewArray = [KPImageView]()
    
    var indexPath: IndexPath!
    
    var delegate: NewMomentCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        operationMenuWidthConstraint.constant = 0
        var temp = [KPImageView]()
        for index in 0..<9 {
            let imageView = KPImageView()
            imageView.tag = imageViewTagBuffer + index
            imageView.isUserInteractionEnabled = true
            mediaView.addSubview(imageView)
            temp.append(imageView)
        }
        imageViewArray = temp
    }
    
    var cellController: NewMomentCellController? {
        didSet {
            if let controller = cellController {
                //-----------头像-----------
                if let url = URL(string: controller.avatarPath) {
                    avatarImageView.kf.setImage(with: url)
                }
                //-----------名称-----------
                nameLabel.text = controller.userName
                //-----------发布的文字-----------
                contentLabel.text = controller.content
                //-----------九宫格图片-----------
                let margin: CGFloat = 5
                let perRowItemCount = perRowCount(for: controller.imagePaths)
                let itemW = CGFloat(itemWidth(for: controller.imagePaths))
                var itemH: CGFloat = 0
                
                mediaView.subviews.forEach {$0.isHidden = true}
                
                var rowNum = 0
                switch controller.imagePaths.count {
                case 1...2:
                    rowNum = 1
                case 3...6:
                    rowNum = 2
                case 7...9:
                    rowNum = 3
                default:
                    rowNum = 0
                }
                mediaHeightConstraint.constant = CGFloat(rowNum) * (itemW + margin)
                
                for (index, path) in controller.imagePaths.enumerated() {
                    if let url = URL(string: path) {
                        KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, url) in
                            let imageView = self.mediaView.viewWithTag(self.imageViewTagBuffer + index) as! KPImageView
                            imageView.isHidden = false
                            imageView.image = image
                            
                            if let img = image {
                                if controller.imagePaths.count == 1 {
                                    itemH = img.size.height / img.size.width * itemW;
                                    self.mediaHeightConstraint.constant = itemH
                                } else {
                                    itemH = itemW
                                }
                            }
                            let columnIndex = index % perRowItemCount;
                            let rowIndex = index / perRowItemCount;
                            
                            imageView.frame = CGRect(x: CGFloat(columnIndex) * (itemW + margin), y: CGFloat(rowIndex) * (itemH + margin), width: itemW, height: itemH)
                        })
                    }
                }
                //-----------显示的评论-----------
                for (index, comment) in controller.comments.enumerated() {
                    if index < 3 {
                        let label = viewWithTag(labelTagBuffer + index) as! UILabel
                        label.isHidden = false
                        label.text = comment.comment
                    }
                }
                //-----------更多评论按钮-----------
                commentCountBtn.isHidden = controller.comments.count < 3
                if commentCountBtn.isHidden == false {
                    commentCountBtn.setTitle("共\(controller.comments.count)条评论, 点击查看更多 >>", for: .normal)
                }
                //-----------时间-----------
                timeLabel.text = controller.createTime
            }
        }
    }
    
    @IBAction func showMoreContentBtnDidTouchUpInside(_ sender: UIButton) {
        
    }
    
    @IBAction func operationBtnDidTouchUpInside(_ sender: UIButton) {
        let constant = operationMenuWidthConstraint.constant
        operationMenuWidthConstraint.constant = constant == 0 ? 120 : 0
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
        })
    }
    
    @IBAction func likeBtnDidTouchUpInside(_ sender: UIButton) {
        hideMenu()
    }
    
    @IBAction func commentBtnDidTouchUpInside(_ sender: UIButton) {
        hideMenu()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if operationMenuWidthConstraint.constant > 0 {
            hideMenu()
        }
    }
    
    private func hideMenu() {
        operationMenuWidthConstraint.constant = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
        })
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
    
    /// 九宫格排布方式
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

extension NewMomentCell: Reuseable { }

final class NewMomentCellController {
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
        print("有图片:\(imagePaths.count)张")
    }
}

extension NewMomentCell: CellConfigurable { }
