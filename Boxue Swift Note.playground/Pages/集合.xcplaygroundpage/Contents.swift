import Foundation

//: # 集合
// 集合可以看成是字典的那一组 key

//: ## 构造与使用
var vowel: Set<Character> = ["a", "e", "i", "o", "u"]

vowel.count
vowel.isEmpty

vowel.contains("a")
vowel.remove("a")
vowel.insert("1")

var setA: Set = [1, 2, 3, 4, 5, 6]
var setB: Set = [4, 5, 6, 7, 8, 9]

let interSectAB = setA.intersection(setB)
let symmetricDiffAB = setA.symmetricDifference(setB)
let unionAB = setA.union(setB)
let aSubtractB = setA.subtracting(setB)

// 修改自身
setA.formIntersection(setB)

//: [上一页](@previous) | [下一页](@next)
