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
    var request: URLRequest!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
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
            request = URLRequest(url: URL(string: urlString)!)
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
