# HWRichTextView-swift
HWRichTextView的属性inputMode使用时一定要赋值true/false
false 表示展示，可以当label使用
true表示编辑状态，可以编辑，但不能点击
##用作label显示
```
let richText = HWRichTextView()
richText.text = "xxx"
richText.normalColor = UIColor.green
richText.attributeColor = UIColor.blue
//这个highlightColor是点击富文本的时候，背景高亮的颜色
richText.highlightColor = UIColor.orange
//这个是针对一般的xxx:xxxxx格式特别加的，冒号前的是niceName
richText.niceName = "xxx"
richText.inputMode = false
richText.niceColor = UIColor.red
richText.delegate = self
richText.frame = CGRect(x: , y: , width: , height: )
view.addSubview(richText)
```
##用作textViewx输入
```
let richText = HWRichTextView()
richText.normalColor = UIColor.green
richText.attributeColor = UIColor.blue
richText.highlightColor = UIColor.orange
richText.inputMode = true
richText.niceColor = UIColor.red
richText.delegate = self
richText.frame = CGRect(x: , y: , width: , height: )
view.addSubview(richText)
```
