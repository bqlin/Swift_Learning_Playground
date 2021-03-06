//: # 析构过程
//: *析构器*只适用于类类型，当一个类的实例被释放之前，析构器会被立即调用。析构器用关键字 `deinit` 来标示，类似于构造器要用 `init` 来标示。
//:
//: ## 析构过程原理
//:
//: Swift 会自动释放不再需要的实例以释放资源。如[自动引用计数](Automatic_Reference_Counting)章节中所讲述，Swift 通过*自动引用计数（ARC)* 处理实例的内存管理。通常当你的实例被释放时不需要手动地去清理。但是，当使用自己的资源时，你可能需要进行一些额外的清理。例如，如果创建了一个自定义的类来打开一个文件，并写入一些数据，你可能需要在类实例被释放之前手动去关闭该文件。
//:
//: 在类的定义中，每个类最多只能有一个析构器，而且析构器不带任何参数和圆括号，如下所示：
//:
//deinit {
//	// 执行析构过程
//}

//: 析构器是在实例释放发生前被自动调用的。你不能主动调用析构器。子类继承了父类的析构器，并且在子类析构器实现的最后，父类的析构器会被自动调用。即使子类没有提供自己的析构器，父类的析构器也同样会被调用。
//:
//: 因为直到实例的析构器被调用后，实例才会被释放，所以析构器可以访问实例的所有属性，并且可以根据那些属性可以修改它的行为（比如查找一个需要被关闭的文件）。
//:
//: ## 析构器实践
//:
class Bank {
	static var coinsInBank = 10_000
	static func distribute(coins numberOfCoinsRequested: Int) -> Int {
		let numberOfCoinsToVend = min(numberOfCoinsRequested, coinsInBank)
		coinsInBank -= numberOfCoinsToVend
		return numberOfCoinsToVend
	}
	static func receive(coins: Int) {
		coinsInBank += coins
	}
}

class Player {
	var coinsInPurse: Int
	init(coins: Int) {
		coinsInPurse = Bank.distribute(coins: coins)
	}
	func win(coins: Int) {
		coinsInPurse += Bank.distribute(coins: coins)
	}
	deinit {
		Bank.receive(coins: coinsInPurse)
	}
}

var playerOne: Player? = Player(coins: 100)
//print("A new player has joined the game with \(playerOne!.coinsInPurse) coins")
// 打印 "A new player has joined the game with 100 coins"
//print("There are now \(Bank.coinsInBank) coins left in the bank")
// 打印 "There are now 9900 coins left in the bank"

playerOne!.win(coins: 2_000)
//print("PlayerOne won 2000 coins & now has \(playerOne!.coinsInPurse) coins")
// 打印 "PlayerOne won 2000 coins & now has 2100 coins"
//print("The bank now only has \(Bank.coinsInBank) coins left")
// 打印 "The bank now only has 7900 coins left"

playerOne = nil
//print("PlayerOne has left the game")
// 打印 "PlayerOne has left the game"
//print("The bank now has \(Bank.coinsInBank) coins")
// 打印 "The bank now has 10000 coins"



//: [上一页](@previous) | [下一页](@next)
