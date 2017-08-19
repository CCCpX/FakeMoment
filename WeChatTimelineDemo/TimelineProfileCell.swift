//
//  TimelineProfileCell.swift
//  WeChatTimelineDemo
//
//  Created by CPX on 19/08/2017.
//  Copyright © 2017 CPX. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class TimelineProfileCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    var cellController: TimelineProfileCellController? {
        didSet {
            if let controller = cellController {
                if let url = URL(string: controller.avatar) {
                    avatarImageView.kf.setImage(with: url)
                }
                nameLabel.text = controller.name
                descLabel.text = controller.desc
            }
        }
    }
}

extension TimelineProfileCell: Reuseable { }

final class TimelineProfileCellController {
    let avatar: String
    let name: String
    let desc: String
    
    init(user: String) {
        avatar = ""
        name = ""
        desc = ""
    }
    
}

extension TimelineProfileCell: CellConfigurable { }
