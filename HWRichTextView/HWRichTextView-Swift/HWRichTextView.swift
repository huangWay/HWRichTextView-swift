//
//  HWRichTextView.swift
//  HWRichTextView
//
//  Created by HuangWay on 16/2/1.
//  Copyright © 2016年 HuangWay. All rights reserved.
//

import UIKit
//因为swift默认所有的代理方法都是必须实现的，所以如果有的方法要是可选的(optional)，那么代理要加@objc
protocol HWRichtTextDelegate:NSObjectProtocol {
    /**
     url点击
     */
    func urlClick(url:String)
    /**
     @点击
     */
    func atFunction(at:String)
    /**
     话题点击
     */
    func topicClick(topic:String)
    /**
     昵称点击
     */
    func niceNameClick(niceName:String)
}
extension HWRichtTextDelegate {
    func urlClick(url:String) {
        print("urlClick:\(url)")
    }
    func atFunction(at:String) {
        print("atFunction:\(at)")
    }
    func topicClick(topic:String) {
        print("topicClick:\(topic)")
    }
    func niceNameClick(niceName:String) {
        print("niceNameClick:\(niceName)")
    }
}
enum HWRichTextType {
    case url        //url类型
    case at         //@类型
    case topic      //话题类型
    case niceName   //昵称类型
    case error      //不是正常的富文本
}

class HWRichTextView: UIView,UITextViewDelegate {
    weak var delegate:HWRichtTextDelegate?
    /// 选中区域高亮的颜色
    var highlightColor:UIColor = UIColor.clearColor()
    /// 文本
    var text:String = ""
    /// 富文本的颜色
    var attributeColor:UIColor = UIColor.clearColor()
    /// 普通文本的颜色
    var normalColor:UIColor = UIColor.clearColor()
    /// 字体
    var font:UIFont = UIFont.systemFontOfSize(17)
    /// 是不是输入模式，使用的时候一定要赋值，
    var inputMode:Bool = false {
        didSet {
            textView.scrollEnabled = inputMode
            textView.userInteractionEnabled = inputMode
            textView.editable = inputMode
        }
    }
    /// 昵称
    var niceName:String = ""
    /// 昵称的颜色
    var niceColor:UIColor = UIColor.clearColor()
    
    private lazy var selectable = [HWMatchResult]()
    private var textView:UITextView = UITextView()
    private lazy var backgrounds = [UIView]()
    private let url:String = "((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)"
    private let atfunc = "(@[^\\s]{1,}\\s)|(@[^\\s]{1,}$)"
    private let topic = "#[^#]+#"
    
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }
    private func prepareUI() {
        textView.backgroundColor = UIColor.clearColor()
        textView.textContainerInset = UIEdgeInsetsMake(0, -5, 0, -5)
        textView.delegate = self
        textView.autocapitalizationType = UITextAutocapitalizationType.None
        self.addSubview(textView)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: layoutsubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        textView.frame = bounds
        textView.attributedText = attributeTextWithText(text)
    }
    //MARK: private 方法
    private func attributeTextWithText(text:String) -> NSAttributedString {
        if text.characters.count > 0 {
            let result = attributeTextAfterEmotionWithText(text)
            let attrM = NSMutableAttributedString(attributedString: result)
            attrM.addAttribute(NSForegroundColorAttributeName, value: normalColor, range: NSMakeRange(0, text.characters.count))
            //其它要匹配的这里加
            attributeStringWithPattern(attrM, pattern:url,niceName: niceName)
            attributeStringWithPattern(attrM, pattern:atfunc,niceName: nil)
            attributeStringWithPattern(attrM, pattern:topic,niceName: nil)
            return attrM
        }
        return NSAttributedString(string: text)
    }
    /**
     除去表情的富文本
     
     - parameter text: 原文本
     
     - returns: 转化以后的富文本
     */
    private func attributeTextAfterEmotionWithText(text:String) -> NSAttributedString {
        let strMatch = HWStringMatch.instance
        var mutArr = [HWMatchResult]()
        strMatch.matchType = "emoji"
        let emojiPattern = "\\[[0-9a-zA-Z\\u4e00-\\u9fa5]+\\]"
        let emojis = strMatch.matchStringWithPattern(text, pattern: emojiPattern)
        strMatch.matchType = "notemoji"
        let noemojis = strMatch.seperateStringWithPattern(text, pattern: emojiPattern)
        mutArr.appendContentsOf(emojis)
        mutArr.appendContentsOf(noemojis)
        mutArr.sortInPlace { (obj1, obj2) -> Bool in
            if obj1.range.location < obj2.range.location {
                return true
            }
            return false
        }
        let attrM = NSMutableAttributedString()
        for matchRes in mutArr {
            let attrStr = NSAttributedString(string: matchRes.cutStr)
            attrM.appendAttributedString(attrStr)
        }
        attrM.addAttribute(NSFontAttributeName, value: font, range: NSMakeRange(0, attrM.length))
        return attrM
    }
    
    private func attributeStringWithPattern(attributeString:NSMutableAttributedString,pattern:String,niceName:String?) {
        let strMatch = HWStringMatch.instance
        let matchResults = strMatch.matchStringWithPattern(attributeString.string, pattern: pattern)
        if niceName != nil {
            if niceName!.characters.count > 0 {
                let match = strMatch.matchSpecialStringInOriginalString(niceName!, orginalString: attributeString.string)
                if match.count == 1 {
                    let matchRes = match[0]
                    matchRes.matchType = pattern
                    matchRes.cutStr = niceName!
                    attributeString.addAttribute(NSForegroundColorAttributeName, value: niceColor, range: matchRes.range)
                    matchRes.type = HWRichTextType.niceName
                    selectable.append(matchRes)
                }
            }
        }
        let type = typeWithPattern(pattern)
        for matchresult in matchResults {
            attributeString.addAttribute(NSForegroundColorAttributeName, value:attributeColor, range: matchresult.range)
            matchresult.type = type
            selectable.append(matchresult)
        }
    }
    
    private func typeWithPattern(pattern:String) -> HWRichTextType {
        if pattern == url {
            return HWRichTextType.url
        }
        if pattern == atfunc {
            return HWRichTextType.at
        }
        if pattern == topic {
            return HWRichTextType.topic
        }
        return HWRichTextType.error
    }
    
    private func clickWithType(type:HWRichTextType,cutStr:String) {
        switch type {
        case .url:
            self.delegate?.urlClick(cutStr)
        case .at:
            self.delegate?.atFunction(cutStr)
        case.topic:
            self.delegate?.topicClick(cutStr)
        case.niceName:
            self.delegate?.niceNameClick(cutStr)
        default:
            break
        }
    }
    //MARK:UITextViewDelegate
    func textViewDidChange(textView: UITextView) {
        let range = textView.selectedRange
        //这两句可以得到当前高亮选择的字（就是中文输入状态下，英文被选中的那个状态）
        let selectRange = textView.markedTextRange
        let position = textView.positionFromPosition((selectRange?.start)!, offset: 0)
        if position != nil {
            textView.attributedText = attributeTextWithText(textView.text)
        }
        textView.selectedRange = range
    }
    //MARK:富文本区域点击
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        let point = (touches as NSSet).anyObject()?.locationInView(self)
        let textRange = textView.characterRangeAtPoint(point!)
        textView.selectedTextRange = textRange
        let range = textView.selectedRange
        for matchResult in selectable {
            var type = HWRichTextType.error
            let judge = NSLocationInRange(range.location, matchResult.range)
            if judge == true {
                textView.selectedRange = matchResult.range
                type = matchResult.type
                let rects = textView.selectionRectsForRange(textView.selectedTextRange!)
                for rect in rects {
                    let back = UIView()
                    back.backgroundColor = highlightColor
                    let frm = rect as! UITextSelectionRect
                    back.frame = frm.rect
                    back.layer.cornerRadius = 5
                    back.layer.masksToBounds = true
                    back.alpha = 0.5
                    textView.insertSubview(back, atIndex: 0)
                    backgrounds.append(back)
                }
                if type != HWRichTextType.error {
                    clickWithType(type, cutStr: matchResult.cutStr)
                }
                break
            }
        }
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for view in backgrounds {
            view.removeFromSuperview()
        }
        backgrounds.removeAll()
    }
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
    }
}
