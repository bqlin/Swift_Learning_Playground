//: # 基本运算符
//: Swift 支持大部分标准 C 语言的运算符，且改进许多特性来减少常规编码错误。如：赋值符（`=`）不返回值，以防止把想要判断相等运算符（`==`）的地方写成赋值符导致的错误。算术运算符（`+`，`-`，`*`，`/`，`%` 等）会检测并不允许值溢出，以此来避免保存变量时由于变量大于或小于其类型所能承载的范围时导致的异常结果。当然允许你使用 Swift 的溢出运算符来实现溢出。详情参见[溢出运算符](Advanced_Operators)。
//:
//: Swift 还提供了 C 语言没有的区间运算符，例如 `a..<b` 或 `a...b`，这方便我们表达一个区间内的数值。
//:
//: ## 赋值运算符
//:
let (x, y) = (1, 2)
// 现在 x 等于 1，y 等于 2

// 与 C 语言和 Objective-C 不同，Swift 的赋值操作并不返回任何值。所以以下陈述时无效的：
//if x = y {
//	// 此句错误，因为 x = y 并不返回任何值
//}

//: ## 算术运算符
//: Swift 中所有数值类型都支持了基本的四则*算术运算符*：
//:
//: 与 C 语言和 Objective-C 不同的是，Swift 默认情况下不允许在数值运算中出现溢出情况。但是你可以使用 Swift 的溢出运算符来实现溢出运算（如 `a &+ b`）。详情参见[溢出运算符](Advanced_Operators)。
//:
//: 加法运算符也可用于 `String` 的拼接：
//:
"hello, " + "world"  // 等于 "hello, world"

//: ### 求余运算符
//: > 求余运算符（`%`）在其他语言也叫*取模运算符*。但是严格说来，我们看该运算符对负数的操作结果，「求余」比「取模」更合适些。
//:
//: ![Art/remainderInteger_2x.png](https://docs.swift.org/swift-book/_images/remainderInteger_2x.png)
//:
//: 在对负数 `b` 求余时，`b` 的符号会被忽略。这意味着 `a % b` 和 `a % -b` 的结果是相同的。
//:
// -9 = (4 × -2) + -1
-9 % 4   // 等于 -1

//: ## 比较运算符（Comparison Operators）
//: 所有标准 C 语言中的*比较运算符*都可以在 Swift 中使用。
//: > Swift 也提供恒等（`===`）和不恒等（`!==`）这两个比较符来判断两个对象是否引用同一个对象实例。更多细节在[类与结构](Structures_And_Classes)。
//:
//: 如果两个元组的元素相同，且长度相同的话，元组就可以被比较。比较元组大小会按照从左到右、逐值比较的方式，直到发现有两个值不等时停止。如果所有的值都相等，那么这一对元组我们就称它们是相等的。例如：
//:
(1, "zebra") < (2, "apple")   // true，因为 1 小于 2
(3, "apple") < (3, "bird")    // true，因为 3 等于 3，但是 apple 小于 bird
(4, "dog") == (4, "dog")      // true，因为 4 等于 4，dog 等于 dog

//: `Bool` 不能被比较，也意味着存有布尔类型的元组不能被比较。
//:
("blue", -1) < ("purple", 1)       // 正常，比较的结果为 true
//("blue", false) < ("purple", true) // 错误，因为 < 不能比较布尔类型

//: > Swift 标准库只能比较七个以内元素的元组比较函数。如果你的元组元素超过七个时，你需要自己实现比较运算符。

//: ## 空合运算符（Nil Coalescing Operator）
//: *空合运算符*（`a ?? b`）将对可选类型 `a` 进行空判断，如果 `a` 包含一个值就进行解封，否则就返回一个默认值 `b`。表达式 `a` 必须是 Optional 类型。默认值 `b` 的类型必须要和 `a` 存储值的类型保持一致。
//:
//: 空合运算符是对以下代码的简短表达方法：
//: `a != nil ? a! : b`
//: > 如果 `a` 为非空值（`non-nil`），那么值 `b` 将不会被计算。这也就是所谓的*短路求值*。
//:
let defaultColorName = "red"
var userDefinedColorName: String?   //默认值为 nil

var colorNameToUse = userDefinedColorName ?? defaultColorName
// userDefinedColorName 的值为空，所以 colorNameToUse 的值为 "red"

userDefinedColorName = "green"
colorNameToUse = userDefinedColorName ?? defaultColorName
// userDefinedColorName 非空，因此 colorNameToUse 的值为 "green"

//: ## 区间运算符（Range Operators）
//:
//: ### 闭区间运算符
//: *闭区间运算符*（`a...b`）定义一个包含从 `a` 到 `b`（包括 `a` 和 `b`）的所有值的区间。`a` 的值不能超过 `b`。
for index in 1...5 {
//	print("\(index) * 5 = \(index * 5)")
}
// 1 * 5 = 5
// 2 * 5 = 10
// 3 * 5 = 15
// 4 * 5 = 20
// 5 * 5 = 25

//: ### 半开区间运算符
//: *半开区间运算符*（`a..<b`）定义一个从 `a` 到 `b` 但不包括 `b` 的区间。
//:
//: 半开区间的实用性在于当你使用一个从 0 开始的列表（如数组）时，非常方便地从0数到列表的长度。
//:
let names = ["Anna", "Alex", "Brian", "Jack"]
let count = names.count
for i in 0..<count {
//	print("第 \(i + 1) 个人叫 \(names[i])")
}
// 第 1 个人叫 Anna
// 第 2 个人叫 Alex
// 第 3 个人叫 Brian
// 第 4 个人叫 Jack

//: ### 单侧区间
//: 闭区间操作符有另一个表达形式，可以表达往一侧无限延伸的区间 —— 例如，一个包含了数组从索引 2 到结尾的所有值的区间。在这些情况下，你可以省略掉区间操作符一侧的值。这种区间叫做单侧区间，因为操作符只有一侧有值。例如：
for name in names[2...] {
//	print(name)
}
// Brian
// Jack

for name in names[...2] {
//	print(name)
}
// Anna
// Alex
// Brian

//: 半开区间操作符也有单侧表达形式，附带上它的最终值。就像你使用区间去包含一个值，最终值并不会落在区间内。例如：
//:
for name in names[..<2] {
//	print(name)
}
// Anna
// Alex

//: 单侧区间不止可以在下标里使用，也可以在别的情境下使用。你不能遍历省略了初始值的单侧区间，因为遍历的开端并不明显。你可以遍历一个省略最终值的单侧区间；然而，由于这种区间无限延伸的特性，请保证你在循环里有一个结束循环的分支。你也可以查看一个单侧区间是否包含某个特定的值，就像下面展示的那样。
//:
let range = ...5
range.contains(7)   // false
range.contains(4)   // true
range.contains(-1)  // true



//: [上一页](@previous) | [下一页](@next)
