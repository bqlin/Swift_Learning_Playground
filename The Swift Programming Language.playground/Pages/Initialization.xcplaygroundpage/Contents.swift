//: # 构造过程
//: *构造过程*是使用类、结构体或枚举类型的实例之前的准备过程。在新实例使用前有个过程是必须的，它包括设置实例中每个存储属性的初始值和执行其他必须的设置或构造过程。
//:
//: 你要通过定义*构造器*来实现构造过程，它就像用来创建特定类型新实例的特殊方法。与 Objective-C 中的构造器不同，Swift 的构造器没有返回值。它们的主要任务是保证某种类型的新实例在第一次使用前完成正确的初始化。
//:
//: 类的实例也可以通过实现*析构器*来执行它释放之前自定义的清理工作。想了解更多关于析构器的内容，请参考[析构过程](Deinitialization)。
//:
//: ## 存储属性的初始赋值
//:
//: 类和结构体在创建实例时，必须为所有存储型属性设置合适的初始值。存储型属性的值不能处于一个未知的状态。
//:
//: 你可以在构造器中为存储型属性设置初始值，也可以在定义属性时分配默认值。
//:
//: > 当你为存储型属性分配默认值或者在构造器中为设置初始值时，它们的值是被直接设置的，不会触发任何属性观察者。
//:
//: ### 构造器
//:
//: 构造器在创建某个特定类型的新实例时被调用。它的最简形式类似于一个不带任何形参的实例方法，以关键字 `init` 命名：
//:
struct Fahrenheit {
	var temperature: Double
	init() {
		temperature = 32.0
	}
}
var f = Fahrenheit()
print("The default temperature is \(f.temperature)° Fahrenheit")
// 打印 "The default temperature is 32.0° Fahrenheit"

//: ### 默认属性值
//:
//: 如前所述，你可以在构造器中为存储型属性设置初始值。同样，你也可以在属性声明时为其设置默认值。
//:
//: > 如果一个属性总是使用相同的初始值，那么为其设置一个默认值比每次都在构造器中赋值要好。两种方法的最终结果是一样的，只不过使用默认值让属性的初始化和声明结合得更紧密。它能让你的构造器更简洁、更清晰，且能通过默认值自动推导出属性的类型；同时，它也能让你充分利用默认构造器、构造器继承等特性，后续章节将讲到。
//:
//struct Fahrenheit {
//	var temperature = 32.0
//}

//: ## 自定义构造过程
//:
//: 你可以通过输入形参和可选属性类型来自定义构造过程，也可以在构造过程中分配常量属性。这些都将在后面章节中提到。
//:
//: ### 形参的构造过程
//:
//: 自定义构造过程时，可以在定义中提供*构造形参*，指定其值的类型和名字。构造形参的功能和语法跟函数和方法的形参相同。
//:
struct Celsius {
	var temperatureInCelsius: Double
	init(fromFahrenheit fahrenheit: Double) {
		temperatureInCelsius = (fahrenheit - 32.0) / 1.8
	}
	init(fromKelvin kelvin: Double) {
		temperatureInCelsius = kelvin - 273.15
	}
}

let boilingPointOfWater = Celsius(fromFahrenheit: 212.0)
// boilingPointOfWater.temperatureInCelsius 是 100.0
let freezingPointOfWater = Celsius(fromKelvin: 273.15)
// freezingPointOfWater.temperatureInCelsius 是 0.0

//: ### 形参命名和实参标签
//:
//: 跟函数和方法形参相同，构造形参可以同时使用在构造器里使用的形参命名和一个外部调用构造器时使用的实参标签。
//:
//: 然而，构造器并不像函数和方法那样在括号前有一个可辨别的方法名。因此在调用构造器时，主要通过构造器中形参命名和类型来确定应该被调用的构造器。正因如此，如果你在定义构造器时没有提供实参标签，Swift 会为构造器的*每个*形参自动生成一个实参标签。
//:
struct Color {
	let red, green, blue: Double
	init(red: Double, green: Double, blue: Double) {
		self.red   = red
		self.green = green
		self.blue  = blue
	}
	init(white: Double) {
		red   = white
		green = white
		blue  = white
	}
}
let magenta = Color(red: 1.0, green: 0.0, blue: 1.0)
let halfGray = Color(white: 0.5)

struct Celsius2 {
	var temperatureInCelsius: Double
	init(fromFahrenheit fahrenheit: Double) {
		temperatureInCelsius = (fahrenheit - 32.0) / 1.8
	}
	init(fromKelvin kelvin: Double) {
		temperatureInCelsius = kelvin - 273.15
	}
	init(_ celsius: Double){
		temperatureInCelsius = celsius
	}
}

let bodyTemperature = Celsius2(37.0)
// bodyTemperature.temperatureInCelsius 为 37.0

//: ### 可选属性类型
//:
//: 如果你自定义的类型有一个逻辑上允许值为空的存储型属性——无论是因为它无法在初始化时赋值，还是因为它在之后某个时机可以赋值为空——都需要将它声明为 `可选类型`。可选类型的属性将自动初始化为 `nil`，表示这个属性是特意在构造过程设置为空。
//:
class SurveyQuestion {
	var text: String
	var response: String?
	init(text: String) {
		self.text = text
	}
	func ask() {
		print(text)
	}
}

let cheeseQuestion = SurveyQuestion(text: "Do you like cheese?")
cheeseQuestion.ask()
// 打印 "Do you like cheese?"
cheeseQuestion.response = "Yes, I do like cheese."

//: ### 构造过程中常量属性的赋值
//:
//: 你可以在构造过程中的任意时间点给常量属性赋值，只要在构造过程结束时它设置成确定的值。一旦常量属性被赋值，它将永远不可更改。
//:
//: > 对于类的实例来说，它的常量属性只能在定义它的类的构造过程中修改；不能在子类中修改。
//:
class SurveyQuestion2 {
	let text: String
	var response: String?
	init(text: String) {
		self.text = text
	}
	func ask() {
		print(text)
	}
}
let beetsQuestion = SurveyQuestion2(text: "How about beets?")
beetsQuestion.ask()
// 打印 "How about beets?"
beetsQuestion.response = "I also like beets. (But not with cheese.)"

//: ## 默认构造器
//:
//: 如果结构体或类为所有属性提供了默认值，又没有提供任何自定义的构造器，那么 Swift 会给这些结构体或类提供一个*默认构造器*。这个默认构造器将简单地创建一个所有属性值都设置为它们默认值的实例。
//:
class ShoppingListItem {
	var name: String?
	var quantity = 1
	var purchased = false
}
var item = ShoppingListItem()

//: ### 结构体的逐一成员构造器
//:
//: 结构体如果没有定义任何自定义构造器，它们将自动获得一个*逐一成员构造器（memberwise initializer）*。不像默认构造器，即使存储型属性没有默认值，结构体也能会获得逐一成员构造器。
//:
struct Size {
	var width = 0.0, height = 0.0
}
let twoByTwo = Size(width: 2.0, height: 2.0)

//: ## 值类型的构造器代理
//:
//: 构造器可以通过调用其它构造器来完成实例的部分构造过程。这一过程称为*构造器代理*，它能避免多个构造器间的代码重复。
//:
//: 构造器代理的实现规则和形式在值类型和类类型中有所不同。值类型（结构体和枚举类型）不支持继承，所以构造器代理的过程相对简单，因为它们只能代理给自己的其它构造器。类则不同，它可以继承自其它类（请参考[继承](Inheritance)）。这意味着类有责任保证其所有继承的存储型属性在构造时也能正确的初始化。这些责任将在后续章节[类的继承和构造过程]()中介绍。
//:
//: 对于值类型，你可以使用 `self.init` 在自定义的构造器中引用相同类型中的其它构造器。并且你只能在构造器内部调用 `self.init`。
//:
//: 请注意，如果你为某个值类型定义了一个自定义的构造器，你将无法访问到默认构造器（如果是结构体，还将无法访问逐一成员构造器）。这种限制避免了在一个更复杂的构造器中做了额外的重要设置，但有人不小心使用自动生成的构造器而导致错误的情况。
//:
//: > 假如你希望默认构造器、逐一成员构造器以及你自己的自定义构造器都能用来创建实例，可以将自定义的构造器写到扩展（`extension`）中，而不是写在值类型的原始定义中。想查看更多内容，请查看[扩展](Extensions)章节。
//:
struct Point {
	var x = 0.0, y = 0.0
}

struct Rect {
	var origin = Point()
	var size = Size()
	init() {}
	
	init(origin: Point, size: Size) {
		self.origin = origin
		self.size = size
	}
	
	init(center: Point, size: Size) {
		let originX = center.x - (size.width / 2)
		let originY = center.y - (size.height / 2)
		self.init(origin: Point(x: originX, y: originY), size: size)
	}
}

let basicRect = Rect()
// basicRect 的 origin 是 (0.0, 0.0)，size 是 (0.0, 0.0)

let originRect = Rect(origin: Point(x: 2.0, y: 2.0),
					  size: Size(width: 5.0, height: 5.0))
// originRect 的 origin 是 (2.0, 2.0)，size 是 (5.0, 5.0)

let centerRect = Rect(center: Point(x: 4.0, y: 4.0),
					  size: Size(width: 3.0, height: 3.0))
// centerRect 的 origin 是 (2.5, 2.5)，size 是 (3.0, 3.0)

//: > 如果你想用另外一种不需要自己定义 `init()` 和 `init(origin:size:)` 的方式来实现这个例子，请参考[扩展](Extensions)。
//:
//: ## 类的继承和构造过程
//:
//: 类里面的所有存储型属性——包括所有继承自父类的属性——都*必须*在构造过程中设置初始值。
//:
//: Swift 为类类型提供了两种构造器来确保实例中所有存储型属性都能获得初始值，它们被称为指定构造器和便利构造器。
//:
//: ### 指定构造器和便利构造器
//:
//: *指定构造器*是类中最主要的构造器。一个指定构造器将初始化类中提供的所有属性，并调用合适的父类构造器让构造过程沿着父类链继续往上进行。
//:
//: 类倾向于拥有极少的指定构造器，普遍的是一个类只拥有一个指定构造器。指定构造器像一个个“漏斗”放在构造过程发生的地方，让构造过程沿着父类链继续往上进行。
//:
//: 每一个类都必须至少拥有一个指定构造器。在某些情况下，许多类通过继承了父类中的指定构造器而满足了这个条件。具体内容请参考后续章节[构造器的自动继承]()。
//:
//: *便利构造器*是类中比较次要的、辅助型的构造器。你可以定义便利构造器来调用同一个类中的指定构造器，并为部分形参提供默认值。你也可以定义便利构造器来创建一个特殊用途或特定输入值的实例。
//:
//: 你应当只在必要的时候为类提供便利构造器，比方说某种情况下通过使用便利构造器来快捷调用某个指定构造器，能够节省更多开发时间并让类的构造过程更清晰明了。
//:
//: ### 指定构造器和便利构造器的语法
//:
//: 类的指定构造器的写法跟值类型简单构造器一样：
//:
//init(parameters) {
//	statements
//}

//: 便利构造器也采用相同样式的写法，但需要在 `init` 关键字之前放置 `convenience` 关键字，并使用空格将它们俩分开：
//:
//convenience init(parameters) {
//	statements
//}

//: ### 类类型的构造器代理
//:
//: 为了简化指定构造器和便利构造器之间的调用关系，Swift 构造器之间的代理调用遵循以下三条规则：
//:
//: ##### 规则 1
//: 指定构造器必须调用其直接父类的的指定构造器。
//:
//: ##### 规则 2
//: 便利构造器必须调用*同*类中定义的其它构造器。
//:
//: ##### 规则 3
//: 便利构造器最后必须调用指定构造器。
//:
//: 一个更方便记忆的方法是：
//:
//: - 指定构造器必须总是*向上*代理
//: - 便利构造器必须总是*横向*代理
//:
//: ### 两段式构造过程
//:
//: Swift 中类的构造过程包含两个阶段。第一个阶段，类中的每个存储型属性赋一个初始值。当每个存储型属性的初始值被赋值后，第二阶段开始，它给每个类一次机会，在新实例准备使用之前进一步自定义它们的存储型属性。
//:
//: 两段式构造过程的使用让构造过程更安全，同时在整个类层级结构中给予了每个类完全的灵活性。两段式构造过程可以防止属性值在初始化之前被访问，也可以防止属性被另外一个构造器意外地赋予不同的值。
//:
//: > Swift 的两段式构造过程跟 Objective-C 中的构造过程类似。最主要的区别在于阶段 1，Objective-C 给每一个属性赋值 `0` 或空值（比如说 `0` 或 `nil`）。Swift  的构造流程则更加灵活，它允许你设置定制的初始值，并自如应对某些属性不能以 `0` 或 `nil` 作为合法默认值的情况。
//:
//: Swift 编译器将执行 4 种有效的安全检查，以确保两段式构造过程不出错地完成：
//:
//: ##### 安全检查 1
//: 指定构造器必须保证它所在类的所有属性都必须先初始化完成，之后才能将其它构造任务向上代理给父类中的构造器。
//:
//: 如上所述，一个对象的内存只有在其所有存储型属性确定之后才能完全初始化。为了满足这一规则，指定构造器必须保证它所在类的属性在它往上代理之前先完成初始化。
//:
//: ##### 安全检查 2
//: 指定构造器必须在为继承的属性设置新值之前向上代理调用父类构造器。如果没这么做，指定构造器赋予的新值将被父类中的构造器所覆盖。
//:
//: ##### 安全检查 3
//: 便利构造器必须为任意属性（包括所有同类中定义的）赋新值之前代理调用其它构造器。如果没这么做，便利构造器赋予的新值将被该类的指定构造器所覆盖。
//:
//: ##### 安全检查 4
//: 构造器在第一阶段构造完成之前，不能调用任何实例方法，不能读取任何实例属性的值，不能引用 `self` 作为一个值。
//:
//: 类的实例在第一阶段结束以前并不是完全有效的。只有第一阶段完成后，类的实例才是有效的，才能访问属性和调用方法。
//:
//: 以下是基于上述安全检查的两段式构造过程展示：
//:
//: ##### 阶段 1
//:
//: - 类的某个指定构造器或便利构造器被调用。
//: - 完成类的新实例内存的分配，但此时内存还没有被初始化。
//: - 指定构造器确保其所在类引入的所有存储型属性都已赋初值。存储型属性所属的内存完成初始化。
//: - 指定构造器切换到父类的构造器，对其存储属性完成相同的任务。
//: - 这个过程沿着类的继承链一直往上执行，直到到达继承链的最顶部。
//: - 当到达了继承链最顶部，而且继承链的最后一个类已确保所有的存储型属性都已经赋值，这个实例的内存被认为已经完全初始化。此时阶段 1 完成。
//:
//: ##### 阶段 2
//:
//: - 从继承链顶部往下，继承链中每个类的指定构造器都有机会进一步自定义实例。构造器此时可以访问 `self`、修改它的属性并调用实例方法等等。
//: - 最终，继承链中任意的便利构造器有机会自定义实例和使用 `self`。
//:
//: ### 构造器的继承和重写
//:
//: 跟 Objective-C 中的子类不同，Swift 中的子类默认情况下不会继承父类的构造器。Swift 的这种机制可以防止一个父类的简单构造器被一个更精细的子类继承，而在用来创建子类时的新实例时没有完全或错误被初始化。
//:
//: > 父类的构造器仅会在安全和适当的某些情况下被继承。具体内容请参考后续章节[构造器的自动继承]()。
//:
//: 假如你希望自定义的子类中能提供一个或多个跟父类相同的构造器，你可以在子类中提供这些构造器的自定义实现。
//:
//: 当你在编写一个和父类中指定构造器相匹配的子类构造器时，你实际上是在重写父类的这个指定构造器。因此，你必须在定义子类构造器时带上 `override` 修饰符。即使你重写的是系统自动提供的默认构造器，也需要带上 `override` 修饰符，具体内容请参考[默认构造器]()。
//:
//: 正如重写属性，方法或者是下标，`override` 修饰符会让编译器去检查父类中是否有相匹配的指定构造器，并验证构造器参数是否被按预想中被指定。
//:
//: > 当你重写一个父类的指定构造器时，你总是需要写 `override` 修饰符，即使是为了实现子类的便利构造器。
//:
//: 相反，如果你编写了一个和父类便利构造器相匹配的子类构造器，由于子类不能直接调用父类的便利构造器（每个规则都在上文[类的构造器代理规则]()有所描述），因此，严格意义上来讲，你的子类并未对一个父类构造器提供重写。最后的结果就是，你在子类中“重写”一个父类便利构造器时，不需要加 `override` 修饰符。
//:
//: 在下面的例子中定义了一个叫 `Vehicle` 的基类。基类中声明了一个存储型属性 `numberOfWheels`，它是默认值为 `Int` 类型的 `0`。`numberOfWheels` 属性用在一个描述车辆特征 `String` 类型为 `descrpiption` 的计算型属性中：
//:
class Vehicle {
	var numberOfWheels = 0
	var description: String {
		return "\(numberOfWheels) wheel(s)"
	}
}

//: `Vehicle` 类只为存储型属性提供默认值，也没有提供自定义构造器。因此，它会自动获得一个默认构造器，具体内容请参考[默认构造器](#default_initializers)。默认构造器（如果有的话）总是类中的指定构造器，可以用于创建 `numberOfWheels` 为 `0` 的 `Vehicle`
//:
let vehicle = Vehicle()
print("Vehicle: \(vehicle.description)")
// Vehicle: 0 wheel(s)

//: 下面例子中定义了一个 `Vehicle` 的子类 `Bicycle`：
//:
class Bicycle: Vehicle {
	override init() {
		super.init()
		numberOfWheels = 2
	}
}

//: 子类 `Bicycle` 定义了一个自定义指定构造器 `init()`。这个指定构造器和父类的指定构造器相匹配，所以 `Bicycle` 中这个版本的构造器需要带上 `override` 修饰符。
//:
//: `Bicycle` 的构造器 `init()` 以调用 `super.init()` 方法开始，这个方法的作用是调用 `Bicycle` 的父类 `Vehicle` 的默认构造器。这样可以确保 `Bicycle` 在修改属性之前，它所继承的属性 `numberOfWheels` 能被 `Vehicle` 类初始化。在调用 `super.init()` 之后，属性 `numberOfWheels` 的原值被新值 `2` 替换。
//:
//: 如果你创建一个 `Bicycle` 实例，你可以调用继承的 `description` 计算型属性去查看属性 `numberOfWheels` 是否有改变：
//:
let bicycle = Bicycle()
print("Bicycle: \(bicycle.description)")
// 打印 "Bicycle: 2 wheel(s)"

//: 如果父类的构造器没有在阶段 2 过程中做自定义操作，并且父类有一个无参数的自定义构造器。你可以在所有父类的存储属性赋值之后省略 `super.init()` 的调用。
//:
//: 这个例子定义了另一个 `Vehicle` 的子类 `Hoverboard` ，只设置它的 `color` 属性。这个构造器依赖隐式调用父类的构造器来完成，而不是显示调用 `super.init()`。
//:
class Hoverboard: Vehicle {
	var color: String
	init(color: String) {
		self.color = color
		// super.init() 在这里被隐式调用
	}
	override var description: String {
		return "\(super.description) in a beautiful \(color)"
	}
}
let hoverboard = Hoverboard(color: "silver")
print("Hoverboard: \(hoverboard.description)")
// Hoverboard: 0 wheel(s) in a beautiful silver

//: > 子类可以在构造过程修改继承来的变量属性，但是不能修改继承来的常量属性。
//:
//: ### 构造器的自动继承
//:
//: 如上所述，子类在默认情况下不会继承父类的构造器。但是如果满足特定条件，父类构造器是可以被自动继承的。事实上，这意味着对于许多常见场景你不必重写父类的构造器，并且可以在安全的情况下以最小的代价继承父类的构造器。
//:
//: ##### 规则 1
//: 如果子类没有定义任何指定构造器，它将自动继承父类所有的指定构造器。
//:
//: ##### 规则 2
//: 如果子类提供了所有父类指定构造器的实现——无论是通过规则 1 继承过来的，还是提供了自定义实现——它将自动继承父类所有的便利构造器。
//:
//: 即使你在子类中添加了更多的便利构造器，这两条规则仍然适用。
//:
//: > 子类可以将父类的指定构造器实现为便利构造器来满足规则 2。
//:
//: ### 指定构造器和便利构造器实践
//:
//: 接下来的例子将在实践中展示指定构造器、便利构造器以及构造器的自动继承。这个例子定义了包含三个类 `Food`、`RecipeIngredient` 以及 `ShoppingListItem` 的层级结构，并将演示它们的构造器是如何相互作用的。
//:
//: 类层次中的基类是 `Food`，它是一个简单的用来封装食物名字的类。`Food` 类引入了一个叫做 `name` 的 `String` 类型的属性，并且提供了两个构造器来创建 `Food` 实例：
//:
class Food {
	var name: String
	init(name: String) {
		self.name = name
	}
	
	convenience init() {
		self.init(name: "[Unnamed]")
	}
}
let namedMeat = Food(name: "Bacon")
// namedMeat 的名字是 "Bacon"

//: `Food` 类中的构造器 `init(name: String)` 被定义为一个指定构造器，因为它能确保 `Food` 实例的所有存储型属性都被初始化。`Food` 类没有父类，所以 `init(name: String)` 构造器不需要调用 `super.init()` 来完成构造过程。
//:
//: `Food` 类同样提供了一个没有参数的便利构造器 `init()`。这个 `init()` 构造器为新食物提供了一个默认的占位名字，通过横向代理到指定构造器 `init(name: String)` 并给参数 `name` 赋值为 `[Unnamed]` 来实现：
//:
let mysteryMeat = Food()
// mysteryMeat 的名字是 [Unnamed]

//: 层级中的第二个类是 `Food` 的子类 `RecipeIngredient`。`RecipeIngredient` 类用来表示食谱中的一项原料。它引入了 `Int` 类型的属性 `quantity`（以及从 `Food` 继承过来的 `name` 属性），并且定义了两个构造器来创建 `RecipeIngredient` 实例：
//:
class RecipeIngredient: Food {
	var quantity: Int
	init(name: String, quantity: Int) {
		self.quantity = quantity
		super.init(name: name)
	}
	override convenience init(name: String) {
		self.init(name: name, quantity: 1)
	}
}

//: `RecipeIngredient` 类拥有一个指定构造器 `init(name: String, quantity: Int)`，它可以用来填充 `RecipeIngredient` 实例的所有属性值。这个构造器一开始先将传入的 `quantity` 实参赋值给 `quantity` 属性，这个属性也是唯一在 `RecipeIngredient` 中新引入的属性。随后，构造器向上代理到父类 `Food` 的 `init(name: String)`。这个过程满足[两段式构造过程]()中的安全检查 1。
//:
//: `RecipeIngredient` 也定义了一个便利构造器 `init(name: String)`，它只通过 `name` 来创建 `RecipeIngredient` 的实例。这个便利构造器假设任意 `RecipeIngredient` 实例的 `quantity` 为 `1`，所以不需要显式的质量即可创建出实例。这个便利构造器的定义可以更加方便和快捷地创建实例，并且避免了创建多个 `quantity` 为 `1` 的 `RecipeIngredient` 实例时的代码重复。这个便利构造器只是简单地横向代理到类中的指定构造器，并为 `quantity` 参数传递 `1`。
//:
//: `RecipeIngredient` 的便利构造器 `init(name: String)` 使用了跟 `Food` 中指定构造器 `init(name: String)` 相同的形参。由于这个便利构造器重写了父类的指定构造器 `init(name: String)`，因此必须在前面使用 `override` 修饰符（参见[构造器的继承和重写]()）。
//:
//: 尽管 `RecipeIngredient` 将父类的指定构造器重写为了便利构造器，但是它依然提供了父类的所有指定构造器的实现。因此，`RecipeIngredient` 会自动继承父类的所有便利构造器。
//:
//: 在这个例子中，`RecipeIngredient` 的父类是 `Food`，它有一个便利构造器 `init()`。这个便利构造器会被 `RecipeIngredient` 继承。这个继承版本的 `init()` 在功能上跟 `Food` 提供的版本是一样的，只是它会代理到 `RecipeIngredient` 版本的 `init(name: String)` 而不是 `Food` 提供的版本。
//:
//: 所有的这三种构造器都可以用来创建新的 `RecipeIngredient` 实例：
//:
let oneMysteryItem = RecipeIngredient()
let oneBacon = RecipeIngredient(name: "Bacon")
let sixEggs = RecipeIngredient(name: "Eggs", quantity: 6)

//: 类层级中第三个也是最后一个类是 `RecipeIngredient` 的子类，叫做 `ShoppingListItem`。这个类构建了购物单中出现的某一种食谱原料。
//:
//: 购物单中的每一项总是从未购买状态开始的。为了呈现这一事实，`ShoppingListItem` 引入了一个 Boolean（布尔类型） 的属性 `purchased`，它的默认值是 `false`。`ShoppingListItem` 还添加了一个计算型属性 `description`，它提供了关于 `ShoppingListItem` 实例的一些文字描述：
//:
class ShoppingListItem2: RecipeIngredient {
	var purchased = false
	var description: String {
		var output = "\(quantity) x \(name)"
		output += purchased ? " ✔" : " ✘"
		return output
	}
}

//: > `ShoppingListItem` 没有定义构造器来为 `purchased` 提供初始值，因为添加到购物单的物品的初始状态总是未购买。
//:
//: 因为它为自己引入的所有属性都提供了默认值，并且自己没有定义任何构造器，`ShoppingListItem` 将自动继承所有父类中的指定构造器和便利构造器。
//:
//: 你可以使用三个继承来的构造器来创建 `ShoppingListItem` 的新实例：
//:
var breakfastList = [
	ShoppingListItem2(),
	ShoppingListItem2(name: "Bacon"),
	ShoppingListItem2(name: "Eggs", quantity: 6),
]
breakfastList[0].name = "Orange juice"
breakfastList[0].purchased = true
for item in breakfastList {
	print(item.description)
}
// 1 x orange juice ✔
// 1 x bacon ✘
// 6 x eggs ✘

//: 如上所述，例子中通过字面量方式创建了一个数组 `breakfastList`，它包含了三个 `ShoppingListItem` 实例，因此数组的类型也能被自动推导为 `[ShoppingListItem]`。在数组创建完之后，数组中第一个 `ShoppingListItem` 实例的名字从 `[Unnamed]` 更改为 `Orange juice`，并标记状态为已购买。打印数组中每个元素的描述显示了它们都已按照预期被赋值。
//:
//: ## 可失败构造器
//:
//: 有时，定义一个构造器可失败的类，结构体或者枚举是很有用的。这里所指的“失败” 指的是，如给构造器传入无效的形参，或缺少某种所需的外部资源，又或是不满足某种必要的条件等。
//:
//: 为了妥善处理这种构造过程中可能会失败的情况。你可以在一个类，结构体或是枚举类型的定义中，添加一个或多个可失败构造器。其语法为在 `init` 关键字后面添加问号（`init?`）。
//:
//: > 可失败构造器的参数名和参数类型，不能与其它非可失败构造器的参数名，及其参数类型相同。
//:
//: 可失败构造器会创建一个类型为自身类型的可选类型的对象。你通过 `return nil` 语句来表明可失败构造器在何种情况下应该 “失败”。
//:
//: > 严格来说，构造器都不支持返回值。因为构造器本身的作用，只是为了确保对象能被正确构造。因此你只是用 `return nil` 表明可失败构造器构造失败，而不要用关键字 `return` 来表明构造成功。
//:
let wholeNumber: Double = 12345.0
let pi = 3.14159

if let valueMaintained = Int(exactly: wholeNumber) {
	print("\(wholeNumber) conversion to Int maintains value of \(valueMaintained)")
}
// 打印 "12345.0 conversion to Int maintains value of 12345"

let valueChanged = Int(exactly: pi)
// valueChanged 是 Int? 类型，不是 Int 类型

if valueChanged == nil {
	print("\(pi) conversion to Int does not maintain value")
}
// 打印 "3.14159 conversion to Int does not maintain value"

struct Animal {
	let species: String
	init?(species: String) {
		if species.isEmpty {
			return nil
		}
		self.species = species
	}
}

let someCreature = Animal(species: "Giraffe")
// someCreature 的类型是 Animal? 而不是 Animal

if let giraffe = someCreature {
	print("An animal was initialized with a species of \(giraffe.species)")
}
// 打印 "An animal was initialized with a species of Giraffe"

let anonymousCreature = Animal(species: "")
// anonymousCreature 的类型是 Animal?, 而不是 Animal

if anonymousCreature == nil {
	print("The anonymous creature could not be initialized")
}
// 打印 "The anonymous creature could not be initialized"

//: > 检查空字符串的值（如 `""`，而不是 `"Giraffe"` ）和检查值为 `nil` 的可选类型的字符串是两个完全不同的概念。上例中的空字符串（`""`）其实是一个有效的，非可选类型的字符串。这里我们之所以让 `Animal` 的可失败构造器构造失败，只是因为对于 `Animal` 这个类的 `species` 属性来说，它更适合有一个具体的值，而不是空字符串。
//:
//: ### 枚举类型的可失败构造器
//:
//: 你可以通过一个带一个或多个形参的可失败构造器来获取枚举类型中特定的枚举成员。如果提供的形参无法匹配任何枚举成员，则构造失败。
//:
enum TemperatureUnit {
	case Kelvin, Celsius, Fahrenheit
	init?(symbol: Character) {
		switch symbol {
		case "K":
			self = .Kelvin
		case "C":
			self = .Celsius
		case "F":
			self = .Fahrenheit
		default:
			return nil
		}
	}
}

let fahrenheitUnit = TemperatureUnit(symbol: "F")
if fahrenheitUnit != nil {
	print("This is a defined temperature unit, so initialization succeeded.")
}
// 打印 "This is a defined temperature unit, so initialization succeeded."

let unknownUnit = TemperatureUnit(symbol: "X")
if unknownUnit == nil {
	print("This is not a defined temperature unit, so initialization failed.")
}
// 打印 "This is not a defined temperature unit, so initialization failed."

//: ### 带原始值的枚举类型的可失败构造器
//:
//: 带原始值的枚举类型会自带一个可失败构造器 `init?(rawValue:)`，该可失败构造器有一个合适的原始值类型的 `rawValue` 形参，选择找到的相匹配的枚举成员，找不到则构造失败。
//:
enum TemperatureUnit2: Character {
	case Kelvin = "K", Celsius = "C", Fahrenheit = "F"
}

let fahrenheitUnit2 = TemperatureUnit2(rawValue: "F")
if fahrenheitUnit2 != nil {
	print("This is a defined temperature unit, so initialization succeeded.")
}
// 打印 "This is a defined temperature unit, so initialization succeeded."

let unknownUnit2 = TemperatureUnit2(rawValue: "X")
if unknownUnit2 == nil {
	print("This is not a defined temperature unit, so initialization failed.")
}
// 打印 "This is not a defined temperature unit, so initialization failed."

//: ### 构造失败的传递
//:
//: 类、结构体、枚举的可失败构造器可以横向代理到它们自己其他的可失败构造器。类似的，子类的可失败构造器也能向上代理到父类的可失败构造器。
//:
//: 无论是向上代理还是横向代理，如果你代理到的其他可失败构造器触发构造失败，整个构造过程将立即终止，接下来的任何构造代码不会再被执行。
//:
//: > 可失败构造器也可以代理到其它的不可失败构造器。通过这种方式，你可以增加一个可能的失败状态到现有的构造过程中。
//:
class Product {
	let name: String
	init?(name: String) {
		if name.isEmpty { return nil }
		self.name = name
	}
}

class CartItem: Product {
	let quantity: Int
	init?(name: String, quantity: Int) {
		if quantity < 1 { return nil }
		self.quantity = quantity
		super.init(name: name)
	}
}

if let twoSocks = CartItem(name: "sock", quantity: 2) {
	print("Item: \(twoSocks.name), quantity: \(twoSocks.quantity)")
}
// 打印 "Item: sock, quantity: 2"

if let zeroShirts = CartItem(name: "shirt", quantity: 0) {
	print("Item: \(zeroShirts.name), quantity: \(zeroShirts.quantity)")
} else {
	print("Unable to initialize zero shirts")
}
// 打印 "Unable to initialize zero shirts"

if let oneUnnamed = CartItem(name: "", quantity: 1) {
	print("Item: \(oneUnnamed.name), quantity: \(oneUnnamed.quantity)")
} else {
	print("Unable to initialize one unnamed product")
}
// 打印 "Unable to initialize one unnamed product"

//: ### 重写一个可失败构造器
//:
//: 如同其它的构造器，你可以在子类中重写父类的可失败构造器。或者你也可以用子类的非可失败构造器重写一个父类的可失败构造器。这使你可以定义一个不会构造失败的子类，即使父类的构造器允许构造失败。
//:
//: 注意，当你用子类的非可失败构造器重写父类的可失败构造器时，向上代理到父类的可失败构造器的唯一方式是对父类的可失败构造器的返回值进行强制解包。
//:
//: > 你可以用非可失败构造器重写可失败构造器，但反过来却不行。
//:
class Document {
	var name: String?
	// 该构造器创建了一个 name 属性的值为 nil 的 document 实例
	init() {}
	// 该构造器创建了一个 name 属性的值为非空字符串的 document 实例
	init?(name: String) {
		if name.isEmpty { return nil }
		self.name = name
	}
}

class AutomaticallyNamedDocument: Document {
	override init() {
		super.init()
		self.name = "[Untitled]"
	}
	override init(name: String) {
		super.init()
		if name.isEmpty {
			self.name = "[Untitled]"
		} else {
			self.name = name
		}
	}
}

//: 你可以在子类的不可失败构造器中使用强制解包来调用父类的可失败构造器。比如，下面的 `UntitledDocument` 子类的 `name` 属性的值总是 `"[Untitled]"`，它在构造过程中使用了父类的可失败构造器 `init?(name:)`：
//:
class UntitledDocument: Document {
	override init() {
		super.init(name: "[Untitled]")!
	}
}

//: 在这个例子中，如果在调用父类的可失败构造器 `init?(name:)` 时传入的是空字符串，那么强制解包操作会引发运行时错误。不过，因为这里是通过字符串常量来调用它，构造器不会失败，所以并不会发生运行时错误。
//:
//: ### init! 可失败构造器
//:
//: 通常来说我们通过在 `init` 关键字后添加问号的方式（`init?`）来定义一个可失败构造器，但你也可以通过在 `init` 后面添加感叹号的方式来定义一个可失败构造器（`init!`），该可失败构造器将会构建一个对应类型的隐式解包可选类型的对象。
//:
//: 你可以在 `init?` 中代理到 `init!`，反之亦然。你也可以用 `init?` 重写 `init!`，反之亦然。你还可以用 `init` 代理到 `init!`，不过，一旦 `init!` 构造失败，则会触发一个断言。
//:
//: ## 必要构造器
//:
//: 在类的构造器前添加 `required` 修饰符表明所有该类的子类都必须实现该构造器：
//:
class SomeClass {
	required init() {
		// 构造器的实现代码
	}
}

//: 在子类重写父类的必要构造器时，必须在子类的构造器前也添加 `required` 修饰符，表明该构造器要求也应用于继承链后面的子类。在重写父类中必要的指定构造器时，不需要添加 `override` 修饰符：
//:
class SomeSubclass: SomeClass {
	required init() {
		// 构造器的实现代码
	}
}

//: > 如果子类继承的构造器能满足必要构造器的要求，则无须在子类中显式提供必要构造器的实现。
//:
//: ## 通过闭包或函数设置属性的默认值
//:
//: 如果某个存储型属性的默认值需要一些自定义或设置，你可以使用闭包或全局函数为其提供定制的默认值。每当某个属性所在类型的新实例被构造时，对应的闭包或函数会被调用，而它们的返回值会当做默认值赋值给这个属性。
//:
//: 这种类型的闭包或函数通常会创建一个跟属性类型相同的临时变量，然后修改它的值以满足预期的初始状态，最后返回这个临时变量，作为属性的默认值。
//:
//: 下面模板介绍了如何用闭包为属性提供默认值：
//:
//class SomeClass {
//	let someProperty: SomeType = {
//		// 在这个闭包中给 someProperty 创建一个默认值
//		// someValue 必须和 SomeType 类型相同
//		return someValue
//	}()
//}

//: 注意闭包结尾的花括号后面接了一对空的小括号。这用来告诉 Swift 立即执行此闭包。如果你忽略了这对括号，相当于将闭包本身作为值赋值给了属性，而不是将闭包的返回值赋值给属性。
//:
//: > 如果你使用闭包来初始化属性，请记住在闭包执行时，实例的其它部分都还没有初始化。这意味着你不能在闭包里访问其它属性，即使这些属性有默认值。同样，你也不能使用隐式的 `self` 属性，或者调用任何实例方法。
//:
struct Chessboard {
	let boardColors: [Bool] = {
		var temporaryBoard = [Bool]()
		var isBlack = false
		for i in 1...8 {
			for j in 1...8 {
				temporaryBoard.append(isBlack)
				isBlack = !isBlack
			}
			isBlack = !isBlack
		}
		return temporaryBoard
	}()
	func squareIsBlackAt(row: Int, column: Int) -> Bool {
		return boardColors[(row * 8) + column]
	}
}

let board = Chessboard()
print(board.squareIsBlackAt(row: 0, column: 1))
// 打印 "true"
print(board.squareIsBlackAt(row: 7, column: 7))
// 打印 "false”

//: [上一页](@previous) | [下一页](@next)
