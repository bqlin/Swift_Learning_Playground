//: ## 枚举和结构体（Enumerations and Structures）
//:
//: 使用`enum`来创建一个枚举。就像类和其他所有命名类型一样，枚举可以包含方法。
//:
// 设置的类型约束的是指定了枚举的原始值
enum Rank: Int {
	// 先对 ace 的原始值赋值，以确定后面枚举的原始值
	case ace = 1
	case two, three, four, five, six, seven, eight, nine, ten
	case jack, queen, king
	
	func simpleDescription() -> String {
		switch self {
		case .ace:
			return "ace"
		case .jack:
			return "jack"
		case .queen:
			return "queen"
		case .king:
			return "king"
		default:
			return String(self.rawValue)
		}
	}
}
let ace = Rank.ace
let aceRawValue = ace.rawValue

//: - Experiment:
//:  写一个函数，通过比较它们的原始值来比较两个`Rank`值。
//:
extension Rank {
	func isHigherThan(_ otherRank:Rank) -> Bool {
		return self.rawValue > otherRank.rawValue;
	}
}
let jack = Rank.jack
jack.isHigherThan(ace)

//: 默认情况下，Swift从零开始并每次递增1分配原始值，但你可以通过显式指定值来更改此行为。在上面的例子中，`Ace`被明确地赋予原始值`1`，其余的原始值按顺序分配。你还可以使用字符串或浮点数作为枚举的原始类型。使用`rawValue`属性访问枚举大小写的原始值。
//:
//: 使用`init?(rawValue:)`初始化构造器在原始值和枚举值之间进行转换。
//:
// 使用原始值创建枚举值，若该枚举类型不包含该原始值，则为 nil
if let convertedRank = Rank(rawValue: 3) {
	let threeDescription = convertedRank.simpleDescription()
}

//: 枚举的成员值是实际值，并不是原始值的另一种表达方法。实际上，以防原始值没有意义，你不需要设置。
//:
// 此处没有设定枚举的值类型
enum Suit {
	case spades, hearts, diamonds, clubs
	
	func simpleDescription() -> String {
		switch self {
		case .spades:
			return "spades"
		case .hearts:
			return "hearts"
		case .diamonds:
			return "diamonds"
		case .clubs:
			return "clubs"
		}
	}
}
let hearts = Suit.hearts
let heartsDescription = hearts.simpleDescription()

//: - Experiment:
//: 给`Suit`添加一个`color()`方法，对`spades`和`clubs`返回“black”，对`hearts`和`diamonds`返回“red”。
//:
extension Suit {
	func color() -> String {
		switch self {
		case .spades, .clubs:
			return "black"
		case .hearts, .diamonds:
			return "red"
		}
	}
}
hearts.color()

//: 注意，有两种方式可以引用`hearts`成员：1. 给`hearts`常量赋值时，枚举成员`Suit.hearts`需要用全名来引用，因为常量没有显式指定类型。2. 在`switch`语句中，枚举成员可以使用缩写`.hearts`来引用，因为`self`的值已经知道是一个`Suit`枚举。已知变量类型的情况下，你可以随时使用缩写。
//:
//: 如果枚举具有原始值，则这些值将在声明中确定，这意味着特定枚举每个实例的成员始终具有相同的原始值。枚举成员的另一个选择是使值与成员相关联——这些值在你创建实例时确定，并且对于枚举每个实例的成员它们可以不同。你可以将关联值视为与枚举实例成员的存储属性相似。例如，考虑从服务器请求日出和日落时间的情况。服务器要么响应所请求的信息，要么响应错误的描述。
//:
enum ServerResponse {
	case result(String, String)
	case failure(String)
	case unknown
}

let success = ServerResponse.result("6:00 am", "8:09 pm")
let failure = ServerResponse.failure("Out of cheese.")

switch success {
case let .result(sunrise, sunset):
	print("Sunrise is at \(sunrise) and sunset is at \(sunset).")
case let .failure(message):
	print("Failure...  \(message)")
case .unknown:
	print("unknown")
}

//: - Experiment:
//: 给`ServerResponse`和`switch`添加第三种情况。
//:
//: 注意：对比从`ServerResponse`中提取日升和日落时间并用得到的值的方式与使用`switch`的方式。
//:
//: 使用`struct`来创建一个结构体。结构体和类有很多相同的地方，比如方法和构造器。它们之间最大的一个区别就是结构体是传值，类是传值引用。
//:
struct Card {
	var rank: Rank
	var suit: Suit
	func simpleDescription() -> String {
		return "The \(rank.simpleDescription()) of \(suit.simpleDescription())"
	}
}
let threeOfSpades = Card(rank: .three, suit: .spades)
let threeOfSpadesDescription = threeOfSpades.simpleDescription()

//: - Experiment:
//: 给`Card`添加一个方法，创建一副完整的扑克牌并把每张牌的 rank 和 suit 对应起来。
//:
extension Rank {
	static let allValues = [ace, two, three, four, five, six, seven, eight, nine, ten, jack, queen, king];
}
extension Suit {
	static let allValues = [spades, hearts, diamonds, clubs];
}
extension Card {
	static func fullCards() -> [Card] {
		var fullCards = [Card]();
		for rank in Rank.allValues {
			for suit in Suit.allValues {
				fullCards.append(Card(rank: rank, suit: suit))
			}
		}
		return fullCards;
	}
}
Card.fullCards()



//: [Previous](@previous) | [Next](@next)
