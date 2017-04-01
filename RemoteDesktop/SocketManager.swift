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
    var ws: WebSocket
    fileprivate var parserCompletionHandler:((CGSize) -> Void )?
    
    init(url: String) {
        ws = WebSocket(url)
    }
    
    func parseFeed (completionHandler: ((CGSize) -> Void)?) -> Void {
        
        self.parserCompletionHandler = completionHandler
            
            ws.event.open = {
                print("opened")
            }
            
            ws.event.message = { message in
                if let text = message as? String {
                    let data = text.data(using: .utf8)!
                    print(text)
                    self.parser(data)
                }
            }
        
    }
    
    func parser(_ data: Data){
        
        let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
        
        if let results = json["images"] as? [[String: AnyObject]] {
            
            for result in results {
                if let d = result["d"] as? String {
                    print("image")
                }
            }
            
        }
        
        parserCompletionHandler?(screenSize)
    }
    
}
