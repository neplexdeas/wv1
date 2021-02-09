//
//  ViewController.swift
//  WKWebView
//
//  Created by Nik S on 06/02/21.
//

import UIKit
import WebKit

class HomeController: UIViewController {
    private var TAG: String = "HomeController"

    @IBOutlet weak var webView: WKWebView!
    
    private var activityIndicatorContainer: UIView!
    private var activityIndicator: UIActivityIndicatorView!

    var baseUrl: String = "https://getmaxluck.com/?s=35&ref=wp_w94049p143_vulkanclub&url=register"

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        loadWebview()
    }

    private func initView(){
        
    }
    
    private func loadWebview(){
        let url = URL(string: baseUrl)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    // MARK: Init Loader
     private func initActivityIndicator() {
         self.activityIndicatorContainer = UIView(frame: CGRect(x: 0, y: 0, width: 140, height: 140))
         self.activityIndicatorContainer.center.x = self.webView.center.x
         self.activityIndicatorContainer.center.y = self.webView.center.y
         self.activityIndicatorContainer.backgroundColor = UIColor.black
         self.activityIndicatorContainer.alpha = 0.8
         self.activityIndicatorContainer.layer.cornerRadius = 10
         
         self.activityIndicator = UIActivityIndicatorView()
         self.activityIndicator.hidesWhenStopped = true
         self.activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
         self.activityIndicator.color = .white
         self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
         self.activityIndicatorContainer.addSubview(activityIndicator)
         self.webView.addSubview(activityIndicatorContainer)
         
         self.activityIndicator.centerXAnchor.constraint(equalTo: self.activityIndicatorContainer.centerXAnchor).isActive = true
         self.activityIndicator.centerYAnchor.constraint(equalTo: self.activityIndicatorContainer.centerYAnchor).isActive = true
         
        let labelText = UILabel()
        labelText.text = "Загрузка"
        labelText.textColor = UIColor.white
        labelText.layer.borderWidth = 1.0
        self.activityIndicatorContainer.addSubview(labelText)
        labelText.translatesAutoresizingMaskIntoConstraints = false
        labelText.topAnchor.constraint(equalTo: self.activityIndicator.bottomAnchor, constant: 20).isActive = true
        labelText.centerXAnchor.constraint(equalTo: self.activityIndicator.centerXAnchor).isActive = true
    }
    
    private func showLoader() {
        self.initActivityIndicator()
        self.activityIndicator.startAnimating()
            
        Timer.scheduledTimer(timeInterval:
              5000/1000 ,
              target: self,
              selector: #selector(hideLoader),
              userInfo: [ "foo" : "bar" ],
              repeats: false)
    }
    
    @objc func hideLoader() {
        self.activityIndicator.stopAnimating()
        self.activityIndicatorContainer.removeFromSuperview()
    }
}

func printLog(tag: String, message: String){
    print(tag, message)
}

// MARK: All Delegates
extension HomeController: WKUIDelegate, WKNavigationDelegate{
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.showLoader()
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        //self.showSpinner()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.hideLoader()
    }
     
    func webView(_ webView: WKWebView, didFailLoadWithError error: Error) {
        self.hideLoader()
    }
    
     func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        printLog(tag: TAG, message: "Error code: \(error._code)")
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String,
                   initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {

          let alertController = UIAlertController(title: message, message: nil,
                                                  preferredStyle: UIAlertController.Style.alert);
          alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel) {
              _ in completionHandler()}
          );

          self.present(alertController, animated: true, completion: {});
      }

      func webView(_: WKWebView, createWebViewWith _: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures _: WKWindowFeatures) -> WKWebView? {
          return nil
      }
}

