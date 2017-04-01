//
//  MyURLProtocol.swift
//  RemoteDesktop
//
//  Created by Эрик Вильданов on 04.03.17.
//  Copyright © 2017 ErikVildanov. All rights reserved.
//

import UIKit

var requestFlag = false

class MyURLProtocol: URLProtocol {
    
    override class func canInit(with request: URLRequest) -> Bool {
        
        let url: NSURL = request.url! as URL as NSURL
        let urlParts = url.pathComponents
        print(urlParts)
    
        if urlParts?.count == 4 && urlParts?[3] == "start" {
            requestFlag = true
        }
        
        return false
    }
    
}
