//: # 方法
//: *方法*是与某些特定类型相关联的函数。类、结构体、枚举都可以定义实例方法；实例方法为给定类型的实例封装了具体的任务与功能。类、结构体、枚举也可以定义类型方法；类型方法与类型本身相关联。类型方法与 Objective-C 中的类方法（class methods）相似。
//:
//: 结构体和枚举能够定义方法是 Swift 与 C/Objective-C 的主要区别之一。在 Objective-C 中，类是唯一能定义方法的类型。但在 Swift 中，你不仅能选择是否要定义一个类/结构体/枚举，还能灵活地在你创建的类型（类/结构体/枚举）上定义方法。
//:
//: ## 实例方法（Instance Methods）
//:
//: *实例方法*是属于某个特定类、结构体或者枚举类型实例的方法。实例方法提供访问和修改实例属性的方法或提供与实例目的相关的功能，并以此来支撑实例的功能。实例方法的语法与函数完全一致，详情参见[函数](Functions)。
//:
//: 实例方法要写在它所属的类型的前后大括号之间。实例方法能够隐式访问它所属类型的所有的其他实例方法和属性。实例方法只能被它所属的类的某个特定实例调用。实例方法不能脱离于现存的实例而被调用。
//:
class Counter {
	var count = 0
	func increment() {
		count += 1
	}
	func increment(by amount: Int) {
		count += amount
	}
	func reset() {
		count = 0
	}
}

let counter = Counter()
// 初始计数值是0
counter.increment()
// 计数值现在是1
counter.increment(by: 5)
// 计数值现在是6
counter.reset()
// 计数值现在是0

//: 函数参数可以同时有一个局部名称（在函数体内部使用）和一个外部名称（在调用函数时使用），详情参见[指定外部参数名](Functions)。方法参数也一样，因为方法就是函数，只是这个函数与某个类型相关联了。
//:
//: ### self 属性
//:
//: 类型的每一个实例都有一个隐含属性叫做 `self`，`self` 完全等同于该实例本身。你可以在一个实例的实例方法中使用这个隐含的 `self` 属性来引用当前实例。
//:
struct Point {
	var x = 0.0, y = 0.0
	func isToTheRightOfX(_ x: Double) -> Bool {
		return self.x > x
	}
}
let somePoint = Point(x: 4.0, y: 5.0)
if somePoint.isToTheRightOfX(1.0) {
	print("This point is to the right of the line where x == 1.0")
}
// 打印 "This point is to the right of the line where x == 1.0"

//: ### 在实例方法中修改值类型
//:
//: 结构体和枚举是*值类型*。默认情况下，值类型的属性不能在它的实例方法中被修改。
//:
//: 但是，如果你确实需要在某个特定的方法中修改结构体或者枚举的属性，你可以为这个方法选择 `可变（mutating）`行为，然后就可以从其方法内部改变它的属性；并且这个方法做的任何改变都会在方法执行结束时写回到原始结构中。方法还可以给它隐含的 `self` 属性赋予一个全新的实例，这个新实例在方法结束时会替换现存实例。
//:
//: 要使用 `可变`方法，将关键字 `mutating` 放到方法的 `func` 关键字之前就可以了：
//:
struct Point2 {
	var x = 0.0, y = 0.0
	mutating func moveByX(_ deltaX: Double, y deltaY: Double) {
		x += deltaX
		y += deltaY
	}
}
var somePoint2 = Point2(x: 1.0, y: 1.0)
somePoint2.moveByX(2.0, y: 3.0)
print("The point is now at (\(somePoint2.x), \(somePoint2.y))")
// 打印 "The point is now at (3.0, 4.0)"

//: 注意，不能在结构体类型的常量（a constant of structure type）上调用可变方法，因为其属性不能被改变，即使属性是变量属性，详情参见[常量结构体的存储属性](Properties)：
//:
let fixedPoint = Point2(x: 3.0, y: 3.0)
//fixedPoint.moveByX(2.0, y: 3.0)
// 这里将会报告一个错误

//: ### 在可变方法中给 self 赋值
//:
//: 可变方法能够赋给隐含属性 `self` 一个全新的实例。上面 `Point` 的例子可以用下面的方式改写：
//:
struct Point3 {
	var x = 0.0, y = 0.0
	mutating func moveBy(x deltaX: Double, y deltaY: Double) {
		self = Point3(x: x + deltaX, y: y + deltaY)
	}
}

enum TriStateSwitch {
	case Off, Low, High
	mutating func next() {
		switch self {
		case .Off:
			self = .Low
		case .Low:
			self = .High
		case .High:
			self = .Off
		}
	}
}
var ovenLight = TriStateSwitch.Low
ovenLight.next()
// ovenLight 现在等于 .High
ovenLight.next()
// ovenLight 现在等于 .Off

//: ## 类型方法
//:
//: 实例方法是被某个类型的实例调用的方法。你也可以定义在类型本身上调用的方法，这种方法就叫做*类型方法*。在方法的 `func` 关键字之前加上关键字 `static`，来指定类型方法。类还可以用关键字 `class` 来允许子类重写父类的方法实现。
//:
//: > 在 Objective-C 中，你只能为 Objective-C 的类类型（classes）定义类型方法（type-level methods）。在 Swift 中，你可以为所有的类、结构体和枚举定义类型方法。每一个类型方法都被它所支持的类型显式包含。
//:
struct LevelTracker {
	static var highestUnlockedLevel = 1
	var currentLevel = 1
	
	static func unlock(_ level: Int) {
		if level > highestUnlockedLevel { highestUnlockedLevel = level }
	}
	
	static func isUnlocked(_ level: Int) -> Bool {
		return level <= highestUnlockedLevel
	}
	
	@discardableResult
	mutating func advance(to level: Int) -> Bool {
		if LevelTracker.isUnlocked(level) {
			currentLevel = level
			return true
		} else {
			return false
		}
	}
}

//: 为了便于管理 `currentLevel` 属性，`LevelTracker` 定义了实例方法 `advance(to:)`。这个方法会在更新 `currentLevel` 之前检查所请求的新等级是否已经解锁。`advance(to:)` 方法返回布尔值以指示是否能够设置 `currentLevel`。因为允许在调用 `advance(to:)` 时候忽略返回值，不会产生编译警告，所以函数被标注为 `@discardableResult` 属性，更多关于属性信息，请参考[属性](Attributes章节。
//:
class Player {
	var tracker = LevelTracker()
	let playerName: String
	func complete(level: Int) {
		LevelTracker.unlock(level + 1)
		tracker.advance(to: level + 1)
	}
	init(name: String) {
		playerName = name
	}
}
var player = Player(name: "Argyrios")
player.complete(level: 1)
print("highest unlocked level is now \(LevelTracker.highestUnlockedLevel)")
// 打印 "highest unlocked level is now 2"

player = Player(name: "Beto")
if player.tracker.advance(to: 6) {
	print("player is now on level 6")
} else {
	print("level 6 has not yet been unlocked")
}
// 打印 "level 6 has not yet been unlocked"



//: [上一页](@previous) | [下一页](@next)
