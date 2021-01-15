import Foundation

//: # Swift函数
/*：
 Swift函数特性：
 
 - 如JavaScript的风格，函数需要使用func标识符表示。
 - 返回值使用->在函数体前声明。
 - 如C/C++的风格，函数参数列表在函数名称后面的小括号中声明。
 - 如Objective-C，函数名称除了定义的名称外，还可以配置标签，如果标签是_，调用函数是还可以忽略该标签名称的书写。
 - 让其可读性更好，也为了让函数声明的表达与参数变量的命名区分开来。
 - 如C++，参数声明时可以直接使用=，赋值参数默认值，有默认值的参数可以在调用的时候不书写。
 - 如C++，参数还支持可变长参数，同样使用...表示，在函数内接收到的是一个该类型的数组。
 - Swift让可变长参数都接收到一个数组中，更容易操作。
 - 取代C/C++的引用/指针类型，Swift有inout标识符来声明可读写的入参。
 - 与C++一样，其支持函数重载。
 - Swift的函数签名组成：函数名+参数类型列表+返回值类型。
 
 函数在Swift中是一等公民，意味着其和Swift其它类型有着完全相同的语法功能。主要包括：
 - 可以用来定义变量；
 - 可以当成函数参数；
 - 可以被函数返回；
 */

//: ## 可变长参数
func mul(_ numbers: Int ...) {
    print("参数：\(numbers)")
    let arrayMul = numbers.reduce(1, *)
    print("mul: \(arrayMul)")
}
mul(2, 3, 4, 5, 6, 7)



//: ## inout 参数
// 函数参数默认情况下是只读的，不能修改，更不能通过此对外返回修改的结果了
func mul(result: Int, _ numbers: Int ...) {
    //result = numbers.reduce(1, *) // 直接编译错误
    print("mul: \(result)")
}

// 使用 inout
func mul(result: inout Int, _ numbers: Int ...) {
    result = numbers.reduce(1, *)
    print("mul: \(result)")
}

var result = 0
mul(result: &result, 2, 3, 4, 5, 6, 7)



//: ## 函数签名

// 参数名不同不能代表参数列表不同，需要参数类型不一样才行
//func mul(resultt: inout Int, _ numbers: Int ...) {}

func multiply(m: Int, n: Int) -> Int {
    return m * n
}
func divide(a: Int, b: Int) -> Int {
    return a / b
}

let fnMul: (inout Int, Int ...) -> Void = mul
fnMul(&result, 2, 3)



//: ## 函数返回值

// 使用函数作为返回值
func calc<T>(_ first: T, _ second: T, _ fn: (T, T) -> T) -> T {
    return fn(first, second);
}
calc(2, 3, multiply)
calc(2, 4, divide)

func mul(_ a: Int) -> (Int) -> Int {
    func innerMul(_ b: Int) -> Int {
        return a * b
    }
    return innerMul
}
let mul2By = mul(2)
mul2By(3)

//: [上一页](@previous) | [下一页](@next)
