//
//  LoginViewController.swift
//  RemoteDesktop
//
//  Created by Эрик Вильданов on 19.02.17.
//  Copyright © 2017 ErikVildanov. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UIWebViewDelegate {
    
    let clientTableDataSource = ClientTableDataSource()
    let loginView = LoginView()
    let waitView = WaitView()
    let deskRollURL = DeskRollURL()
    var request: NSURLRequest!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginView.webView.delegate = self
        view = loginView
        navigationItem.title = "LogIn DeskRoll"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Reachability.connectedToNetwork() == true {
            let urlString = deskRollURL.baseURL.appendingFormat(deskRollURL.loginURL)
            request = NSURLRequest(url: NSURL(string: urlString) as! URL)
            loginView.webView.loadRequest(request as URLRequest)
        } else {
            let alert = UIAlertController(title: "Соединение не установлено", message: "проверьте соединение с интернетом", preferredStyle: UIAlertControllerStyle.alert)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let urlString: NSString = request.url!.absoluteString as NSString
        
        if urlString == "https://deskroll.com/my/start/" {
            let clientTableViewController = ClientTableViewController()
            clientTableViewController.webView = loginView.webView
            clientTableViewController.request = NSURLRequest(url: NSURL(string: "https://deskroll.com/my/rd/list.php?") as! URL)
            clientTableViewController.modalTransitionStyle = .crossDissolve
            self.navigationController?.pushViewController(clientTableViewController, animated: false)
            loginView.webView.removeFromSuperview()
        }
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        waitView.frame = view.frame
        view.addSubview(waitView)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        waitView.removeFromSuperview()
    }

}
