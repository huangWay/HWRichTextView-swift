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
        richText.text = "屌得飞起:危旧房屋@好友的名字老长了， 金额放假啊放假啊http://baidu.com是一个好网站一二三文啊饿啊饿啊我 屌得飞起:长的飞起"
        richText.normalColor = UIColor.greenColor()
        richText.attributeColor = UIColor.blueColor()
        richText.highlightColor = UIColor.blueColor()
        richText.niceName = "屌得飞起:"
        richText.inputMode = false
        richText.niceColor = UIColor.redColor()
        richText.delegate = self
//        richText.font = UIFont.systemFontOfSize(17)
        richText.frame = CGRect(x: 0, y: 200, width: 300, height: 300)
        richText.backgroundColor = UIColor.lightGrayColor()
        view.addSubview(richText)
        
        let testv = UITextView(frame: CGRectMake(0, 100, 300, 200))
        testv.text = "我擦！！！！！"
        testv.backgroundColor = UIColor.redColor()
//        view.addSubview(testv)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: HWRichTextViewDelegate
    func urlClick(url: String) {
//        let vc = HWTestVC()
//        vc.url = url
//        navigationController?.pushViewController(vc, animated: true)
        print("点击了网址：\(url)")
    }
    func niceNameClick(niceName: String) {
        print("点击了昵称是：\(niceName)")
    }
    func atFunction(at: String) {
        print("艾特了这个人：\(at)")
    }
}

