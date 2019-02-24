
class Adapter:NSObject {
    class func transFormHanYuToPingYin(str:NSString)->NSString {
        let pinyin = str.mutableCopy() as! CFMutableString
        CFStringTransform(pinyin, nil, kCFStringTransformToLatin, false)
        print("被转的汉字是:\(str),转换后是:\(pinyin)")
        return pinyin
    }

    class func adaptFontSize(fontSize:CGFloat) -> UIFont{
        let size = self.adaptSize(pxValue: fontSize)
        return UIFont.systemFont(ofSize: size)
    }

    class func adaptSize(pxValue:CGFloat) -> CGFloat{
        let size = (pxValue * UIScreen.main.bounds.width / referenceSize)
        return size;
    }
}
