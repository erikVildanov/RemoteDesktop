//
//  mouseEvent.swift
//  RemoteDesktop
//
//  Created by Эрик Вильданов on 22.04.17.
//  Copyright © 2017 ErikVildanov. All rights reserved.
//

import UIKit

class MouseEvent {
    
    var et = 1
    var x = 0
    var y = 0
    var b = 0
    var bs = 0
    var sx = 0
    var sy = 0
    private var map = ["events":[[String: String]]()]
    private var array = [[String: String]]()
    
    init() {
    }
    
    init(x: Int, y: Int, b: Int, bs: Int){
        self.x = x
        self.y = y
        self.b = b
        self.bs = bs
    }
    
    init(x: Int, y: Int, sx: Int, sy: Int) {
        self.x = x
        self.y = y
        self.sx = sx
        self.sy = sy
    }
    
    func addEvent() {
        array.append(["et": "\(et)","x": "\(x)","y": "\(y)","b": "\(b)","bs": "\(bs)","sx": "\(sx)","sy": "\(sy)"])
        map["events"] = array
    }
    
    func clearEvent(){
        array.removeAll()
        map.removeAll()
    }
    
    func toString() -> String {
        let data = try! JSONSerialization.data(withJSONObject: map, options: [])
        return String(data: data, encoding: .utf8)!
    }
    
}

