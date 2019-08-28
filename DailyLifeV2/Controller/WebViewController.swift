//
//  WebViewController.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/14/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
  
  @IBOutlet var webViewArticle: WKWebView!
  @IBOutlet var linkTextField: UITextField!
  @IBOutlet var backButton: UIButton!
  @IBOutlet var fowardButton: UIButton!
  @IBOutlet var progressView: UIProgressView!
  @IBOutlet var refreshButton: UIButton!
  
  
  var urlOfContent: String?
  let mainLink = "Daily Life"
  var isWebViewFinishLoading = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupLinkTextField()
    setupWebViewArticle()
    
  }
  
  func setupLinkTextField(){
    linkTextField.delegate = self
    linkTextField.text = String(urlOfContent!)
  }
  
  func setupWebViewArticle(){
    webViewArticle.navigationDelegate = self
    webViewArticle.configuration.allowsInlineMediaPlayback = true
    
    let refreshController = UIRefreshControl()
    refreshController.addTarget(self, action: #selector(pullToRefreshWebView(sender:)), for: .valueChanged)
    refreshController.tintColor = #colorLiteral(red: 1, green: 0.765712738, blue: 0.0435429886, alpha: 1)
    refreshController.backgroundColor = .black

    webViewArticle.scrollView.addSubview(refreshController)
    
    let urlContent = URL(string: urlOfContent!)
    webViewArticle.load(URLRequest(url: urlContent!))
    
    let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
    swipeLeft.direction = .left
    
    let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
    swipeRight.direction = .right
    
    webViewArticle.addGestureRecognizer(swipeLeft)
    webViewArticle.addGestureRecognizer(swipeRight)
    webViewArticle.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
  }
  
  @objc func pullToRefreshWebView(sender: UIRefreshControl){
    webViewArticle.reload()
    sender.endRefreshing()
  }
  
  @objc func handleSwipeLeft(){
    if webViewArticle.canGoForward{
      webViewArticle.goForward()
    }
  }
  
  @objc func handleSwipeRight(){
    if webViewArticle.canGoBack{
      webViewArticle.goBack()
    }
  }
  
  @IBAction func backButton(_ sender: Any) {
    if webViewArticle.canGoBack{
      webViewArticle.goBack()
    }
  }
  
  @IBAction func fowardButton(_ sender: Any) {
    if webViewArticle.canGoForward{
      webViewArticle.goForward()
    }
  }
  
  @IBAction func refreshButton(_ sender: Any) {
    webViewArticle.reload()
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == "estimatedProgress"{
      progressView.progress = Float(webViewArticle.estimatedProgress)
    }
  }
}

extension WebViewController: UITextFieldDelegate{
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    var urlString = textField.text!
    if urlString.contains("https://www.") == false{
      urlString = "https://www.\(urlString)"
    } else if urlString.contains("https://") == false{
      urlString = "https://\(urlString)"
    }
    webViewArticle.load(URLRequest(url: URL(string: urlString)!))
    textField.resignFirstResponder()
    return true
  }
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    return isWebViewFinishLoading ? true : false
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    linkTextField.text = String(urlOfContent!)
    textField.selectAll(nil)
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    textField.becomeFirstResponder()
    textField.text = mainLink
  }
}

extension WebViewController: WKNavigationDelegate{
  func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
    linkTextField.text = webView.url?.absoluteString
    progressView.isHidden = false
    
    switch (webView.canGoBack, webView.canGoForward){
    case (false, false):
      backButton.isEnabled = false
      fowardButton.isEnabled = false
    case (false, true):
      backButton.isEnabled = false
      fowardButton.isEnabled = true
    case (true, false):
      backButton.isEnabled = true
      fowardButton.isEnabled = false
    case (true, true):
      backButton.isEnabled = true
      fowardButton.isEnabled = true
    }
  }
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    isWebViewFinishLoading = true
    progressView.isHidden = true
    linkTextField.text = mainLink
  }
}
