//
//  ClientTableViewCell.swift
//  RemoteDesktop
//
//  Created by Эрик Вильданов on 19.02.17.
//  Copyright © 2017 ErikVildanov. All rights reserved.
//

import UIKit

class ClientTableViewCell: UITableViewCell {
    
    var iconImage = UIImageView()
    var nickName = UILabel()
    var stasus = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        nickName.translatesAutoresizingMaskIntoConstraints = false
        stasus.translatesAutoresizingMaskIntoConstraints = false
        iconImage.contentMode = .scaleAspectFit
        
        backgroundColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        nickName.lineBreakMode = .byWordWrapping
        nickName.numberOfLines = 0
        
        contentView.addSubview(iconImage)
        contentView.addSubview(nickName)
        contentView.addSubview(stasus)
        
        let viewsDict = [
            "iconImage" : iconImage,
            "information" : nickName,
            "stasus" : stasus
            ] as [String : Any]
        
        if #available(iOS 9.0, *) {
            iconImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        } else {
            addConstraint(NSLayoutConstraint(item: iconImage, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: 0))
        }
        if #available(iOS 9.0, *) {
            iconImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        } else {
            addConstraint(NSLayoutConstraint(item: iconImage, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0))
        }
        iconImage.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[iconImage(50)]", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[iconImage(50)]-10-[information]-(>=10)-[stasus]-3-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-3-[information(>=40)]-3-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-3-[stasus(>=40)]-3-|", options: [], metrics: nil, views: viewsDict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        iconImage.image = nil
        nickName.text = nil
    }
    
}
