//
//  ViewController.swift
//  HWRichTextView
//
//  Created by HuangWay on 16/1/27.
//  Copyright © 2016年 HuangWay. All rights reserved.
//

import UIKit

class ViewController: UIViewController,HWRichtTextDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        let richText = HWRichTextView()
//        richText.text = "屌得飞起:危旧房屋@好友的名字老长了， 金额放假啊放假啊http://baidu.com是一个好网站一二三文啊饿啊饿啊我 屌得飞起:长的飞起"
        richText.normalColor = UIColor.green
        richText.attributeColor = UIColor.blue
        richText.highlightColor = UIColor.blue
//        richText.niceName = "屌得飞起:"
//        richText.inputMode = false
        richText.niceColor = UIColor.red
        richText.delegate = self
//        richText.font = UIFont.systemFontOfSize(17)
        richText.inputMode = true;
        richText.frame = CGRect(x: 50, y: 200, width: 300, height: 300)
        richText.backgroundColor = UIColor.lightGray
        view.addSubview(richText)
        
//        let testv = UITextView(frame: CGRect(x: 0, y: 100, width: 300, height: 200))
//        testv.text = "我擦！！！！！"
//        testv.backgroundColor = UIColor.red
//        view.addSubview(testv)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: HWRichTextViewDelegate
    func urlClick(_ url: String) {
//        let vc = HWTestVC()
//        vc.url = url
//        navigationController?.pushViewController(vc, animated: true)
        print("点击了网址：\(url)")
    }
    func niceNameClick(_ niceName: String) {
        print("点击了昵称是：\(niceName)")
    }
    func atFunction(_ at: String) {
        print("艾特了这个人：\(at)")
    }
}

