//
//  ClientTableViewController.swift
//  RemoteDesktop
//
//  Created by Эрик Вильданов on 19.02.17.
//  Copyright © 2017 ErikVildanov. All rights reserved.
//

import UIKit

class ClientTableViewController: UIViewController, UITableViewDelegate, UIWebViewDelegate {

    let clientTableDataSource = ClientTableDataSource()
    let clientTableView = ClientTableView()
    let refreshControl = UIRefreshControl()
    var request = NSURLRequest()
    var webView = UIWebView()
    let feedParser = FeedParser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func loadJson(_ completion: ((Void) -> Void)?){
        feedParser.parseFeed(request: request , completionHandler:
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
        request = NSURLRequest(url: NSURL(string: "https://deskroll.com/my/rd/connect.php?guid=".appending(feedParser.client.value[indexPath.row])) as! URL)
        webView.loadRequest(request as URLRequest)
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        let urlString: NSString = request.url!.absoluteString as NSString
        let url: NSURL = request.url! as URL as NSURL
        let urlParts = url.pathComponents
        
        if urlParts?.count == 3 && urlParts?[1] != "plugins"{
            let viewController = ViewController()
            viewController.url = urlString as String
            viewController.modalTransitionStyle = .crossDissolve
            self.navigationController?.pushViewController(viewController, animated: false)
        }
        
        return true
    }
    

}
