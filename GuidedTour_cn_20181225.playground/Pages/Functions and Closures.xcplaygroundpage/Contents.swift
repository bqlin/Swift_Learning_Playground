//: ## 函数和闭包（Functions and Closures）
//:
//: 使用`func`来声明一个函数，使用名字和参数来调用函数。使用`->`来指定函数返回值的类型。
//:
func greet(person: String, day: String) -> String {
    return "Hello \(person), today is \(day)."
}
greet(person: "Bob", day: "Tuesday")

//: - Experiment:
//: 删除`day`参数，添加一个参数来表示今天吃了什么午饭。
//:
func greet2(person: String, food: String) -> String {
	return "\(person)食左\(food)。"
}
greet2(person: "Bq", food: "柠檬")

//: 默认情况下，函数使用其参数名称作为其参数的标签。你还可以在参数名称前添加一个自定义参数标签，或者`_`以不使用参数标签。
//:
func greet(_ person: String, on day: String) -> String {
    return "Hello \(person), today is \(day)."
}
greet("John", on: "Wednesday")

//: 使用元组来让一个函数返回多个值。该元组的元素可以用名称或数字来表示。
//:
func calculateStatistics(scores: [Int]) -> (min: Int, max: Int, sum: Int) {
    var min = scores[0]
    var max = scores[0]
    var sum = 0

    for score in scores {
        if score > max {
            max = score
        } else if score < min {
            min = score
        }
        sum += score
    }

    return (min, max, sum)
}
let statistics = calculateStatistics(scores: [5, 3, 100, 3, 9])
//print(statistics.sum)
//print(statistics.2)

//: 函数可以嵌套。嵌套函数可以访问外部函数中声明的变量。你可以使用嵌套函数的形式组织冗长或复杂的代码。
//:
func returnFifteen() -> Int {
    var y = 10
    func add() {
        y += 5
    }
    add()
    return y
}
returnFifteen()

//: 函数是一等的类型。这意味着函数可以作为返回值使用。
//:
func makeIncrementer() -> ((Int) -> Int) {
    func addOne(number: Int) -> Int {
        return 1 + number
    }
    return addOne
}
var increment = makeIncrementer()
increment(7)

//: 函数也可以作为另一个函数的参数值使用。
//:
func hasAnyMatches(list: [Int], condition: (Int) -> Bool) -> Bool {
    for item in list {
        if condition(item) {
            return true
        }
    }
    return false
}
func lessThanTen(number: Int) -> Bool {
    return number < 10
}
var numbers = [20, 19, 7, 12]
hasAnyMatches(list: numbers, condition: lessThanTen)

//: 函数实际上是闭包的一种特殊形式：可以在以后调用的代码块。闭包中的代码可以访问创建闭包时作用域中可用的变量和函数，即使闭包在执行时的作用域不同——你已经看到了嵌套函数的示例。您可以使用大括号（`{}`）来编写没有名称的闭包。使用`in`将参数和返回类型与函数体分开。
//:
numbers.map({ (number: Int) -> Int in
    let result = 3 * number
    return result
})

//: - Experiment:
//: 重写闭包，对所有奇数返回零。
//:
numbers.map { (number: Int) -> Int in
	if number % 2 == 1 {
		return 0
	}
	return number
}

//: 你可以通过几种方式更简洁地编写闭包。当已知闭包的类型（例如委托的回调）时，可以省略其参数的类型，返回类型或两者。在单个闭包语句中还可以直接隐式返回其值。
//:
let mappedNumbers = numbers.map({ number in 3 * number })
//print(mappedNumbers)

//: 你可以使用参数编号取代参数名称来引用参数——这种方法在非常短的闭包中特别有用。当闭包作为函数的最后一个参数传递时，可以在括号后面立即出现。当闭包是函数的唯一参数时，可以完全省略括号。
//:
let sortedNumbers = numbers.sorted { $0 > $1 }
//print(sortedNumbers)



//: [Previous](@previous) | [Next](@next)
