import Foundation

//: KeyPath

struct StructType {
    let id: Int
    var age: Int
    var name: String
}
let first = StructType(id: 1, age: 2, name: "3")

class ClassType {
    let id: Int
    var age: Int
    var name: String
    
    init(id: Int, age: Int, name: String) {
        self.id = id
        self.age = age
        self.name = name
    }
}
let second = ClassType(id: 4, age: 5, name: "6")

//: 三种类型的KeyPath
let simpleKeyPath = \StructType.id
print("\(simpleKeyPath): \(first[keyPath: simpleKeyPath])")
print("KeyPath type: \( type(of: simpleKeyPath))")
print("WritableKeyPath type: \(type(of: \StructType.age))")
print("ReferenceWritableKeyPath type: \(type(of: \ClassType.age))")
print("KeyPath type: \(type(of: \ClassType.id))")

//: KeyPath带来的更多作用是约定了类型及其元素的组合，在范型中可以直接操作模型中的属性

//: [上一页](@previous) | [下一页](@next)
