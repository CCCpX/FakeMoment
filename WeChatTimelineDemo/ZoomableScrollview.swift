//
//  ZoomableScrollview.swift
//  NZImageShowDemo
//
//  Created by NeoZ on 15/6/16.
//  Copyright © 2016年 NeoZ. All rights reserved.
//

import UIKit
import Kingfisher

open class ZoomableScrollview: UIScrollView, UIScrollViewDelegate {
    
    var thumbImage = UIImage()
    
    var imageloaded : UIImage?
    
    var imageView = UIImageView()
    
    var imageHolder = UIImage()
    
    var isImageDownloaded = false
    
    var rectPassed : CGRect?
    //private var myContext = 0
    
    var circleProgressView: CircleProgressView = {
        let progress = CircleProgressView()
        progress.trackImage = UIImage(named: "angular")
        progress.clockwise = true
        progress.contentMode = .redraw
        progress.frame = CGRect(x: 25, y: 25, width: 50, height: 50)
        progress.backgroundColor = UIColor.clear
        
        return progress
    }()
    
    var imageUrl: String! {
        didSet {
            if !isImageDownloaded {
                if let url = URL(string: imageUrl){
                    //print("called kf_setImageWithURL......")
                    imageView.kf.setImage(with: url, placeholder: imageHolder, options: nil, progressBlock: { (receivedSize, totalSize) in
                        let percentage : Double = Double(receivedSize) / Double(totalSize)
                        self.circleProgressView.progress = percentage
                        
                    }, completionHandler: { (image, error, cacheType, url) in
                        
                        self.circleProgressView.removeFromSuperview()
                        
                        self.imageloaded = image
                        if self.imageloaded != nil  {
                            
                            self.isImageDownloaded = true
                            
                            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                                self.imageView.frame.size = self.calculatePictureSize()
                                self.centerizingImage()
                            }, completion: { (true) in
                                self.updateUI()
                            })
                        }
                    })
                }
            }
            //end if
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //imageView.addObserver(self, forKeyPath: "image", options: .New, context: &myContext)
        
        self.frame = frame
        self.delegate = self
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.addSubview(imageView)
        imageView.addSubview(circleProgressView)
        imageView.clipsToBounds = true
        //centerizingImage()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit...")
        //imageView.removeObserver(self, forKeyPath: "image", context: &myContext)
    }
    /*
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == &myContext {
            self.maximumZoomScale = calculateMaximumScale()
        } else {
            super.observeValueForKeyPath(keyPath!, ofObject: object!, change: change!, context: context)
        }
    }
    */
    
    func isZoomed() -> Bool {
        return self.zoomScale != self.minimumZoomScale
    }
    
    func zoomOut() {
        self.setZoomScale(minimumZoomScale, animated: false)

    }
    
    func tapZoom() {
        if isZoomed() {
            self.setZoomScale(minimumZoomScale, animated: true)
            self.bounces = false
        } else {
            self.setZoomScale(maximumZoomScale, animated: true)
            self.bounces = true
        }
    }
    
    fileprivate func screenSize() -> CGSize {
        return CGSize(width: bounds.width, height: bounds.height)
    }

    internal func calculatePictureSize() -> CGSize {
        if imageloaded != nil {
            let picSize = imageloaded!.size
            let picRatio = picSize.width / picSize.height
            let screenRatio = screenSize().width / screenSize().height
            
            if (picRatio > screenRatio){
                return CGSize(width: screenSize().width, height: screenSize().width / picSize.width * picSize.height)
            } else {
                return CGSize(width: screenSize().height / picSize.height * picSize.width, height: screenSize().height)
            }
        } else {
            //return CGSize(width: screenSize().width, height: screenSize().height)
            return CGSize(width: 100, height: 100)
        }
    }
    
    fileprivate func calculateMaximumScale() -> CGFloat {
        if let image = imageView.image {
            return image.size.width / calculatePictureSize().width
        } else {
            return 1.0
        }
    }
    
    fileprivate func centerizingImage(){
        var intendHorizon = (screenSize().width - imageView.frame.width ) / 2
        var intendVertical = (screenSize().height - imageView.frame.height ) / 2
        intendHorizon = intendHorizon > 0 ? intendHorizon : 0
        intendVertical = intendVertical > 0 ? intendVertical : 0
        contentInset = UIEdgeInsets(top: intendVertical, left: intendHorizon, bottom: intendVertical, right: intendHorizon)
    }
    
    fileprivate func isFullScreen() -> Bool{
        if (imageView.frame.width >= screenSize().width && imageView.frame.height >= screenSize().height){
            return true
        } else {
            return false
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()

        updateUI()
    }
    
    func updateUI() {
        if (!isZoomed()) {
            imageView.frame.size = calculatePictureSize()
            centerizingImage()
        }
        
        if (self.isFullScreen()) {
            self.clearContentInsets()
        } else {
            centerizingImage()
        }
        
        self.maximumZoomScale = calculateMaximumScale()
    }
    
    func clearContentInsets() {
        self.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    //MARK: UIScrollViewDelegate
    
    open func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerizingImage()
    }
    
    open func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}
