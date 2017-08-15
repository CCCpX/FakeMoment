//
//  ViewController.swift
//  WeChatTimelineDemo
//
//  Created by CPX on 15/08/2017.
//  Copyright © 2017 CPX. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func viewWeChatTimeline(_ sender: UIButton) {
        let storyboard = UIStoryboard(storybard: .main)
        let timelineVC: TimelineViewController = storyboard.instantiateViewController()
        navigationController?.pushViewController(timelineVC, animated: true)
    }
    
}
