//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
let nstr = NSString(string: str).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)
let queryUrl = "q=\(nstr!)&source="

let a = "aaa"
let b = "bbb"

let ss = String(format:"text = \"%@\" and lang = \"%@\"",a,b)