//
//  NewTimelineViewController.swift
//  WeChatTimelineDemo
//
//  Created by CPX on 19/08/2017.
//  Copyright © 2017 CPX. All rights reserved.
//

import Foundation
import UIKit

class NewTimelineViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var newTimelineUIController: NewTimelineUIController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newTimelineUIController = NewTimelineUIController(tableView: tableView)
        newTimelineUIController.delegate = self
    }
    
}

extension NewTimelineViewController: NewTimelineUIControllerDelegate {
    func select(timeline: Timeline) {
        
    }
}
