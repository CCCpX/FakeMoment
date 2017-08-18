//
//  FullScreenView.swift
//  NZImageShow
//
//  Created by NeoZ on 16/6/16.
//  Copyright © 2016年 NeoZ. All rights reserved.
//


import UIKit

@objc public protocol FullScreenViewDelegate {
    @objc optional func callbackWithRect(_ imageView : UIImageView, indexPage : Int)
}

class FullScreenView: UIView, UIScrollViewDelegate {
    
    var delegate : FullScreenViewDelegate?
    
    fileprivate var pageRollingWidth = CGFloat()
    
    fileprivate var localImagesUrlArray = [String]()
    
    var updatedThumbArrayImages = [UIImage]()
    
    fileprivate var arrayOfImageScrollViews : [ZoomableScrollview] = []
    
    fileprivate var pagecontrol : UIPageControl = {
        let page = UIPageControl()
        page.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        page.currentPage = 0
        page.currentPageIndicatorTintColor = UIColor.white
        page.pageIndicatorTintColor = UIColor.lightGray
        
        return page
    }()
    
    fileprivate var shareButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 20, y: 20, width: 60, height: 40))
        //button.setTitle("Save", forState: .Normal)
        button.setImage(UIImage(named: "ic_share"), for: UIControlState())
        //button.addTarget(self, action: #selector(shareImage(_:)), forControlEvents: .TouchUpInside)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        button.autoresizingMask = UIViewAutoresizing.flexibleLeftMargin
        
        return button
    }()
    
    fileprivate var currentDisplyedPage : Int {
        get{
            return pagecontrol.currentPage
        }set{
            pagecontrol.currentPage = newValue
            
            if arrayOfImageScrollViews.count > 0 {
                let scrollviewSelected = arrayOfImageScrollViews[newValue]
                
                scrollviewSelected.imageHolder = updatedThumbArrayImages[newValue]
                scrollviewSelected.imageUrl = localImagesUrlArray[newValue]
                self.outerScrollView.setContentOffset(CGPoint(x: pageRollingWidth * CGFloat(newValue), y: 0), animated: false)
            }
        }
    }
    
    var myImageArray = [String]() {
        didSet{
            pagecontrol.numberOfPages = myImageArray.count
            setupImageScrollView(myImageArray) { (viewsArray) in
                self.arrayOfImageScrollViews = viewsArray
            }
        }
    }
    
    var outerScrollView: UIScrollView = {
        let view = UIScrollView()
        view.isPagingEnabled = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.isScrollEnabled = true
        view.clipsToBounds = true
        view.bounces = false
        
        return view
    }()

    required override init(frame: CGRect) {
        pageRollingWidth = frame.size.width
        super.init(frame: frame)
        
        self.autoresizesSubviews = true
        self.clipsToBounds = true
    }
    
    required internal init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setupArrayViews(_ imagesArray : [String], complitionHandler:(_ isComplited:Bool) -> ()) {
        //let window : UIWindow = ((UIApplication.sharedApplication().delegate?.window)!)!
        
        shareButton.addTarget(self, action: #selector(shareImage(_:)), for: .touchUpInside)
        
        outerScrollView.delegate = self
        outerScrollView.frame = self.frame
        self.addSubview(outerScrollView)
        self.addSubview(pagecontrol)
        self.addSubview(shareButton)
        //window.addSubview(self)
        
        self.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedScrollView(_:)))
        tap.numberOfTapsRequired = 1
        self.addGestureRecognizer(tap)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(tappedToZoom(_:)))
        tap2.numberOfTapsRequired = 2
        self.addGestureRecognizer(tap2)
        
        tap.require(toFail: tap2)
        
        myImageArray = imagesArray
        
        complitionHandler(true)
    }
    
    func prepareForReview() {
        
        shareButton.addTarget(self, action: #selector(shareImage(_:)), for: .touchUpInside)
        
        outerScrollView.delegate = self
        outerScrollView.frame = self.frame
        self.addSubview(outerScrollView)
        self.addSubview(pagecontrol)
        self.addSubview(shareButton)
        //window.addSubview(self)
        
        self.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedScrollView(_:)))
        tap.numberOfTapsRequired = 1
        self.addGestureRecognizer(tap)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(tappedToZoom(_:)))
        tap2.numberOfTapsRequired = 2
        self.addGestureRecognizer(tap2)
        
        tap.require(toFail: tap2)
    }
    
    internal func showSelectedView(_ indexClicked:Int, rectPassed : CGRect) {
        
        self.isHidden = false
        /*
        let window : UIWindow = ((UIApplication.sharedApplication().delegate?.window)!)!
        let vc = window.rootViewController
        vc?.navigationController?.navigationBar.hidden = true
        */
        if arrayOfImageScrollViews.count > 0 {
            let scrollviewSelected = arrayOfImageScrollViews[indexClicked]
            if scrollviewSelected.isImageDownloaded {
                let trickyImageview = UIImageView(frame: rectPassed)
                trickyImageview.image = scrollviewSelected.imageloaded
                self.addSubview(trickyImageview)
                scrollviewSelected.imageView.alpha = 0
                
                UIView.animate(withDuration: 0.3, animations: {
                    let size = scrollviewSelected.calculatePictureSize()
                    trickyImageview.frame = CGRect(x: (self.bounds.size.width - size.width) / 2, y: (self.bounds.size.height - size.height) / 2, width: size.width, height: size.height)
                    }, completion: { (true) in
                        trickyImageview.removeFromSuperview()
                        scrollviewSelected.imageView.alpha = 1
                })
            }
        }
        
        currentDisplyedPage = indexClicked
    }
    
    func setupImageScrollView(_ imagesArrayUrl : [String], completion:(_ viewsArray : [ZoomableScrollview]) -> ()) {
        
        localImagesUrlArray = imagesArrayUrl
        if localImagesUrlArray.count > 0 {
            var localArray = [ZoomableScrollview]()
            var i = 0
            for _ in localImagesUrlArray {
                let scrollviewFrame = CGRect(x: bounds.size.width * CGFloat(i), y: 0, width: bounds.size.width, height: bounds.size.height)
                let imageScrollView = ZoomableScrollview.init(frame: scrollviewFrame)
                imageScrollView.tag = i
                
                localArray.append(imageScrollView)
                outerScrollView.addSubview(imageScrollView)
                i += 1
            }
            completion(localArray)
        }

    }
    
    deinit {
        print("deinit count:\(arrayOfImageScrollViews.count)")
    }
    
    override func layoutSubviews() {
        
        outerScrollView.frame = self.bounds
        outerScrollView.contentSize = CGSize(width: self.bounds.size.width * CGFloat(myImageArray.count), height: self.bounds.size.height)
        
        pageRollingWidth = outerScrollView.frame.size.width
        
        pagecontrol.center = CGPoint(x: outerScrollView.frame.size.width / 2, y: outerScrollView.frame.size.height - 10)
        shareButton.frame = CGRect(x: 20, y: 20, width: 50, height: 50)
        
        var i = 0
        for view in outerScrollView.subviews {
            if let imgView = view as? UIScrollView {
                imgView.frame = CGRect(x: frame.size.width * CGFloat(i), y: 0, width: frame.size.width, height: frame.size.height)
                i += 1
            }
            
        }
        
        self.outerScrollView.setContentOffset(CGPoint(x: pageRollingWidth * CGFloat(currentDisplyedPage), y: 0), animated: false)
    }
    
    override func draw(_ rect: CGRect) {
        //print("drawRect")
        //self.frame = UIScreen.mainScreen().bounds
    }
    
    func shareImage(_ sender:UIButton) {
        if arrayOfImageScrollViews.count > 0 {
            let scrollviewSelected = arrayOfImageScrollViews[currentDisplyedPage]
            if scrollviewSelected.isImageDownloaded {
                let image = scrollviewSelected.imageloaded
                let message = String(format: "Share message")
                let urlString = localImagesUrlArray[currentDisplyedPage]
                let webSite = URL(string: urlString)
                let shareObj : Array = [message, image!, webSite!] as [Any]
                
                let acv = UIActivityViewController(activityItems: shareObj as [AnyObject], applicationActivities: nil)
                
                let window : UIWindow = ((UIApplication.shared.delegate?.window)!)!
                //let vc = UIApplication.sharedApplication().keyWindow?.rootViewController
                let vc = window.rootViewController
                vc!.present(acv, animated: true, completion: nil)
                vc?.view.superview?.bringSubview(toFront: acv.view)
                if let pop = acv.popoverPresentationController {
                    let v = sender as UIView // sender would be the button view tapped, but could be any view
                    pop.sourceView = v
                    pop.sourceRect = v.bounds
                    
                }
            }
        }
    }
    
    func tappedScrollView(_ sender: UIGestureRecognizer) {
        
        let currentScrollview = arrayOfImageScrollViews[currentDisplyedPage]

        if let adelegate = delegate {
            if let responsedMethod = adelegate.callbackWithRect {
                responsedMethod(currentScrollview.imageView, currentDisplyedPage)
            }else{
                print("delegate method NOT implemented yet!")
            }
        }else{
            print("delegate error")
        }
        
        currentScrollview.zoomOut()
        
        self.isHidden = true
        /*
        let window : UIWindow = ((UIApplication.sharedApplication().delegate?.window)!)!
        let vc = window.rootViewController
        vc?.navigationController?.navigationBar.hidden = false
*/
    }
    
    func tappedToZoom(_ sender: UIGestureRecognizer) {
        let currenImageScrollView = arrayOfImageScrollViews[currentDisplyedPage]
        currenImageScrollView.tapZoom()
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentDisplyedPage = PageNumberInScrollview(scrollView)
        resetZoomScaleExcept(currentDisplyedPage)
    }
    
    fileprivate func PageNumberInScrollview(_ scrollView: UIScrollView) -> Int {
        let contentOffset = scrollView.contentOffset
        let viewsize = scrollView.bounds.size
        let horizontalPage = max(0.0, contentOffset.x / viewsize.width)
        return Int(horizontalPage)
    }
    
    func resetZoomScaleExcept(_ currentPage : Int) {
        for view in outerScrollView.subviews {
            if let scrollerview = view as? ZoomableScrollview {
                if scrollerview.tag != currentPage {
                    scrollerview.zoomOut()
                }
            }
        }
    }
}
