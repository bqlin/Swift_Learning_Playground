//: ## 控制流（Control Flow）
//:
//: 使用`if`和`switch`来进行条件操作，使用`for-in`、`for`、`while`和`repeat-while`来进行循环。包裹条件和循环变量括号可以省略，但是语句体的大括号是必须的。
//:
let individualScores = [75, 43, 103, 87, 12]
var teamScore = 0
for score in individualScores {
    if score > 50 {
        teamScore += 3
    } else {
        teamScore += 1
    }
}
//print(teamScore)

//: 在`if`语句中，条件必须是一个布尔表达式——这意味着像`if score { ... }`这样的代码将报错，而不会隐形地与 0 做对比。
//:
//: 你可以一起使用`if`和`let`来处理值缺失的情况。这些值可由可选值来代表。一个可选的值是一个具体的值或者是`nil`以表示值缺失。在类型后面加一个问号来标记这个变量的值是可选的。
//:
var optionalString: String? = "Hello"
//print(optionalString == nil)

var optionalName: String? = "John Appleseed"
var greeting = "Hello!"
//optionalName = nil
if let name = optionalName {
	// 使用 if let 这种方式赋值，在当值为空时不会进入函数体中
    greeting = "Hello, \(name)"
}

//: - Experiment:
//: 把`optionalName`改成`nil`，greeting会是什么？添加一个`else`语句，当`optionalName`是`nil`时给greeting赋一个不同的值。
//:
//: 如果变量的可选值是`nil`，条件会判断为`false`，大括号中的代码会被跳过。如果不是`nil`，会将值赋给`let`后面的常量，这样代码块中就可以使用这个值了。
//:
//: 另外一个处理可选类型的方法是使用运算符`??`提供一个默认值。如果可选类型的值发生缺失，就会使用默认值来代替。
//:
var nickName: String? = nil
nickName = "Bq"
let fullName: String = "John Appleseed"
let informalGreeting = "Hi \(nickName ?? fullName)"

//: `switch`支持任意类型的数据以及各种比较操作——不仅仅是整数以及测试相等。
//:
let vegetable = "red pepper"
switch vegetable {
    case "celery":
        print("Add some raisins and make ants on a log.")
    case "cucumber", "watercress":
        print("That would make a good tea sandwich.")
    case let x where x.hasSuffix("pepper"):
        print("Is it a spicy \(x)?")
    default:
        print("Everything tastes good in soup.")
}

//: - Experiment:
//: 删除`default`语句，看看会有什么错误？（error: switch must be exhaustive）
//:
//: 注意`let`在上述例子的等式中是如何使用的，它将匹配等式的值赋给常量`x`。
//:
//: 运行`switch`中匹配到的子句之后，程序会退出`switch`语句，并不会继续向下运行，所以不需要在每个子句结尾写`break`。
//:
//: 你可以使用`for-in`来遍历字典，需要两个变量来表示每个键值对。字典是一个无序的集合，所以他们的键和值以任意顺序迭代结束。
//:
let interestingNumbers = [
    "Prime": [2, 3, 5, 7, 11, 13],
    "Fibonacci": [1, 1, 2, 3, 5, 8],
    "Square": [1, 4, 9, 16, 25],
]
var largest = Int()
var kingOfLargest = String()
// 使用元组遍历字典的每一个元素
for (kind, numbers) in interestingNumbers {
    for number in numbers {
        if number > largest {
            largest = number
			kingOfLargest = kind
        }
    }
}
print("larget is \(largest), kind of \(kingOfLargest)")

//: - Experiment:
//: 添加另一个变量来记录现在和之前最大数字的类型。
//:
//: 使用`while`来重复运行一段代码直到不满足条件。循环条件也可以在结尾，保证能至少循环一次。
//:
// 当型循环
var n = 2
while n < 100 {
    n *= 2
}
//print(n)

// 直到型循环
var m = 2
repeat {
    m *= 2
} while m < 100
//print(m)

//: 您可以使用`..<`来生成一系列索引，从而在循环中保留索引。
//:
var total = 0
for i in 0..<4 {
    total += i
}
//print(total)

//: 使用`..<`创建的范围不包含上界，如果想包含的话需要使用`...`。
//:



//: [Previous](@previous) | [Next](@next)
