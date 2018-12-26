//: ## 泛型（Generics）
//:
//: 在尖括号里写一个名字来创建一个泛型函数或者类型。
//:
func makeArray<Item>(repeating item: Item, numberOfTimes: Int) -> [Item] {
    var result = [Item]()
    for _ in 0..<numberOfTimes {
         result.append(item)
    }
    return result
}
makeArray(repeating: "knock", numberOfTimes: 4)

//: 你也可以创建泛型函数、方法、类、枚举和结构体。
//:
// 重新实现Swift标准库的可选类型
enum OptionalValue<Wrapped> {
    case none
    case some(Wrapped)
}
var possibleInteger: OptionalValue<Int> = .none
possibleInteger = .some(100)

//: 在函数体之前，使用 `where` 来指定泛型的序列列表——例如，限定类型实现一个协议，限定两个类型是相同的，或者限定某个类必须有一个特定的父类。
//:
func anyCommonElements<T: Sequence, U: Sequence>(_ lhs: T, _ rhs: U) -> Bool
    where T.Element: Equatable, T.Element == U.Element
{
    for lhsItem in lhs {
        for rhsItem in rhs {
            if lhsItem == rhsItem {
                return true
            }
        }
    }
   return false
}
anyCommonElements([1, 2, 3], [3])

//: - Experiment:
//: 修改`anyCommonElements(_:_:)`函数来创建一个函数，返回一个数组，内容是两个序列的共有元素。
//:
func allCommonElements<A: Sequence, B: Sequence>(_ aSeq: A, _ bSeq: B) -> [A.Element]
	where A.Element: Equatable, B.Element == A.Element
{
	var allCommonElements = [A.Element]()
	for aItem in aSeq {
		if bSeq.contains(aItem) {
			allCommonElements.append(aItem)
		}
	}
	return allCommonElements
}
allCommonElements([1, 2, 3.12], [2, 3.19999999])

//:  `<T: Equatable>`和`<T where T: Equatable>`是完全等价的。
//:



//: [Previous](@previous) | [Next](@next)
