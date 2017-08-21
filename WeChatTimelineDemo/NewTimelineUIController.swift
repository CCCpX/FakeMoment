//
//  NewTimelineUIController.swift
//  WeChatTimelineDemo
//
//  Created by CPX on 19/08/2017.
//  Copyright © 2017 CPX. All rights reserved.
//

import Foundation
import UIKit

protocol NewTimelineUIControllerDelegate {
    func select(timeline: Timeline)
}

class NewTimelineUIController: NSObject {
    var tableView: UITableView?
    
    var delegate: NewTimelineUIControllerDelegate?
    
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        tableView.register(NewTimelineCell.self)
        tableView.register(TimelineProfileCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    var timelines = [Timeline]() {
        didSet {
            tableView?.beginUpdates()
            tableView?.reloadData()
            tableView?.endUpdates()
        }
    }
}

extension NewTimelineUIController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        default: return timelines.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let profileCell: TimelineProfileCell = tableView.dequeueReuseableCell(indexPath: indexPath)
            return profileCell
        default:
            let timelineCell: NewTimelineCell = tableView.dequeueReuseableCell(indexPath: indexPath)
            let controller = NewTimelineCellController(timeline: timelines[indexPath.row])
            timelineCell.cellController = controller
            return timelineCell
        }
    }
}

extension NewTimelineUIController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.select(timeline: timelines[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 120
        default: return 90
        }
    }
}
