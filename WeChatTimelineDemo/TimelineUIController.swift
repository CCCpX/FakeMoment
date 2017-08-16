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
        tableView.register(TimelineCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    var dataArray = [Timeline]() {
        didSet(oldValue) {
            tableView?.reloadData()
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}

extension TimelineUIController: TimelineCellDelegate {
    func showMoreAction(indexPath: IndexPath) {
        var timeline = self.dataArray[indexPath.row]
        timeline.isOpen = !timeline.isOpen
        tableView?.reloadRows(at: [indexPath], with: .fade)
    }
    
    func clickedLikeButton(cell: TimelineCell) {
    }
    
    func clickedCommentButton(cell: TimelineCell) {
    }
    
    func reply(to commentID: String) {
    }
}
