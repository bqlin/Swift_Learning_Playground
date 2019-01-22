//: # 高级运算符
//: 除了之前介绍过的[基本运算符](./02_Basic_Operators.md)，Swift 还提供了数种可以对数值进行复杂运算的高级运算符。它们包含了在 C 和 Objective-C 中已经被大家所熟知的位运算符和移位运算符。
//:
//: 与 C 语言中的算术运算符不同，Swift 中的算术运算符默认是不会溢出的。所有溢出行为都会被捕获并报告为错误。如果想让系统允许溢出行为，可以选择使用 Swift 中另一套默认支持溢出的运算符，比如溢出加法运算符（`&+`）。所有的这些溢出运算符都是以 `&` 开头的。
//:
//: 自定义结构体、类和枚举时，如果也为它们提供标准 Swift 运算符的实现，将会非常有用。在 Swift 中为这些运算符提供自定义的实现非常简单，运算符也会针对不同类型使用对应实现。
//:
//: 我们不用被预定义的运算符所限制。在 Swift 中可以自由地定义中缀、前缀、后缀和赋值运算符，它们具有自定义的优先级与关联值。这些运算符在代码中可以像预定义的运算符一样使用，你甚至可以扩展已有的类型以支持自定义运算符。
//:
//: ## 溢出运算符
//:
//: 当向一个整数类型的常量或者变量赋予超过它容量的值时，Swift 默认会报错，而不是允许生成一个无效的数。这个行为为我们在运算过大或者过小的数时提供了额外的安全性。
//:
//: 例如，`Int16` 型整数能容纳的有符号整数范围是 `-32768` 到 `32767`。当为一个 `Int16` 类型的变量或常量赋予的值超过这个范围时，系统就会报错：
//:
var potentialOverflow = Int16.max
// potentialOverflow 的值是 32767，这是 Int16 能容纳的最大整数
//potentialOverflow += 1
// 这里会报错

//: 在赋值时为过大或者过小的情况提供错误处理，能让我们在处理边界值时更加灵活。
//:
//: 然而，当你希望的时候也可以选择让系统在数值溢出的时候采取截断处理，而非报错。Swift 提供的三个*溢出运算符*来让系统支持整数溢出运算。这些运算符都是以 `&` 开头的：
//:
//: * 溢出加法 `&+`
//: * 溢出减法 `&-`
//: * 溢出乘法 `&*`
//:
//: ### 数值溢出
//:
//: 数值有可能出现上溢或者下溢。
//:
var unsignedOverflow = UInt8.max
// unsignedOverflow 等于 UInt8 所能容纳的最大整数 255
unsignedOverflow = unsignedOverflow &+ 1
// 此时 unsignedOverflow 等于 0

//: `unsignedOverflow` 被初始化为 `UInt8` 所能容纳的最大整数（`255`，以二进制表示即 `11111111`）。然后使用溢出加法运算符（`&+`）对其进行加 `1` 运算。这使得它的二进制表示正好超出 `UInt8` 所能容纳的位数，也就导致了数值的溢出，如下图所示。数值溢出后，仍然留在 `UInt8` 边界内的值是 `00000000`，也就是十进制数值的 `0`。
//:

unsignedOverflow = UInt8.min
// unsignedOverflow 等于 UInt8 所能容纳的最小整数 0
unsignedOverflow = unsignedOverflow &- 1
// 此时 unsignedOverflow 等于 255

//: `UInt8` 型整数能容纳的最小值是 `0`，以二进制表示即 `00000000`。当使用溢出减法运算符对其进行减 `1` 运算时，数值会产生下溢并被截断为 `11111111`， 也就是十进制数值的 `255`。
//:
//: 溢出也会发生在有符号整型上。针对有符号整型的所有溢出加法或者减法运算都是按位运算的方式执行的，符号位也需要参与计算，正如[按位左移、右移运算符]()所描述的。
//:
var signedOverflow = Int8.min
// signedOverflow 等于 Int8 所能容纳的最小整数 -128
signedOverflow = signedOverflow &- 1
// 此时 signedOverflow 等于 127

//: `Int8` 型整数能容纳的最小值是 `-128`，以二进制表示即 `10000000`。当使用溢出减法运算符对其进行减 `1` 运算时，符号位被翻转，得到二进制数值 `01111111`，也就是十进制数值的 `127`，这个值也是 `Int8` 型整所能容纳的最大值。
//:
//: 对于无符号与有符号整型数值来说，当出现上溢时，它们会从数值所能容纳的最大数变成最小数。同样地，当发生下溢时，它们会从所能容纳的最小数变成最大数。
//:
//: ## 优先级和结合性
//:
//: 运算符的*优先级*使得一些运算符优先于其他运算符；它们会先被执行。
//: 
//: *结合性*定义了相同优先级的运算符是如何结合的，也就是说，是与左边结合为一组，还是与右边结合为一组。可以将其理解为“它们是与左边的表达式结合的”，或者“它们是与右边的表达式结合的”。
//:
//: 当考虑一个复合表达式的计算顺序时，运算符的优先级和结合性是非常重要的。举例来说，运算符优先级解释了为什么下面这个表达式的运算结果会是 `17`。
//:
2 + 3 % 4 * 5
// 结果是 17

//: 如果你直接从左到右进行运算，你可能认为运算的过程是这样的：
//:
//: - 2 + 3 = 5
//: - 5 % 4 = 1
//: - 1 * 5 = 5
//:
//: 但是正确答案是 `17` 而不是 `5`。优先级高的运算符要先于优先级低的运算符进行计算。与 C 语言类似，在 Swift 中，乘法运算符（`*`）与取余运算符（`%`）的优先级高于加法运算符（`+`）。因此，它们的计算顺序要先于加法运算。
//:
//: 而乘法运算与取余运算的优先级*相同*。这时为了得到正确的运算顺序，还需要考虑结合性。乘法运算与取余运算都是左结合的。可以将这考虑成，从它们的左边开始为这两部分表达式都隐式地加上括号：
//:
2 + ((3 % 4) * 5)

//: 有关 Swift 标准库提供的操作符信息，包括操作符优先级组和结核性设置的完整列表，请参见[操作符声明](https://developer.apple.com/documentation/swift/swift_standard_library/operator_declarations)。
//:
//: > 相对 C 语言和 Objective-C 来说，Swift 的运算符优先级和结合性规则更加简洁和可预测。但是，这也意味着它们相较于 C 语言及其衍生语言并不是完全一致。在对现有的代码进行移植的时候，要注意确保运算符的行为仍然符合你的预期。
//:
//: ## 运算符函数
//:
//: 类和结构体可以为现有的运算符提供自定义的实现。这通常被称为运算符*重载*。
//:
//: 下面的例子展示了如何让自定义的结构体支持加法运算符（`+`）。算术加法运算符是一个*二元运算符*，因为它是对两个值进行运算，同时它还可以称为*中缀*运算符，因为它出现在两个值中间。
//:
struct Vector2D {
	var x = 0.0, y = 0.0
}

extension Vector2D {
	static func + (left: Vector2D, right: Vector2D) -> Vector2D {
		return Vector2D(x: left.x + right.x, y: left.y + right.y)
	}
}

let vector = Vector2D(x: 3.0, y: 1.0)
let anotherVector = Vector2D(x: 2.0, y: 4.0)
let combinedVector = vector + anotherVector
// combinedVector 是一个新的 Vector2D 实例，值为 (5.0, 5.0)

//: ### 前缀和后缀运算符
//:
//: 上个例子演示了一个二元中缀运算符的自定义实现。类与结构体也能提供标准*一元运算符*的实现。一元运算符只运算一个值。当运算符出现在值之前时，它就是*前缀*的（例如 `-a`），而当它出现在值之后时，它就是*后缀*的（例如 `b!`）。
//:
//: 要实现前缀或者后缀运算符，需要在声明运算符函数的时候在 `func` 关键字之前指定 `prefix` 或者 `postfix` 修饰符：
//:
extension Vector2D {
	static prefix func - (vector: Vector2D) -> Vector2D {
		return Vector2D(x: -vector.x, y: -vector.y)
	}
}

let positive = Vector2D(x: 3.0, y: 4.0)
let negative = -positive
// negative 是一个值为 (-3.0, -4.0) 的 Vector2D 实例
let alsoPositive = -negative
// alsoPositive 是一个值为 (3.0, 4.0) 的 Vector2D 实例

//: ### 复合赋值运算符
//:
//: *复合赋值运算符*将赋值运算符（`=`）与其它运算符进行结合。例如，将加法与赋值结合成加法赋值运算符（`+=`）。在实现的时候，需要把运算符的左参数设置成 `inout` 类型，因为这个参数的值会在运算符函数内直接被修改。
//:
extension Vector2D {
	static func += (left: inout Vector2D, right: Vector2D) {
		left = left + right
	}
}

//: 因为加法运算在之前已经定义过了，所以在这里无需重新定义。在这里可以直接利用现有的加法运算符函数，用它来对左值和右值进行相加，并再次赋值给左值：
//:
var original = Vector2D(x: 1.0, y: 2.0)
let vectorToAdd = Vector2D(x: 3.0, y: 4.0)
original += vectorToAdd
// original 的值现在为 (4.0, 6.0)

//: > 不能对默认的赋值运算符（`=`）进行重载。只有复合赋值运算符可以被重载。同样地，也无法对三元条件运算符 （`a ? b : c`） 进行重载。
//:
//: ### 等价运算符
//:
//: 通常情况下，自定义的类和结构体没有对*等价运算符*进行默认实现，等价运算符通常被称为*相等*运算符（`==`）与*不等*运算符（`!=`）。
//:
//: 为了使用等价运算符对自定义的类型进行判等运算，需要为“相等”运算符提供自定义实现，实现的方法与其它中缀运算符一样, 并且增加对标准库 `Equatable` 协议的遵循：
//:
extension Vector2D: Equatable {
	static func == (left: Vector2D, right: Vector2D) -> Bool {
		return (left.x == right.x) && (left.y == right.y)
	}
}

//: 上述代码实现了“相等”运算符（`==`）来判断两个 `Vector2D` 实例是否相等。对于 `Vector2D` 来说，“相等”意味着“两个实例的 `x` 和 `y` 都相等”，这也是代码中用来进行判等的逻辑。如果你已经实现了“相等”运算符，通常情况下你并不需要自己再去实现“不等”运算符（`!=`）。标准库对于“不等”运算符提供了默认的实现，它简单地将“相等”运算符的结果进行取反后返回。
//:
let twoThree = Vector2D(x: 2.0, y: 3.0)
let anotherTwoThree = Vector2D(x: 2.0, y: 3.0)
if twoThree == anotherTwoThree {
	print("These two vectors are equivalent.")
}
// 打印“These two vectors are equivalent.”

//: Swift 为以下数种自定义类型提供等价运算符的默认实现：
//:
//: - 只拥有存储属性，并且它们全都遵循 `Equatable` 协议的结构体
//: - 只拥有关联类型，并且它们全都遵循 `Equatable` 协议的枚举
//: - 没有关联类型的枚举
//:
//: 在类型原始的声明中声明遵循 `Equatable` 来接收这些默认实现。
//:
struct Vector3D: Equatable {
	var x = 0.0, y = 0.0, z = 0.0
}

let twoThreeFour = Vector3D(x: 2.0, y: 3.0, z: 4.0)
let anotherTwoThreeFour = Vector3D(x: 2.0, y: 3.0, z: 4.0)
if twoThreeFour == anotherTwoThreeFour {
	print("These two vectors are also equivalent.")
}
// 打印“These two vectors are also equivalent.”

//: ## 自定义运算符
//:
//: 除了实现标准运算符，在 Swift 中还可以声明和实现*自定义运算符*。可以用来自定义运算符的字符列表请参考[运算符](Lexical_Structure)。
//:
//: 新的运算符要使用 `operator` 关键字在全局作用域内进行定义，同时还要指定 `prefix`、`infix` 或者 `postfix` 修饰符：
//:
prefix operator +++

//: 上面的代码定义了一个新的名为 `+++` 的前缀运算符。对于这个运算符，在 Swift 中并没有已知的意义，因此在针对 `Vector2D` 实例的特定上下文中，给予了它自定义的意义。对这个示例来讲，`+++` 被实现为“前缀双自增”运算符。它使用了前面定义的复合加法运算符来让矩阵与自身进行相加，从而让 `Vector2D` 实例的 `x` 属性和 `y` 属性值翻倍。你可以像下面这样通过对 `Vector2D` 添加一个 `+++` 类方法，来实现 `+++` 运算符：
//:
extension Vector2D {
	static prefix func +++ (vector: inout Vector2D) -> Vector2D {
		vector += vector
		return vector
	}
}

var toBeDoubled = Vector2D(x: 1.0, y: 4.0)
let afterDoubling = +++toBeDoubled
// toBeDoubled 现在的值为 (2.0, 8.0)
// afterDoubling 现在的值也为 (2.0, 8.0)

//: ### 自定义中缀运算符的优先级
//:
//: 每个自定义中缀运算符都属于某个优先级组。优先级组指定了这个运算符相对于其他中缀运算符的优先级和结合性。[优先级和结合性](#precedence_and_associativity)中详细阐述了这两个特性是如何对中缀运算符的运算产生影响的。
//:
//: 而没有明确放入某个优先级组的自定义中缀运算符将会被放到一个默认的优先级组内，其优先级高于三元运算符。
//:
//: 以下例子定义了一个新的自定义中缀运算符 `+-`，此运算符属于 `AdditionPrecedence` 优先组：
//:
infix operator +-: AdditionPrecedence
extension Vector2D {
	static func +- (left: Vector2D, right: Vector2D) -> Vector2D {
		return Vector2D(x: left.x + right.x, y: left.y - right.y)
	}
}
let firstVector = Vector2D(x: 1.0, y: 2.0)
let secondVector = Vector2D(x: 3.0, y: 4.0)
let plusMinusVector = firstVector +- secondVector
// plusMinusVector 是一个 Vector2D 实例，并且它的值为 (4.0, -2.0)

//: 这个运算符把两个向量的 `x` 值相加，同时从第一个向量的 `y` 中减去第二个向量的 `y` 。因为它本质上是属于“相加型”运算符，所以将它放置在 `+` 和 `-` 等默认中缀“相加型”运算符相同的优先级组中。关于 Swift 标准库提供的运算符，以及完整的运算符优先级组和结合性设置，请参考 [运算符声明](https://developer.apple.com/documentation/swift/swift_standard_library/operator_declarations)。而更多关于优先级组以及自定义操作符和优先级组的语法，请参考[运算符声明](https://docs.swift.org/swift-book/ReferenceManual/Declarations.html#ID380)。
//:
//: > 当定义前缀与后缀运算符的时候，我们并没有指定优先级。然而，如果对同一个值同时使用前缀与后缀运算符，则后缀运算符会先参与运算。
//:



//: [上一页](@previous) | [下一页](@next)
