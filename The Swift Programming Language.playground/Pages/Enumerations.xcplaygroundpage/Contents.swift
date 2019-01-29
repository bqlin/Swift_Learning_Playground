//: # 枚举
//: *枚举*为一组相关的值定义了一个共同的类型，使你可以在你的代码中以类型安全的方式来使用这些值。
//:
//: 此外，枚举成员可以指定*任意*类型的关联值存储到枚举成员中，就像其他语言中的联合体（unions）和变体（variants）。你可以在一个枚举中定义一组相关的枚举成员，每一个枚举成员都可以有适当类型的关联值。
//:
//: 在 Swift 中，枚举类型是一等（first-class）类型。它们采用了很多在传统上只被类（class）所支持的特性，例如计算属性（computed properties），用于提供枚举值的附加信息，实例方法（instance methods），用于提供和枚举值相关联的功能。枚举也可以定义构造函数（initializers）来提供一个初始值；可以在原始实现的基础上扩展它们的功能；还可以遵循协议（protocols）来提供标准的功能。
//:
//: ## 枚举语法
//: 使用 `enum` 关键词来创建枚举并且把它们的整个定义放在一对大括号内：
//:
enum SomeEnumeration {
	// 枚举定义放在这里
}

enum CompassPoint {
	case north
	case south
	case east
	case west
}

// 定义到一行
enum Planet {
	case mercury, venus, earth, mars, jupiter, saturn, uranus, neptune
}

var directionToHead = CompassPoint.west
// 由于值类型已确定，所可以以更简短的语法修改值
directionToHead = .east

//: ## 使用 Switch 语句匹配枚举值
//:
directionToHead = .south
switch directionToHead {
case .north:
	print("Lots of planets have a north")
case .south:
	print("Watch out for penguins")
case .east:
	print("Where the sun rises")
case .west:
	print("Where the skies are blue")
}
// 打印 "Watch out for penguins”

let somePlanet = Planet.earth
switch somePlanet {
case .earth:
	print("Mostly harmless")
default:
	print("Not a safe place for humans")
}
// 打印 "Mostly harmless”

//: 在判断一个枚举类型的值时，`switch` 语句必须穷举所有情况。如果忽略了 `.west` 这种情况，上面那段代码将无法通过编译，因为它没有考虑到 `CompassPoint` 的全部成员。强制穷举确保了枚举成员不会被意外遗漏。
//:
//: ## 枚举成员的遍历
//:
//: 在一些情况下，你会需要得到一个包含枚举所有成员的集合。可以通过如下代码实现：
//:
//: 令枚举遵循 `CaseIterable` 协议。Swift 会生成一个 `allCases` 属性，用于表示一个包含枚举所有成员的集合。下面是一个例子：
//:

// Xcode 10 以上可用
enum Beverage: CaseIterable {
	case coffee, tea, juice
}
let numberOfChoices = Beverage.allCases.count
//print("\(numberOfChoices) beverages available")
// 打印 "3 beverages available"

for beverage in Beverage.allCases {
//	print(beverage)
}
// coffee
// tea
// juice

//: ## 关联值
//:
//: 你可以定义 Swift 枚举来存储任意类型的关联值，如果需要的话，每个枚举成员的关联值类型可以各不相同。枚举的这种特性跟其他语言中的可识别联合（discriminated unions），标签联合（tagged unions），或者变体（variants）相似。
//:
enum Barcode {
	case upc(Int, Int, Int, Int)
	case qrCode(String)
}
var productBarcode = Barcode.upc(8, 85909, 51226, 3)
productBarcode = .qrCode("ABCDEFGHIJKLMNOP")

switch productBarcode {
case .upc(let numberSystem, let manufacturer, let product, let check):
	print("UPC: \(numberSystem), \(manufacturer), \(product), \(check).")
case .qrCode(let productCode):
	print("QR code: \(productCode).")
}
// 打印 "QR code: ABCDEFGHIJKLMNOP."

//: 如果一个枚举成员的所有关联值都被提取为常量，或者都被提取为变量，为了简洁，你可以只在成员名称前标注一个 `let` 或者 `var`：
//:
switch productBarcode {
case let .upc(numberSystem, manufacturer, product, check):
	print("UPC: \(numberSystem), \(manufacturer), \(product), \(check).")
case let .qrCode(productCode):
	print("QR code: \(productCode).")
}
// 打印 "QR code: ABCDEFGHIJKLMNOP."

//: ## 原始值
//: 作为关联值的替代选择，枚举成员可以被默认值（称为*原始值*）预填充，这些原始值的类型必须相同。
//:
enum ASCIIControlCharacter: Character {
	case tab = "\t"
	case lineFeed = "\n"
	case carriageReturn = "\r"
}

//: > 原始值和关联值是不同的。原始值是在定义枚举时被预先填充的值，像上述三个 ASCII 码。对于一个特定的枚举成员，它的原始值始终不变。关联值是创建一个基于枚举成员的常量或变量时才设置的值，枚举成员的关联值可以变化。
//: > 当然，若没有指定原始值类型，是无法获取原始值的（无 `rawValue` 属性）。
//:
//: ### 原始值的隐式赋值
//: 在使用原始值为整数或者字符串类型的枚举时，不需要显式地为每一个枚举成员设置原始值，Swift 将会自动为你赋值。
//:
enum Planet2: Int {
	case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
}
let earthsOrder = Planet2.earth.rawValue

enum CompassPoint2: String {
	case north, south, east, west
}
let sunsetDirection = CompassPoint2.west.rawValue

//: ### 使用原始值初始化枚举实例
//:
//: 如果在定义枚举类型的时候使用了原始值，那么将会自动获得一个初始化方法，这个方法接收一个叫做 `rawValue` 的参数，参数类型即为原始值类型，返回值则是枚举成员或 `nil`。你可以使用这个初始化方法来创建一个新的枚举实例。
//:
let possiblePlanet = Planet2(rawValue: 7)
// possiblePlanet 类型为 Planet? 值为 Planet.uranus

//: > 原始值构造器是一个可失败构造器，因为并不是每一个原始值都有与之对应的枚举成员。
//:

let positionToFind = 11
if let somePlanet = Planet2(rawValue: positionToFind) {
	switch somePlanet {
	case .earth:
		print("Mostly harmless")
	default:
		print("Not a safe place for humans")
	}
} else {
//	print("There isn't a planet at position \(positionToFind)")
}
// 打印 "There isn't a planet at position 11"

//: ## 递归枚举
//:
//: *递归枚举*是一种枚举类型，它有一个或多个枚举成员使用该枚举类型的实例作为关联值。使用递归枚举时，编译器会插入一个间接层。你可以在枚举成员前加上 `indirect` 来表示该成员可递归。
//:
//: 例如，下面的例子中，枚举类型存储了简单的算术表达式：
//:
enum ArithmeticExpression {
	case number(Int)
	indirect case addition(ArithmeticExpression, ArithmeticExpression)
	indirect case multiplication(ArithmeticExpression, ArithmeticExpression)
}

//: 你也可以在枚举类型开头加上 `indirect` 关键字来表明它的所有成员都是可递归的：
//:
indirect enum ArithmeticExpression2 {
	case number(Int)
	case addition(ArithmeticExpression, ArithmeticExpression)
	case multiplication(ArithmeticExpression, ArithmeticExpression)
}

let five = ArithmeticExpression.number(5)
let four = ArithmeticExpression.number(4)
let sum = ArithmeticExpression.addition(five, four)
let product = ArithmeticExpression.multiplication(sum, ArithmeticExpression.number(2))

func evaluate(_ expression: ArithmeticExpression) -> Int {
	switch expression {
	case let .number(value):
		print("\(value);")
		return value
	case let .addition(left, right):
		let result = evaluate(left) + evaluate(right)
		print("\(left) + \(right) = \(result)")
		return result
	case let .multiplication(left, right):
		let result = evaluate(left) * evaluate(right);
		print("\(left) × \(right) = \(result)")
		return result
	}
}

//print(evaluate(product))
// 打印 "18"



//: [上一页](@previous) | [下一页](@next)
