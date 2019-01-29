//: # 结构体和类
//: *结构体*和*类*作为一种通用而又灵活的结构，成为了人们构建代码的基础。你可以使用定义常量、变量和函数的语法，为你的结构体和类定义属性、添加方法。
//:
//: 与其他编程语言所不同的是，Swift 并不要求你为自定义的结构体和类的接口与实现代码分别创建文件。你只需在单一的文件中定义一个结构体或者类，系统将会自动生成面向其它代码的外部接口。
//:
//: > 通常一个*类*的实例被称为*对象*。然而相比其他语言，Swift 中结构体和类的功能更加相近，本章中所讨论的大部分功能都可以用在结构体或者类上。因此，这里会使用*实例*这个更通用的术语。
//:
//: ## 结构体和类对比
//:
//: Swift 中结构体和类有很多共同点。两者都可以：
//:
//: * 定义属性用于存储值
//: * 定义方法用于提供功能
//: * 定义下标操作用于通过下标语法访问它们的值
//: * 定义构造器用于设置初始值
//: * 通过扩展以增加默认实现之外的功能
//: * 遵循协议以提供某种标准功能
//:
//: 与结构体相比，类还有如下的附加功能：
//:
//: * 继承允许一个类继承另一个类的特征
//: * 类型转换允许在运行时检查和解释一个类实例的类型
//: * 析构器允许一个类实例释放任何其所被分配的资源
//: * 引用计数允许对一个类的多次引用
//:
//: 类支持的附加功能是以增加复杂性为代价的。作为一般准则，优先使用结构体和枚举，因为它们更容易理解，仅在适当或必要时才使用类。实际上，这意味着你的大多数自定义数据类型都会是结构体和枚举。更多详细的比较参见 [在结构和类之间进行选择](https://developer.apple.com/documentation/swift/choosing_between_structures_and_classes)。
//:
//: ### 类型定义的语法
//: 结构体和类有着相似的定义方式。你通过 `struct` 关键字引入结构体，通过 `class` 关键字引入类，并将它们的具体定义放在一对大括号中：
//:
struct SomeStructure {
	// 在这里定义结构体
}
class SomeClass {
	// 在这里定义类
}

//: > 每当你定义一个新的结构体或者类时，你都是定义了一个新的 Swift 类型。请使用 `UpperCamelCase` 这种方式来命名类型（如这里的 `SomeClass` 和 `SomeStructure`），以便符合标准 Swift 类型的大写命名风格（如 `String`，`Int` 和 `Bool`）。请使用 `lowerCamelCase` 这种方式来命名属性和方法（如 `framerate` 和 `incrementCount`），以便和类型名区分。
//:

struct Resolution {
	var width = 0
	var height = 0
}
class VideoMode {
	var resolution = Resolution()
	var interlaced = false
	var frameRate = 0.0
	var name: String?
}

//: ### 结构体和类的实例
//: 创建结构体和类实例的语法非常相似：
//:
let someResolution = Resolution()
let someVideoMode = VideoMode()

//: 结构体和类都使用构造器语法来创建新的实例。构造器语法的最简单形式是在结构体或者类的类型名称后跟随一对空括号，如 `Resolution()` 或 `VideoMode()`。通过这种方式所创建的类或者结构体实例，其属性均会被初始化为默认值。[构造过程](Initialization) 章节会对类和结构体的初始化进行更详细的讨论。
//:
//: ### 属性访问
//:
//: 你可以通过使用*点语法*访问实例的属性。其语法规则是，实例名后面紧跟属性名，两者以点号（`.`）分隔，不带空格：
//:
//print("The width of someResolution is \(someResolution.width)")
// 打印 "The width of someResolution is 0"
//print("The width of someVideoMode is \(someVideoMode.resolution.width)")
// 打印 "The width of someVideoMode is 0"

someVideoMode.resolution.width = 1280
//print("The width of someVideoMode is now \(someVideoMode.resolution.width)")
// 打印 "The width of someVideoMode is now 1280"

//: ### 结构体类型的成员逐一构造器
//:
//: 所有结构体都有一个自动生成的*成员逐一构造器*，用于初始化新结构体实例中成员的属性。新实例中各个属性的初始值可以通过属性的名称传递到成员逐一构造器之中：
//:
let vga = Resolution(width: 640, height: 480)

//: 与结构体不同，类实例没有默认的成员逐一构造器。[构造过程](Initialization) 章节会对构造器进行更详细的讨论。
//:
//: ## 结构体和枚举是值类型
//:
//: *值类型*是这样一种类型，当它被赋值给一个变量、常量或者被传递给一个函数的时候，其值会被*拷贝*。
//:
//: > 标准库定义的集合，例如数组，字典和字符串，都对复制进行了优化以降低性能成本。新集合不会立即复制，而是跟原集合共享同一份内存，共享同样的元素。在集合的某个副本要被修改前，才会复制它的元素。而你在代码中看起来就像是立即发生了复制。
//:
let hd = Resolution(width: 1920, height: 1080)
var cinema = hd

cinema.width = 2048
//print("cinema is now  \(cinema.width) pixels wide")
// 打印 "cinema is now 2048 pixels wide"

//print("hd is still \(hd.width) pixels wide")
// 打印 "hd is still 1920 pixels wide"

enum CompassPoint {
	case north, south, east, west
	mutating func turnNorth() {
		self = .north
	}
}
var currentDirection = CompassPoint.west
let rememberedDirection = currentDirection
currentDirection.turnNorth()

//print("The current direction is \(currentDirection)")
//print("The remembered direction is \(rememberedDirection)")
// 打印 "The current direction is north"
// 打印 "The remembered direction is west"

//: ## 类是引用类型
//:
//: 与值类型不同，*引用类型*在被赋予到一个变量、常量或者被传递到一个函数时，其值不会被拷贝。因此，使用的是已存在实例的引用，而不是其拷贝。
//:
let tenEighty = VideoMode()
tenEighty.resolution = hd
tenEighty.interlaced = true
tenEighty.name = "1080i"
tenEighty.frameRate = 25.0

let alsoTenEighty = tenEighty
alsoTenEighty.frameRate = 30.0

//print("The frameRate property of tenEighty is now \(tenEighty.frameRate)")
// 打印 "The frameRate property of theEighty is now 30.0"

//: ### 恒等运算符
//:
//: 判定两个常量或者变量是否引用同一个类实例有时很有用。为了达到这个目的，Swift 提供了两个恒等运算符：
//:
//: * 相同（`===`）
//: * 不相同（`!==`）
//:
if tenEighty === alsoTenEighty {
//	print("tenEighty and alsoTenEighty refer to the same VideoMode instance.")
}
// 打印 "tenEighty and alsoTenEighty refer to the same VideoMode instance."

//: ### 指针
//:
//: 如果你有 C，C++ 或者 Objective-C 语言的经验，那么你也许会知道这些语言使用*指针*来引用内存中的地址。Swift 中引用了某个引用类型实例的常量或变量，与 C 语言中的指针类似，不过它并不直接指向某个内存地址，也不要求你使用星号（`*`）来表明你在创建一个引用。相反，Swift 中引用的定义方式与其它的常量或变量的一样。如果需要直接与指针交互，你可以使用标准库提供的指针和缓冲区类型 —— 参见 [手动管理内存](https://developer.apple.com/documentation/swift/swift_standard_library/manual_memory_management)。
//:


//: [上一页](@previous) | [下一页](@next)
