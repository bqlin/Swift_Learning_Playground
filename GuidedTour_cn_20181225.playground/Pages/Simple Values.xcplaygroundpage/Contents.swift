//: # A Swift Tour
//:
//: 通常来说，编程语言教程中的第一个程序应该在屏幕上打印“Hello, world”。在 Swift 中，可以用一行代码实现：
//:
print("Hello, world!")

//: 如果您写过 C 或者 Objective-C 代码，那您应该很熟悉这种形式——在 Swift 中，这行代码就是一个完整的程序。您不需要为了输入输出或者字符串处理导入一个单独的库。全局作用域中的代码会被自动当做程序的入口点，所以您也不需要`main()`函数。您同样不需要在每个语句结尾写上分号。
//:
//: 这个教程会通过一系列编程例子来让您对 Swift 有初步了解，如果您有什么不理解的地方也不用担心——任何本章介绍的内容都会在后面的章节中详细讲解。
//:
//: ## 简单值
//:
//: 使用`let`来声明常量，使用`var`来声明变量。一个常量的值，在编译的时候，并不需要有明确的值，但是您只能为它赋值一次。也就是说您可以用常量来表示这样一个值：您只需要设置一次，但是需要使用很多次。
//:
var myVariable = 42
myVariable = 50
let myConstant = 42

//: 常量或者变量的类型必须和您赋给它们的值一样。然而，您不用明确地声明类型，声明的同时赋值的话，编译器会自动推断类型。在上面的例子中，编译器推断出`myVariable`是一个整数（integer）因为它的初始值是整数。
//:
//: 如果初始值没有提供足够的信息（或者没有初始值），那您需要在变量后面声明类型，用冒号分割。
//:
let implicitInteger = 70
let implicitDouble = 70.0
let explicitDouble: Double = 70

//: > **练习**:
//: > 创建一个常量，声明它的类型为`Float`并且值为`4`。
//:
let testConst: Float = 4
//print(testConst)

//: 值永远不会隐式的转换为另一种类型。如果需要转换为其他类型的一个值， 请创建一个所需类型的实例。
//:
let label = "The width is "
let width = 94
let widthLabel = label + String(width)

//: > **练习**:
//: > 删除最后一行中的`String`，错误提示是什么？
//:
//: 有一种更简单的把值转换成字符串的方法：把值写到括号中，并且在括号之前写一个反斜杠。例如：
//:
let apples = 3
let oranges = 5
let appleSummary = "I have \(apples) apples."
let fruitSummary = "I have \(apples + oranges) pieces of fruit."

//: > **练习**:
//: > 使用`\()`来把一个浮点计算转换成字符串，并加上某人的名字，和他打个招呼。
//:
//print("你 \(testConst) 不 \(testConst) 傻")

//: 对于多行字符串，使用三对双引号（`"""`）。只要每一行的行首缩进与右引号的缩进相同，其缩进都会被移除。例如：
//:
let quotation = """
    Even though there's whitespace to the left,
    the actual lines aren't indented.
        Except for this line.
    Double quotes (") can appear without being escaped.

    I still have \(apples + oranges) pieces of fruit.
    """
//print(quotation)

//: 使用方括号`[]`来创建数组和字典，并使用下标或者键（key）来访问元素。最后一个元素后面允许有个逗号。
//:
var shoppingList = ["catfish", "water", "tulips"]
shoppingList[1] = "bottle of water"

var occupations = [
    "Malcolm": "Captain",
    "Kaylee": "Mechanic",
 ]
occupations["Jayne"] = "Public Relations"
//print(occupations)

//: 当你添加元素，数组会自动增长
//:
shoppingList.append("blue paint")
print(shoppingList)

//: 要创建一个空数组或者字典，使用初始化语法。
//:
let emptyArray = [String]()
let emptyDictionary = [String: Float]()

//: 如果类型信息可以被推断出来，您可以用`[]`和`[:]`来创建空数组和空字典——就像您声明变量或者给函数传参数的时候一样。
//:
shoppingList = []
occupations = [:]



//: 查看 [许可证](License) 信息。
//: 
//: [Next](@next)
