//
//  main.swift
//  InterOperateCwithSwift
//
//  Created by Bq Lin on 2021/1/27.
//  Copyright © 2021 Bq. All rights reserved.
//

import Foundation

//MARK: 基本类型桥接
print("\n基本类型桥接🚩")
func bridgeBasicVarExp() {
    print("\(type(of: global_ten)), \(global_ten)")
}
//bridgeBasicVarExp()

//MARK: 函数桥接
func bridgeBasicFunctionExp() {
    print("\n函数桥接🚩")
    print("add: \(add(1, 2))")
    
    /**
     vsum函数会转换成：
     func vsum(count: Int32, numbers: CVaListPointer) -> Int32
     */
    // 通过getVaList函数创建CVaListPointer
    let vaListPointer = getVaList([1, 2, 3, 4, 5, 6])
    let sum0 = vsum(6, vaListPointer)
    print("sum0: \(sum0)")
    
    // 或通过withVaList函数：
    let sum1 = withVaList([1, 2, 3, 4, 5, 6]) {
        vaListPointer in
        vsum(6, vaListPointer)
    }
    print("sum1: \(sum1)")
}
//bridgeBasicFunctionExp()

//MARK: 结构体桥接
print("\n结构体桥接🚩")

func bridgeStructExp() {
    // C的结构体会直接桥接成Swift的结构体，并具有成员初始化方法和默认初始化方法。
    print("初始：\(Location())，成员初始化：\(Location(x: 1, y: 2))")
    
    // 添加的结构体方法
    var a = Location(x: 1, y: 1)
    a = a.moveX(delta: 2)
    print("new location: \(a)")
    a = Location.init(xy: 4)
    print("new location: \(a)")
    
    print("origin: \(Location.origin)")
    // 只有实现了setter方法后才能修改值
    Location.origin.y = 11
    print("origin: \(Location.origin)")
}
//bridgeStructExp()

//MARK: 联合体桥接
print("\n联合体桥接🚩")
/**
 C的联合体Swift没有对应的类型，而是使用Swift的结构体表达。
 ASCII联合体会生成这样的结构体：
 struct ASCII {
     var character: Int8
     var code: Int32
     init(character: Int8)
     init(code: Int32)
 }
 */
func bridgeUnionExp() {
    let a = ASCII(character: Int8("a".utf8["a".startIndex]))
    let character = Character(UnicodeScalar(UInt8(a.character)))
    print("联合体：character: \(character), \(type(of: a.character)), code: \(a.code)")
    
    var bmw = Car(.init(series: 5), info: .init(pricing: 500_000, isAvailable: true))
    bmw.mode = 2
    print("包含匿名联合体的结构体：\(bmw)")
}
//bridgeUnionExp()

//MARK: 枚举的桥接
print("\n枚举的桥接🚩")
/**
 很遗憾C语言的enum不会直接桥接成Swift的enum，而是几个打散的全局变量。
 如C语言定义的：
 typedef enum {
     RED, YELLOW, GREEN
 } TrafficLightColor0;

 在Swift中会变成：
 struct TrafficLightColor: RawRepresentable, Equatable { }
 var RED: TrafficLightColor { get }
 var YELLOW: TrafficLightColor { get }
 var GREEN: TrafficLightColor { get }
 */
func originCEnumExp() {
    let y = YELLOW
    print(y.rawValue)
}
//originCEnumExp()

// 使用NS_ENUM声明的结构体会直接桥接成Swift的结构体
func nsEnumExp() {
    let g: TrafficLightColor1 = .GREEN1
    print("\(g.rawValue), type: \(type(of: g)), value type: \(type(of: g.rawValue))")
}
//nsEnumExp()

//
/**
 使用OC模拟的枚举，其实导入到Swift中是个结构体。
 会变成类似这样的结构体：
 struct TrafficLightColor: RawRepresentable {
     typealias RawValue = String
     init(rawValue: RawValue)
     var rawValue: RawValue { get }
     static var red: TrafficLightColor { get }
     static var yellow: TrafficLightColor { get }
     static var green: TrafficLightColor { get }
 }
 */
func simulateEnumExp() {
    let ocEnum = TrafficLightColor.red
    print("oc enum: \(ocEnum), \(type(of: TrafficLightColor.self))")
    switch ocEnum {
        case .red:
            print("红灯")
        case .green:
            print("绿灯")
        case .yellow:
            print("黄灯")
        default:
            print("其他")
    }
}
//simulateEnumExp()

// 因为使用NS_STRING_ENUM定义的类型，扩展就会麻烦些
extension TrafficLightColor {
    static var blue: Self {
        return TrafficLightColor(rawValue: "blue")
    }
}

// 更便于扩展的枚举
extension Shape {
    static var rectangle: Self {
        return Shape(4)
    }
}

func simulateEnumExp2() {
    print(TrafficLightColor.blue)
    print(Shape.rectangle)
}
//simulateEnumExp2()
