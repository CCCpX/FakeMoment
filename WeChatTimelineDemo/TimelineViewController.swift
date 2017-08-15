//
//  TimelineViewController.swift
//  WeChatTimelineDemo
//
//  Created by CPX on 15/08/2017.
//  Copyright © 2017 CPX. All rights reserved.
//

import Foundation
import UIKit

class TimelineViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var timelineUIController: TimelineUIController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timelineUIController = TimelineUIController(tableView: tableView)
        timelineUIController.delegate = self
    }
    
    @IBAction func popBackAction(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}

extension TimelineViewController: TimelineUIControllerDelegate {
    
}
