//
//  ClientTableView.swift
//  RemoteDesktop
//
//  Created by Эрик Вильданов on 19.02.17.
//  Copyright © 2017 ErikVildanov. All rights reserved.
//

import UIKit

class ClientTableView: UIView {
    
    var tableView = UITableView()

    override init (frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        initializeView()
    }
    
    convenience init () {
        self.init(frame: CGRect.zero)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeView(){
        addSubview(tableView)

        UIApplication.shared.statusBarStyle = .lightContent
        tableView.estimatedRowHeight = 109
        tableView.rowHeight = UITableViewAutomaticDimension
        let viewsDict = [
            "tableView" : tableView,
        ]
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView]|", options: [], metrics: nil, views: viewsDict))
        
    }
    
    
    
}
