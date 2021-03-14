import Foundation

//: # 属性观察器

class StepCounter {
    var totalSteps: Int = 0 {
        willSet(newTotalSteps) {
            print("\(type(of: self)): 将 totalSteps 的值设置为 \(newTotalSteps)")
        }
        didSet {
            if totalSteps > oldValue  {
                print("\(type(of: self)): 增加了 \(totalSteps - oldValue) 步")
            }
            // 在属性观察器中更新属性不会触发属性器
            if totalSteps > 800 {
                totalSteps = 1000
            }
        }
    }
}

//: 个人觉得不建议在didSet中修改自身的值，虽然这可以达到限制值的更改，但这似乎违背了属性观察器的语义。它应该仅用于监听属性值的变更，然后修改其他属性或其他逻辑。
//: 要限制值的修改这样的逻辑，应该通过添加一个私有的存储属性，再用一个公开的计算属性将其包裹，在公开的计算属性的getter、setter中执行相关的逻辑。

let stepCounter = StepCounter()
stepCounter.totalSteps = 200
// 将 totalSteps 的值设置为 200
// 增加了 200 步
stepCounter.totalSteps = 360
// 将 totalSteps 的值设置为 360
// 增加了 160 步
stepCounter.totalSteps = 896
// 将 totalSteps 的值设置为 896
// 增加了 536 步

class SubCounter: StepCounter {
    override var totalSteps: Int {
        didSet {
            print("Sub: \(oldValue) -> \(totalSteps)")
        }
    }
}
print("创建SubCounter实例")
let subCounter = SubCounter()
subCounter.totalSteps = 888


//: [上一页](@previous) | [下一页](@next)
