//
//  NewTimelineCell.swift
//  WeChatTimelineDemo
//
//  Created by CPX on 19/08/2017.
//  Copyright © 2017 CPX. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class NewTimelineCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var setImageView: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var picCountLabel: UILabel!
    
    var cellController: NewTimelineCellController? {
        didSet {
            if let controller = cellController {
                timeLabel.text = controller.time
                if let url = URL(string: controller.imageViewPath) {
                    setImageView.kf.setImage(with: url)
                }
                descLabel.text = controller.desc
                picCountLabel.text = "共\(controller.picCount)张"
            }
        }
    }
}

extension NewTimelineCell: Reuseable { }

final class NewTimelineCellController {
    let time: String
    let imageViewPath: String
    let desc: String
    let picCount: String
    
    init(timeline: Timeline) {
        time = timeline.createTime
        if timeline.imagePaths.count > 0 {
            imageViewPath = timeline.imagePaths[0]
            picCount = "\(timeline.imagePaths.count)"
        } else {
            imageViewPath = ""
            picCount = ""
        }
        desc = timeline.content
    }
}

extension NewTimelineCell: CellConfigurable { }
