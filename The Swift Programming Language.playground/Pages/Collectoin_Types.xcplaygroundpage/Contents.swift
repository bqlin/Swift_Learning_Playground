//: # 集合类型
//: Swift 语言提供 `Arrays`、`Sets` 和 `Dictionaries` 三种基本的*集合类型*用来存储集合数据。数组（Arrays）是有序数据的集。集合（Sets）是无序无重复数据的集。字典（Dictionaries）是无序的键值对的集。
//:
//: Swift 语言中的 `Arrays`、`Sets` 和 `Dictionaries` 中存储的数据值类型必须明确。这意味着我们不能把错误的数据类型插入其中。同时这也说明你完全可以对取回值的类型非常放心。
//:
//: > Swift 的 `Arrays`、`Sets` 和 `Dictionaries` 类型被实现为*泛型集合*。更多关于泛型类型和集合，参见 [泛型](./23_Generics.html)章节。
//:
//: ## 集合的可变性
//: 如果创建一个 `Arrays`、`Sets` 或 `Dictionaries` 并且把它分配成一个变量，这个集合将会是*可变的*。这意味着你可以在创建之后添加更多或移除已存在的数据项，或者改变集合中的数据项。如果我们把 `Arrays`、`Sets` 或 `Dictionaries` 分配成常量，那么它就是*不可变的*，它的大小和内容都不能被改变。
//: > 在我们不需要改变集合的时候创建不可变集合是很好的实践。如此 Swift 编译器可以优化我们创建的集合。
//: ## 数组（Arrays）
//: *数组*使用有序列表存储同一类型的多个值。相同的值可以多次出现在一个数组的不同位置中。
//: > Swift 的 `Array` 类型被桥接到 `Foundation` 中的 `NSArray` 类。
//:
//: ### 创建一个空数组
//:
var someInts = [Int]()
//print("someInts is of type [Int] with \(someInts.count) items.")
// 打印 "someInts is of type [Int] with 0 items."

someInts.append(3)
// someInts 现在包含一个 Int 值
someInts = []
// someInts 现在是空数组，但是仍然是 [Int] 类型的。

//: ### 创建一个带有默认值的数组
//:
var threeDoubles = Array(repeating: 0.0, count: 3)
// threeDoubles 是一种 [Double] 数组，等价于 [0.0, 0.0, 0.0]

//: ### 通过两个数组相加创建一个数组
//:
//: 我们可以使用加法操作符（`+`）来组合两种已存在的相同类型数组。新数组的数据类型会被从两个数组的数据类型中推断出来：
//:
var anotherThreeDoubles = Array(repeating: 2.5, count: 3)
// anotherThreeDoubles 被推断为 [Double]，等价于 [2.5, 2.5, 2.5]

var sixDoubles = threeDoubles + anotherThreeDoubles
// sixDoubles 被推断为 [Double]，等价于 [0.0, 0.0, 0.0, 2.5, 2.5, 2.5]

//: ### 用数组字面量构造数组
//:
var shoppingList = ["Eggs", "Milk"]
var tests = [1, 2, 3] + ["1.1", "1.2", "3.2"];

//: ### 访问和修改数组
//:
//print("The shopping list contains \(shoppingList.count) items.")
// 输出 "The shopping list contains 2 items."（这个数组有2个项）

if shoppingList.isEmpty {
//	print("The shopping list is empty.")
} else {
//	print("The shopping list is not empty.")
}
// 打印 "The shopping list is not empty."（shoppinglist 不是空的）

shoppingList.append("Flour")
// shoppingList 现在有3个数据项，有人在摊煎饼

shoppingList += ["Baking Powder"]
// shoppingList 现在有四项了
shoppingList += ["Chocolate Spread", "Cheese", "Butter"]
// shoppingList 现在有七项了

var firstItem = shoppingList[0]
// 第一项是 "Eggs"

shoppingList[0] = "Six eggs"
// 其中的第一项现在是 "Six eggs" 而不是 "Eggs"

shoppingList[4...6] = ["Bananas", "Apples"]
// shoppingList 现在有6项

//: > 不可以用下标访问的形式去在数组尾部添加新项。

shoppingList.insert("Maple Syrup", at: 0)
// shoppingList 现在有7项
// "Maple Syrup" 现在是这个列表中的第一项

let mapleSyrup = shoppingList.remove(at: 0)
// 索引值为0的数据项被移除
// shoppingList 现在只有6项，而且不包括 Maple Syrup
// mapleSyrup 常量的值等于被移除数据项的值 "Maple Syrup"

//: > 如果我们试着对索引越界的数据进行检索或者设置新值的操作，会引发一个运行期错误。我们可以使用索引值和数组的 `count` 属性进行比较来在使用某个索引之前先检验是否有效。除了当 `count` 等于 0 时（说明这是个空数组），最大索引值一直是 `count - 1`，因为数组都是零起索引。

firstItem = shoppingList[0]
// firstItem 现在等于 "Six eggs"

let apples = shoppingList.removeLast()
// 数组的最后一项被移除了
// shoppingList 现在只有5项，不包括 Apples
// apples 常量的值现在等于 "Apples" 字符串

//: ### 数组的遍历
//:
for item in shoppingList {
//	print(item)
}
// Six eggs
// Milk
// Flour
// Baking Powder
// Bananas

for (index, value) in shoppingList.enumerated() {
//	print("Item \(index + 1): \(value)")
}
// Item 1: Six eggs
// Item 2: Milk
// Item 3: Flour
// Item 4: Baking Powder
// Item 5: Bananas

//: ## 集合（Sets）
//:*集合（Set）*用来存储相同类型并且没有确定顺序的值。当集合元素顺序不重要时或者希望确保每个元素只出现一次时可以使用集合而不是数组。
//:
//: > Swift 的 `Set` 类型被桥接到 `Foundation` 中的 `NSSet` 类。
//:
//: ### 集合类型的哈希值
//:
//: 一个类型为了存储在集合中，该类型必须是*可哈希化*的——也就是说，该类型必须提供一个方法来计算它的*哈希值*。一个哈希值是 `Int` 类型的，相等的对象哈希值必须相同，比如 `a==b`,因此必须 `a.hashValue == b.hashValue`。
//:
//: ### 集合类型语法
//:
var letters = Set<Character>()
//print("letters is of type Set<Character> with \(letters.count) items.")
// 打印 "letters is of type Set<Character> with 0 items."

letters.insert("a")
// letters 现在含有1个 Character 类型的值
letters = []
// letters 现在是一个空的 Set，但是它依然是 Set<Character> 类型

//var favoriteGenres: Set<String> = ["Rock", "Classical", "Hip hop"]
// 同等于
var favoriteGenres: Set = ["Rock", "Classical", "Hip hop"]

//: ### 访问和修改一个集合
//:
//print("I have \(favoriteGenres.count) favorite music genres.")
// 打印 "I have 3 favorite music genres."

if favoriteGenres.isEmpty {
//	print("As far as music goes, I'm not picky.")
} else {
//	print("I have particular music preferences.")
}
// 打印 "I have particular music preferences."

favoriteGenres.insert("Jazz")
// favoriteGenres 现在包含4个元素

if let removedGenre = favoriteGenres.remove("Rock") {
//	print("\(removedGenre)? I'm over it.")
} else {
//	print("I never much cared for that.")
}
// 打印 "Rock? I'm over it."

if favoriteGenres.contains("Funk") {
//	print("I get up on the good foot.")
} else {
//	print("It's too funky in here.")
}
// 打印 "It's too funky in here."

//: ### 遍历一个集合
//:
for genre in favoriteGenres {
//	print("\(genre)")
}
// Classical
// Jazz
// Hip hop

for genre in favoriteGenres.sorted() {
//	print("\(genre)")
}
// Classical
// Hip hop
// Jazz

//: ## 集合操作
//:
let oddDigits: Set = [1, 3, 5, 7, 9]
let evenDigits: Set = [0, 2, 4, 6, 8]
let singleDigitPrimeNumbers: Set = [2, 3, 5, 7]

oddDigits.union(evenDigits).sorted()
// [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
oddDigits.intersection(evenDigits).sorted()
// []
oddDigits.subtracting(singleDigitPrimeNumbers).sorted()
// [1, 9]
oddDigits.symmetricDifference(singleDigitPrimeNumbers).sorted()
// [1, 2, 9]

//: ### 集合成员关系和相等
//:
//: * 使用“是否相等”运算符（`==`）来判断两个集合是否包含全部相同的值。
//: * 使用 `isSubset(of:)` 方法来判断一个集合中的值是否也被包含在另外一个集合中。
//: * 使用 `isSuperset(of:)` 方法来判断一个集合中包含另一个集合中所有的值。
//: * 使用 `isStrictSubset(of:)` 或者 `isStrictSuperset(of:)` 方法来判断一个集合是否是另外一个集合的子集合或者父集合并且两个集合并不相等。
//: * 使用 `isDisjoint(with:)` 方法来判断两个集合是否不含有相同的值（是否没有交集）。
//:
let houseAnimals: Set = ["🐶", "🐱"]
let farmAnimals: Set = ["🐮", "🐔", "🐑", "🐶", "🐱"]
let cityAnimals: Set = ["🐦", "🐭"]

houseAnimals.isSubset(of: farmAnimals)
// true
farmAnimals.isSuperset(of: houseAnimals)
// true
farmAnimals.isDisjoint(with: cityAnimals)
// true

//: ## 字典
//: *字典*是一种存储多个相同类型的值的容器。每个值（value）都关联唯一的键（key），键作为字典中的这个值数据的标识符。和数组中的数据项不同，字典中的数据项并没有具体顺序。我们在需要通过标识符（键）访问数据的时候使用字典，这种方法很大程度上和我们在现实世界中使用字典查字义的方法一样。
//: > Swift 的 `Dictionary` 类型被桥接到 `Foundation` 的 `NSDictionary` 类。
//:
//: ### 字典类型简化语法
//: Swift 的字典使用 `Dictionary<Key, Value>` 定义，其中 `Key` 是字典中键的数据类型，`Value` 是字典中对应于这些键所存储值的数据类型。
//: > 一个字典的 `Key` 类型必须遵循 `Hashable` 协议，就像 `Set` 的值类型。
//: 我们也可以用 `[Key: Value]` 这样简化的形式去创建一个字典类型。虽然这两种形式功能上相同，但是后者是首选，并且这本指导书涉及到字典类型时通篇采用后者。
//:
//: ### 创建一个空字典
//:
var namesOfIntegers = [Int: String]()
// namesOfIntegers 是一个空的 [Int: String] 字典

namesOfIntegers[16] = "sixteen"
// namesOfIntegers 现在包含一个键值对
namesOfIntegers = [:]
// namesOfIntegers 又成为了一个 [Int: String] 类型的空字典

//: ### 用字典字面量创建字典
//:
//var airports: [String: String] = ["YYZ": "Toronto Pearson", "DUB": "Dublin"]
// 等同于：
var airports = ["YYZ": "Toronto Pearson", "DUB": "Dublin"]

//: ### 访问和修改字典
//:
//print("The dictionary of airports contains \(airports.count) items.")
// 打印 "The dictionary of airports contains 2 items."（这个字典有两个数据项）

if airports.isEmpty {
//	print("The airports dictionary is empty.")
} else {
//	print("The airports dictionary is not empty.")
}
// 打印 "The airports dictionary is not empty."

airports["LHR"] = "London"
// airports 字典现在有三个数据项

if let oldValue = airports.updateValue("Dublin Airport", forKey: "DUB") {
//	print("The old value for DUB was \(oldValue).")
}
// 输出 "The old value for DUB was Dublin."

if let airportName = airports["DUB"] {
//	print("The name of the airport is \(airportName).")
} else {
//	print("That airport is not in the airports dictionary.")
}
// 打印 "The name of the airport is Dublin Airport."

airports["APL"] = "Apple Internation"
// "Apple Internation" 不是真的 APL 机场，删除它
airports["APL"] = nil
// APL 现在被移除了

if let removedValue = airports.removeValue(forKey: "DUB") {
//	print("The removed airport's name is \(removedValue).")
} else {
//	print("The airports dictionary does not contain a value for DUB.")
}
// prints "The removed airport's name is Dublin Airport."

//: ### 字典遍历
//: 我们可以使用 `for-in` 循环来遍历某个字典中的键值对。每一个字典中的数据项都以 `(key, value)` 元组形式返回，并且我们可以使用临时常量或者变量来分解这些元组：
//:
for (airportCode, airportName) in airports {
//	print("\(airportCode): \(airportName)")
}
// YYZ: Toronto Pearson
// LHR: London Heathrow

for airportCode in airports.keys {
//	print("Airport code: \(airportCode)")
}
// Airport code: YYZ
// Airport code: LHR

for airportName in airports.values {
//	print("Airport name: \(airportName)")
}
// Airport name: Toronto Pearson
// Airport name: London Heathrow

let airportCodes = [String](airports.keys)
// airportCodes 是 ["YYZ", "LHR"]

let airportNames = [String](airports.values)
// airportNames 是 ["Toronto Pearson", "London Heathrow"]



//: [上一页](@previous) | [下一页](@next)
