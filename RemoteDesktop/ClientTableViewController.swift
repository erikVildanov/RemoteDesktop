//
//  ClientTableViewController.swift
//  RemoteDesktop
//
//  Created by Эрик Вильданов on 19.02.17.
//  Copyright © 2017 ErikVildanov. All rights reserved.
//

import UIKit

class ClientTableViewController: UIViewController, UITableViewDelegate {

    let clientTableDataSource = ClientTableDataSource()
    let clientTableView = ClientTableView()
    let refreshControl = UIRefreshControl()
    let feedParser = FeedParser()
    let waitView = WaitView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        clientTableView.tableView.delegate = self
        refreshTable()
        createBarButtonLogOut()
        view = clientTableView
        clientTableView.tableView.register(ClientTableViewCell.self, forCellReuseIdentifier: "Cell")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        loadJson{
            self.clientTableView.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        clientTableDataSource.client = feedParser.client
        clientTableView.tableView.dataSource = clientTableDataSource
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func loadJson(_ completion: ((Void) -> Void)?){
        feedParser.parseFeed(request: URLRequest(url: URL(string: "https://deskroll.com/my/rd/list.php?")!) , completionHandler:
            {
                (json: Client) -> Void in
                self.clientTableDataSource.client = json
                DispatchQueue.main.async(execute: {
                    completion?()
                })
        })
    }
    
    func createBarButtonLogOut(){
        let logOutButton = UIBarButtonItem(image: UIImage(named: "Exit"), style: .plain, target: self, action: #selector(logout))
        self.navigationItem.setRightBarButton(logOutButton, animated: true)
    }
    
    func logout() {
        URLCache.shared.removeAllCachedResponses()
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
        let loginViewController = LoginViewController()
        self.navigationController?.pushViewController(loginViewController, animated: false)
    }
    
    func refreshTable(){
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        clientTableView.tableView.addSubview(refreshControl)
    }
    
    func refresh() {
        refreshControl.beginRefreshing()
        loadJson {
            self.clientTableView.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            self.refreshControl.endRefreshing()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        waitView.frame = view.frame
        view.addSubview(waitView)
        let request = URLRequest(url: URL(string: "https://deskroll.com/my/rd/connect.php?guid=".appending(feedParser.client.value[indexPath.row]))!)
        redirectURL(request: request) {
            url in
            DispatchQueue.main.async {
            let viewController = ViewController()
            viewController.url = url.absoluteString
            viewController.modalTransitionStyle = .crossDissolve
            self.navigationController?.pushViewController(viewController, animated: false)
            self.waitView.removeFromSuperview()
            }
        }
    }
    
    func redirectURL(request : URLRequest, successHandler: @escaping (_ response: URL) -> Void){
        let session = URLSession.shared
        let task = session.dataTask(with: request) {
            data, response, error in
            
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            successHandler((response?.url)!);
        }
        task.resume()
    }
}
