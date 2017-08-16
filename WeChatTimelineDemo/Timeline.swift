//
//  Timeline.swift
//  WeChatTimelineDemo
//
//  Created by CPX on 15/08/2017.
//  Copyright © 2017 CPX. All rights reserved.
//

import Foundation
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
    
    /// content的内容过多时, 只显示部分
    func isContentOverflow() -> Bool {
        return content.characters.count > 144
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
