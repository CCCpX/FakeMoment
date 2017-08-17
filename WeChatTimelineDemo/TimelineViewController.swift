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
    
    let testCount = 64
    let enablePhotos = true
    let enableLike = true
    let enableComment = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timelineUIController = TimelineUIController(tableView: tableView)
        timelineUIController.delegate = self
        
        main_delay(1) {
            self.timelineUIController.dataArray.append(contentsOf: self.createFakeData(count: self.testCount))
        }
    }
    
    @IBAction func popBackAction(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}

extension TimelineViewController: TimelineUIControllerDelegate {
    
}

func main_delay(_ second:Int, handle: @escaping (() -> Void)) {
    let additionalTime: DispatchTimeInterval = .seconds(second)
    DispatchQueue.main.asyncAfter(deadline: .now() + additionalTime) {
        handle()
    }
}

extension TimelineViewController {
    func createFakeData(count: Int) -> [Timeline] {
        
        let iconImageNamesArray = ["http://tse3.mm.bing.net/th?id=OIP.cYWADtWoK1vKjBa_itptVwEsDw&pid=15.1","http://tse4.mm.bing.net/th?id=OIP.H-oYKguFg4mVnsPM7IHdcADvEs&pid=15.1","http://tse2.mm.bing.net/th?id=OIP.aP__Sh5APikQdkyuo0OT7AEsEs&pid=15.1","http://tse3.mm.bing.net/th?id=OIP.1ahEEqqxo93R_moCetTX_AD6D6&pid=15.1","http://tse4.mm.bing.net/th?id=OIP.tzXqOPgg-0AYCBMHM0W5RwEsEs&pid=15.1"]
        
        let namesArray = ["GSD_iOS","风口上的猪","当今世界网名都不好起了","我叫郭德纲","Hello Kitty"]
        
        let textArray = ["当你的 app 没有提供 3x 的 LaunchImage 时，系统默认进入兼容模式，https://github.com/gsdios/SDAutoLayout大屏幕一切按照 320 宽度渲染，屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。",
        "然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，https://github.com/gsdios/SDAutoLayout等于把小屏完全拉伸。",
        "当你的 app 没有提供 3x 的 LaunchImage 时屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。屏幕宽度返回 320；https://github.com/gsdios/SDAutoLayout然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。",
        "但是建议不要长期处于这种模式下，否则在大屏上会显得字大，内容少，容易遭到用户投诉。",
        "屏幕宽度返回 320；https://github.com/gsdios/SDAutoLayout然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。"
        ]
        
        let commentsArray = ["社会主义好！👌👌👌👌","正宗好凉茶，正宗好声音。。。","你好，我好，大家好才是真的好","有意思","你瞅啥？","瞅你咋地？？？！！！","hello，看我","曾经在幽幽暗暗反反复复中追问，才知道平平淡淡从从容容才是真","人艰不拆","咯咯哒","呵呵~~~~~~~~","我勒个去，啥世道啊","真有意思啊你💢💢💢"]
        
        let picImageNamesArray = ["http://tse3.mm.bing.net/th?id=OIP.sBRxVziJv5yFtpmqHyi7QgEsEs&pid=15.1","http://tse1.mm.bing.net/th?id=OIP.5UqpOnXX6lmeU8hIe6pvWwEsEs&pid=15.1","http://tse3.mm.bing.net/th?id=OIP.5wxdU104TnkB9z6hOmxH0QEsDU&pid=15.1","http://tse3.mm.bing.net/th?id=OIP.1YeL3QZyWNcpL378nFafpgFNC7&pid=15.1","http://tse4.mm.bing.net/th?id=OIP.AjXFKomqKnIusvuDrFhYWgDIDI&pid=15.1","http://tse1.mm.bing.net/th?id=OIP.JS-WD0pPMsIpFNjYdiPwZgEsEf&pid=15.1","http://www.heberger-image.fr/data/images/19396_calimero.gif","http://tse3.mm.bing.net/th?id=OIP.1YeL3QZyWNcpL378nFafpgFNC7&pid=15.1","http://tse1.mm.bing.net/th?id=OIP.5UqpOnXX6lmeU8hIe6pvWwEsEs&pid=15.1"]
        
        var resArr = [Timeline]()
        
        for _ in 0..<count {
            let rdmIndex0 = Int(arc4random_uniform(5))
            let rdmIndex1 = Int(arc4random_uniform(5))
            let rdmIndex2 = Int(arc4random_uniform(5))
            let rdmIndex3 = Int(arc4random_uniform(9))
            
            var rdmImages = [String]()
            let rmdImageIndex = Int(arc4random_uniform(9))
            
            for _ in 0..<rmdImageIndex {
                let rdm = Int(arc4random_uniform(9))
                rdmImages.append(picImageNamesArray[rdm])
            }
            if enablePhotos == false {
                rdmImages = [String]()
            }
            var likeItems = [TimelineLikeItem]()
            for _ in 0..<rdmIndex0 {
                let item = TimelineLikeItem(name: namesArray[rdmIndex1], id: "2")
                likeItems.append(item)
            }
            if enableLike == false {
                likeItems = [TimelineLikeItem]()
            }
            var commentItems = [TimelineCommentItem]()
            for _ in 0..<rdmIndex3 {
                let rdm = Int(arc4random_uniform(9))
                let item = TimelineCommentItem(comment: commentsArray[rdm], author: namesArray[rdmIndex1], commentator: "评论人")
                commentItems.append(item)
            }
            if enableComment == false {
                commentItems = [TimelineCommentItem]()
            }
            let model = Timeline(name: namesArray[rdmIndex0], avatar: iconImageNamesArray[rdmIndex1], content: textArray[rdmIndex2], isLike: false, imagePaths: rdmImages, likeArray: likeItems, commentArray: commentItems, createTime: "2017-08-19", isOpen: false)
            
            resArr.append(model)
        }
        return resArr
    }
}
