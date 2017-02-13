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
    var image = UIImage()
    var screenSize = ScreenSize()
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        imageView.backgroundColor = UIColor.white
        scrollView.backgroundColor = UIColor.yellow
        initializeView()
    }
    
    convenience init () {
        self.init(frame: CGRect.zero)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeView(){
        
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
        //image = drawCustomImage(size: CGSize(width: CGFloat(screenSize.widht), height: CGFloat(screenSize.height)))
        //imageView.image = image
    }
    
    func drawCustomImage(size: CGSize) -> UIImage {
        // Setup our context
        let bounds = CGRect(origin: CGPoint.zero, size: size)
        let opaque = false
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        let context = UIGraphicsGetCurrentContext()
        
        // Setup complete, do drawing here
        context!.setStrokeColor(UIColor.red.cgColor)
        context!.setLineWidth(1.0)
        
        context?.setFillColor(UIColor.red.cgColor)
        
        let countSquareX = Int(size.width/106)
        let countSquareY = Int(size.height/106)
        
        var xPoint = 0
        var yPoint = 0
        
        for i in 0..<countSquareX {
            xPoint = 112 * i
            
            context!.beginPath()
            context?.move(to: CGPoint(x: xPoint-8, y: 0))
            context?.addLine(to: CGPoint(x: CGFloat(xPoint-8), y: bounds.maxY))
            context?.move(to: CGPoint(x: CGFloat(xPoint-4), y: bounds.maxY))
            context?.addLine(to: CGPoint(x: xPoint-4, y: 0))
            context!.strokePath()
            
            for j in 0..<countSquareY{
                yPoint = 112 * j
                context?.setFillColor(getRandomColor().cgColor)
                context?.fill(CGRect(x: xPoint, y: yPoint, width: 100, height: 100))
                context!.beginPath()
                context?.move(to: CGPoint(x: 0, y: yPoint-8))
                context?.addLine(to: CGPoint(x: bounds.maxX, y: CGFloat(yPoint-8)))
                context?.move(to: CGPoint(x: bounds.maxX, y: CGFloat(yPoint-4)))
                context?.addLine(to: CGPoint(x: 0, y: yPoint-4))
                context!.strokePath()
            }
        }
        

        
        // Drawing complete, retrieve the finished image and cleanup
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func getRandomColor() -> UIColor{
        
        let randomRed:CGFloat = CGFloat(drand48())
        
        let randomGreen:CGFloat = CGFloat(drand48())
        
        let randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }

}
































