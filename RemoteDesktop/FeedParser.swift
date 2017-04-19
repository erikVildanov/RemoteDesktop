//
//  FeedParser.swift
//  RemoteDesktop
//
//  Created by Эрик Вильданов on 19.02.17.
//  Copyright © 2017 ErikVildanov. All rights reserved.
//

import UIKit

class FeedParser {
    
    var client = Client()
    
    private var parserCompletionHandler:((Client) -> Void)?
    
    
    func parseFeed (request: URLRequest, completionHandler: ((Client) -> Void)?) -> Void {
        self.parserCompletionHandler = completionHandler
        
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request as URLRequest, completionHandler:{
            (data, respouse, error) -> Void in
            
            if error != nil {
                print("\(String(describing: error?.localizedDescription))")
            }
            self.parser(data: data!)
        })
        task.resume()
    }
    
    func parser(data: Data){
        let stringUrl = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
        
        let clientValue = listGroups(pattern: "value=\"(.*)\"", inString: stringUrl as String)
        let nickName = listGroups(pattern: "deff_nickname=\".*\">(.+)<span rel=", inString: stringUrl as String)
        let urlIcon = listGroups(pattern: "img src=\"(.*)\" alt", inString: stringUrl as String)
        let status = listGroups(pattern: "b-users-table-item-status\">(.*)<\\/div>", inString: stringUrl as String)
        client.value = clientValue
        client.name = nickName
        client.iconUrl = urlIcon
        client.status = status
        
        parserCompletionHandler?(client)
    }
    
    func listMatches(pattern: String, inString string: String) -> [String] {
        let regex = try! NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
        let range = NSMakeRange(0, string.characters.count)
        let matches = regex.matches(in: string, options: [], range: range)
        
        return matches.map {
            let range = $0.range
            return (string as NSString).substring(with: range)
        }
    }
    
    func listGroups(pattern: String, inString string: String) -> [String] {
        let regex = try! NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
        let range = NSMakeRange(0, string.characters.count)
        let matches = regex.matches(in: string, options: [], range: range)
        
        var groupMatches = [String]()
        for match in matches {
            let rangeCount = match.numberOfRanges
            
            for group in 1..<rangeCount {
                groupMatches.append((string as NSString).substring(with: match.rangeAt(group)))
            }
        }
        
        return groupMatches
    }
    
}
