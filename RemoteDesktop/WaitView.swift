//
//  WaitView.swift
//  RemoteDesktop
//
//  Created by Эрик Вильданов on 19.02.17.
//  Copyright © 2017 ErikVildanov. All rights reserved.
//

import UIKit

class WaitView: UIView {
    
    let boxView = UIView()
    let textLabel = UILabel()
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        
        initializeView()
    }
    
    convenience init () {
        self.init(frame: CGRect.zero)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeView(){
        
        addSubview(boxView)
        boxView.addSubview(activityView)
        boxView.addSubview(textLabel)
        boxView.translatesAutoresizingMaskIntoConstraints = false
        boxView.backgroundColor = UIColor.black
        boxView.alpha = 0.8
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[boxView]|", options: [], metrics: nil, views: ["boxView": boxView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[boxView]|", options: [], metrics: nil, views: ["boxView": boxView]))
        
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.centerXAnchor.constraint(equalTo: boxView.centerXAnchor).isActive = true
        activityView.centerYAnchor.constraint(equalTo: boxView.centerYAnchor).isActive = true
        boxView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[activityView(80)]", options: [], metrics: nil, views: ["activityView": activityView]))
        boxView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[activityView(80)]", options: [], metrics: nil, views: ["activityView": activityView]))
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        activityView.startAnimating()
        
    }
}
