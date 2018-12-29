//: # 控制流
//: Swift 提供了多种流程控制结构，包括可以多次执行任务的 `while` 循环，基于特定条件选择执行不同代码分支的 `if`、`guard` 和 `switch` 语句，还有控制流程跳转到其他代码位置的 `break` 和 `continue` 语句。
//:
//: ## For-In 循环
//:
// for-in 遍历一个数组
let names = ["Anna", "Alex", "Brian", "Jack"]
for name in names {
	print("Hello, \(name)!")
}
// Hello, Anna!
// Hello, Alex!
// Hello, Brian!
// Hello, Jack!

// for-in 遍历一个字典
let numberOfLegs = ["spider": 8, "ant": 6, "cat": 4]
for (animalName, legCount) in numberOfLegs {
	print("\(animalName)s have \(legCount) legs")
}
// ants have 6 legs
// spiders have 8 legs
// cats have 4 legs

// for-in 遍历一个数字范围
for index in 1...5 {
	print("\(index) times 5 is \(index * 5)")
}
// 1 times 5 is 5
// 2 times 5 is 10
// 3 times 5 is 15
// 4 times 5 is 20
// 5 times 5 is 25

// 忽略区间序列各项的值
let base = 3
let power = 10
var answer = 1
for _ in 1...power {
	answer *= base
}
print("\(base) to the power of \(power) is \(answer)")
// 输出 "3 to the power of 10 is 59049"

let minutes = 60
for tickMark in 0..<minutes {
	// 每一分钟都渲染一个刻度线（60次）
}

// 在开区间跳过不需要的标记
let minuteInterval = 5
for tickMark in stride(from: 0, to: minutes, by: minuteInterval) {
	// 每5分钟渲染一个刻度线（0, 5, 10, 15 ... 45, 50, 55）
}

// 在闭区间跳过不需要的标记
let hours = 12
let hourInterval = 3
for tickMark in stride(from: 3, through: hours, by: hourInterval) {
	// 每3小时渲染一个刻度线（3, 6, 9, 12）
}

//: ## While 循环
//:
//: `while` 循环会一直运行一段语句直到条件变成 `false`。这类循环适合使用在第一次迭代前，迭代次数未知的情况下。Swift 提供两种 `while` 循环形式：
//:
//: * `while` 循环，每次在循环开始时计算条件是否符合；
//: * `repeat-while` 循环，每次在循环结束时计算条件是否符合。
//:
//: ### While
//: `while` 循环从计算一个条件开始。如果条件为 `true`，会重复运行一段语句，直到条件变为 `false`。
//:
let finalSquare = 25
var board = [Int](repeating: 0, count: finalSquare + 1)

board[03] = +08; board[06] = +11; board[09] = +09; board[10] = +02
board[14] = -10; board[19] = -11; board[22] = -02; board[24] = -08

var square = 0
var diceRoll = 0
while square < finalSquare {
	// 掷骰子
	diceRoll += 1
	if diceRoll == 7 { diceRoll = 1 }
	// 根据点数移动
	square += diceRoll
	if square < board.count {
		// 如果玩家还在棋盘上，顺着梯子爬上去或者顺着蛇滑下去
		square += board[square]
	}
}
print("Game over!")

//: ### Repeat-While
//: `while` 循环的另外一种形式是 `repeat-while`，它和 `while` 的区别是在判断循环条件之前，先执行一次循环的代码块。然后重复循环直到条件为 `false`。
//:
//let finalSquare = 25
//var board = [Int](repeating: 0, count: finalSquare + 1)
//
//board[03] = +08; board[06] = +11; board[09] = +09; board[10] = +02
//board[14] = -10; board[19] = -11; board[22] = -02; board[24] = -08
//var square = 0
//var diceRoll = 0
//
//repeat {
//	// 顺着梯子爬上去或者顺着蛇滑下去
//	square += board[square]
//	// 掷骰子
//	diceRoll += 1
//	if diceRoll == 7 { diceRoll = 1 }
//	// 根据点数移动
//	square += diceRoll
//} while square < finalSquare
//print("Game over!")

//: ## 条件语句
//:

//: ### Switch
//: `switch` 语句会尝试把某个值与若干个模式（pattern）进行匹配。根据第一个匹配成功的模式，`switch` 语句会执行对应的代码。当有可能的情况较多时，通常用 `switch` 语句替换 `if` 语句。
//:
//: `switch` 语句必须是完备的。这就是说，每一个可能的值都必须至少有一个 case 分支与之对应。在某些不可能涵盖所有值的情况下，你可以使用默认（`default`）分支来涵盖其它所有没有对应的值，这个默认分支必须在 `switch` 语句的最后面。
//:
let someCharacter: Character = "z"
switch someCharacter {
case "a":
	print("The first letter of the alphabet")
case "z":
	print("The last letter of the alphabet")
default:
	print("Some other character")
}
// 输出 "The last letter of the alphabet"

//: #### 不存在隐式的贯穿
//: 与 C 和 Objective-C 中的 `switch` 语句不同，在 Swift 中，当匹配的 case 分支中的代码执行完毕后，程序会终止 `switch` 语句，而不会继续执行下一个 case 分支。这也就是说，不需要在 case 分支中显式地使用 `break` 语句。这使得 `switch` 语句更安全、更易用，也避免了漏写 `break` 语句导致多个语言被执行的错误。
//: > 虽然在 Swift 中 `break` 不是必须的，但你依然可以在 case 分支中的代码执行完毕前使用 `break` 跳出。
//:
//: 每一个 case 分支都*必须*包含至少一条语句。像下面这样书写代码是无效的，因为第一个 case 分支是空的：
//:
let anotherCharacter: Character = "a"
switch anotherCharacter {
//case "a": // 无效，这个分支下面没有语句
case "A":
	print("The letter A")
default:
	print("Not the letter A")
}

//: 为了让单个 case 同时匹配 `a` 和 `A`，可以将这个两个值组合成一个复合匹配，并且用逗号分开：
//:
switch anotherCharacter {
case "a", "A":
	print("The letter A")
default:
	print("Not the letter A")
}
// 输出 "The letter A

//: > 如果想要显式贯穿 case 分支，请使用 `fallthrough` 语句，详情请参考[贯穿](#fallthrough)。
//:
//: #### 区间匹配
//: case 分支的模式也可以是一个值的区间。下面的例子展示了如何使用区间匹配来输出任意数字对应的自然语言格式：
//:
let approximateCount = 62
let countedThings = "moons orbiting Saturn"
let naturalCount: String
switch approximateCount {
case 0:
	naturalCount = "no"
case 1..<5:
	naturalCount = "a few"
case 5..<12:
	naturalCount = "several"
case 12..<100:
	naturalCount = "dozens of"
case 100..<1000:
	naturalCount = "hundreds of"
default:
	naturalCount = "many"
}
print("There are \(naturalCount) \(countedThings).")
// 输出 "There are dozens of moons orbiting Saturn."

//: #### 元组
//:
//: 我们可以使用元组在同一个 `switch` 语句中测试多个值。元组中的元素可以是值，也可以是区间。另外，使用下划线（`_`）来匹配所有可能的值。
//:
let somePoint = (1, 1)
switch somePoint {
case (0, 0):
	print("\(somePoint) is at the origin")
case (_, 0):
	print("\(somePoint) is on the x-axis")
case (0, _):
	print("\(somePoint) is on the y-axis")
case (-2...2, -2...2):
	print("\(somePoint) is inside the box")
default:
	print("\(somePoint) is outside of the box")
}
// 输出 "(1, 1) is inside the box"

//: #### 值绑定（Value Bindings）
//:
//: case 分支允许将匹配的值声明为临时常量或变量，并且在 case 分支体内使用 —— 这种行为被称为*值绑定*（value binding），因为匹配的值在 case 分支体内，与临时的常量或变量绑定。
//:
let anotherPoint = (2, 0)
switch anotherPoint {
case (let x, 0):
	print("on the x-axis with an x value of \(x)")
case (0, let y):
	print("on the y-axis with a y value of \(y)")
case let (x, y):
	print("somewhere else at (\(x), \(y))")
}
// 输出 "on the x-axis with an x value of 2"

//: #### Where
//:
//: case 分支的模式可以使用 `where` 语句来判断额外的条件。
//:
let yetAnotherPoint = (1, -1)
switch yetAnotherPoint {
case let (x, y) where x == y:
	print("(\(x), \(y)) is on the line x == y")
case let (x, y) where x == -y:
	print("(\(x), \(y)) is on the line x == -y")
case let (x, y):
	print("(\(x), \(y)) is just some arbitrary point")
}
// 输出 "(1, -1) is on the line x == -y"

//: #### 复合型 Cases
//:
//: 当多个条件可以使用同一种方法来处理时，可以将这几种可能放在同一个 `case` 后面，并且用逗号隔开。当 case 后面的任意一种模式匹配的时候，这条分支就会被匹配。并且，如果匹配列表过长，还可以分行书写：
//:
switch someCharacter {
case "a", "e", "i", "o", "u":
	print("\(someCharacter) is a vowel")
case "b", "c", "d", "f", "g", "h", "j", "k", "l", "m",
	 "n", "p", "q", "r", "s", "t", "v", "w", "x", "y", "z":
	print("\(someCharacter) is a consonant")
default:
	print("\(someCharacter) is not a vowel or a consonant")
}

let stillAnotherPoint = (9, 0)
switch stillAnotherPoint {
case (let distance, 0), (0, let distance):
	print("On an axis, \(distance) from the origin")
default:
	print("Not on an axis")
}
// 输出 "On an axis, 9 from the origin"

//: ## 控制转移语句
//: 控制转移语句改变你代码的执行顺序，通过它可以实现代码的跳转。Swift 有五种控制转移语句：
//:
//: - `continue`（循环）
//: - `break`（循环、switch）
//: - `fallthrough`
//: - `return`
//: - `throw`
//:
let numberSymbol: Character = "三"  // 简体中文里的数字 3
var possibleIntegerValue: Int?
switch numberSymbol {
case "1", "١", "一", "๑":
	possibleIntegerValue = 1
case "2", "٢", "二", "๒":
	possibleIntegerValue = 2
case "3", "٣", "三", "๓":
	possibleIntegerValue = 3
case "4", "٤", "四", "๔":
	possibleIntegerValue = 4
default:
	break
}
if let integerValue = possibleIntegerValue {
	print("The integer value of \(numberSymbol) is \(integerValue).")
} else {
	print("An integer value could not be found for \(numberSymbol).")
}
// 输出 "The integer value of 三 is 3."

//: ### 贯穿（Fallthrough）
//:
//: 在 Swift 里，`switch` 语句不会从上一个 case 分支跳转到下一个 case 分支中。相反，只要第一个匹配到的 case 分支完成了它需要执行的语句，整个 `switch` 代码块完成了它的执行。相比之下，C 语言要求你显式地插入 `break` 语句到每个 case 分支的末尾来阻止自动落入到下一个 case 分支中。Swift 的这种避免默认落入到下一个分支中的特性意味着它的 `switch` 功能要比 C 语言的更加清晰和可预测，可以避免无意识地执行多个 case 分支从而引发的错误。
//:
//: 如果你确实需要 C 风格的贯穿的特性，你可以在每个需要该特性的 case 分支中使用 `fallthrough` 关键字。下面的例子使用 `fallthrough` 来创建一个数字的描述语句。
//:
let integerToDescribe = 5
var description = "The number \(integerToDescribe) is"
switch integerToDescribe {
case 2, 3, 5, 7, 11, 13, 17, 19:
	description += " a prime number, and also"
	fallthrough
default:
	description += " an integer."
}
print(description)
// 输出 "The number 5 is a prime number, and also an integer."

//: > `fallthrough` 关键字不会检查它下一个将会落入执行的 case 中的匹配条件。`fallthrough` 简单地使代码继续连接到下一个 case 中的代码，这和 C 语言标准中的 `switch` 语句特性是一样的。

//: ### 带标签的语句
//:
//: 声明一个带标签的语句是通过在该语句的关键词的同一行前面放置一个标签，作为这个语句的前导关键字（introducor keyword），并且该标签后面跟随一个冒号。
//:
gameLoop: while square != finalSquare {
	diceRoll += 1
	if diceRoll == 7 { diceRoll = 1 }
	switch square + diceRoll {
	case finalSquare:
		// 骰子数刚好使玩家移动到最终的方格里，游戏结束。
		break gameLoop
	case let newSquare where newSquare > finalSquare:
		// 骰子数将会使玩家的移动超出最后的方格，那么这种移动是不合法的，玩家需要重新掷骰子
		continue gameLoop
	default:
		// 合法移动，做正常的处理
		square += diceRoll
		square += board[square]
	}
}
print("Game over!")

//: > 如果上述的 `break` 语句没有使用 `gameLoop` 标签，那么它将会中断 `switch` 语句而不是 `while` 循环。使用 `gameLoop` 标签清晰的表明了 `break` 想要中断的是哪个代码块。
//:

//: ## 提前退出
//: 像 `if` 语句一样，`guard` 的执行取决于一个表达式的布尔值。我们可以使用 `guard` 语句来要求条件必须为真时，以执行 `guard` 语句后的代码。不同于 `if` 语句，一个 `guard` 语句总是有一个 `else` 从句，如果条件不为真则执行 `else` 从句中的代码。
//:
func greet(person: [String: String]) {
	guard let name = person["name"] else {
		return
	}
	print("Hello \(name)")
	guard let location = person["location"] else {
		print("I hope the weather is nice near you.")
		return
	}
	print("I hope the weather is nice in \(location).")
}
greet(["name": "John"])
// 输出 "Hello John!"
// 输出 "I hope the weather is nice near you."
greet(["name": "Jane", "location": "Cupertino"])
// 输出 "Hello Jane!"
// 输出 "I hope the weather is nice in Cupertino."

//: 相比于可以实现同样功能的 `if` 语句，按需使用 `guard` 语句会提升我们代码的可读性。它可以使你的代码连贯的被执行而不需要将它包在 `else` 块中，它可以使你在紧邻条件判断的地方，处理违规的情况。

//: ## 检测 API 可用性
//:
//: Swift 内置支持检查 API 可用性，这可以确保我们不会在当前部署机器上，不小心地使用了不可用的 API。
//:
//: 我们在 `if` 或 `guard` 语句中使用 `可用性条件（availability condition)`去有条件的执行一段代码，来在运行时判断调用的 API 是否可用。编译器使用从可用性条件语句中获取的信息去验证，在这个代码块中调用的 API 是否可用。
//:
if #available(iOS 10, macOS 10.12, *) {
	// 在 iOS 使用 iOS 10 的 API, 在 macOS 使用 macOS 10.12 的 API
} else {
	// 使用先前版本的 iOS 和 macOS 的 API
}

//: 以上可用性条件指定，`if` 语句的代码块仅仅在 iOS 10 或 macOS 10.12 及更高版本才运行。最后一个参数，`*`，是必须的，用于指定在所有其它平台中，如果版本号高于你的设备指定的最低版本，if 语句的代码块将会运行。
//:
//: 在它一般的形式中，可用性条件使用了一个平台名字和版本的列表。平台名字可以是 `iOS`，`macOS`，`watchOS` 和 `tvOS`——请访问[声明属性](../chapter3/06_Attributes.html)来获取完整列表。除了指定像 iOS 8 或 macOS 10.10 的大版本号，也可以指定像 iOS 11.2.6 以及 macOS 10.13.3 的小版本号。
//: 

//: [上一页](@previous) | [下一页](@next)
