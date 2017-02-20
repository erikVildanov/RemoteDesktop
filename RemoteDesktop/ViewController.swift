//
//  ViewController.swift
//  RemoteDesktop
//
//  Created by Эрик Вильданов on 17.09.16.
//  Copyright © 2016 ErikVildanov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    let socket = SocketManager()
    let screenView = ScreenView()
    var size = CGSize()
    var url = String()
    
    var arrayOfTickets:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        loadJson{
            self.screenView.imageView.image = self.screenView.drawCustomImage(size: self.size)
            self.view = self.screenView
            self.screenView.scrollView.delegate = self
            self.initializeImageView()
            self.setupGestureRecognizer()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }

        let tap = UITapGestureRecognizer(target: self, action: #selector(showMoreActions))
        tap.numberOfTapsRequired = 1
        screenView.imageView.addGestureRecognizer(tap)
        print("ViewController",url)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func loadJson(_ completion: ((Void) -> Void)?){
        socket.parseFeed(completionHandler:
            {
                (json: CGSize) -> Void in
                self.size = json
                DispatchQueue.main.async(execute: {
                    completion?()
                })
        })
        
    }
    
    
    func initializeImageView(){
        
        screenView.imageView.contentMode = UIViewContentMode.center
        screenView.imageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        screenView.scrollView.contentSize = size
        
        let scrollViewFrame = screenView.scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / screenView.scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / screenView.scrollView.contentSize.height
        let minScale = min(scaleHeight, scaleWidth)
        
        screenView.scrollView.minimumZoomScale = minScale
        screenView.scrollView.maximumZoomScale = 1
        screenView.scrollView.zoomScale = minScale
        
        centerScrollViewContents()
    }
    
    func showMoreActions(touch: UITapGestureRecognizer) {
        
        let touchPoint = touch.location(in: self.screenView.imageView)
        let circlePath = UIBezierPath(arcCenter: touchPoint, radius: CGFloat(20), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        let color = getPixelColorAtPoint(point: touchPoint, sourceView: screenView.imageView).cgColor.components!
        
        socket.sendMessage("{\"jsonrpc\":\"2.0\",\"method\":\"event\",\"params\":{\"x\":\(touchPoint.x),\"y\":\(touchPoint.y),\"color\":{\"r\":\(color[0]*255),\"g\":\(color[1]*255),\"b\":\(color[3]*255)}},\"id\":2}")
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        //change the fill color
        shapeLayer.fillColor = UIColor.clear.cgColor
        //you can change the stroke color
        shapeLayer.strokeColor = UIColor.red.cgColor
        //you can change the line width
        shapeLayer.lineWidth = 3.0
        
        screenView.imageView.layer.addSublayer(shapeLayer)
        
    }
    
    func getPixelColorAtPoint(point:CGPoint, sourceView: UIView) -> UIColor{
        
        let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        context!.translateBy(x: -point.x, y: -point.y)
        sourceView.layer.render(in: context!)
        let color:UIColor = UIColor(red: CGFloat(pixel[0])/255.0,
                                    green: CGFloat(pixel[1])/255.0,
                                    blue: CGFloat(pixel[2])/255.0,
                                    alpha: CGFloat(pixel[3])/255.0)
        pixel.deallocate(capacity: 4)
        return color
    }
    
    func centerScrollViewContents(){
        let boundsSize = screenView.scrollView.bounds.size
        var contentsFrame = screenView.imageView.frame
        
        if contentsFrame.size.width < boundsSize.width{
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2
        }else{
            contentsFrame.origin.x = 0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2
        }else{
            contentsFrame.origin.y = 0
        }
        self.screenView.imageView.frame = contentsFrame
        
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerScrollViewContents()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return screenView.imageView
    }
    
    func setupGestureRecognizer() {
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(deviceDidRotate(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        screenView.imageView.isUserInteractionEnabled = true
    }
    
    func deviceDidRotate(_ notification: Notification)
    {
        centerScrollViewContents()
    }
}

