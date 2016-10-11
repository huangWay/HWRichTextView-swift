//
//  HWMatchResult.swift
//  HWRichTextView
//
//  Created by HuangWay on 16/2/1.
//  Copyright © 2016年 HuangWay. All rights reserved.
//

import UIKit

class HWMatchResult {
    /// 匹配结果的范围
    var range:NSRange
    /// 匹配结果后截取的字符串
    var cutStr:String
    /// 匹配类型
    var matchType:String
    /// 类型，这个类型用来做点击判断的
    var type:HWRichTextType
    init(){
        range = NSMakeRange(0, 0)
        cutStr = ""
        matchType = ""
        type = HWRichTextType.error
    }
    class func result() -> HWMatchResult{
        return HWMatchResult()
    }
}
class HWStringMatch {
    /// 匹配类型
    var matchType:String
    static let instance = HWStringMatch()
    fileprivate init(){
        matchType = ""
    }
    /**
     匹配指定字符串
     
     - parameter specialString: 指定字符串
     - parameter orginalString: 原始字符串
     
     - returns: HWMatchResult类型的数组
     */
    func matchSpecialStringInOriginalString(_ specialString:String,orginalString:String) -> [HWMatchResult] {
        var mutArr = [HWMatchResult]()
        if specialString.characters.count > 0{
            let range = (specialString as NSString).range(of: specialString)
            if range.length > 0 {
                let result = HWMatchResult()
                result.range = range
                result.cutStr = specialString
                result.matchType = "specialString"
                mutArr.append(result)
            }
        }
        return mutArr
    }
    /**
     根据正则表达式匹配结果
     
     - parameter string:  被匹配的字符串
     - parameter pattern: 正则表达式
     
     - returns: HWMatchResult类型的数组
     */
    func matchStringWithPattern(_ string:String,pattern:String) -> [HWMatchResult] {
        
        do {
            let express = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let results = express.matches(in: string, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, string.characters.count))
            var resultM = [HWMatchResult]()
            for result in results {
                let matchRes = HWMatchResult()
                matchRes.range = result.range
                let str = string as NSString
                matchRes.cutStr = str.substring(with: result.range)
                matchRes.matchType = matchType
                resultM.append(matchRes)
            }
            return resultM
        }catch {
            let results = [HWMatchResult]()
            return results
        }
    }
    /**
     按照正则拆分字符串，返回未匹配的结果
     
     - parameter string:  被匹配的字符串
     - parameter pattern: 正则表达式
     
     - returns: 未被匹配的NSString数组
     */
    func seperateStringWithPattern(_ string:String,pattern:String) -> [HWMatchResult] {
        let matchresults = matchStringWithPattern(string, pattern: pattern)
        var nomatches = [HWMatchResult]()
        let str = string as NSString
        if matchresults.count == 0 {
            let nomatch = HWMatchResult()
            nomatch.range = NSMakeRange(0, string.characters.count)
            nomatch.cutStr = string
            nomatch.matchType = matchType
            nomatches.append(nomatch)
        }
        for index in 0 ..< matchresults.count {
            let subMatch = matchresults[index]
            if index == 0 {
                if subMatch.range.location != 0 {
                    let noMatch = HWMatchResult()
                    noMatch.range = subMatch.range
                    noMatch.cutStr = str.substring(with: subMatch.range)
                    noMatch.matchType = matchType
                    nomatches.append(noMatch)
                }
            }
            if index > 0 && index < matchresults.count - 1 {
                let preMatch = matchresults[index - 1]
                let endPosition = preMatch.range.location + preMatch.range.length
                if subMatch.range.location != endPosition {
                    let noMatch = HWMatchResult()
                    noMatch.range = NSMakeRange(endPosition, subMatch.range.location - endPosition)
                    noMatch.cutStr = str.substring(with: noMatch.range)
                    noMatch.matchType = matchType
                    nomatches.append(noMatch)
                }
            }
            if index == matchresults.count - 1 {
                let endP = subMatch.range.location + subMatch.range.length
                if endP != string.characters.count {
                    let noMatch = HWMatchResult()
                    noMatch.range = NSMakeRange(endP, string.characters.count - endP)
                    noMatch.cutStr = str.substring(with: noMatch.range)
                    noMatch.matchType = matchType
                    nomatches.append(noMatch)
                }
            }
        }
        return nomatches
    }
}
