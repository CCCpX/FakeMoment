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
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    var dataArray = [Timeline]() {
        didSet(oldValue) {
            
        }
    }
}

extension TimelineUIController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TimelineCell = tableView.dequeueReuseableCell(indexPath: indexPath)
        cell.delegate = self
        cell.indexPath = indexPath
        let timeline = dataArray[indexPath.row]
        cell.cellController = TimelineCellController(timeline: timeline)
        return cell
    }
}

extension TimelineUIController: UITableViewDelegate {
    
}

extension TimelineUIController: TimelineCellDelegate {
    func showMoreAction(indexPath: IndexPath) {
    }
    
    func clickedLikeButton(cell: TimelineCell) {
    }
    
    func clickedCommentButton(cell: TimelineCell) {
    }
    
    func reply(to commentID: String) {
    }
}
