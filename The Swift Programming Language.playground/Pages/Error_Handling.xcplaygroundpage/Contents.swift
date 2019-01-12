//: # 错误处理
//: *错误处理（Error handling）* 是响应错误以及从错误中恢复的过程。Swift 在运行时提供了抛出、捕获、传递和操作可恢复错误（recoverable errors）的一等支持（first-class support）。
//:
//: 某些操作无法保证总是执行完所有代码或生成有用的结果。可选类型用来表示值缺失，但是当某个操作失败时，理解造成失败的原因有助于你的代码作出相应的应对。
//:
//: > Swift 中的错误处理涉及到错误处理模式，这会用到 Cocoa 和 Objective-C 中的 `NSError`。更多详情参见 [用 Swift 解决 Cocoa 错误](https://developer.apple.com/documentation/swift/cocoa_design_patterns/handling_cocoa_errors_in_swift)。
//:
//: ## 表示与抛出错误
//:
//: 在 Swift 中，错误用遵循 `Error` 协议的类型的值来表示。这个空协议表明该类型可以用于错误处理。
//:
enum VendingMachineError: Error {
	case invalidSelection				     //选择无效
	case insufficientFunds(coinsNeeded: Int) //金额不足
	case outOfStock			                 //缺货
}

//: 抛出一个错误可以让你表明有意外情况发生，导致正常的执行流程无法继续执行。抛出错误使用 `throw` 语句。例如，下面的代码抛出一个错误，提示贩卖机还需要 `5` 个硬币：
//:
//throw VendingMachineError.insufficientFunds(coinsNeeded: 5)

//: ## 处理错误
//:
//: 某个错误被抛出时，附近的某部分代码必须负责处理这个错误，例如纠正这个问题、尝试另外一种方式、或是向用户报告错误。
//:
//: Swift 中有 `4` 种处理错误的方式。你可以把函数抛出的错误传递给调用此函数的代码、用 `do-catch` 语句处理错误、将错误作为可选类型处理、或者断言此错误根本不会发生。每种方式在下面的小节中都有描述。
//:
//: 当一个函数抛出一个错误时，你的程序流程会发生改变，所以重要的是你能迅速识别代码中会抛出错误的地方。为了标识出这些地方，在调用一个能抛出错误的函数、方法或者构造器之前，加上 `try` 关键字，或者 `try?` 或 `try!` 这种变体。这些关键字在下面的小节中有具体讲解。
//:
//: > Swift 中的错误处理和其他语言中用 `try`，`catch` 和 `throw` 进行异常处理很像。和其他语言中（包括 Objective-C ）的异常处理不同的是，Swift 中的错误处理并不涉及解除调用栈，这是一个计算代价高昂的过程。就此而言，`throw` 语句的性能特性是可以和 `return` 语句相媲美的。
//:
//: ### 用 throwing 函数传递错误
//:
//: 为了表示一个函数、方法或构造器可以抛出错误，在函数声明的参数之后加上 `throws` 关键字。一个标有 `throws` 关键字的函数被称作 *throwing 函数*。如果这个函数指明了返回值类型，`throws` 关键词需要写在返回箭头（`->`）的前面。
//:
//func canThrowErrors() throws -> String
//func cannotThrowErrors() -> String

//: 一个 throwing 函数可以在其内部抛出错误，并将错误传递到函数被调用时的作用域。
//:
//: > 只有 throwing 函数可以传递错误。任何在某个非 throwing 函数内部抛出的错误只能在函数内部处理。
//:
struct Item {
	var price: Int
	var count: Int
}

class VendingMachine {
	var inventory = [
		"Candy Bar": Item(price: 12, count: 7),
		"Chips": Item(price: 10, count: 4),
		"Pretzels": Item(price: 7, count: 11)
	]
	var coinsDeposited = 0
	
	func vend(itemNamed name: String) throws {
		guard let item = inventory[name] else {
			throw VendingMachineError.invalidSelection
		}
		
		guard item.count > 0 else {
			throw VendingMachineError.outOfStock
		}
		
		guard item.price <= coinsDeposited else {
			throw VendingMachineError.insufficientFunds(coinsNeeded: item.price - coinsDeposited)
			return
		}
		
		coinsDeposited -= item.price
		
		var newItem = item
		newItem.count -= 1
		inventory[name] = newItem
		
		print("Dispensing \(name)")
	}
}

let favoriteSnacks = [
	"Alice": "Chips",
	"Bob": "Licorice",
	"Eve": "Pretzels",
]
func buyFavoriteSnack(person: String, vendingMachine: VendingMachine) throws {
	let snackName = favoriteSnacks[person] ?? "Candy Bar"
	try vendingMachine.vend(itemNamed: snackName)
}

//: 上例中，`buyFavoriteSnack(person:vendingMachine:)` 函数会查找某人最喜欢的零食，并通过调用 `vend(itemNamed:)` 方法来尝试为他们购买。因为 `vend(itemNamed:)` 方法能抛出错误，所以在调用的它时候在它前面加了 `try` 关键字。
//:
//: `throwing` 构造器能像 `throwing` 函数一样传递错误。例如下面代码中的 `PurchasedSnack` 构造器在构造过程中调用了 throwing 函数，并且通过传递到它的调用者来处理这些错误。
//:

struct PurchasedSnack {
	let name: String
	init(name: String, vendingMachine: VendingMachine) throws {
		try vendingMachine.vend(itemNamed: name)
		self.name = name
	}
}

//: ### 用 Do-Catch 处理错误
//:
//: 你可以使用一个 `do-catch` 语句运行一段闭包代码来处理错误。如果在 `do` 子句中的代码抛出了一个错误，这个错误会与 `catch` 子句做匹配，从而决定哪条子句能处理它。
//:
//do {
//	try expression
//	statements
//} catch pattern 1 {
//	statements
//} catch pattern 2 where condition {
//	statements
//} catch {
//	statements
//}

var vendingMachine = VendingMachine()
vendingMachine.coinsDeposited = 8
do {
	try buyFavoriteSnack(person: "Alice", vendingMachine: vendingMachine)
	print("Success! Yum.")
} catch VendingMachineError.invalidSelection {
	print("Invalid Selection.")
} catch VendingMachineError.outOfStock {
	print("Out of Stock.")
} catch VendingMachineError.insufficientFunds(let coinsNeeded) {
	print("Insufficient funds. Please insert an additional \(coinsNeeded) coins.")
} catch {
	print("Unexpected error: \(error).")
}
// 打印 “Insufficient funds. Please insert an additional 2 coins.”

//: `catch` 子句不必将 `do` 子句中的代码所抛出的每一个可能的错误都作处理。如果所有 `catch` 子句都未处理错误，错误就会传递到周围的作用域。然而，错误还是必须要被某个周围的作用域处理的。在不会抛出错误的函数中，必须用 `do-catch` 语句处理错误。而能够抛出错误的函数既可以使用 `do-catch` 语句处理，也可以让调用方来处理错误。如果错误传递到了顶层作用域却依然没有被处理，你会得到一个运行时错误。
//:

func nourish(with item: String) throws {
	do {
		try vendingMachine.vend(itemNamed: item)
	} catch is VendingMachineError {
		print("Invalid selection, out of stock, or not enough money.")
	}
}

do {
	try nourish(with: "Beet-Flavored Chips")
} catch {
	print("Unexpected non-vending-machine-related error: \(error)")
}
// 打印 "Invalid selection, out of stock, or not enough money."

//: ### 将错误转换成可选值
//:
//: 可以使用 `try?` 通过将错误转换成一个可选值来处理错误。如果是在计算 `try?` 表达式时抛出错误，该表达式的结果就为 `nil`。例如，在下面的代码中，`x` 和 `y` 有着相同的数值和等价的含义：
//:
//func someThrowingFunction() throws -> Int {
//	// ...
//}
//
//let x = try? someThrowingFunction()
//
//let y: Int?
//do {
//	y = try someThrowingFunction()
//} catch {
//	y = nil
//}

//: 如果你想对所有的错误都采用同样的方式来处理，用 `try?` 就可以让你写出简洁的错误处理代码。例如，下面的代码用几种方式来获取数据，如果所有方式都失败了则返回 `nil`。
//:
//func fetchData() -> Data? {
//	if let data = try? fetchDataFromDisk() { return data }
//	if let data = try? fetchDataFromServer() { return data }
//	return nil
//}

//: ### 禁用错误传递
//:
//: 有时你知道某个 `throwing` 函数实际上在运行时是不会抛出错误的，在这种情况下，你可以在表达式前面写 `try!` 来禁用错误传递，这会把调用包装在一个不会有错误抛出的运行时断言中。如果真的抛出了错误，你会得到一个运行时错误。
//:
//let photo = try! loadImage(atPath: "./Resources/John Appleseed.jpg")

//: ## 指定清理操作
//:
//: 你可以使用 `defer` 语句在即将离开当前代码块时执行一系列语句。该语句让你能执行一些必要的清理工作，不管是以何种方式离开当前代码块的——无论是由于抛出错误而离开，或是由于诸如 `return`、`break` 的语句。例如，你可以用 `defer` 语句来确保文件描述符得以关闭，以及手动分配的内存得以释放。
//:
//: `defer` 语句将代码的执行延迟到当前的作用域退出之前。该语句由 `defer` 关键字和要被延迟执行的语句组成。延迟执行的语句不能包含任何控制转移语句，例如 `break`、`return` 语句，或是抛出一个错误。延迟执行的操作会按照它们声明的顺序从后往前执行——也就是说，第一条 `defer` 语句中的代码最后才执行，第二条 `defer` 语句中的代码倒数第二个执行，以此类推。最后一条语句会第一个执行。
//:
//func processFile(filename: String) throws {
//	if exists(filename) {
//		let file = open(filename)
//		defer {
//			close(file)
//		}
//		while let line = try file.readline() {
//			// 处理文件。
//		}
//		// close(file) 会在这里被调用，即作用域的最后。
//	}
//}

//: 上面的代码使用一条 `defer` 语句来确保 `open(_:)` 函数有一个相应的对 `close(_:)` 函数的调用。
//:
//: > 即使没有涉及到错误处理的代码，你也可以使用 `defer` 语句。
//:



//: [上一页](@previous) | [下一页](@next)
