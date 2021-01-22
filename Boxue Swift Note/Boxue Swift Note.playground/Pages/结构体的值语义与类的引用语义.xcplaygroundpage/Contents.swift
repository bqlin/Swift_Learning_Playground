import Foundation
import Utils

//: # 值语义与引用语义

//: 一个可修改的类对象会在很多时候，偷偷给我们带来意想不到的麻烦。所以，越来越多的言论在鼓励我们尽可能使用常量，当然，这里也就包含了值不可被修改的对象。因为这的确可以为我们带来更安全和可维护的代码。

//: ## struct 与 class 的取舍
//: 使用 class：必须有明确的声明周期。必须被明确地初始化、使用，最后明确地被释放。例如：文件句柄、数据库连接、线程同步锁等等。
//: 使用 strcut、enum：没有明显的生命周期。这些对象一旦被创建，就很少被修改，我们只是需要使用这些对象的值，用完之后，我们也无需为这些对象的销毁做更多额外的工作，只是把它们占用的内存回收就好了。例如：整数、字符串、URL等等。
//: ## Type property
//: 作为 struct 的特殊值出现。他们不是 struct 对象的一部分，因此不对增加 struct 对象的大小。


struct Point {
    var x: Double
    var y: Double
    
    static let origin = Point(x: 0, y: 0)
}
Point.origin

//: ## 理解 struct 的值语义

// 添加 didSet block
var pointC = Point(x: 100, y: 100) {
    didSet {
        print("pointC changed: \(pointC)")
    }
}
var pointB = Point(x: 10, y: 10)
pointC = pointB
// 观察这个变量，可见，每次即使是修改属性，也会确保重新创建一个新的实例。这里会看到其setter会执行。
pointC.x += 1

//: 为 struct 添加方法
//: struct 的方法，默认都是只读的。
extension Point {
    func distance(to: Point) -> Double {
        let distX = self.x - to.x
        let distY = self.y - to.y
        
        return sqrt(distX * distX + distY * distY)
    }
}
pointC.distance(to: Point.origin)

//: 要想方法可以修改自身的值，需要添加 mutating 修饰
//: 这样，Swift编译器就会在所有的 `mutating` 方法第一个参数的位置，自动添加一个 `inout Self` 参数：
extension Point {
    mutating func moveTo(
        /*self: inout Self, */
        to: Point) {
        self = to
    }
}
pointC.moveTo(to: pointB)

//: ## class 的不同之处

struct PointValue {
    var x: Int
    var y: Int
}

class PointRef {
    var x: Int
    var y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

//: - 引用类型必须明确指定 init 方法
//: - 引用类型关注的是对象本身
//: - 引用类型默认是可以修改的

let pRef1 = PointRef(x: 0, y: 0)
let pValue2 = PointValue(x: 0, y: 0)
//p2.x = 10 // Compile time error
pRef1.x = 10 // OK
//p1 = PointRef(x: 1, y: 1) // Compile time error
var p3 = pRef1
var p4 = pValue2

pRef1 === p3 // true
p3.x = 10
pRef1.x // 10

p4.x = 10
pValue2.x // 0

//: - struct 可以给 self 赋值，进行简单的值拷贝；而 class 的 self 是一个常量。

extension PointRef {
    func move(to: PointRef) {
        self.x = to.x
        self.y = to.y
    }
}

//: [上一页](@previous) | [下一页](@next)
