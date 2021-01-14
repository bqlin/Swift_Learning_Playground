import Foundation

//: ## 数组的用法

//: ### 定义数组的3种方式
var array1: [Int] = [Int]()
var array2: [Int] = []
var array3 = array2

//: ### 定义数组同时指定初始化值
// [3, 3, 3]
var threeInts = [Int](repeating: 3, count: 3)
// [3, 3, 3, 3, 3, 3]
var sixInts = threeInts + threeInts
// [1, 2, 3, 4, 5]
var fiveInts = [1, 2, 3, 4, 5]

//: ### 访问数组元素，索引在 Swift 是最不被推荐的用法。
fiveInts[0...2] // 这里获得的不是一个数组，而是一个 ArraySlice，类似于 String 的某一段内容的 view
type(of: fiveInts[0...2])

// Array 使用下标访问时需要自己确保不越界
type(of: fiveInts[1]) // 没有用可选类型保护越界

//: ### Swift 方式的数组遍历

// 访问每一个元素，Swift 建议这样使用
print("使用 forEach 方法遍历：")
fiveInts.forEach { value in
    print(value)
}

print("使用 forin 方式遍历：")
for value in fiveInts {
    print(value)
}

// 当访问元素时需要使用元素索引
print("访问元素的同时获取索引：")
for (index, value) in fiveInts.enumerated() {
    print("fiveInts[\(index)]: \(value)")
}

// 当需要通过值查找元素索引时
fiveInts.firstIndex {
    $0 == 3
}

// 筛选
fiveInts.filter { value in
    value % 2 == 0
}

//: ### 添加和删除元素
array1.append(1)
array1 += [2, 3, 4]
array1.insert(5, at: array1.startIndex)
array1.remove(at: 4)

/*:
 ### 安全地使用数组

 如何定义为安全，这里指的是即使使用越界的索引或访问了空的数组，其不会产生运行时错误而崩溃，而是返回nil或边界值。

 - 避免使用[]访问数组元素的方式，而使用Swift数组提供的方法，如`first`、`last`、`firstIndex`、`lastIndex`之类的返回可选类型的方法；
 - 如要安全删除最后一个元素，使用`popLast`而不是使用`removeLast`。

 总的来说，当你要完成特定的操作时，Swift一定有比直接使用下标更具表现力和安全的写法。
 */
// 安全周到的方式
var emptys: [Int] = []
emptys.first
emptys.last
type(of: emptys.first)
// emptys.removeLast() // 引发错误
emptys.popLast()

//: ## Array 与 NSArray 的差异

// 把 Array 内容的地址变成一个字符串
func getBufferAddress<T>(of array: [T]) -> String {
    return array.withUnsafeBufferPointer { buffer in
        String(describing: buffer.baseAddress)
    }
}

// 按值语义实现的 Array，区别于 NSArray
var a = [1, 2, 3]
print("初始 a 数组地址：\(getBufferAddress(of: a))")
var copyA = a
print("拷贝后的 a 数组地址：\(getBufferAddress(of: copyA))")
// 仅当修改了值时才发生复制
copyA.append(4)
print("修改后的 a 数组地址： \(getBufferAddress(of: copyA))")
getBufferAddress(of: a)

// 区别于 NSArray
let b = NSMutableArray(array: [1, 2, 3])
let copyB: NSArray = b
let deepCopyB = b.copy() as! NSArray

b.insert(0, at: 0)
copyB

//: ## 通过闭包参数化对数组元素的变形操作
//: 其目的是让我们的代码从面向机器的，转变为面向业务需求的。
var fibonacci = [0, 1, 1, 2, 3, 5]
var squares = [Int]()
// 朴素的 for 循环
for value in fibonacci {
    squares.append(value * value)
}

// 使用 map 闭包
let constSquares = fibonacci.map { $0 * $0 }

// 简单实现 map
extension Array {
    func myMap<T>(_ transform: (Element) -> T) -> [T] {
        var tmp: [T] = []
        tmp.reserveCapacity(count) // 给新数组预留空间

        for value in self {
            tmp.append(transform(value))
        }

        return tmp
    }
}

let constSequence1 = fibonacci.myMap { $0 * $0 }

// 类似的，使用闭包做的一些数组遍历
fibonacci.forEach { print($0) } // 与 map 最大的不同在于其是没有返回值

fibonacci.min()
fibonacci.max()

fibonacci.filter { $0 % 2 == 0 }

fibonacci.elementsEqual([0, 1, 1], by: { $0 == $1 })
fibonacci.starts(with: [0, 1, 1], by: { $0 == $1 })

fibonacci.sort(by: >)

// 计算一个分界点
let pivot = fibonacci.partition(by: { $0 < 1 })
print("pivot: \(pivot)")
fibonacci[0 ..< pivot]

// 合并值，第一个参数时初始值，第二个参数则是合法算法
fibonacci.reduce(0, +)

// 不建议在闭包中修改外部变量，如：
var sum = 0
let constSquares2 = fibonacci.map { (fib: Int) -> Int in
    sum += fib
    return fib * fib
}

// 可以换成类似 reduce 这样实现
extension Array {
    func accumulate<T>(_ initial: T, _ nextSum: (T, Element) -> T) -> [T] {
        var sum = initial
        return map { next in
            sum = nextSum(sum, next)
            return sum
        }
    }
}

fibonacci.accumulate(0, +)

//: ## reduce
/*:
 个人觉得reduce的用法挺耐人寻味的，泊学中，是这么描述它的功能的：把一个数组变成某种形式的值。感觉不太明确，官方的描述是：Returns the result of combining the elements of the sequence using the given closure.

 翻译过来就是通过给定的闭包，把元素结合起来。这里存在两个变量：

 - 闭包。这里有两个参数：
    - 上次计算的结果；
    - 本次遍历到的元素；
 - 结合的方式。这其实也是闭包中定义的内容，或者说算法。如何结合是闭包定义的。
 */

// 自己实现一个reduce
extension Array {
    func myReduce<T>(_ initial: T, _ next: (T, Element) -> T) -> T {
        var result = initial

        for e in self {
            result = next(result, e)
        }

        return result
    }
}

// 测试
fibonacci.reduce(0, +)
fibonacci.myReduce(0, +)

//: 通过初始参数和结合方式的不同，reduce可以实现很多事情

// 数组转字符串
fibonacci.reduce("") { result, e in
    result + "\(e)"
}

extension Array {
    // 实现map
    func myMapByReduce<T>(_ transform: (Element) -> T) -> [T] {
        return reduce([]) { $0 + [transform($1)] }
    }

    // 实现filter
    func myFilterByReduce(_ predicate: (Element) -> Bool) -> [Element] {
        return reduce([]) { predicate($1) ? $0 + [$1] : $0 }
    }
}

//: ## flatMap

let animals = ["🐶", "🐱", "🐹", "🐰", "🐻"]
let ids = [1, 2, 3, 4, 5]

// 使用 map 只会得到一个数组的数组，即二维数组
let animalsMap = animals.map { animal in
    ids.map { id in (animal, id) }
}

print("animalsMap: \(animalsMap)")

// 若想得到一个一维的数组，则需要使用 flatMap：
let animalsFlatMap = animals.flatMap { animal in
    ids.map { id in (animal, id) }
}

print("animalsFlatMap: \(animalsFlatMap)")

// 实现 flatMap

extension Array {
    func myFlatMap<T>(_ transform: (Element) -> [T]) -> [T] {
        var tmp: [T] = []
        for value in self {
            tmp.append(contentsOf: transform(value))
        }
        return tmp
    }
}

//: 即flatMap是把transform中生成的数组取出元素进行拼接，进而去除了transform产生的数组

//: [上一页](@previous) | [下一页](@next)
