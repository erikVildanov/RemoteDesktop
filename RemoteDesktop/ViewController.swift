//
//  ViewController.swift
//  RemoteDesktop
//
//  Created by Эрик Вильданов on 17.09.16.
//  Copyright © 2016 ErikVildanov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    var socket: SocketManager!
    let screenView = ScreenView()
    var size = CGSize(width: 0, height: 0)
    var url = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postURL(urlString: url, successHandler: {
            self.connectWS()
        })
        setupGestureRecognizer()
    }
    
    override func viewWillLayoutSubviews() {
        
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            navigationController?.isNavigationBarHidden = true
            setZoomScale()
        case .portrait:
            navigationController?.isNavigationBarHidden = false
            setZoomScale()
        default:
            setZoomScale()
        }
        
    }

    func postURL(urlString : String, successHandler: @escaping () -> Void){
        var request = URLRequest(url: URL(string: urlString.appending("start"))!)
        request.httpMethod = "POST"
        request.addValue("application/json; charset=UTF-8",forHTTPHeaderField: "Content-Type")
        request.addValue("application/json, text/javascript, */*; q=0.01",forHTTPHeaderField: "Accept")
        let p2p = ["p2p":"0"]
        let data: Data = try! JSONSerialization.data(withJSONObject: p2p, options: .prettyPrinted)
        request.httpBody = data
        
        let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            successHandler()
        }
        task.resume()
    }
    

    func connectWS() {
        url = (replaceMatches(pattern: "https", inString: url, withString: "wss")?.appending("ws"))!
        
        socket = SocketManager(url: url)
        
        socket.ws.event.open = {
            print("opened")
        }
        
        socket.ws.event.message = { message in
            if let text = message as? String {
                let data = text.data(using: .utf8)!
                guard !self.socket.SessionStarted(data) else {
                    print("started false")
                    return }
                
                if self.socket.parserScreen(data).height > 0 {
                    self.size = self.socket.parserScreen(data)
                    self.view = self.screenView
                    self.screenView.scrollView.delegate = self
                    self.screenView.imageView.frame = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
                    self.screenView.scrollView.contentSize = self.size
                    self.setZoomScale()
                    UIGraphicsBeginImageContext(self.size)
                } else if self.size.height > 0{
                    self.screenView.imageView.image = self.getMixedImg(images: self.socket.getimage(data))
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getMixedImg(images: Images) -> UIImage {
        
        images.image.draw(at: CGPoint(x: images.x, y: images.y))
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        
        return finalImage!
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return screenView.imageView
    }
    
    func setZoomScale() {
        
        let imageViewSize = screenView.imageView.bounds.size
        let scrollViewSize = screenView.scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        
        screenView.scrollView.minimumZoomScale = min(widthScale, heightScale)
        screenView.scrollView.maximumZoomScale = max(widthScale, heightScale)
        screenView.scrollView.zoomScale = min(widthScale, heightScale)
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        let imageViewSize = screenView.imageView.frame.size
//        let scrollViewSize = screenView.scrollView.bounds.size
//        
//        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
//        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
//        
//        screenView.scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
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
    
    func setupGestureRecognizer() {
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(tapActions))
        tap.minimumPressDuration = 0
        screenView.imageView.addGestureRecognizer(tap)
        
    }
    
    func tapActions(touch: UILongPressGestureRecognizer) {
        
        let touchPoint = touch.location(in: self.screenView.imageView)
        var touchBegan = CGPoint()
        
        if touch.state == .began {
            touchBegan = touchPoint
            let p2p = ["et":"1","x":"\(Int(touchPoint.x))","y":"\(Int(touchPoint.y))","b":"1","bs":"1","sx":"0","sy":"0"]
            let data: Data = try! JSONSerialization.data(withJSONObject: p2p, options: .prettyPrinted)
            let datastring = String(data: data, encoding: .utf8)
            print(datastring ?? "")
            socket.ws.send(datastring ?? "")
        } else if touch.state == .ended {
            let p2p = ["et":"1","x":"\(Int(touchPoint.x))","y":"\(Int(touchPoint.y))","b":"1","bs":"2","sx":"0","sy":"0"]
            let data: Data = try! JSONSerialization.data(withJSONObject: p2p, options: .prettyPrinted)
            let datastring = String(data: data, encoding: .utf8)
            print(datastring ?? "")
            socket.ws.send(datastring ?? "")
        }
//        else if touch.state == .changed && (Int(touchBegan.x) != Int(touchPoint.x) || Int(touchBegan.y) != Int(touchPoint.y)){
//            let p2p = ["et":"1","x":"\(Int(touchPoint.x))","y":"\(Int(touchPoint.y))","b":"0","bs":"0","sx":"0","sy":"0"]
//            let data: Data = try! JSONSerialization.data(withJSONObject: p2p, options: .prettyPrinted)
//            socket.ws.send(data)
//        }
        
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        if parent == nil {
        socket.ws.close()
        UIGraphicsEndImageContext()
        }
    }
    
    func replaceMatches(pattern: String, inString string: String, withString replacementString: String) -> String? {
        let regex = try! NSRegularExpression(pattern: pattern, options: .allowCommentsAndWhitespace)
        let range = NSMakeRange(0, string.characters.count)
        
        return regex.stringByReplacingMatches(in: string, options: .anchored, range: range, withTemplate: replacementString)
    }
}

