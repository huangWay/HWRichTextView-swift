//
//  HWTestVC.swift
//  HWRichTextView
//
//  Created by HuangWay on 16/2/1.
//  Copyright © 2016年 HuangWay. All rights reserved.
//

import UIKit

class HWTestVC: UIViewController {
    var url:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        let webView = UIWebView(frame: view.bounds)
        let request = NSURLRequest(URL: NSURL(string: url!)!)
        webView.loadRequest(request)
        view.addSubview(webView)
    }
}
