//: Playground - noun: a place where people can play

import Foundation

var value = "http://naturesnurtureblog.com/homemade-cleaning-wipes/?abc=123#test"
var urlComponents = NSURL(string: value)
urlComponents?.host
urlComponents?.path?.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "/"))