//: Playground - noun: a place where people can play

import Foundation

let myString: String? = "Hello, world!"
let myBool: Bool? = true
let myInt: Int? = 0
let otherInt: Int = 1

let myStringNil: String? = nil
let myBoolNil: Bool? = nil
let myIntNil: Int? = nil

//////// With values

print("\(myString ?? "")")

if myString?.isEmpty == true {
    print("if myString?.isEmpty == true")
}

if myBool == false {
    print("if myBool == false")
}

if myInt > otherInt {
    print("if myInt > otherInt")
}

//////// With nil's

print("\(myStringNil ?? "")")

if myStringNil?.isEmpty == true { //Fails condition
    print("if myStringNil?.isEmpty == true")
}

if myBoolNil == false { //Fails condition
    print("if myBoolNil == false")
}

if myIntNil > otherInt { //Fails condition
    print("if myBoolNil == false")
}