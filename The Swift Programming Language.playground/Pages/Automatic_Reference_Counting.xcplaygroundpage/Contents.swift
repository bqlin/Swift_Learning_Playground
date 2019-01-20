//: # 自动引用计数
//: Swift 使用*自动引用计数（ARC）*机制来跟踪和管理你的应用程序的内存。通常情况下，Swift 内存管理机制会一直起作用，你无须自己来考虑内存的管理。ARC 会在类的实例不再被使用时，自动释放其占用的内存。
//:
//: 然而在少数情况下，为了能帮助你管理内存，ARC 需要更多的，代码之间关系的信息。本章描述了这些情况，并且为你示范怎样才能使 ARC 来管理你的应用程序的所有内存。在 Swift 使用 ARC 与在 Obejctive-C 中使用 ARC 非常类似，具体请参考[过渡到 ARC 的发布说明](https://developer.apple.com/library/content/releasenotes/ObjectiveC/RN-TransitioningToARC/Introduction/Introduction.html#//apple_ref/doc/uid/TP40011226)
//:
//: > 引用计数仅仅应用于类的实例。结构体和枚举类型是值类型，不是引用类型，也不是通过引用的方式存储和传递。
//:
//: ## 自动引用计数的工作机制
//:
//: 当你每次创建一个类的新的实例的时候，ARC 会分配一块内存来储存该实例信息。内存中会包含实例的类型信息，以及这个实例所有相关的存储型属性的值。
//:
//: 此外，当实例不再被使用时，ARC 释放实例所占用的内存，并让释放的内存能挪作他用。这确保了不再被使用的实例，不会一直占用内存空间。
//:
//: 然而，当 ARC 收回和释放了正在被使用中的实例，该实例的属性和方法将不能再被访问和调用。实际上，如果你试图访问这个实例，你的应用程序很可能会崩溃。
//:
//: 为了确保使用中的实例不会被销毁，ARC 会跟踪和计算每一个实例正在被多少属性，常量和变量所引用。哪怕实例的引用数为 1，ARC 都不会销毁这个实例。
//:
//: 为了使上述成为可能，无论你将实例赋值给属性、常量或变量，它们都会创建此实例的强引用。之所以称之为“强”引用，是因为它会将实例牢牢地保持住，只要强引用还在，实例是不允许被销毁的。
//:
//: ## 自动引用计数实践
//:
class Person {
	let name: String
	init(name: String) {
		self.name = name
		print("\(name) is being initialized")
	}
	deinit {
		print("\(name) is being deinitialized")
	}
}

var reference1: Person?
var reference2: Person?
var reference3: Person?

reference1 = Person(name: "John Appleseed")
// 打印“John Appleseed is being initialized”

reference2 = reference1
reference3 = reference1

//: 现在这一个 `Person` 实例已经有三个强引用了。
//:
reference1 = nil
reference2 = nil

//: 在你清楚地表明不再使用这个 `Person` 实例时，即第三个也就是最后一个强引用被断开时，ARC 会销毁它：
//:
//reference3 = nil
// 打印“John Appleseed is being deinitialized”

//: ## 类实例之间的循环强引用
//:
//: 然而，我们可能会写出一个类实例的强引用数*永远不能*变成 `0` 的代码。如果两个类实例互相持有对方的强引用，因而每个实例都让对方一直存在，就是这种情况。这就是所谓的*循环强引用*。
//:
//: 你可以通过定义类之间的关系为弱引用或无主引用，以替代强引用，从而解决循环强引用的问题。具体的过程在[解决类实例之间的循环强引用]()中有描述。不管怎样，在你学习怎样解决循环强引用之前，很有必要了解一下它是怎样产生的。
//:
class Person2 {
	let name: String
	init(name: String) { self.name = name }
	var apartment: Apartment?
	deinit { print("\(name) is being deinitialized") }
}

class Apartment {
	let unit: String
	init(unit: String) { self.unit = unit }
	var tenant: Person2?
	deinit { print("Apartment \(unit) is being deinitialized") }
}

var john: Person2?
var unit4A: Apartment?

john = Person2(name: "John Appleseed")
unit4A = Apartment(unit: "4A")

//: 现在你能够将这两个实例关联在一起，这样人就能有公寓住了，而公寓也有了房客。注意感叹号是用来展开和访问可选变量 `john` 和 `unit4A` 中的实例，这样实例的属性才能被赋值：
//:
john!.apartment = unit4A
unit4A!.tenant = john

//: 不幸的是，这两个实例关联后会产生一个循环强引用。`Person` 实例现在有了一个指向 `Apartment` 实例的强引用，而 `Apartment` 实例也有了一个指向 `Person` 实例的强引用。因此，当你断开 `john` 和 `unit4A` 变量所持有的强引用时，引用计数并不会降为 `0`，实例也不会被 ARC 销毁：
//:
john = nil
unit4A = nil

//: 注意，当你把这两个变量设为 `nil` 时，没有任何一个析构器被调用。循环强引用会一直阻止 `Person` 和 `Apartment` 类实例的销毁，这就在你的应用程序中造成了内存泄漏。
//:
//: `Person` 和 `Apartment` 实例之间的强引用关系保留了下来并且不会被断开。
//:
//: ## 解决实例之间的循环强引用
//:
//: Swift 提供了两种办法用来解决你在使用类的属性时所遇到的循环强引用问题：弱引用（weak reference）和无主引用（unowned reference）。
//:
//: 弱引用和无主引用允许循环引用中的一个实例引用另一个实例而*不*保持强引用。这样实例能够互相引用而不产生循环强引用。
//:
//: 当其他的实例有更短的生命周期时，使用弱引用，也就是说，当其他实例析构在先时。在上面公寓的例子中，很显然一个公寓在它的生命周期内会在某个时间段没有它的主人，所以一个弱引用就加在公寓类里面，避免循环引用。相比之下，当其他实例有相同的或者更长生命周期时，请使用无主引用。
//:
//: ### 弱引用
//:
//: *弱引用*不会对其引用的实例保持强引用，因而不会阻止 ARC 销毁被引用的实例。这个特性阻止了引用变为循环强引用。声明属性或者变量时，在前面加上 `weak` 关键字表明这是一个弱引用。
//:
//: 因为弱引用不会保持所引用的实例，即使引用存在，实例也有可能被销毁。因此，ARC 会在引用的实例被销毁后自动将其弱引用赋值为 `nil`。并且因为弱引用需要在运行时允许被赋值为 `nil`，所以它们会被定义为可选类型变量，而不是常量。
//:
//: 你可以像其他可选值一样，检查弱引用的值是否存在，你将永远不会访问已销毁的实例的引用。
//:
//: > 当 ARC 设置弱引用为 `nil` 时，属性观察不会被触发。
//:
class Person3 {
	let name: String
	init(name: String) { self.name = name }
	var apartment: Apartment2?
	deinit { print("\(name) is being deinitialized") }
}

class Apartment2 {
	let unit: String
	init(unit: String) { self.unit = unit }
	weak var tenant: Person3?
	deinit { print("Apartment \(unit) is being deinitialized") }
}

var john2: Person3?
var unit4A2: Apartment2?

john2 = Person3(name: "John Appleseed 2")
unit4A2 = Apartment2(unit: "4A 2")

john2!.apartment = unit4A2
unit4A2!.tenant = john2

john2 = nil
// 打印“John Appleseed is being deinitialized”

unit4A2 = nil
// 打印“Apartment 4A is being deinitialized”

//: >在 Playground 中似乎弱引用也不易释放
//:
//: > 在使用垃圾收集的系统里，弱指针有时用来实现简单的缓冲机制，因为没有强引用的对象只会在内存压力触发垃圾收集时才被销毁。但是在 ARC 中，一旦值的最后一个强引用被移除，就会被立即销毁，这导致弱引用并不适合上面的用途。
//:
//: ### 无主引用
//:
//: 和弱引用类似，*无主引用*不会牢牢保持住引用的实例。和弱引用不同的是，无主引用在其他实例有相同或者更长的生命周期时使用。你可以在声明属性或者变量时，在前面加上关键字 `unowned` 表示这是一个无主引用。
//:
//: 无主引用通常都被期望拥有值。不过 ARC 无法在实例被销毁后将无主引用设为 `nil`，因为非可选类型的变量不允许被赋值为 `nil`。
//:
//: > 使用无主引用，你*必须*确保引用始终指向一个未销毁的实例。
//:
//: > 如果你试图在实例被销毁后，访问该实例的无主引用，会触发运行时错误。
//:
class Customer {
	let name: String
	var card: CreditCard?
	init(name: String) {
		self.name = name
	}
	deinit { print("\(name) is being deinitialized") }
}

class CreditCard {
	let number: UInt64
	// 无主引用
	unowned let customer: Customer
	init(number: UInt64, customer: Customer) {
		self.number = number
		self.customer = customer
	}
	deinit { print("Card #\(number) is being deinitialized") }
}

//: > `CreditCard` 类的 `number` 属性被定义为 `UInt64` 类型而不是 `Int` 类型，以确保 `number` 属性的存储量在 32 位和 64 位系统上都能足够容纳 16 位的卡号。
//:
var john3: Customer?
john3 = Customer(name: "John Appleseed 3")
john3!.card = CreditCard(number: 1234_5678_9012_3456, customer: john3!)

john3 = nil
// 打印“John Appleseed is being deinitialized”
// 打印“Card #1234567890123456 is being deinitialized”

//: > 上面的例子展示了如何使用安全的无主引用。对于需要禁用运行时的安全检查的情况（例如，出于性能方面的原因），Swift 还提供了不安全的无主引用。与所有不安全的操作一样，你需要负责检查代码以确保其安全性。
//:
//: ### 无主引用和隐式解包可选值属性
//:
//: 上面弱引用和无主引用的例子涵盖了两种常用的需要打破循环强引用的场景。
//:
//: 然而，存在着第三种场景，在这种场景中，两个属性都必须有值，并且初始化完成后永远不会为 `nil`。在这种场景中，需要一个类使用无主属性，而另外一个类使用隐式解包可选值属性。
//:
class Country {
	let name: String
	var capitalCity: City!
	init(name: String, capitalName: String) {
		self.name = name
		self.capitalCity = City(name: capitalName, country: self)
	}
}

class City {
	let name: String
	unowned let country: Country
	init(name: String, country: Country) {
		self.name = name
		self.country = country
	}
}

var country = Country(name: "Canada", capitalName: "Ottawa")
print("\(country.name)'s capital city is called \(country.capitalCity.name)")
// 打印“Canada's capital city is called Ottawa”

//: ## 闭包的循环强引用
//:
//: 循环强引用还会发生在当你将一个闭包赋值给类实例的某个属性，并且这个闭包体中又使用了这个类实例时。这个闭包体中可能访问了实例的某个属性，例如 `self.someProperty`，或者闭包中调用了实例的某个方法，例如 `self.someMethod()`。这两种情况都导致了闭包“捕获”`self`，从而产生了循环强引用。
//:
//: 循环强引用的产生，是因为闭包和类相似，都是引用类型。当你把一个闭包赋值给某个属性时，你是将这个闭包的引用赋值给了属性。实质上，这跟之前的问题是一样的——两个强引用让彼此一直有效。但是，和两个类实例不同，这次一个是类实例，另一个是闭包。
//:
//: Swift 提供了一种优雅的方法来解决这个问题，称之为 `闭包捕获列表`（closure capture list）。同样的，在学习如何用闭包捕获列表打破循环强引用之前，先来了解一下这里的循环强引用是如何产生的，这对我们很有帮助。
//:
class HTMLElement {
	let name: String
	let text: String?
	
	lazy var asHTML: () -> String = {
		if let text = self.text {
			return "<\(self.name)>\(text)</\(self.name)>"
		} else {
			return "<\(self.name) />"
		}
	}
	
	init(name: String, text: String? = nil) {
		self.name = name
		self.text = text
	}
	
	deinit {
		print("\(name) is being deinitialized")
	}
}

let heading = HTMLElement(name: "h1")
let defaultText = "some default text"
heading.asHTML = {
	return "<\(heading.name)>\(heading.text ?? defaultText)</\(heading.name)>"
}
print(heading.asHTML())
// 打印“<h1>some default text</h1>”

//: > `asHTML` 声明为 `lazy` 属性，因为只有当元素确实需要被处理为 HTML 输出的字符串时，才需要使用 `asHTML`。也就是说，在默认的闭包中可以使用 `self`，因为只有当初始化完成以及 `self` 确实存在后，才能访问 `lazy` 属性。
//:

var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello, world")
print(paragraph!.asHTML())
// 打印“<p>hello, world</p>”

//: > 上面的 `paragraph` 变量定义为可选类型的 `HTMLElement`，因此我们可以赋值 `nil` 给它来演示循环强引用。
//:
//: 实例的 `asHTML` 属性持有闭包的强引用。但是，闭包在其闭包体内使用了 `self`（引用了 `self.name` 和 `self.text`），因此闭包捕获了 `self`，这意味着闭包又反过来持有了 `HTMLElement` 实例的强引用。这样两个对象就产生了循环强引用。（更多关于闭包捕获值的信息，请参考[值捕获](Closures)）。
//:
//: > 虽然闭包多次使用了 `self`，它只捕获 `HTMLElement` 实例的一个强引用。
//:
paragraph = nil

//: ## 解决闭包的循环强引用
//:
//: 在定义闭包时同时定义捕获列表作为闭包的一部分，通过这种方式可以解决闭包和类实例之间的循环强引用。捕获列表定义了闭包体内捕获一个或者多个引用类型的规则。跟解决两个类实例间的循环强引用一样，声明每个捕获的引用为弱引用或无主引用，而不是强引用。应当根据代码关系来决定使用弱引用还是无主引用。
//:
//: > Swift 有如下要求：只要在闭包内使用 `self` 的成员，就要用 `self.someProperty` 或者 `self.someMethod()`（而不只是 `someProperty` 或 `someMethod()`）。这提醒你可能会一不小心就捕获了 `self`。
//:
//: ### 定义捕获列表
//:
//: 捕获列表中的每一项都由一对元素组成，一个元素是 `weak` 或 `unowned` 关键字，另一个元素是类实例的引用（例如 `self`）或初始化过的变量（如 `delegate = self.delegate!`）。这些项在方括号中用逗号分开。
//:
//: 如果闭包有参数列表和返回类型，把捕获列表放在它们前面：
//:
//lazy var someClosure: (Int, String) -> String = {
//	[unowned self, weak delegate = self.delegate!] (index: Int, stringToProcess: String) -> String in
//	// 这里是闭包的函数体
//}

//: 如果闭包没有指明参数列表或者返回类型，它们会通过上下文推断，那么可以把捕获列表和关键字 `in` 放在闭包最开始的地方：
//:
//lazy var someClosure: () -> String = {
//	[unowned self, weak delegate = self.delegate!] in
//	// 这里是闭包的函数体
//}

//: ### 弱引用和无主引用
//:
//: 在闭包和捕获的实例总是互相引用并且总是同时销毁时，将闭包内的捕获定义为 `无主引用`。
//:
//: 相反的，在被捕获的引用可能会变为 `nil` 时，将闭包内的捕获定义为 `弱引用`。弱引用总是可选类型，并且当引用的实例被销毁后，弱引用的值会自动置为 `nil`。这使我们可以在闭包体内检查它们是否存在。
//:
//: > 如果被捕获的引用绝对不会变为 `nil`，应该用无主引用，而不是弱引用。
//:
class HTMLElement2 {
	let name: String
	let text: String?
	
	lazy var asHTML: () -> String = {
		[unowned self] in
		if let text = self.text {
			return "<\(self.name)>\(text)</\(self.name)>"
		} else {
			return "<\(self.name) />"
		}
	}
	
	init(name: String, text: String? = nil) {
		self.name = name
		self.text = text
	}
	
	deinit {
		print("\(name) is being deinitialized")
	}
}

var paragraph2: HTMLElement2? = HTMLElement2(name: "p2", text: "hello, world 2")
print(paragraph2!.asHTML())
// 打印“<p>hello, world</p>”

paragraph2 = nil
// 打印“p is being deinitialized”



//: [上一页](@previous) | [下一页](@next)
