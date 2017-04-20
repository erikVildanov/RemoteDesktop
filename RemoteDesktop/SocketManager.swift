//
//  SocketIOManager.swift
//  RemoteDesktop
//
//  Created by Эрик Вильданов on 04.11.16.
//  Copyright © 2016 ErikVildanov. All rights reserved.
//

import UIKit

class SocketManager: NSObject {
    
    var curRes = Int()
    var ws: WebSocket
    fileprivate var parserCompletionHandler:((CGSize) -> Void )?
    
    init(url: String) {
        ws = WebSocket(url)
    }
    
    
    func getimage(_ data: Data) -> (Images) {
        let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
        let imageModel = Images()
        
        if let images = json["images"] as? [[String: AnyObject]] {
            for image in images {
                let d = image["d"] as? String
                    let dataDecoded : Data = Data(base64Encoded: d!, options: .ignoreUnknownCharacters)!
                    imageModel.image = UIImage(data: dataDecoded)!

                if let x = Int(image["x"] as! String) {
                    imageModel.x = x
                }
                
                if let y = Int(image["y"] as! String) {
                    imageModel.y = y
                }
            }
        }
        
        return imageModel
    }
    
    func SessionStarted(_ data: Data) -> Bool {
        let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
        
        if let session = json["session"] as? [String: AnyObject] {
            if session["started"] as? Int == 1 {
                return true
            }
        }
        return false
        
    }
    
    func parserScreen(_ data: Data) -> CGSize!{
        
        var screenSize = CGSize()
        
        let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
        
        if let destop = json["desktop"] as? [String: AnyObject] {
            if let displays = destop["displays"] as? [[String: AnyObject]] {
                    
                    if let isCaptured = Int(displays[0]["isCaptured"] as! String) {
                    
                    if let resolutions = displays[0]["resolutions"] as? [[String: AnyObject]]{
                        screenSize.height = CGFloat(Int(resolutions[isCaptured]["height"] as! String)!)
                        screenSize.width = CGFloat(Int(resolutions[isCaptured]["width"] as! String)!)
                    }
                    }

                
            }
        }
        return screenSize
    }
    
    func sendMessage(_ message: String){
        ws.send(text: message)
        }
}
