//
//  TimelineUIController.swift
//  WeChatTimelineDemo
//
//  Created by CPX on 15/08/2017.
//  Copyright © 2017 CPX. All rights reserved.
//

import Foundation
import UIKit

protocol TimelineUIControllerDelegate {
    
}

class TimelineUIController: NSObject {
    var tableView: UITableView?
    
    var delegate: TimelineUIControllerDelegate?
    
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
    }
}