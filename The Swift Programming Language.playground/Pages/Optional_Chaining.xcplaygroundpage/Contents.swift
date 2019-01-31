//: # 可选链式调用
//:
//: *可选链式调用*是一种可以在当前值可能为 `nil` 的可选值上请求和调用属性、方法及下标的方法。如果可选值有值，那么调用就会成功；如果可选值是 `nil`，那么调用将返回 `nil`。多个调用可以连接在一起形成一个调用链，如果其中任何一个节点为 `nil`，整个调用链都会失败，即返回 `nil`。
//:
//: > Swift 的可选链式调用和 Objective-C 中向 `nil` 发送消息有些相像，但是 Swift 的可选链式调用可以应用于任意类型，并且能检查调用是否成功。
//:
//: ## 使用可选链式调用代替强制展开
//:
//: 通过在想调用的属性、方法，或下标的可选值后面放一个问号（`?`），可以定义一个可选链。这一点很像在可选值后面放一个叹号（`!`）来强制展开它的值。它们的主要区别在于当可选值为空时可选链式调用只会调用失败，然而强制展开将会触发运行时错误。
//:
//: 为了反映可选链式调用可以在空值（`nil`）上调用的事实，不论这个调用的属性、方法及下标返回的值是不是可选值，它的返回结果都是一个可选值。你可以利用这个返回值来判断你的可选链式调用是否调用成功，如果调用有返回值则说明调用成功，返回 `nil` 则说明调用失败。
//:
//: 这里需要特别指出，可选链式调用的返回结果与原本的返回结果具有相同的类型，但是被包装成了一个可选值。例如，使用可选链式调用访问属性，当可选链式调用成功时，如果属性原本的返回结果是 `Int` 类型，则会变为 `Int?` 类型。
//:
class Person {
	var residence: Residence?
}

class Residence {
	var numberOfRooms = 1
}

let john = Person()
//let roomCount = john.residence!.numberOfRooms
// 这会引发运行时错误

if let roomCount = john.residence?.numberOfRooms {
//	print("John's residence has \(roomCount) room(s).")
} else {
//	print("Unable to retrieve the number of rooms.")
}
// 打印“Unable to retrieve the number of rooms.”

john.residence = Residence()

if let roomCount = john.residence?.numberOfRooms {
//	print("John's residence has \(roomCount) room(s).")
} else {
//	print("Unable to retrieve the number of rooms.")
}
// 打印“John's residence has 1 room(s).”

//: ## 为可选链式调用定义模型类
//:
//: 通过使用可选链式调用可以调用多层属性、方法和下标。这样可以在复杂的模型中向下访问各种子属性，并且判断能否访问子属性的属性、方法和下标。
//:
class Person2 {
	var residence: Residence2?
}

class Residence2 {
	var rooms = [Room]()
	var numberOfRooms: Int {
		return rooms.count
	}
	subscript(i: Int) -> Room {
		get {
			return rooms[i]
		}
		set {
			rooms[i] = newValue
		}
	}
	func printNumberOfRooms() {
//		print("The number of rooms is \(numberOfRooms)")
	}
	var address: Address?
}

class Room {
	let name: String
	init(name: String) { self.name = name }
}

class Address {
	var buildingName: String?
	var buildingNumber: String?
	var street: String?
	func buildingIdentifier() -> String? {
		if buildingName != nil {
			return buildingName
		} else if let buildingNumber = buildingNumber, let street = street {
			return "\(buildingNumber) \(street)"
		} else {
			return nil
		}
	}
}

//: ## 通过可选链式调用访问属性
//:
//: 正如[使用可选链式调用代替强制展开]()中所述，可以通过可选链式调用在一个可选值上访问它的属性，并判断访问是否成功。
//:
let john2 = Person2()
if let roomCount = john2.residence?.numberOfRooms {
//	print("John's residence has \(roomCount) room(s).")
} else {
//	print("Unable to retrieve the number of rooms.")
}
// 打印 “Unable to retrieve the number of rooms.”

let someAddress = Address()
someAddress.buildingNumber = "29"
someAddress.street = "Acacia Road"
john2.residence?.address = someAddress

//: 在这个例子中，通过 `john.residence` 来设定 `address` 属性也会失败，因为 `john.residence` 当前为 `nil`。
//:
//: 上面代码中的赋值过程是可选链式调用的一部分，这意味着可选链式调用失败时，等号右侧的代码不会被执行。对于上面的代码来说，很难验证这一点，因为像这样赋值一个常量没有任何副作用。下面的代码完成了同样的事情，但是它使用一个函数来创建 `Address` 实例，然后将该实例返回用于赋值。该函数会在返回前打印“Function was called”，这使你能验证等号右侧的代码是否被执行。
//:
func createAddress() -> Address {
//	print("Function was called.")
	
	let someAddress = Address()
	someAddress.buildingNumber = "29"
	someAddress.street = "Acacia Road"
	
	return someAddress
}
john2.residence?.address = createAddress()

//: 没有任何打印消息，可以看出 `createAddress()` 函数并未被执行。
//:

//: ## 通过可选链式调用来调用方法
//:
//: 可以通过可选链式调用来调用方法，并判断是否调用成功，即使这个方法没有返回值。
//:
//: 通过判断返回值是否为 `nil` 可以判断调用是否成功：
//:
if john2.residence?.printNumberOfRooms() != nil {
//	print("It was possible to print the number of rooms.")
} else {
//	print("It was not possible to print the number of rooms.")
}
// 打印 “It was not possible to print the number of rooms.”

if (john2.residence?.address = someAddress) != nil {
//	print("It was possible to set the address.")
} else {
//	print("It was not possible to set the address.")
}
// 打印 “It was not possible to set the address.”

//: ## 通过可选链式调用访问下标
//:
//: 通过可选链式调用，我们可以在一个可选值上访问下标，并且判断下标调用是否成功。
//:
//: > 通过可选链式调用访问可选值的下标时，应该将问号放在下标方括号的前面而不是后面。可选链式调用的问号一般直接跟在可选表达式的后面。
//:
if let firstRoomName = john2.residence?[0].name {
//	print("The first room name is \(firstRoomName).")
} else {
//	print("Unable to retrieve the first room name.")
}
// 打印 “Unable to retrieve the first room name.”

let johnsHouse = Residence2()
johnsHouse.rooms.append(Room(name: "Living Room"))
johnsHouse.rooms.append(Room(name: "Kitchen"))
john2.residence = johnsHouse

if let firstRoomName = john2.residence?[0].name {
//	print("The first room name is \(firstRoomName).")
} else {
//	print("Unable to retrieve the first room name.")
}
// 打印 “The first room name is Living Room.”

//: ### 访问可选类型的下标
//:
//: 如果下标返回可选类型值，比如 Swift 中 `Dictionary` 类型的键的下标，可以在下标的结尾括号后面放一个问号来在其可选返回值上进行可选链式调用：
//:
var testScores = ["Dave": [86, 82, 84], "Bev": [79, 94, 81]]
testScores["Dave"]?[0] = 91
testScores["Bev"]?[0] += 1
testScores["Brian"]?[0] = 72
// "Dave" 数组现在是 [91, 82, 84]，"Bev" 数组现在是 [80, 94, 81]

//: ## 连接多层可选链式调用
//:
//: 可以通过连接多个可选链式调用在更深的模型层级中访问属性、方法以及下标。然而，多层可选链式调用不会增加返回值的可选层级。
//:
//: 也就是说：
//:
//: + 如果你访问的值不是可选的，可选链式调用将会返回可选值。
//: + 如果你访问的值就是可选的，可选链式调用不会让可选返回值变得“更可选”。
//: 因此：
//:
//: + 通过可选链式调用访问一个 `Int` 值，将会返回 `Int?`，无论使用了多少层可选链式调用。
//: + 类似的，通过可选链式调用访问 `Int?` 值，依旧会返回 `Int?` 值，并不会返回 `Int??`。
//:
if let johnsStreet = john2.residence?.address?.street {
//	print("John's street name is \(johnsStreet).")
} else {
//	print("Unable to retrieve the address.")
}
// 打印 “Unable to retrieve the address.”

let johnsAddress = Address()
johnsAddress.buildingName = "The Larches"
johnsAddress.street = "Laurel Street"
john2.residence?.address = johnsAddress

if let johnsStreet = john2.residence?.address?.street {
//	print("John's street name is \(johnsStreet).")
} else {
//	print("Unable to retrieve the address.")
}
// 打印 “John's street name is Laurel Street.”

//: ## 在方法的可选返回值上进行可选链式调用
//:
//: 上面的例子展示了如何在一个可选值上通过可选链式调用来获取它的属性值。我们还可以在一个可选值上通过可选链式调用来调用方法，并且可以根据需要继续在方法的可选返回值上进行可选链式调用。
//:
if let buildingIdentifier = john2.residence?.address?.buildingIdentifier() {
//	print("John's building identifier is \(buildingIdentifier).")
}
// 打印 “John's building identifier is The Larches.”

if let beginsWithThe =
	john2.residence?.address?.buildingIdentifier()?.hasPrefix("The") {
	if beginsWithThe {
//		print("John's building identifier begins with \"The\".")
	} else {
//		print("John's building identifier does not begin with \"The\".")
	}
}
// 打印 “John's building identifier begins with "The".”



//: [上一页](@previous) | [下一页](@next)
