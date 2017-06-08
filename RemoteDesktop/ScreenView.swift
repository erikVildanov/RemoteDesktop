//
//  ScreenView.swift
//  RemoteDesktop
//
//  Created by Эрик Вильданов on 17.09.16.
//  Copyright © 2016 ErikVildanov. All rights reserved.
//

import UIKit

class ScreenView: UIView {
    
    var imageView = UIImageView()
    var scrollView = UIScrollView()
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        imageView.backgroundColor = UIColor.blue
        initializeView()
    }
    
    convenience init () {
        self.init(frame: CGRect.zero)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeView(){
        self.imageView.isMultipleTouchEnabled = true
        self.imageView.isUserInteractionEnabled = true
        
        scrollView.panGestureRecognizer.minimumNumberOfTouches = 2
        scrollView.panGestureRecognizer.maximumNumberOfTouches = 2
        addSubview(scrollView)
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        scrollView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        let viewsDict = [
            "scrollView" : scrollView,
            "toolBar" : imageView
        ] as [String : Any]
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollView]|", options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[scrollView]|", options: [], metrics: nil, views: viewsDict))
        
        scrollView.addSubview(imageView)
    }
    

}
































