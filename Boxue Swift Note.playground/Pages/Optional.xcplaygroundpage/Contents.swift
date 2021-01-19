import Foundation

//: # Optional

//: ## Optional使用范式
//: if let，取出值，并且可以进一步约束值

// 甚至可以重复使用一致的名字
let number: Int? = 1
if let number = number {
    print("number value: \(number)")
}

//: while let，注意这里只是把值取出来，并没有解的，所以得出的值还是optional
let numbers = [1, 2, 3, nil]
print("while let:")
var interator = numbers.makeIterator() // !!!: 注意这里的interator是个变量
while let e = interator.next() {
    print(e as Any)
}

// 等同于下面，因为Swift的for in是while模拟出来的。也因此，每次的循环变量都是一个新的对象，而不是对上一个循环变量的修改。
for e in numbers {
    e
}

// 若要得到解包，还需要使用`case let 变量?`的方式
print("\ncase let 变量?:")
for case let e? in numbers {
    print(e)
}

//: 使用guard简化optional unarapping

func arrayProcess(array: [Int]) {
    guard let first = array.first else {
        return
    }
    
    // 使用 guard 后，后面就可以直接安全使用可选变量了
    print(first)
}

//: ## 链式调用，只处理有值的情况
var swift: String? = "Swift"
let SWIFT = swift?.uppercased().lowercased()

//: 若调用的方法自身也是返回一个可选类型，则需要在每次链式调用中添加 ?

extension String {
    func toUppercase() -> String? {
        guard !self.isEmpty else {
            return nil
        }
        
        return self.uppercased()
    }
    
    func toLowercase() -> String? {
        guard self.count != 0 else {
            return nil
        }
        
        return self.lowercased()
    }
}

let SWIFT1 = swift?.toUppercase()?.toLowercase()

//: compactMap可以滤掉nil的元素

var stringNumbers: [Any] = numbers.compactMap{$0}
stringNumbers = stringNumbers.compactMap{ "\($0)" }
print(stringNumbers)

let ints = ["1", "2", "3", "4", "five"]
let intOnes = ints.compactMap { Int($0) }.reduce(0, +)
print(intOnes)

//: ## 使用隐式解包的场景
/*:
 - 用来传承Objective-C中对象指针的语义；
    - OC创建对象时若能确保是有值的，则使用隐式解包修饰。用于方便后续的使用。
 - 用来定义那些初始为nil，但一定会经过既定流程之后，就再也不会为nil的变量；
    - 典型的如@IBOutlet修饰的属性。
 */




//: [上一页](@previous) | [下一页](@next)
