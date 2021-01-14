import Foundation

//: ## 变量和常量

func varExp() {
    print(#function)
    // 变量，使用关键字 var 修饰
    var swiftString = "Swift is fun"
    var hours = 24
    var PI = 3.14
    var siwftIsFun = true
    
    hours = 12
    PI = 3.14159
    
    // tuple 包含多值、多类型的元组，使用小括号包围
    var me = ("Mars", 11, "11@boxue.io")
    me.0
    me.1
    
    // 常量，使用关键词 let 修饰
    
    let minutes = 30
    let fireIsHot = true
    // 不允许修改
    //fireIsHot = false
    
    // 在有值的常量、变量，Swift 会进行类型推断（Type Inference）
    // 但在只定义变量时，就不能推断其类型，就需要类型声明：
    var x: Int
    var s: String
}
//varExp()

//: ## 整数和浮点数

func numberExp() {
    print(#function)
    // 整型 Int 和 UInt 根据所占空间，分别定义了4种类型，但使用 Int 和 UInt 时，Swift 就会自动转换为合适的类型
    print("Int: \(Int.min) ~ \(Int.max)")
    print("Int8: \(Int8.min) ~ \(Int8.max)")
    print("Int16: \(Int16.min) ~ \(Int16.max)")
    print("Int32: \(Int32.min) ~ \(Int32.max)")
    print("Int64: \(Int64.min) ~ \(Int64.max)")
    
    print("UInt: \(UInt.min) ~ \(UInt.max)")
    print("UInt8: \(UInt8.min) ~ \(UInt8.max)")
    print("UInt16: \(UInt16.min) ~ \(UInt16.max)")
    print("UInt32: \(UInt32.min) ~ \(UInt32.max)")
    print("UInt64: \(UInt64.min) ~ \(UInt64.max)")
    
    // 使用各种进制表达整数（字面量）
    let fifteenInDecimal = 15
    let fifteenInHex = 0xf
    let fifteenInOctal = 0o17
    let fifteenInBinary = 0b1111
    
    // 使用分隔符
    let million = 1_000_000
    
    // 浮点数
    //  最多6位的 Float
    var oneThirdInFloat: Float = 1/3
    // 至少15位精度的 Double
    var oneThirdInDouble: Double = 1/3
    
    // 使用科学计数法
    var PI = 0.314e1
    PI = 314159e-5
    
    // 在进行算术运算时不同类型的字面量可以计算，但类型不同的变量则不可进行运算
    //PI = fifteenInHex + oneThirdInDouble
    //PI = Float(fifteenInHex) + oneThirdInFloat
    PI = Double(fifteenInHex) + oneThirdInDouble
    
    // 使用 typeof 函数查看变量类型
    type(of: PI)
}
//numberExp()

//: ## 字符串
/*:
 字符的几个概念：
 
 ### C语言的字符串
 
 C语言的字符串是由若干个字符组成的字符数组，而每个字符则对应着一个8位的ASCII数值。
 
 注意这里的8位整数是定长地表示一个字符，即ASCII字符集只能表达128个字符。
 
 ### Unicode
 
 现如今的unicode采用的是可变长度编码方案。而所谓的“可变长度”包含了两个意思：
 
 - “编码单位（code unit）”的长度是可变的；
 - 构成同一个字符的“编码单位”组合也是可变的；
 
 unicode也是由不同数字构成的字符。其中表示一个unicode的数字长度则区分了几种编码类型：
 
 - UTF-8，是由多个连续的8位数字表示一个unicode，因为都是8位数字，所以与ASCII编码兼容。
 - UTF-16，是用一个16位数字表示一个unicode。
 - UTF-32，用一个32位数字表示一个unicode。

 Swift里，我们可以使用\u{}这样的方式使用unicode scalar定义unicode字符。
 
 Swift用view的概念表达String字符串中的内容：
 - unicodeScalar：按照字符串中每一个字符的unicode scalar来形成集合；
 - utf8：按照字符串中每一个字符的UTF-8编码来形成集合；
 - utf16：按照字符串中每一个字符的UTF-16编码来形成集合；
 */

func stringExp() {
    print(#function)
    /// Swift String 确保了语义的正确，而不管编码方式
    
    let cafe = "Caf\u{00e9}"
    print("\(cafe) count: \(cafe.count), utf8 count: \(cafe.utf8.count), urf16 count: \(cafe.utf16.count)")
    
    
    let cafee = "Caf\u{0065}\u{0301}"
    print("\(cafee) count: \(cafee.count), utf8 count: \(cafee.utf8.count), utf16 count: \(cafee.utf16.count)")
    
    
    // 对于`cafe`来说，`é`的UTF-8编码是`C3 A9`，加上前面`Caf`的编码是`43 61 66`，因此`cafe`的UTF-8编码个数是5；
    // 对于`cafee`来说，声调字符`'`的UTF-8编码是`CC 81`，加上前面`Cafe`的UTF-8编码是`43 61 66 65`，因此是6个，它相当于`Cafe'`；
    
    cafe == cafee
    
    // 而使用 NSString 情况就不一样了
    let nsCafe = NSString(characters: [0x43, 0x61, 0x66, 0xe9], length: 4)
    nsCafe.length
    let nsCafee = NSString(characters: [0x43, 0x61, 0x66, 0x65, 0x0301], length: 5);
    nsCafee.length
    nsCafe == nsCafee
    
    /// 组合字符
    // 给`é`外围再套个圈，字符个数仍为 4
    let circleCafee = cafee + "\u{20dd}"
    print("circleCafee: \(circleCafee), count: \(circleCafee.count)")
    
    "👨‍💼".count
    "👨‍💻".count
    "👪".count
    "🇨🇳🇨🇫".count
    var partner = ""
    for _ in 0...1 {
        partner += "👦"
        // 粘合
        partner += "\u{200d}"
    }
    print("partner: \(partner), count: \(partner.count)")
    
    /// String 是个集合？
    
    //extension String: Collection {}
    
    var swift = "Swift is fun"
    swift.dropFirst(9) // 丢掉前面 9 个字符
    
    
    let f = "👨‍👩‍👧‍👦"
    print("\n\(f).unicodeScalars forEach:")
    f.unicodeScalars.count
    f.unicodeScalars.forEach { print($0)}
    print("\(f) drop first is: \(f.dropFirst())") // 这里丢掉一个字符并不是三个小伙伴，而是整个emoji删除，语义更加正确。
    
    cafee.dropFirst(1) // ""
    cafee.dropLast(1)  // !!! Runtime error !!!，在 Swift 4 中是正确的
    
    cafee.count
    print("\ncafee forEach:")
    cafee.forEach { print("cafee: \($0)") }
    for (index, value) in cafee.enumerated() {
        print("\(index): \(value)")
    }
    
    cafee.unicodeScalars.count
    print("\ncafee.unicodeScalars forEach:")
    cafee.unicodeScalars.forEach { print("\(type(of: $0)): \($0)") }
    
    // 获得字符串的 String.UTF8View，8位整数集合，下面的 utf16 也类似
    print("\ncafee.utf8 forEach:")
    let cafeUtf8 = cafe.utf8
    cafeUtf8.forEach { print("\(type(of: $0)): \($0)") }
    
    print("\ncafee.utf16 forEach:")
    let cafeUtf16 = cafe.utf16
    cafeUtf16.forEach { print("\(type(of: $0)): \($0)") }
    
    var lastSubString = cafee.unicodeScalars.dropLast(1) // cafe
    var lastSubString16 = cafee.utf16.dropLast(1)          // cafe
    var lastSubString8 = cafee.utf8.dropLast(1)           // cafe�
    print("last substring: \(lastSubString), utf16: \(lastSubString16), utf8:\(lastSubString8)")
}
//stringExp()

//: ## 元组

func tupleExp() {
    print(#function)
    let success = (200, "HTTP OK")
    let fileNotFound = (404, "File not found")
    
    // 给元组每个成员一个标签
    let me = (name: "Mars", no: 11, email: "11@boxue.io")
    
    // 访问元组成员
    // 没有定义成员标签的，使用数字索引访问
    success.0
    success.1
    
    fileNotFound.0
    fileNotFound.1
    
    // 定了标签，则可以直接使用标签访问成员
    me.name
    me.no
    me.email
    
    // 还可以把一个Tuple的值，一一对应的拆分到不同的变量上
    var (successCode, successMessage) = success
    print(successCode)
    print(successMessage)
    
    // 获取的值与源元组没有关系
    successCode = 201
    print("tupe: \(success), successCode: \(successCode)")
    
    // 元组类型
    var redirect: (Int, String) = (302, "temporary redirect")
    
    // 元组比较，只有只有元素个数相同的元组u变量之间，才能b进行比较
    let tuple12 = (1, 2)
    let tuple123 = (1, 2, 3)
    let tuple11 = (1, 1)
    
    tuple11 < tuple12
}
//tupleExp()

//: 区间操作符

func rangeOperatorExp() {
    print(#function)
    // 区间操作符
    print("---1...5")
    for index in 1...5 {
        print(index)
    }
    
    print("---1..<5")
    for index in 1..<5 {
        print(index)
    }
}
//rangeOperatorExp()

//: [上一页](@previous) | [下一页](@next)
