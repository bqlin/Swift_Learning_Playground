import Foundation

//: # 样式匹配
/*：
 这里所说的样式匹配在我的理解是在循环和分支控制条件中，复合多个条件的一个判别式。其目的是让复合条件更简单明了地表达。
 
 Swift的样式匹配不仅仅是个判别式，还有一些附带功能——值绑定，甚至可以指定类型的值绑定。
 
 若这还不够用，Swift还提供了where作为条件的再次细分。
 
 具体的，可分为以下几种形式的样式匹配：
 - `case 匹配的值 = 要检查的对象`，这种模式若在switch...case...中，则只保留`case 匹配的值`。
 - 在`case 匹配的值`加入`let 变量名`就可以实现值绑定；
 - `case let 变量?`，这样的形式绑定可选值时，会自动提取非nil的值，即会忽略nil。
 - `case let 变量 as 目标类型`，把目标类型转换成功的值绑定到变量上。
 - 使用where语句进行高级样式匹配。一般是这样组合使用，先用`case let`绑定变量，然后使用where语句对变量进行约束。
 - 使用逗号串联，其在switch...case...中表示逻辑或||；在if中表示逻辑与&&。
 */

//: 更具表现力的样式匹配
let origin = (x: 0, y: 0)
let pt1 = (x: 0, y: 0)
// 要判断该点是否是原点。原始方式：
if pt1.x == origin.x && pt1.y == origin.y {
    print("@origin")
}
// 使用样式匹配，注意，这里的相等判断是使用“=”而不是“==”：
if case (0, 0) = pt1 {
    print("@origin")
}

//: switch...case...的样式匹配
switch pt1 {
    case (0, 0):
        print("@origin")
    case (_, 0):
        print("on x axis")
    case (0, _):
        print("on y axis")
    case (-1...1, -1...1):
        print("inside 2x2 square")
    default:
        break
}

//: case 可以单独用于样式匹配：
let array1 = [1, 1, 12, 2, 2]
for case 2 in array1 {
    print("found two")
}

//: 把匹配内容绑定到变量：
switch pt1 {
    case (let x, 0):
        print("(\(x), 0) is on x axis")
    case (0, let y):
        print("(0, \(y)) is on y axis")
    default:
        break
}

enum Direction {
    case north, sourth, east, west(abbr: String)
}
let west = Direction.west(abbr: "W")

// 匹配枚举
if case Direction.west = west {
    print(west)
}
// 匹配枚举中的关联值
if case Direction.west(let direction) = west {
    print(direction)
}


//: 自动提取可选值类型。输出都是具体的类型。**注意这里是带?的**
let skills: [String?] = ["Swift", nil, "PHP", "Javascript", nil]
for case let skill? in skills {
    print(skill)
}

// 自动绑定类型转换的结果
let someValues: [Any] = [1, 1.0, "One"]
for value in someValues {
    switch value {
        case let v as Int:
            print("Integer: \(v)")
        case let v as Double:
            print("Double: \(v)")
        case let v as String:
            print("String: \(v)")
        default:
            print("Invalid value")
    }
}

//: 使用 where 约束条件
for i in 1...10 where i % 2 == 0 {
    print(i)
}

enum Power {
    case fullyCharged
    case normal(percentage: Double)
    case outOfPower
}
let battery = Power.normal(percentage: 0.1)

switch battery {
    case .normal(let percentage) where percentage <= 0.1:
        print("Almost out of power")
    case .normal(let percentage) where percentage >= 0.8:
        print("Almost fully charged")
    default:
        print("Normal battery status")
}

//: 使用逗号串联，其在 switch...case... 中表示逻辑或 ||；在 if 中表示逻辑与 &&

//: [上一页](@previous) | [下一页](@next)
