//: # 泛型
//: *泛型代码*让你能根据自定义的需求，编写出适用于任意类型的、灵活可复用的函数及类型。你可避免编写重复的代码，用一种清晰抽象的方式来表达代码的意图。
//:
//: 泛型是 Swift 最强大的特性之一，很多 Swift 标准库是基于泛型代码构建的。实际上，即使你没有意识到，你也一直在*语言指南*中使用泛型。例如，Swift 的 `Array` 和 `Dictionary` 都是泛型集合。你可以创建一个 `Int` 类型数组，也可创建一个 `String` 类型数组，甚至可以是任意其他 Swift 类型的数组。同样，你也可以创建一个存储任意指定类型的字典，并对该类型没有限制。
//:
//: ## 泛型解决的问题
//:
func swapTwoInts(_ a: inout Int, _ b: inout Int) {
	let temporaryA = a
	a = b
	b = temporaryA
}
//: 这个函数使用输入输出参数（`inout`）来交换 `a` 和 `b` 的值，具体请参考[输入输出参数](Functions)
//:
var someInt = 3
var anotherInt = 107
swapTwoInts(&someInt, &anotherInt)
print("someInt is now \(someInt), and anotherInt is now \(anotherInt)")
// 打印“someInt is now 107, and anotherInt is now 3”

func swapTwoStrings(_ a: inout String, _ b: inout String) {
	let temporaryA = a
	a = b
	b = temporaryA
}

func swapTwoDoubles(_ a: inout Double, _ b: inout Double) {
	let temporaryA = a
	a = b
	b = temporaryA
}

//: > 在上面三个函数中，`a` 和 `b` 类型必须相同。如果 `a` 和 `b` 类型不同，那它们俩就不能互换值。Swift 是类型安全的语言，所以它不允许一个 `String` 类型的变量和一个 `Double` 类型的变量互换值。试图这样做将导致编译错误。
//:
//: ## 泛型函数
//:
func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
	let temporaryA = a
	a = b
	b = temporaryA
}

swapTwoValues(&someInt, &anotherInt)

var someString = "hello"
var anotherString = "world"
swapTwoValues(&someString, &anotherString)
// someString 现在是“world”，anotherString 现在是“hello”

//: > 上面定义的 `swapTwoValues(_:_:)` 函数是受 `swap(_:_:)` 函数启发而实现的。后者存在于 Swift 标准库，你可以在你的应用程序中使用它。如果你在代码中需要类似 `swapTwoValues(_:_:)` 函数的功能，你可以使用已存在的 `swap(_:_:)` 函数。
//:
//: ## 类型参数
//:
//: 你可提供多个类型参数，将它们都写在尖括号中，用逗号分开。
//:
//: ## 命名类型参数
//:
//: 大多情况下，类型参数具有描述下的名称，例如字典 `Dictionary<Key, Value>` 中的 `Key` 和 `Value` 及数组 `Array<Element>` 中的 `Element`，这能告诉阅读代码的人这些参数类型与泛型类型或函数之间的关系。然而，当它们之间没有有意义的关系时，通常使用单个字符来表示，例如 `T`、`U`、`V`，例如上面演示函数 `swapTwoValues(_:_:)` 中的 `T`。
//:
//: > 请始终使用大写字母开头的驼峰命名法（例如 `T` 和 `MyTypeParameter`）来为类型参数命名，以表明它们是占位类型，而不是一个值。
//:
//: ## 泛型类型
//:
//: 除了泛型函数，Swift 还允许自定义*泛型类型*。这些自定义类、结构体和枚举可以适用于*任意类型*，类似于 `Array` 和 `Dictionary`。
//:
//: 本节将向你展示如何编写一个名为 `Stack`（栈）的泛型集合类型。栈是值的有序集合，和数组类似，但比数组有更严格的操作限制。数组允许在其中任意位置插入或是删除元素。而栈只允许在集合的末端添加新的元素（称之为入栈）。类似的，栈也只能从末端移除元素（称之为出栈）。
//:
//: > 栈的概念已被 `UINavigationController` 类用来构造视图控制器的导航结构。你通过调用 `UINavigationController` 的 `pushViewController(_:animated:)` 方法来添加新的视图控制器到导航栈，通过 `popViewControllerAnimated(_:)` 方法来从导航栈中移除视图控制器。每当你需要一个严格的”后进先出”方式来管理集合，栈都是最实用的模型。
//:
struct IntStack {
	var items = [Int]()
	mutating func push(_ item: Int) {
		items.append(item)
	}
	mutating func pop() -> Int {
		return items.removeLast()
	}
}

struct Stack<Element> {
	var items = [Element]()
	mutating func push(_ item: Element) {
		items.append(item)
	}
	mutating func pop() -> Element {
		return items.removeLast()
	}
}

var stackOfStrings = Stack<String>()
stackOfStrings.push("uno")
stackOfStrings.push("dos")
stackOfStrings.push("tres")
stackOfStrings.push("cuatro")
// 栈中现在有 4 个字符串

let fromTheTop = stackOfStrings.pop()
// fromTheTop 的值为“cuatro”，现在栈中还有 3 个字符串

//: ## 泛型扩展
//:
//: 当对泛型类型进行扩展时，你并不需要提供类型参数列表作为定义的一部分。原始类型定义中声明的类型参数列表在扩展中可以直接使用，并且这些来自原始类型中的参数名称会被用作原始定义中类型参数的引用。
//:
extension Stack {
	var topItem: Element? {
		return items.isEmpty ? nil : items[items.count - 1]
	}
}

if let topItem = stackOfStrings.topItem {
	print("The top item on the stack is \(topItem).")
}
// 打印“The top item on the stack is tres.”

//: ## 类型约束
//:
//: `swapTwoValues(_:_:)` 函数和 `Stack` 适用于任意类型。不过，如果能对泛型函数或泛型类型中添加特定的*类型约束*，这将在某些情况下非常有用。类型约束指定类型参数必须继承自指定类、遵循特定的协议或协议组合。
//:
//: ### 类型约束语法
//:
//: 在一个类型参数名后面放置一个类名或者协议名，并用冒号进行分隔，来定义类型约束。下面将展示泛型函数约束的基本语法（与泛型类型的语法相同）：
//:
//func someFunction<T: SomeClass, U: SomeProtocol>(someT: T, someU: U) {
//	// 这里是泛型函数的函数体部分
//}

//: 上面这个函数有两个类型参数。第一个类型参数 `T` 必须是 `SomeClass` 子类；第二个类型参数 `U` 必须符合 `SomeProtocol` 协议。
//:
//: ### 类型约束实践
//:
func findIndex(ofString valueToFind: String, in array: [String]) -> Int? {
	for (index, value) in array.enumerated() {
		if value == valueToFind {
			return index
		}
	}
	return nil
}

let strings = ["cat", "dog", "llama", "parakeet", "terrapin"]
if let foundIndex = findIndex(ofString: "llama", in: strings) {
	print("The index of llama is \(foundIndex)")
}
// 打印“The index of llama is 2”

func findIndex<T: Equatable>(of valueToFind: T, in array:[T]) -> Int? {
	for (index, value) in array.enumerated() {
		if value == valueToFind {
			return index
		}
	}
	return nil
}

let doubleIndex = findIndex(of: 9.3, in: [3.14159, 0.1, 0.25])
// doubleIndex 类型为 Int?，其值为 nil，因为 9.3 不在数组中
let stringIndex = findIndex(of: "Andrea", in: ["Mike", "Malcolm", "Andrea"])
// stringIndex 类型为 Int?，其值为 2

//: ## 关联类型
//:
//: 定义一个协议时，声明一个或多个关联类型作为协议定义的一部分将会非常有用。关联类型为协议中的某个类型提供了一个占位符名称，其代表的实际类型在协议被遵循时才会被指定。关联类型通过 `associatedtype` 关键字来指定。
//:
//: ### 关联类型实践
//:
protocol Container {
	associatedtype Item
	mutating func append(_ item: Item)
	var count: Int { get }
	subscript(i: Int) -> Item { get }
}

struct IntStack2: Container {
	// IntStack 的原始实现部分
	var items = [Int]()
	mutating func push(_ item: Int) {
		items.append(item)
	}
	mutating func pop() -> Int {
		return items.removeLast()
	}
	// Container 协议的实现部分
	typealias Item = Int
	mutating func append(_ item: Int) {
		self.push(item)
	}
	var count: Int {
		return items.count
	}
	subscript(i: Int) -> Int {
		return items[i]
	}
}

struct Stack2<Element>: Container {
	// Stack<Element> 的原始实现部分
	var items = [Element]()
	mutating func push(_ item: Element) {
		items.append(item)
	}
	mutating func pop() -> Element {
		return items.removeLast()
	}
	// Container 协议的实现部分
	mutating func append(_ item: Element) {
		self.push(item)
	}
	var count: Int {
		return items.count
	}
	subscript(i: Int) -> Element {
		return items[i]
	}
}

//: ### 扩展现有类型来指定关联类型
//:
extension Array: Container {}

//: ### 给关联类型添加约束
//:
protocol Container2 {
	associatedtype Item: Equatable
	mutating func append(_ item: Item)
	var count: Int { get }
	subscript(i: Int) -> Item { get }
}

//: ### 在关联类型约束里使用协议
//:
protocol SuffixableContainer: Container {
	associatedtype Suffix: SuffixableContainer where Suffix.Item == Item
	func suffix(_ size: Int) -> Suffix
}

extension Stack2: SuffixableContainer {
	func suffix(_ size: Int) -> Stack2 {
		var result = Stack2()
		for index in (count-size)..<count {
			result.append(self[index])
		}
		return result
	}
	// 推断 suffix 结果是Stack。
}
var stackOfInts = Stack2<Int>()
stackOfInts.append(10)
stackOfInts.append(20)
stackOfInts.append(30)
let suffix = stackOfInts.suffix(2)
// suffix 包含 20 和 30

extension IntStack2: SuffixableContainer {
	func suffix(_ size: Int) -> Stack2<Int> {
		var result = Stack2<Int>()
		for index in (count-size)..<count {
			result.append(self[index])
		}
		return result
	}
	// 推断 suffix 结果是 Stack<Int>.
}

//: ## 泛型 Where 语句
//:
//: [类型约束]()让你能够为泛型函数、下标、类型的类型参数定义一些强制要求。
//:
//: 对关联类型添加约束通常是非常有用的。你可以通过定义一个泛型 `where` 子句来实现。通过泛型 `where` 子句让关联类型遵从某个特定的协议，以及某个特定的类型参数和关联类型必须类型相同。你可以通过将 `where` 关键字紧跟在类型参数列表后面来定义 `where` 子句，`where` 子句后跟一个或者多个针对关联类型的约束，以及一个或多个类型参数和关联类型间的相等关系。你可以在函数体或者类型的大括号之前添加 `where` 子句。
//:
func allItemsMatch<C1: Container, C2: Container>
	(_ someContainer: C1, _ anotherContainer: C2) -> Bool
	where C1.Item == C2.Item, C1.Item: Equatable {
		
		// 检查两个容器含有相同数量的元素
		if someContainer.count != anotherContainer.count {
			return false
		}
		
		// 检查每一对元素是否相等
		for i in 0..<someContainer.count {
			if someContainer[i] != anotherContainer[i] {
				return false
			}
		}
		
		// 所有元素都匹配，返回 true
		return true
}

var stackOfStrings2 = Stack2<String>()
stackOfStrings2.push("uno")
stackOfStrings2.push("dos")
stackOfStrings2.push("tres")

var arrayOfStrings = ["uno", "dos", "tres"]

if allItemsMatch(stackOfStrings2, arrayOfStrings) {
	print("All items match.")
} else {
	print("Not all items match.")
}
// 打印“All items match.”

//: ## 具有泛型 Where 子句的扩展
//:
extension Stack2 where Element: Equatable {
	func isTop(_ item: Element) -> Bool {
		guard let topItem = items.last else {
			return false
		}
		return topItem == item
	}
}

if stackOfStrings2.isTop("tres") {
	print("Top element is tres.")
} else {
	print("Top element is something else.")
}
// 打印“Top element is tres.”

extension Container where Item: Equatable {
	func startsWith(_ item: Item) -> Bool {
		return count >= 1 && self[0] == item
	}
}

if [9, 9, 9].startsWith(42) {
	print("Starts with 42.")
} else {
	print("Starts with something else.")
}
// 打印“Starts with something else.”

extension Container where Item == Double {
	func average() -> Double {
		var sum = 0.0
		for index in 0..<count {
			sum += self[index]
		}
		return sum / Double(count)
	}
}
print([1260.0, 1200.0, 98.6, 37.0].average())
// 打印“648.9”

//: 就像可以在其他地方写泛型 `where` 子句一样，你可以在一个泛型 `where` 子句中包含多个条件作为扩展的一部分。用逗号分隔列表中的每个条件。
//:
//: ## 具有泛型 Where 子句的关联类型
//:
protocol Container3 {
	associatedtype Item
	mutating func append(_ item: Item)
	var count: Int { get }
	subscript(i: Int) -> Item { get }
	
	associatedtype Iterator: IteratorProtocol where Iterator.Element == Item
	func makeIterator() -> Iterator
}

protocol ComparableContainer: Container3 where Item: Comparable { }

//: ## 泛型下标
//:
extension Container {
	subscript<Indices: Sequence>(indices: Indices) -> [Item]
		where Indices.Iterator.Element == Int {
			var result = [Item]()
			for index in indices {
				result.append(self[index])
			}
			return result
	}
}



//: [上一页](@previous) | [下一页](@next)
