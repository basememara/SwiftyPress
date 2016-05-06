//: Playground - noun: a place where people can play

import Foundation

var value: String? = ""
//value = "k"

if value?.isEmpty ?? true {
    print("nil or empty")
} else {
    print("has something")
}