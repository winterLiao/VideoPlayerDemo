//
//  WebViewController.swift
//  VideoPlayerDemo
//
//  Created by 廖文韬 on 2018/8/3.
//  Copyright © 2018年 廖文韬. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    
     var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpWKwebView()
    }
    
    func setUpWKwebView() {
        self.title = "WebView播放视频"
        self.view.backgroundColor = UIColor.white
        let url = NSURL(string: urlString)
        let request = NSURLRequest.init(url: url! as URL)
        self.webView = WKWebView(frame: self.view.bounds)
        self.webView?.load(request as URLRequest)
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
        self.view.addSubview(self.webView)
    }
    
}

extension WebViewController:WKNavigationDelegate,WKUIDelegate
{
    //页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
        
    }
    //当内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!){
        
    }
    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        
    }
    //页面加载失败时调用
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
        
    }
}
