//
//  Timeline.swift
//  WeChatTimelineDemo
//
//  Created by CPX on 15/08/2017.
//  Copyright © 2017 CPX. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

struct TimelineOutput {
    let success: Bool
    let message: String
    let timeline: [Timeline]
}

struct Timeline {
    let name: String
    let avatar: String
    let content: String
    let isLike: Bool
    let imagePaths: [String]
    let likeArray: [TimelineLikeItem]
    let commentArray: [TimelineCommentItem]
    let createTime: String
    
    /// 标示是否已经全部显示
    var isOpen: Bool = false
    
}

extension Timeline {
    /// content的内容过多时, 只显示部分
    func shouldShowMoreBtn() -> Bool {
        let fixedWidth = UIScreen.main.bounds.width - 45 - 8*4
        let height = content.height(withConstrainedWidth: fixedWidth, font: UIFont.systemFont(ofSize: 14))
        return height > 70
    }
}

struct TimelineLikeItem {
    let name: String
    let id: String
}

struct TimelineCommentItem {
    let comment: String
    let author: String
    let commentator: String
}
