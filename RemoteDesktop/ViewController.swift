//
//  ViewController.swift
//  RemoteDesktop
//
//  Created by Эрик Вильданов on 17.09.16.
//  Copyright © 2016 ErikVildanov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    //var socket: SocketManager!
    let screenView = ScreenView()
    var size = CGSize()
    var url = String()
    
    var arrayOfTickets:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        size.width = 1280
        size.height = 1024
        
        let queue = DispatchQueue.global(qos: .utility)
        
        queue.async{
            while requestFlag == false {
            print("sssssssss")
                sleep(1)
        }
            self.connectWS()
        }
        
    }    

    func connectWS() {
        url = (replaceMatches(pattern: "https", inString: url, withString: "wss")?.appending("ws"))!
        
        //socket = SocketManager(url: url)
        
        let ws = WebSocket(url)
        
        ws.event.open = {
            print("opened")
        }
        
        ws.event.message = { message in
            if let text = message as? String {
                let data = text.data(using: .utf8)!
                
                let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
                
                if let results = json["images"] as? [[String: AnyObject]] {
                    
                    for result in results {
                        if let d = result["d"] as? String {
                            print("image: " ,d)
                            let dataDecoded : Data = Data(base64Encoded: d, options: .ignoreUnknownCharacters)!
                            let decodedimage = UIImage(data: dataDecoded)
                            self.screenView.imageView.image = decodedimage!
                            //print(self.screenView.imageView.image?.size)
                            self.view = self.screenView
                            self.screenView.scrollView.delegate = self
                            self.initializeImageView()
                            self.setupGestureRecognizer()
                            
                        }
                    }
                    
                }
                //self.parser(data)
            }
        }
        
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//        loadJson{
////            self.screenView.imageView.image = self.screenView.drawCustomImage(size: self.size)
////            self.view = self.screenView
////            self.screenView.scrollView.delegate = self
////            self.initializeImageView()
////            self.setupGestureRecognizer()
//            UIApplication.shared.isNetworkActivityIndicatorVisible = false
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
//    func loadJson(_ completion: ((Void) -> Void)?){
//        socket.parseFeed(completionHandler:
//            {
//                (json: CGSize) -> Void in
//                self.size = json
//                DispatchQueue.main.async(execute: {
//                    completion?()
//                })
//        })
//        
//    }
    
    
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
    
    func replaceMatches(pattern: String, inString string: String, withString replacementString: String) -> String? {
        let regex = try! NSRegularExpression(pattern: pattern, options: .allowCommentsAndWhitespace)
        let range = NSMakeRange(0, string.characters.count)
        
        return regex.stringByReplacingMatches(in: string, options: .anchored, range: range, withTemplate: replacementString)
    }
}

