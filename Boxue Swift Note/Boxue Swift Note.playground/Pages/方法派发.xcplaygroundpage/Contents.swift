import Foundation

//: # 方法派发
/*:
 Swift方法派发分为3类：
 - Direct Dispatch
 - Table dispatch
 -
 
 ## Direct Dispatch
 方法的地址直接编码到汇编指令里，编译器可以最大程度地优化执行，但也最不灵活。
 
 - 值类型的各个使用阶段都是direct dispatch。
 - 在protocol和class的extension中__定义__的方法使用direct dispatch。
 
 ## Table Dispatch
 虚函数表形式存储函数地址，其具体地址是在运行时获得的。面向对象语言常用的使用多态的方式。
 
 - 在protocol和class的定义中__声明__的方法使用table dispatch。
 
 ## Message Dispatch
 Objective-C使用的方法派发方式，基于objc_msgSend函数的调用。
 
 若类是OC对象（NSObject）子类，则只有在extension中的方法才会是message dispatch，定义在本体中的方法还是使用table dispatch的。
 
 ## 修改方法派发规则的modifiers
 
 - dynamic，添加该修饰符的方法强制使用message dispatch。
 - final用于把方message dispatch方式修改成direct dispatch。
 
 和dynamic类似的一个modifier是@objc。但@objc的作用仅仅是让一个Swift方法可以被Objective-C运行时识别和访问，但并不会改变这个方法的派发方式。类似的@nonobjc则仅仅让一个方法对Objective-C运行时不可见，但不会修改方法的派发方式。
 */

protocol MyProtocol {
    func method4()
}
extension MyProtocol {
    // 定义并实现method3
    func method3() { print("MyProtocol.method3") }
    
    // 提供method4的默认实现
    func method4() { print("MyProtocol.method4") }
}
class Base: MyProtocol {
    func method1() {}
    // 不可被重写
    func method3() { print("Base.method3") }
    
    // 重写了默认实现
    func method4() { print("base.method4") }
}
class SubClass: Base {
    // 重写实现
    override func method4() { print("Subclass.method4") }
}

//: 在protocol和class的extension中__定义__的方法使用direct dispatch。direct dispatch意味着不能使用多态，也就是说其派发过程是跟类型紧密相关的，一旦字面类型（声明的类型）改变，其调用的方法地址就不一样。
func dispatchExp0() {
    let b = Base()
    let p: MyProtocol = b
    b.method3() // Base.method3
    p.method3() // MyProtocol.method3
}
//dispatchExp0()

//: 在protocol和class的定义中__声明__的方法使用table dispatch。这意味着有多态特性，不受字面声明的类型影响其执行方法的地址。
//:
//: 如果你的类型可能会被其他类型继承，你应该实现它遵从protocol的所有方法，哪怕其中一些已经有了默认实现。
func dispatchExp1() {
    let b = Base()
    let p: MyProtocol = b
    b.method4()
    p.method4()
    
    let s = SubClass()
    s.method4() // SubClass.method4
}
dispatchExp1()

//: 使用dynamic修改派发方式。当然在我使用的版本中，在extension中重写method5的前提是要有@objc dynamic修饰的。
class BaseOcClass: NSObject {
    @objc dynamic func method5() { print("Base.method5") }
}
class SubOcClass: BaseOcClass {
}
extension SubOcClass {
    override func method5() { print("Subclass.method5") }
}

func dynamicExp() {
    let base: BaseOcClass = SubOcClass()
    base.method5() // Subclass.method4
}

//: [上一页](@previous) | [下一页](@next)
