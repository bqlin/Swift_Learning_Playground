//: # 基础部分
//: ## 常量和变量
//: ### 声明常量和变量
//: 常量和变量必须在使用前声明，用 `let` 来声明常量，用 `var` 来声明变量。声明一个名字是 `maximumNumberOfLoginAttempts` 的新常量，并给它一个值 `10` 。然后，声明一个名字是 `currentLoginAttempt` 的变量并将它的值初始化为 `0` 。
//:
// 常量
let maximumNumberOfLoginAttempts = 10
// 变量
var currentLoginAttempt = 0

//: 你可以在一行中声明多个常量或者多个变量，用逗号隔开：
var x = 0.0, y = 0.0, z = 0.0

//: > 如果你的代码中有不需要改变的值，请使用 `let` 关键字将它声明为常量。只将需要改变的值声明为变量。

//: ### 类型标注
//: 当你声明常量或者变量的时候可以加上*类型标注（type annotation）*，说明常量或者变量中要存储的值的类型。如果要添加类型标注，需要在常量或者变量名后面加上一个冒号和空格，然后加上类型名称。
//:
let welcomeMessage: String
welcomeMessage = "Hello"
// 在一行中定义多个同类型变量，在最后一个变量之后添加类型标注
var red, green, blue: Double

//: > 一般来说你很少需要写类型标注。如果你在声明常量或者变量的时候赋了一个初始值，Swift 可以推断出这个常量或者变量的类型，请参考[类型安全和类型推断]()。在上面的例子中，没有给 `welcomeMessage` 赋初始值，所以变量 `welcomeMessage` 的类型是通过一个类型标注指定的，而不是通过初始值推断的。

//: ### 常量和变量的命名
//: 常量和变量名可以包含任何字符，包括 Unicode 字符：
let π = 3.14159
let 你好 = "你好世界"
let 🐶🐮 = "dogcow"

//: 常量与变量名不能包含数学符号，箭头，保留的（或者非法的）Unicode 码位，连线与制表符。也不能以数字开头，但是可以在常量与变量名的其他地方包含数字。
//:
//: 一旦你将常量或者变量声明为确定的类型，你就不能使用相同的名字再次进行声明，或者改变其存储的值的类型。同时，你也不能将常量与变量进行互转。
//:
//: > 如果你需要使用与 Swift 保留关键字相同的名称作为常量或者变量名，你可以使用反引号（`）将关键字包围的方式将其作为名字使用。无论如何，你应当避免使用关键字作为常量或变量名，除非你别无选择。

//: ### 输出常量和变量
//: 你可以用 `print(_:separator:terminator:)` 函数来输出当前常量或变量的值:
//:
var friendlyWelcome = "Hello!"
print(friendlyWelcome)
// 输出 "Bonjour!"

//: `print(_:separator:terminator:)` 是一个用来输出一个或多个值到适当输出区的全局函数。如果你用 Xcode，`print(_:separator:terminator:)` 将会输出内容到“console”面板上。`separator` 和 `terminator` 参数具有默认值，因此你调用这个函数的时候可以忽略它们。默认情况下，该函数通过添加换行符来结束当前行。如果不想换行，可以传递一个空字符串给 `terminator` 参数--例如，`print(someValue, terminator:"")` 。关于参数默认值的更多信息，请参考[默认参数值](Functions)。
//:
//: Swift 用*字符串插值（string interpolation）*的方式把常量名或者变量名当做占位符加入到长字符串中，Swift 会用当前常量或变量的值替换这些占位符。将常量或变量名放入圆括号中，并在开括号前使用反斜杠将其转义：
//:
print("The current value of friendlyWelcome is \(friendlyWelcome)")
// 输出 "The current value of friendlyWelcome is Bonjour!

//: > 字符串插值所有可用的选项，请参考[字符串插值](Strings_and_Characters)。

//: ## 注释
//: Swift 中的注释与 C 语言的注释非常相似。单行注释以双正斜杠（`//`）作为起始标记:
//:
// 这是一个注释

//: 你也可以进行多行注释，其起始标记为单个正斜杠后跟随一个星号（`/*`），终止标记为一个星号后跟随单个正斜杠（`*/`）:
//:
/* 这也是一个注释，
但是是多行的 */

//: 与 C 语言多行注释不同，Swift 的多行注释可以嵌套在其它的多行注释之中。你可以先生成一个多行注释块，然后在这个注释块之中再嵌套成第二个多行注释。终止注释时先插入第二个注释块的终止标记，然后再插入第一个注释块的终止标记：

//:
/* 这是第一个多行注释的开头
/* 这是第二个被嵌套的多行注释 */
这是第一个多行注释的结尾 */

//: ## 分号
//: 与其他大部分编程语言不同，Swift 并不强制要求你在每条语句的结尾处使用分号（`;`），当然，你也可以按照你自己的习惯添加分号。有一种情况下必须要用分号，即你打算在同一行内写多条独立的语句：
//:
let cat = "🐱"; print(cat)
// 输出 "🐱"

//: ## 整数
//: Swift 提供了8、16、32和64位的有符号和无符号整数类型。这些整数类型和 C 语言的命名方式很像，比如8位无符号整数类型是 `UInt8`，32位有符号整数类型是 `Int32` 。就像 Swift 的其他类型一样，整数类型采用大写命名法。
//:
//: ### 整数范围
//: 你可以访问不同整数类型的 `min` 和 `max` 属性来获取对应类型的最小值和最大值：
//:
let minValue = UInt8.min  // minValue 为 0，是 UInt8 类型
let maxValue = UInt8.max  // maxValue 为 255，是 UInt8 类型

//: ### Int
//: 一般来说，你不需要专门指定整数的长度。Swift 提供了一个特殊的整数类型 `Int`，长度与当前平台的原生字长相同：
//:
//: * 在32位平台上，`Int` 和 `Int32` 长度相同。
//: * 在64位平台上，`Int` 和 `Int64` 长度相同。
//:
//: 除非你需要特定长度的整数，一般来说使用 `Int` 就够了。这可以提高代码一致性和可复用性。即使是在32位平台上，`Int` 可以存储的整数范围也可以达到 `-2,147,483,648` ~ `2,147,483,647`，大多数时候这已经足够大了。

//: ### UInt
//: Swift 也提供了一个特殊的无符号类型 `UInt`，长度与当前平台的原生字长相同：
//:
//: * 在32位平台上，`UInt` 和 `UInt32` 长度相同。
//: * 在64位平台上，`UInt` 和 `UInt64` 长度相同。
//: > 尽量不要使用 `UInt`，除非你真的需要存储一个和当前平台原生字长相同的无符号整数。除了这种情况，最好使用 `Int`，即使你要存储的值已知是非负的。统一使用 `Int` 可以提高代码的可复用性，避免不同类型数字之间的转换，并且匹配数字的类型推断，请参考[类型安全和类型推断]()。

//: ## 浮点数
//: 浮点类型比整数类型表示的范围更大，可以存储比 `Int` 类型更大或者更小的数字。Swift 提供了两种有符号浮点数类型：
//:
//: * `Double` 表示64位浮点数。当你需要存储很大或者很高精度的浮点数时请使用此类型。
//: * `Float` 表示32位浮点数。精度要求不高的话可以使用此类型。
//: > `Double` 精确度很高，至少有15位数字，而 `Float` 只有6位数字。选择哪个类型取决于你的代码需要处理的值的范围，在两种类型都匹配的情况下，将优先选择 `Double`。

//: ## 类型安全和类型推断
//: Swift 是一个*类型安全（type safe）*的语言。类型安全的语言可以让你清楚地知道代码要处理的值的类型。如果你的代码需要一个 `String`，你绝对不可能不小心传进去一个 `Int`。
//:
//: 由于 Swift 是类型安全的，所以它会在编译你的代码时进行*类型检查（type checks）*，并把不匹配的类型标记为错误。这可以让你在开发的时候尽早发现并修复错误。
//:
//: 当你要处理不同类型的值时，类型检查可以帮你避免错误。然而，这并不是说你每次声明常量和变量的时候都需要显式指定类型。如果你没有显式指定类型，Swift 会使用*类型推断（type inference）*来选择合适的类型。有了类型推断，编译器可以在编译代码的时候自动推断出表达式的类型。原理很简单，只要检查你赋的值即可。
//:
//: 因为有类型推断，和 C 或者 Objective-C 比起来 Swift 很少需要声明类型。常量和变量虽然需要明确类型，但是大部分工作并不需要你自己来完成。
//:
//: 当你声明常量或者变量并赋初值的时候类型推断非常有用。当你在声明常量或者变量的时候赋给它们一个字面量（literal value 或 literal）即可触发类型推断。（字面量就是会直接出现在你代码中的值，比如 `42` 和 `3.14159` 。）
//:
let meaningOfLife = 42
// meaningOfLife 会被推测为 Int 类型
let pi = 3.14159
// pi 会被推测为 Double 类型

//: ## 数值型字面量
//: 整数字面量可以被写作：
//:
//: * 一个*十进制*数，没有前缀
//: * 一个*二进制*数，前缀是 `0b`
//: * 一个*八进制*数，前缀是 `0o`
//: 一个*十六进制*数，前缀是 `0x`
//:
let decimalInteger = 17
let binaryInteger = 0b10001       // 二进制的17
let octalInteger = 0o21           // 八进制的17
let hexadecimalInteger = 0x11     // 十六进制的17

//: 浮点字面量可以是十进制（没有前缀）或者是十六进制（前缀是 `0x` ）。小数点两边必须有至少一个十进制数字（或者是十六进制的数字）。十进制浮点数也可以有一个可选的指数（exponent)，通过大写或者小写的 `e` 来指定；十六进制浮点数必须有一个指数，通过大写或者小写的 `p` 来指定。
//:
//: 如果一个十进制数的指数为 `exp`，那这个数相当于基数和 10^exp 的乘积：
//:
//: * `1.25e2` 表示 1.25 × 10^2，等于 `125.0`。
//: * `1.25e-2` 表示 1.25 × 10^-2，等于 `0.0125`。
//:
//: 如果一个十六进制数的指数为 `exp`，那这个数相当于基数和 2^exp 的乘积：
//:
//: * `0xFp2` 表示 15 × 2^2，等于 `60.0`。
//: * `0xFp-2` 表示 15 × 2^-2，等于 `3.75`。
//:
let decimalDouble = 12.1875
let exponentDouble = 1.21875e1
let hexadecimalDouble = 0xC.3p0
let sixty = 0xfp2
let threePointSevenFive = 0xfp-2

//: 数值类字面量可以包括额外的格式来增强可读性。整数和浮点数都可以添加额外的零并且包含下划线，并不会影响字面量：
//:
let paddedDouble = 000123.456
let oneMillion = 1_000_000
let justOverOneMillion = 1_000_000.000_000_1

//: ## 类型别名
//: *类型别名（type aliases）*就是给现有类型定义另一个名字。你可以使用 `typealias` 关键字来定义类型别名。
//:
typealias AudioSample = UInt16
var maxAmplitudeFound = AudioSample.min
// maxAmplitudeFound 现在是 0

//: ## 布尔值
//: Swift 有一个基本的*布尔（Boolean）类型*，叫做 `Bool`。布尔值指*逻辑*上的值，因为它们只能是真或者假。Swift 有两个布尔常量，`true` 和 `false`：
let orangesAreOrange = true
let turnipsAreDelicious = false

if turnipsAreDelicious {
	print("Mmm, tasty turnips!")
} else {
	print("Eww, turnips are horrible.")
}
// 输出 "Eww, turnips are horrible."

//: 如果你在需要使用 `Bool` 类型的地方使用了非布尔值，Swift 的类型安全机制会报错。下面的例子会报告一个编译时错误：
//:
let i = 1
//if i {} // 这个例子不会通过编译，会报错
if i == 1 {} // 这个例子会编译成功

//: ## 元组
//: *元组（tuples）*把多个值组合成一个复合值。元组内的值可以是任意类型，并不要求是相同类型。
//:
let http404Error = (404, "Not Found")
// http404Error 的类型是 (Int, String)，值是 (404, "Not Found")

// 通过下标访问元素
print("The status code is \(http404Error.0)")
// 输出 "The status code is 404"
print("The status message is \(http404Error.1)")
// 输出 "The status message is Not Found"

// 在定义时给单个元素命名
let http200Status = (statusCode: 200, description: "OK")
print("The status code is \(http200Status.statusCode)")
// 输出 "The status code is 200"
print("The status message is \(http200Status.description)")
// 输出 "The status message is OK"

//: > 元组在临时组织值的时候很有用，但是并不适合创建复杂的数据结构。如果你的数据结构并不是临时使用，请使用类或者结构体而不是元组。请参考[类和结构体](Classes_and_Structures)。

//: ## 可选类型
//: 使用*可选类型（optionals）*来处理值可能缺失的情况。可选类型表示两种可能：
//: > C 和 Objective-C 中并没有可选类型这个概念。最接近的是 Objective-C 中的一个特性，一个方法要不返回一个对象要不返回 `nil`，`nil` 表示“缺少一个合法的对象”。然而，这只对对象起作用——对于结构体，基本的 C 类型或者枚举类型不起作用。对于这些类型，Objective-C 方法一般会返回一个特殊值（比如 `NSNotFound`）来暗示值缺失。这种方法假设方法的调用者知道并记得对特殊值进行判断。然而，Swift 的可选类型可以让你暗示*任意类型*的值缺失，并不需要一个特殊值。
//:
let possibleNumber = "123"
let convertedNumber = Int(possibleNumber)
// convertedNumber 被推测为类型 "Int?"， 或者类型 "optional Int"

//: ### nil
//: 你可以给可选变量赋值为 `nil` 来表示它没有值：
var serverResponseCode: Int? = 404
// serverResponseCode 包含一个可选的 Int 值 404
serverResponseCode = nil
// serverResponseCode 现在不包含值
//: > `nil` 不能用于非可选的常量和变量。如果你的代码中有常量或者变量需要处理值缺失的情况，请把它们声明成对应的可选类型。
//: 如果你声明一个可选常量或者变量但是没有赋值，它们会自动被设置为 `nil`：
//:
var surveyAnswer: String?
// surveyAnswer 被自动设置为 nil

//: > Swift 的 `nil` 和 Objective-C 中的 `nil` 并不一样。在 Objective-C 中，`nil` 是一个指向不存在对象的指针。在 Swift 中，`nil` 不是指针——它是一个确定的值，用来表示值缺失。任何类型的可选状态都可以被设置为 `nil`，不只是对象类型。

//: ### if 语句以及强制解析
//: 你可以使用 `if` 语句和 `nil` 比较来判断一个可选值是否包含值。你可以使用“相等”(`==`)或“不等”(`!=`)来执行比较。
//: 如果可选类型有值，它将不等于 `nil`：
//:
if convertedNumber != nil {
	print("convertedNumber contains some integer value.")
}
// 输出 "convertedNumber contains some integer value."

//: 当你确定可选类型确实包含值之后，你可以在可选的名字后面加一个感叹号（`!`）来获取值。这个惊叹号表示“我知道这个可选有值，请使用它。”这被称为可选值的*强制解析（forced unwrapping）*：
//:
if convertedNumber != nil {
	print("convertedNumber has an integer value of \(convertedNumber!).")
}
// 输出 "convertedNumber has an integer value of 123."

//: > 使用 `!` 来获取一个不存在的可选值会导致运行时错误。使用 `!` 来强制解析值之前，一定要确定可选包含一个非 `nil` 的值。

//: ### 可选绑定
//: 使用*可选绑定（optional binding）*来判断可选类型是否包含值，如果包含就把值赋给一个临时常量或者变量。可选绑定可以用在 `if` 和 `while` 语句中，这条语句不仅可以用来判断可选类型中是否有值，同时可以将可选类型中的值赋给一个常量或者变量。`if` 和 `while` 语句，请参考[控制流](Control_Flow)。
//:
//print(Int(possibleNumber))
// 它已经被可选类型 *包含的* 值初始化过，所以不需要再使用 `!` 后缀来获取它的值。而 if let constantName = someOptional {} 这种语法的值绑定，就限定了等号的右边必须是可选类型。
if let actualNumber = Int(possibleNumber) {
	print("\'\(possibleNumber)\' has an integer value of \(actualNumber)")
} else {
	print("\'\(possibleNumber)\' could not be converted to an integer")
}
// 输出 "'123' has an integer value of 123"

//: 你可以包含多个可选绑定或多个布尔条件在一个 `if` 语句中，只要使用逗号分开就行。只要有任意一个可选绑定的值为 `nil`，或者任意一个布尔条件为 `false`，则整个 `if` 条件判断为 `false`，这时你就需要使用嵌套 `if` 条件语句来处理，如下所示：
//:
if let firstNumber = Int("4"), let secondNumber = Int("42"), firstNumber < secondNumber && secondNumber < 100 {
	print("\(firstNumber) < \(secondNumber) < 100")
}
// 输出 "4 < 42 < 100"

if let firstNumber = Int("4") {
	if let secondNumber = Int("42") {
		if firstNumber < secondNumber && secondNumber < 100 {
			print("\(firstNumber) < \(secondNumber) < 100")
		}
	}
}
// 输出 "4 < 42 < 100"

//: > 在 `if` 条件语句中使用常量和变量来创建一个可选绑定，仅在 `if` 语句的句中（`body`）中才能获取到值。相反，在 `guard` 语句中使用常量和变量来创建一个可选绑定，仅在 `guard` 语句外且在语句后才能获取到值，请参考[提前退出](Control_Flow)。

//: ### 隐式解析可选类型
//: 有时候在程序架构中，第一次被赋值之后，可以确定一个可选类型_总会_有值。在这种情况下，每次都要判断和解析可选值是非常低效的，因为可以确定它总会有值。
//:
//: 这种类型的可选状态被定义为隐式解析可选类型（implicitly unwrapped optionals）。把想要用作可选的类型的后面的问号（`String?`）改成感叹号（`String!`）来声明一个隐式解析可选类型。
//:
//: 一个隐式解析可选类型其实就是一个普通的可选类型，但是可以被当做非可选类型来使用，并不需要每次都使用解析来获取可选值。下面的例子展示了可选类型 `String` 和隐式解析可选类型 `String` 之间的区别：
//:
let possibleString: String? = "An optional string."
let forcedString: String = possibleString! // 需要感叹号来获取值

let assumedString: String! = "An implicitly unwrapped optional string."
let implicitString: String = assumedString  // 不需要感叹号

// 可选绑定
if let definiteString = assumedString {
	print(definiteString)
}
// 输出 "An implicitly unwrapped optional string."

//: 你可以把隐式解析可选类型当做一个可以自动解析的可选类型。你要做的只是声明的时候把感叹号放到类型的结尾，而不是每次取值的可选名字的结尾。
//: > 如果你在隐式解析可选类型没有值的时候尝试取值，会触发运行时错误。和你在没有值的普通可选类型后面加一个惊叹号一样。
//: > 如果一个变量之后可能变成 `nil` 的话请不要使用隐式解析可选类型。如果你需要在变量的生命周期中判断是否是 `nil` 的话，请使用普通可选类型。

//: ## 错误处理
//: 当一个函数遇到错误条件，它能报错。调用函数的地方能抛出错误消息并合理处理。
//:
//: 一个函数可以通过在声明中添加 `throws` 关键词来抛出错误消息。当你的函数能抛出错误消息时，你应该在表达式中前置 `try` 关键词。
//:
func canThrowAnError() throws {
	// 这个函数有可能抛出错误
}

do {
	try canThrowAnError()
	// 没有错误消息抛出
} catch {
	// 有一个错误消息抛出
}

func makeASandwich() throws {
	// ...
}

//do {
//	try makeASandwich()
//	eatASandwich()
//} catch SandwichError.outOfCleanDishes {
//	washDishes()
//} catch SandwichError.missingIngredients(let ingredients) {
//	buyGroceries(ingredients)
//}

//: 抛出，捕捉，以及传播错误会在[错误处理](Error_Handling)章节详细说明。

//: ## 断言和先决条件
//: 断言和先决条件是在运行时所做的检查。你可以用他们来检查在执行后续代码之前是否一个必要的条件已经被满足了。如果断言或者先决条件中的布尔条件评估的结果为 true（真），则代码像往常一样继续执行。如果布尔条件评估结果为 false（假），程序的当前状态是无效的，则代码执行结束，应用程序中止。
//:
//: 除了在运行时验证你的期望值，断言和先决条件也变成了一个在你的代码中的有用的文档形式。和在上面讨论过的[错误处理](Error_Handling)不同，断言和先决条件并不是用来处理可以恢复的或者可预期的错误。因为一个断言失败表明了程序正处于一个无效的状态，没有办法去捕获一个失败的断言。
//:
//: 使用断言和先决条件不是一个能够避免出现程序出现无效状态的编码方法。然而，如果一个无效状态程序产生了，断言和先决条件可以强制检查你的数据和程序状态，使得你的程序可预测的中止（译者：不是系统强制的，被动的中止），并帮助使这个问题更容易调试。一旦探测到无效的状态，执行则被中止，防止无效的状态导致的进一步对于系统的伤害。
//:
//: 断言和先决条件的不同点是，他们什么时候进行状态检测：断言仅在调试环境运行，而先决条件则在调试环境和生产环境中运行。在生产环境中，断言的条件将不会进行评估。这个意味着你可以使用很多断言在你的开发阶段，但是这些断言在生产环境中不会产生任何影响。
//:
//: ### 使用断言进行调试
//: 你可以调用 Swift 标准库的 `assert(_:_:file:line:)` 函数来写一个断言。向这个函数传入一个结果为 `true` 或者 `false` 的表达式以及一条信息，当表达式的结果为 `false` 的时候这条信息会被显示：
//:
let age = -3
//assert(age >= 0, "A person's age cannot be less than zero") // 若不需要断言信息，则可以写成：assert(age >= 0)
// 因为 age < 0，所以断言会触发

//: 如果代码已经检查了条件，你可以使用 `assertionFailure(_:file:line:)` 函数来表明断言失败了，例如：
//:
if age > 10 {
	print("You can ride the roller-coaster or the ferris wheel.")
} else if age > 0 {
	print("You can ride the ferris wheel.")
} else {
	//assertionFailure("A person's age can't be less than zero.")
}

//: ### 强制执行先决条件
//: 当一个条件可能为假，但是继续执行代码要求条件必须为真的时候，需要使用先决条件。例如使用先决条件来检查是否下标越界，或者来检查是否将一个正确的参数传给函数。
//:
//: 你可以使用全局 `precondition(_:_:file:line:)` 函数来写一个先决条件。向这个函数传入一个结果为 `true` 或者 `false` 的表达式以及一条信息，当表达式的结果为 `false` 的时候这条信息会被显示：
//:
// 在一个下标的实现里...
//precondition(index > 0, "Index must be greater than zero.")

//: 你可以调用　`precondition(_:_:file:line:)` 方法来表明出现了一个错误，例如，switch 进入了 default 分支，但是所有的有效值应该被任意一个其他分支（非 default 分支）处理。
//: > 如果你使用 unchecked 模式（-Ounchecked）编译代码，先决条件将不会进行检查。编译器假设所有的先决条件总是为 true（真），它将优化你的代码。然而，`fatalError(_:file:line:)` 函数总是中断执行，无论你怎么进行优化设定。
//:
//: > 你能使用 `fatalError(_:file:line:)` 函数在设计原型和早期开发阶段，这个阶段只有方法的声明，但是没有具体实现，你可以在方法体中写上 fatalError("Unimplemented")作为具体实现。因为 fatalError 不会像断言和先决条件那样被优化掉，所以你可以确保当代码执行到一个没有被实现的方法时，程序会被中断。



//: [上一页](@previous) | [下一页](@next)
