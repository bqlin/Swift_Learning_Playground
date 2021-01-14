import Foundation

//: # 字典
//: ## 定义字典

// 保存用户对某个视频的观看情况
enum RecordType {
    case bool(Bool)
    case number(Int)
    case text(String)
}

let recod11: [String: RecordType] = [
    "uid": .number(11),
    "exp": RecordType.number(100),
    "favourite": RecordType.bool(true),
    "title": RecordType.text("Dictionary basics")
]
print("recod11: \(recod11)")

//: ## 字典的基本用法

recod11["uid"]
recod11["favourite"]
type(of: recod11["title"])
// 字典返回的是可选类型，这是与 Array 最大的区别

//: 基本属性与常见用法

recod11.count
recod11.isEmpty
recod11.keys
recod11.values

print("recod11.keys: \(recod11.keys), type: \(type(of: recod11.keys))")
print("recod11.values: \(recod11.values), type: \(type(of: recod11.values))")

// 在更新 value 的时候，同时获得修改前的值，则可以：
var record10 = recod11
let valueBeforeUpdate = record10.updateValue(.number(120), forKey: "exp")

// 删除某个 key 使用设置 nil 的方式
record10["watchLater"] = RecordType.bool(false)
record10["watchLater"] = nil

//: ### 遍历字典

print("for in 遍历字典：")
for (k, v) in record10 {
    print("\(k): \(v)")
}

print("遍历排序后的字典：")
for key in record10.keys.sorted() {
    print("\(key): \(record10[key]!)")
}

//: ### 实现一个字典合并算法

let defalultRecord: [String: RecordType] = [
    "uid": RecordType.number(0),
    "exp": RecordType.number(100),
    "favourite": RecordType.bool(false),
    "title": RecordType.text("")
]

// 条件：只要它的元素中key和value的类型和Dictionary相同，就可以进行合并
// 只判断其元素的类型
extension Dictionary {
    mutating func merge<S: Sequence>(_ sequence: S)
        where S.Iterator.Element == (key: Key, value: Value) {
            sequence.forEach { self[$0] = $1 }
    }
}

// 测试：
let record10Patch: [(key: String, value: RecordType)] = [
    (key: "uid", value: RecordType.number(100)),
    (key: "title", value: RecordType.text("Common dictionary extentions")),
]
var template1 = defalultRecord
template1.merge(record10Patch)

//: ### 实现使用 tuple 数组初始化字典：
extension Dictionary {
    init<S: Sequence>(_ sequence: S)
        where S.Iterator.Element == (key: Key, value: Value) {
            self = [:]
            self.merge(sequence)
    }
}

// 测试：
let record11 = Dictionary(record10Patch)

//: [上一页](@previous) | [下一页](@next)
