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
    
    fileprivate let fullScreenView = FullScreenView()
    
    var delegate: TimelineUIControllerDelegate?
    
    init(tableView: UITableView, view: UIView) {
        self.tableView = tableView
        super.init()
//        tableView.register(TimelineCell.self)
        tableView.register(MomentCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(fullScreenView)
        fullScreenView.frame = view.bounds
        fullScreenView.prepareForReview()
    }
    
    var dataArray = [Timeline]() {
        didSet(oldValue) {
            tableView?.reloadData()
        }
    }
    
    fileprivate var cellHeights = [Int : CGFloat]()
}

extension TimelineUIController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MomentCell = tableView.dequeueReuseableCell(indexPath: indexPath)
//        cell.delegate = self
//        cell.indexPath = indexPath
        let moment = dataArray[indexPath.row]
//        cell.cellController = TimelineCellController(timeline: timeline)
        cell.cellController = MomentCellController(moment: moment)
        return cell
    }
}

extension TimelineUIController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        if let height = cellHeights[indexPath.row], height > 0 {
//            return height
//        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        /// 保存cell的高度, 防止在刷新指定cell时 jumpy scrolling
        cellHeights[indexPath.row] = cell.bounds.size.height
    }
}

extension TimelineUIController: TimelineCellDelegate {
    func showMoreAction(indexPath: IndexPath) {
        self.dataArray[indexPath.row].isOpen = !self.dataArray[indexPath.row].isOpen
        UIView.performWithoutAnimation {
            self.tableView?.beginUpdates()
            self.tableView?.reloadRows(at: [indexPath], with: .fade)
            self.tableView?.endUpdates()
        }
    }
    
    func select(imagePaths: [String], with index: Int, at indexPath: IndexPath) {
        fullScreenView.myImageArray = imagePaths
        let cell = tableView?.cellForRow(at: indexPath) as! TimelineCell
        let imageViews = cell.mediaContentView.subviews.filter {$0 is UIImageView}
        let convertedRect = tableView!.convert(imageViews[index].frame, to: tableView!.superview)
        
        let thumbImage = UIImage(named: "imagePlaceHolder")!
        let thumbArrayImages = Array(repeating: thumbImage, count: imagePaths.count)
        fullScreenView.updatedThumbArrayImages = thumbArrayImages
        fullScreenView.showSelectedView(index, rectPassed : convertedRect)
    }
    
    func clickedLikeButton(cell: TimelineCell) {
    }
    
    func clickedCommentButton(cell: TimelineCell) {
    }
    
    func reply(to commentID: String) {
    }
}
