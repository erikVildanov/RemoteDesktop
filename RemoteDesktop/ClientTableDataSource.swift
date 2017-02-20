//
//  ClientTableDataSource.swift
//  RemoteDesktop
//
//  Created by Эрик Вильданов on 19.02.17.
//  Copyright © 2017 ErikVildanov. All rights reserved.
//

import UIKit

class ClientTableDataSource: NSObject, UITableViewDataSource {

    var client = Client()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return client.name.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ClientTableViewCell
        
        let url = URL(string: "https://deskroll.com".appending(client.iconUrl[indexPath.row]))
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                cell.iconImage.image = UIImage(data: data!)
            }
        }
        
        cell.nickName.text = client.name[indexPath.row]
        cell.stasus.text = client.status[indexPath.row]
       
        if client.status[indexPath.row] == "online" {
            cell.backgroundColor = UIColor.green
        } else {
            cell.backgroundColor = UIColor.red
        }
        
        return cell
    }
    
}
