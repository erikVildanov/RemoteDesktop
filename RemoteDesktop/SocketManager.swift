//
//  SocketIOManager.swift
//  RemoteDesktop
//
//  Created by Эрик Вильданов on 04.11.16.
//  Copyright © 2016 ErikVildanov. All rights reserved.
//

import UIKit

class SocketManager: NSObject {
    
    
    var screenSize = CGSize()
    let ws = WebSocket("ws://52.55.50.126:1338")
    
    fileprivate var parserCompletionHandler:((CGSize) -> Void )?
    
    func parseFeed (completionHandler: ((CGSize) -> Void)?) -> Void {

        self.parserCompletionHandler = completionHandler
            
            ws.event.open = {
                print("opened")
            }
            
            ws.send("{\"jsonrpc\":\"2.0\",\"method\":\"getRemoteScreenSize\",\"params\":{},\"id\":2}")
            
            ws.event.message = { message in
                if let text = message as? String {
                    let data = text.data(using: .utf8)!
                    self.parser(data)
                }
            }
        
    }
    
    func parser(_ data: Data){
        
        let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
        
        if let result = json["result"] as? [String: AnyObject] {
            
            if let widht = result["width"] as? Int {
                screenSize.width = CGFloat(widht)
            }
            if let height = result["height"] as? Int {
                screenSize.height = CGFloat(height)
            }
        }
        
        parserCompletionHandler?(screenSize)
    }
    
    func sendMessage(_ message: String){
        ws.send(message)
    }
}
