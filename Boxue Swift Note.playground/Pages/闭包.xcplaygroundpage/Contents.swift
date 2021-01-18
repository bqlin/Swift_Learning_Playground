import Foundation

//: # 闭包

//: ## 闭包表达式
/*:
 闭包表达式就是函数的一种简写形式，同等于函数。
 其完整形式为：

 ```
 { (参数列表) -> 返回类型 in
    函数体
 }
 ```
 */

// 函数：
func square(_ n: Int) -> Int {
    return n * n
}

// 闭包表达式：
let squareExpression = { (n: Int) -> Int in
    n * n
}

square(2)
squareExpression(2)

//: 由于类型推断与参数匹配，闭包表达式可以不断简化。

func closureExpressions() {
    let numbers = [1, 2, 3, 4, 5]
    
    // 完整形式
    numbers.map({ (n: Int) -> Int in
        return n * n
    })
    // 返回值可推断且与闭包表达式要求的一致，省略参数和返回类型声明
    numbers.map({ n in
        return n * n
    })
    // 单行表达式，省略return
    numbers.map({ n in
        n * n
    })
    // 不需要形参名称，省略参数声明和in
    numbers.map({
        $0 * $0
    })
    
    // 闭包表达式是参数列表最后一项，省略括号
    numbers.map {
        $0 * $0
    }
    
    // 操作符方法签名与参数签名一致，直接用操作符表示
    numbers.sorted(by: >)
}
closureExpressions()

//: ## 闭包
//: a closure is a record storing a function together with an environment
//: 一个函数加上它捕获的变量一起，才算一个closure。

func closureExp() {
    func makeCounter() -> () -> Int {
        var value = 0
        return {
            value += 1
            return value
        }
    }
    
    let counter1 = makeCounter()
    let counter2 = makeCounter()
    
    print(counter1())
    print(counter1())
    let range = (0...2)
    print("开始执行 \(range)：")
    range.forEach { (_) in
        print(counter1())
    }
    
    let range2 = (0...5)
    print("counter2 开始执行 \(range2)：")
    range2.forEach { (_) in
        print(counter2())
    }
    
    //: counter1、counter2 叫做闭包，他们既有要执行的逻辑，还带上其执行的上下文
    //: 其次，counter1、counter2 拥有各自独立的上下文环境，它们并不共享任何内容
    //: 另外，函数也可以用作变量捕获，成为一个闭包：
    
    func makeCounter2() -> () -> Int {
        var value = 0
        func increment() -> Int {
            value += 1
            return value
        }
        return increment
    }
    let counter3 = makeCounter2()
    let counter4 = makeCounter2()
    print("使用函数捕获变量：")
    (0...2).forEach { (_) in
        print(counter3())
    }
    (0...3).forEach { (_) in
        print(counter4())
    }
}
closureExp()

//: 使用归并排序作为例子展示 local function 捕获变量共享资源的魅力

// 先拆分，再归并的整体过程
extension Array where Element: Comparable {
    mutating func mergeSort(_ begin: Index, _ end: Index) {
        if (end - begin) > 1 {
            let mid = (begin + end) / 2
            
            mergeSort(begin, mid)
            mergeSort(mid, end)
            
            merge(begin, mid, end)
        }
    }
    
    private mutating func merge(_ begin: Index, _ mid: Index, _ end: Index) {
        var result: [Element] = []
        
        // 从两叠数中找到更小的一个
        var i = begin
        var j = mid
        while i != mid && j != end {
            if self[i] < self[j] {
                result.append(self[i])
                i += 1
            } else {
                result.append(self[j])
                j += 1
            }
        }
        
        // 拼接剩余的
        result.append(contentsOf: self[i ..< mid])
        result.append(contentsOf: self[j ..< end])
        
        // 更新自身
        replaceSubrange(begin ..< end, with: result)
    }
    
    //: 优化：使用局部变量共享资源
    mutating func mergeSort2(_ begin: Index, _ end: Index) {
        // 这里把merge方法用到的result数组作为局部变量，每次merge的时候进行清空。省去了每次创建和销毁一个数组的消耗。
        var result: [Element] = []
        result.reserveCapacity(count)
        
        // 把函数作为local function在函数内定义，这样可以隐藏实现细节，也可以方便访问mergeSort2定义的局部变量。
        func merge(_ begin: Int, _ mid: Int, _ end:Int) {
            // 使用局部变量共享存储空间
            result.removeAll(keepingCapacity: true)
            
            var i = begin
            var j = mid
            while i != mid && j != end {
                if self[i] < self[j] {
                    result.append(self[i])
                    i += 1
                } else {
                    result.append(self[j])
                    j += 1
                }
            }
            result.append(contentsOf: self[i ..< mid])
            result.append(contentsOf: self[j ..< end])
            replaceSubrange(begin ..< end, with: result)
        }
        
        if ((end - begin) > 1) {
            let mid = (begin + end) / 2;
            
            mergeSort2(begin, mid)
            mergeSort2(mid, end)
            merge(begin, mid, end)
        }
    }
}

func mergeSortExp() {
    var numbers = [1, 2, 6, 9, 12, 3, 11]
    numbers.mergeSort(numbers.startIndex, numbers.endIndex)
    numbers.mergeSort2(numbers.startIndex, numbers.endIndex)
}
mergeSortExp()

//: [上一页](@previous) | [下一页](@next)
