//: # 协议
//: *协议* 定义了一个蓝图，规定了用来实现某一特定任务或者功能的方法、属性，以及其他需要的东西。类、结构体或枚举都可以遵循协议，并为协议定义的这些要求提供具体实现。某个类型能够满足某个协议的要求，就可以说该类型*遵循*这个协议。
//:
//: 除了遵循协议的类型必须实现的要求外，还可以对协议进行扩展，通过扩展来实现一部分要求或者实现一些附加功能，这样遵循协议的类型就能够使用这些功能。
//:
//: ## 协议语法
//:
//: 协议的定义方式与类、结构体和枚举的定义非常相似：
//:
//protocol SomeProtocol {
//	// 这里是协议的定义部分
//}

//: 要让自定义类型遵循某个协议，在定义类型时，需要在类型名称后加上协议名称，中间以冒号（`:`）分隔。遵循多个协议时，各协议之间用逗号（`,`）分隔：
//:
//struct SomeStructure: FirstProtocol, AnotherProtocol {
//	// 这里是结构体的定义部分
//}

//: 拥有父类的类在遵循协议时，应该将父类名放在协议名之前，以逗号分隔：
//:
//class SomeClass: SomeSuperClass, FirstProtocol, AnotherProtocol {
//	// 这里是类的定义部分
//}

//: ## 属性要求
//:
//: 协议可以要求遵循协议的类型提供特定名称和类型的实例属性或类型属性。协议不指定属性是存储型属性还是计算型属性，它只指定属性的名称和类型。此外，协议还指定属性是可读的还是*可读可写的*。
//:
//: 如果协议要求属性是可读可写的，那么该属性不能是常量属性或只读的计算型属性。如果协议只要求属性是可读的，那么该属性不仅可以是可读的，如果代码需要的话，还可以是可写的。
//:
//: 协议总是用 `var` 关键字来声明变量属性，在类型声明后加上 `{ set get }` 来表示属性是可读可写的，可读属性则用 `{ get }` 来表示：
//:
//protocol SomeProtocol {
//	var mustBeSettable: Int { get set }
//	var doesNotNeedToBeSettable: Int { get }
//}

//: 在协议中定义类型属性时，总是使用 `static` 关键字作为前缀。当类类型遵循协议时，除了 `static` 关键字，还可以使用 `class` 关键字来声明类型属性：
//:
//protocol AnotherProtocol {
//	static var someTypeProperty: Int { get set }
//}

protocol FullyNamed {
	var fullName: String { get }
}

struct Person: FullyNamed {
	var fullName: String
}
let john = Person(fullName: "John Appleseed")
// john.fullName 为“John Appleseed”

class Starship: FullyNamed {
	var prefix: String?
	var name: String
	init(name: String, prefix: String? = nil) {
		self.name = name
		self.prefix = prefix
	}
	var fullName: String {
		return (prefix != nil ? prefix! + " " : "") + name
	}
}
var ncc1701 = Starship(name: "Enterprise", prefix: "USS")
// ncc1701.fullName 是“USS Enterprise”

//: ## 方法要求
//:
//: 协议可以要求遵循协议的类型实现某些指定的实例方法或类方法。这些方法作为协议的一部分，像普通方法一样放在协议的定义中，但是不需要大括号和方法体。可以在协议中定义具有可变参数的方法，和普通方法的定义方式相同。但是，不支持为协议中的方法的参数提供默认值。
//:
//: 正如属性要求中所述，在协议中定义类方法的时候，总是使用 `static` 关键字作为前缀。当类类型遵循协议时，除了 `static` 关键字，还可以使用 `class` 关键字作为前缀：
//:
//protocol SomeProtocol {
//	static func someTypeMethod()
//}

protocol RandomNumberGenerator {
	func random() -> Double
}

class LinearCongruentialGenerator: RandomNumberGenerator {
	var lastRandom = 42.0
	let m = 139968.0
	let a = 3877.0
	let c = 29573.0
	func random() -> Double {
		lastRandom = ((lastRandom * a + c).truncatingRemainder(dividingBy:m))
		return lastRandom / m
	}
}
let generator = LinearCongruentialGenerator()
print("Here's a random number: \(generator.random())")
// 打印“Here's a random number: 0.37464991998171”
print("And another one: \(generator.random())")
// 打印“And another one: 0.729023776863283”

//: ## 异变方法要求
//:
//: 有时需要在方法中改变（或*异变*）方法所属的实例。例如，在值类型（即结构体和枚举）的实例方法中，将 `mutating` 关键字作为方法的前缀，写在 `func` 关键字之前，表示可以在该方法中修改它所属的实例以及实例的任意属性的值。这一过程在[在实例方法中修改值类型](./11_Methods.html#modifying_value_types_from_within_instance_methods)章节中有详细描述。
//:
//: 如果你在协议中定义了一个实例方法，该方法会改变遵循该协议的类型的实例，那么在定义协议时需要在方法前加 `mutating` 关键字。这使得结构体和枚举能够遵循此协议并满足此方法要求。
//:
//: > 实现协议中的 `mutating` 方法时，若是类类型，则不用写 `mutating` 关键字。而对于结构体和枚举，则必须写 `mutating` 关键字。
//:
protocol Togglable {
	mutating func toggle()
}

enum OnOffSwitch: Togglable {
	case off, on
	mutating func toggle() {
		switch self {
		case .off:
			self = .on
		case .on:
			self = .off
		}
	}
}
var lightSwitch = OnOffSwitch.off
lightSwitch.toggle()
// lightSwitch 现在的值为 .on

//: ## 构造器要求
//:
//: 协议可以要求遵循协议的类型实现指定的构造器。你可以像编写普通构造器那样，在协议的定义里写下构造器的声明，但不需要写花括号和构造器的实体：
//:
//protocol SomeProtocol {
//	init(someParameter: Int)
//}

//: ### 协议构造器要求的类实现
//:
//: 你可以在遵循协议的类中实现构造器，无论是作为指定构造器，还是作为便利构造器。无论哪种情况，你都必须为构造器实现标上 `required` 修饰符：
//:
//class SomeClass: SomeProtocol {
//	required init(someParameter: Int) {
//		// 这里是构造器的实现部分
//	}
//}

//: 使用 `required` 修饰符可以确保所有子类也必须提供此构造器实现，从而也能遵循协议。
//:
//: > 如果类已经被标记为 `final`，那么不需要在协议构造器的实现中使用 `required` 修饰符，因为 `final` 类不能有子类。关于 `final` 修饰符的更多内容，请参见[防止重写](Inheritance)。
//:
//: 如果一个子类重写了父类的指定构造器，并且该构造器满足了某个协议的要求，那么该构造器的实现需要同时标注 `required` 和 `override` 修饰符：
//:
protocol SomeProtocol {
	init()
}

class SomeSuperClass {
	init() {
		// 这里是构造器的实现部分
	}
}

class SomeSubClass: SomeSuperClass, SomeProtocol {
	// 因为遵循协议，需要加上 required
	// 因为继承自父类，需要加上 override
	required override init() {
		// 这里是构造器的实现部分
	}
}

//: ### 可失败构造器要求
//:
//: 遵循协议的类型可以通过可失败构造器（`init?`）或非可失败构造器（`init`）来满足协议中定义的可失败构造器要求。协议中定义的非可失败构造器要求可以通过非可失败构造器（`init`）或隐式解包可失败构造器（`init!`）来满足。
//:
//: ## 协议作为类型
//:
//: 尽管协议本身并未实现任何功能，但是协议可以被当做一个成熟的类型来使用。
//:
//: 协议可以像其他普通类型一样使用，使用场景如下：
//:
//: * 作为函数、方法或构造器中的参数类型或返回值类型
//: * 作为常量、变量或属性的类型
//: * 作为数组、字典或其他容器中的元素类型
//:
//: > 协议是一种类型，因此协议类型的名称应与其他类型（例如 `Int`，`Double`，`String`）的写法相同，使用大写字母开头的驼峰式写法，例如（`FullyNamed` 和 `RandomNumberGenerator`）。
//:
class Dice {
	let sides: Int
	let generator: RandomNumberGenerator
	init(sides: Int, generator: RandomNumberGenerator) {
		self.sides = sides
		self.generator = generator
	}
	func roll() -> Int {
		return Int(generator.random() * Double(sides)) + 1
	}
}

var d6 = Dice(sides: 6, generator: LinearCongruentialGenerator())
for _ in 1...5 {
	print("Random dice roll is \(d6.roll())")
}
// Random dice roll is 3
// Random dice roll is 5
// Random dice roll is 4
// Random dice roll is 5
// Random dice roll is 4

//: ## 委托
//:
//: *委托*是一种设计模式，它允许类或结构体将一些需要它们负责的功能委托给其他类型的实例。委托模式的实现很简单：定义协议来封装那些需要被委托的功能，这样就能确保遵循协议的类型能提供这些功能。委托模式可以用来响应特定的动作，或者接收外部数据源提供的数据，而无需关心外部数据源的类型。
//:
protocol DiceGame {
	var dice: Dice { get }
	func play()
}
protocol DiceGameDelegate {
	func gameDidStart(_ game: DiceGame)
	func game(_ game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int)
	func gameDidEnd(_ game: DiceGame)
}

class SnakesAndLadders: DiceGame {
	let finalSquare = 25
	let dice = Dice(sides: 6, generator: LinearCongruentialGenerator())
	var square = 0
	var board: [Int]
	init() {
		board = [Int](repeating: 0, count: finalSquare + 1)
		board[03] = +08; board[06] = +11; board[09] = +09; board[10] = +02
		board[14] = -10; board[19] = -11; board[22] = -02; board[24] = -08
	}
	var delegate: DiceGameDelegate?
	func play() {
		square = 0
		delegate?.gameDidStart(self)
		gameLoop: while square != finalSquare {
			let diceRoll = dice.roll()
			delegate?.game(self, didStartNewTurnWithDiceRoll: diceRoll)
			switch square + diceRoll {
			case finalSquare:
				break gameLoop
			case let newSquare where newSquare > finalSquare:
				continue gameLoop
			default:
				square += diceRoll
				square += board[square]
			}
		}
		delegate?.gameDidEnd(self)
	}
}

class DiceGameTracker: DiceGameDelegate {
	var numberOfTurns = 0
	func gameDidStart(_ game: DiceGame) {
		numberOfTurns = 0
		if game is SnakesAndLadders {
			print("Started a new game of Snakes and Ladders")
		}
		print("The game is using a \(game.dice.sides)-sided dice")
	}
	func game(_ game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int) {
		numberOfTurns += 1
		print("Rolled a \(diceRoll)")
	}
	func gameDidEnd(_ game: DiceGame) {
		print("The game lasted for \(numberOfTurns) turns")
	}
}

let tracker = DiceGameTracker()
let game = SnakesAndLadders()
game.delegate = tracker
game.play()
// Started a new game of Snakes and Ladders
// The game is using a 6-sided dice
// Rolled a 3
// Rolled a 5
// Rolled a 4
// Rolled a 5
// The game lasted for 4 turns

//: ## 在扩展里添加协议遵循
//:
//: 即便无法修改源代码，依然可以通过扩展令已有类型遵循协议。扩展可以为已有类型添加属性、方法、下标以及构造器，因此可以遵循协议中的相应要求。详情请在[扩展](./20_Extensions.html)章节中查看。
//:
//: > 通过扩展令已有类型遵循协议时，该类型的所有实例也会随之获得协议中定义的各项功能。
//:
protocol TextRepresentable {
	var textualDescription: String { get }
}

extension Dice: TextRepresentable {
	var textualDescription: String {
		return "A \(sides)-sided dice"
	}
}

let d12 = Dice(sides: 12, generator: LinearCongruentialGenerator())
print(d12.textualDescription)
// 打印“A 12-sided dice”

extension SnakesAndLadders: TextRepresentable {
	var textualDescription: String {
		return "A game of Snakes and Ladders with \(finalSquare) squares"
	}
}
print(game.textualDescription)
// 打印“A game of Snakes and Ladders with 25 squares”

//: ## 有条件地遵循协议
//:
//: 泛型类型可能只在某些情况下满足一个协议的要求，比如当类型的泛型形式参数遵循对应协议时。你可以通过在扩展类型时列出限制让泛型类型有条件地遵循某协议。在你遵循协议的名字后面写泛型 `where` 分句。更多关于泛型 `where` 分句，见[泛型 Where 分句](Generics)。
//:
extension Array: TextRepresentable where Element: TextRepresentable {
	var textualDescription: String {
		let itemsAsText = self.map { $0.textualDescription }
		return "[" + itemsAsText.joined(separator: ", ") + "]"
	}
}
let myDice = [d6, d12]
print(myDice.textualDescription)
// 打印“[A 6-sided dice, A 12-sided dice]”

//: ## 在扩展里声明遵循协议
//:
//: 当一个类型已经遵循了某个协议中的所有要求，却还没有声明遵循该协议时，可以通过空扩展体的扩展遵循该协议：
//:
struct Hamster {
	var name: String
	var textualDescription: String {
		return "A hamster named \(name)"
	}
}
extension Hamster: TextRepresentable {}

let simonTheHamster = Hamster(name: "Simon")
let somethingTextRepresentable: TextRepresentable = simonTheHamster
print(somethingTextRepresentable.textualDescription)
// 打印“A hamster named Simon”

//: ## 协议类型的集合
//:
//: 协议类型可以在数组或者字典这样的集合中使用，在[协议类型](Protocols)提到了这样的用法。下面的例子创建了一个元素类型为 `TextRepresentable` 的数组：
//:
let things: [TextRepresentable] = [game, d12, simonTheHamster]

for thing in things {
	print(thing.textualDescription)
}
// A game of Snakes and Ladders with 25 squares
// A 12-sided dice
// A hamster named Simon

//: ## 协议的继承
//:
//: 协议能够*继承*一个或多个其他协议，可以在继承的协议的基础上增加新的要求。协议的继承语法与类的继承相似，多个被继承的协议间用逗号分隔：
//:
//protocol InheritingProtocol: SomeProtocol, AnotherProtocol {
//	// 这里是协议的定义部分
//}

protocol PrettyTextRepresentable: TextRepresentable {
	var prettyTextualDescription: String { get }
}

extension SnakesAndLadders: PrettyTextRepresentable {
	var prettyTextualDescription: String {
		var output = textualDescription + ":\n"
		for index in 1...finalSquare {
			switch board[index] {
			case let ladder where ladder > 0:
				output += "▲ "
			case let snake where snake < 0:
				output += "▼ "
			default:
				output += "○ "
			}
		}
		return output
	}
}

print(game.prettyTextualDescription)
// A game of Snakes and Ladders with 25 squares:
// ○ ○ ▲ ○ ○ ▲ ○ ○ ▲ ▲ ○ ○ ○ ▼ ○ ○ ○ ○ ▼ ○ ○ ▼ ○ ▼ ○

//: ## 类专属的协议
//:
//: 你通过添加 `AnyObject` 关键字到协议的继承列表，就可以限制协议只能被类类型遵循（以及非结构体或者非枚举的类型）。
//:
//protocol SomeClassOnlyProtocol: class, SomeInheritedProtocol {
//	// 这里是类专属协议的定义部分
//}

//: 在以上例子中，协议 `SomeClassOnlyProtocol` 只能被类类型遵循。如果尝试让结构体或枚举类型遵循 `SomeClassOnlyProtocol` 协议，则会导致编译时错误。
//:
//: > 当协议定义的要求需要遵循协议的类型必须是引用语义而非值语义时，应该采用类类型专属协议。关于引用语义和值语义的更多内容，请查看[结构体和枚举是值类型](Classes_and_Structures)和[类是引用类型](Classes_and_Structures)。
//:
//: ## 协议合成
//:
//: 要求一个类型同时遵循多个协议是很有用的。你可以使用*协议组合*来复合多个协议到一个要求里。协议组合行为就和你定义的临时局部协议一样拥有构成中所有协议的需求。协议组合不定义任何新的协议类型。
//:
//: 协议组合使用 `SomeProtocol & AnotherProtocol` 的形式。你可以列举任意数量的协议，用和符号（`&`）分开。除了协议列表，协议组合也能包含类类型，这允许你标明一个需要的父类。
//:
protocol Named {
	var name: String { get }
}
protocol Aged {
	var age: Int { get }
}
struct Person2: Named, Aged {
	var name: String
	var age: Int
}
func wishHappyBirthday(to celebrator: Named & Aged) {
	print("Happy birthday, \(celebrator.name), you're \(celebrator.age)!")
}
let birthdayPerson = Person2(name: "Malcolm", age: 21)
wishHappyBirthday(to: birthdayPerson)
// 打印“Happy birthday Malcolm - you're 21!”

class Location {
	var latitude: Double
	var longitude: Double
	init(latitude: Double, longitude: Double) {
		self.latitude = latitude
		self.longitude = longitude
	}
}
class City: Location, Named {
	var name: String
	init(name: String, latitude: Double, longitude: Double) {
		self.name = name
		super.init(latitude: latitude, longitude: longitude)
	}
}
func beginConcert(in location: Location & Named) {
	print("Hello, \(location.name)!")
}

let seattle = City(name: "Seattle", latitude: 47.6, longitude: -122.3)
beginConcert(in: seattle)
// 打印“Hello, Seattle!”

//: ## 检查协议遵循
//:
//: 你可以使用[类型转换](Type_Casting)中描述的 `is` 和 `as` 操作符来检查协议遵循，即是否遵循了某协议，并且可以转换到指定的协议类型。检查和转换到某个协议类型在语法上和类型的检查和转换完全相同：
//:
//: * `is` 用来检查实例是否遵循某个协议，若遵循则返回 `true`，否则返回 `false`。
//: * `as?` 返回一个可选值，当实例遵循某个协议时，返回类型为协议类型的可选值，否则返回 `nil`。
//: * `as!` 将实例强制向下转换到某个协议类型，如果强转失败，会引发运行时错误。
//:
protocol HasArea {
	var area: Double { get }
}

class Circle: HasArea {
	let pi = 3.1415927
	var radius: Double
	var area: Double { return pi * radius * radius }
	init(radius: Double) { self.radius = radius }
}
class Country: HasArea {
	var area: Double
	init(area: Double) { self.area = area }
}

class Animal {
	var legs: Int
	init(legs: Int) { self.legs = legs }
}

let objects: [AnyObject] = [
	Circle(radius: 2.0),
	Country(area: 243_610),
	Animal(legs: 4)
]

for object in objects {
	if let objectWithArea = object as? HasArea {
		print("Area is \(objectWithArea.area)")
	} else {
		print("Something that doesn't have an area")
	}
}
// Area is 12.5663708
// Area is 243610.0
// Something that doesn't have an area

//: ## 可选的协议要求
//:
//: 协议可以定义*可选要求*，遵循协议的类型可以选择是否实现这些要求。在协议中使用 `optional` 关键字作为前缀来定义可选要求。可选要求用在你需要和 Objective-C 打交道的代码中。协议和可选要求都必须带上 `@objc` 属性。标记 `@objc` 特性的协议只能被继承自 Objective-C 类的类或者 `@objc` 类遵循，其他类以及结构体和枚举均不能遵循这种协议。
//:
//: 使用可选要求时（例如，可选的方法或者属性），它们的类型会自动变成可选的。比如，一个类型为 `(Int) -> String` 的方法会变成 `((Int) -> String)?`。需要注意的是整个函数类型是可选的，而不是函数的返回值。
//:
//: 协议中的可选要求可通过可选链式调用来使用，因为遵循协议的类型可能没有实现这些可选要求。类似 `someOptionalMethod?(someArgument)` 这样，你可以在可选方法名称后加上 `?` 来调用可选方法。详细内容可在[可选链式调用](Optional_Chaining)章节中查看。
//:
import Foundation
@objc protocol CounterDataSource {
	@objc optional func increment(forCount count: Int) -> Int
	@objc optional var fixedIncrement: Int { get }
}

//: > 严格来讲，`CounterDataSource` 协议中的方法和属性都是可选的，因此遵循协议的类可以不实现这些要求，尽管技术上允许这样做，不过最好不要这样写。
//:
class Counter {
	var count = 0
	var dataSource: CounterDataSource?
	func increment() {
		if let amount = dataSource?.increment?(forCount: count) {
			count += amount
		} else if let amount = dataSource?.fixedIncrement {
			count += amount
		}
	}
}

class ThreeSource: NSObject, CounterDataSource {
	let fixedIncrement = 3
}

var counter = Counter()
counter.dataSource = ThreeSource()
for _ in 1...4 {
	counter.increment()
	print(counter.count)
}
// 3
// 6
// 9
// 12

@objc class TowardsZeroSource: NSObject, CounterDataSource {
	func increment(forCount count: Int) -> Int {
		if count == 0 {
			return 0
		} else if count < 0 {
			return 1
		} else {
			return -1
		}
	}
}

counter.count = -4
counter.dataSource = TowardsZeroSource()
for _ in 1...5 {
	counter.increment()
	print(counter.count)
}
// -3
// -2
// -1
// 0
// 0

//: ## 协议扩展
//:
//: 协议可以通过扩展来为遵循协议的类型提供属性、方法以及下标的实现。通过这种方式，你可以基于协议本身来实现这些功能，而无需在每个遵循协议的类型中都重复同样的实现，也无需使用全局函数。
//:
extension RandomNumberGenerator {
	func randomBool() -> Bool {
		return random() > 0.5
	}
}

print("Here's a random number: \(generator.random())")
// 打印“Here's a random number: 0.37464991998171”
print("And here's a random Boolean: \(generator.randomBool())")
// 打印“And here's a random Boolean: true”

//: ### 提供默认实现
//:
//: 可以通过协议扩展来为协议要求的属性、方法以及下标提供默认的实现。如果遵循协议的类型为这些要求提供了自己的实现，那么这些自定义实现将会替代扩展中的默认实现被使用。
//:
//: > 通过协议扩展为协议要求提供的默认实现和可选的协议要求不同。虽然在这两种情况下，遵循协议的类型都无需自己实现这些要求，但是通过扩展提供的默认实现可以直接调用，而无需使用可选链式调用。
//:
extension PrettyTextRepresentable  {
	var prettyTextualDescription: String {
		return textualDescription
	}
}

//: ### 为协议扩展添加限制条件
//:
//: 在扩展协议的时候，可以指定一些限制条件，只有遵循协议的类型满足这些限制条件时，才能获得协议扩展提供的默认实现。这些限制条件写在协议名之后，使用 `where` 子句来描述，正如[泛型 Where 子句](Generics)中所描述的。
//:
extension Collection where Element: Equatable {
	func allEqual() -> Bool {
		for element in self {
			if element != self.first {
				return false
			}
		}
		return true
	}
}

let equalNumbers = [100, 100, 100, 100, 100]
let differentNumbers = [100, 100, 200, 100, 200]

print(equalNumbers.allEqual())
// 打印“true”
print(differentNumbers.allEqual())
// 打印“false”

//: > 如果一个遵循的类型满足了为同一方法或属性提供实现的多个限制型扩展的要求， Swift 使用这个实现方法去匹配那个最特殊的限制。



//: [上一页](@previous) | [下一页](@next)
