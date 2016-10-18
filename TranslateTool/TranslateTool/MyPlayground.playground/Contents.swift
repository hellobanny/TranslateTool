//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
let nstr = NSString(string: str).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)
let queryUrl = "q=\(nstr!)&source="