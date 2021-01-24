import Foundation
import PlaygroundSupport

//: # 闭包的内存管理

/*:
 ## 闭包的捕获
 - 无论是值类型i还是引用类型c，closure捕获到的都是它们的引用，这也是为数不多的值类型变量有引用语义的地方；
 - Closure内表达式的值，是在closure被调用的时候才评估的，而不是在closure定义的时候评估的；
 */
func closureCaptureExp() {
    var i = 10
    var captureI = { print(i) }
    captureI()
    i = 11
    // What will this print out?
    captureI() // 11
}
//closureCaptureExp()

class Demo { var value = "" }

func closureCaptureExp2() {
    var c = Demo()
    var captureC = { print(c.value) }
    c.value = "updated"
    c = Demo() // <-- A new object
    captureC() // ""
}
//closureCaptureExp2()

//: 不经意间的循环引用

class Role {
    var name: String
    var action: () -> Void = { }
    init(_ name: String = "Foo") {
        self.name = name
        print("\(self) init")
    }
    deinit {
        print("\(self) deinit")
    }
}
extension Role: CustomStringConvertible {
    var description: String {
        return "<Role: \(name)>"
    }
}

//: 当我们在类内部实现closure属性的时候，只要它访问了self，就一定会发生引用循环。这里不限于在自身属性内使用self，还是在外部赋值时使用。访问即捕获。

func circleRefrence() {
    var boss = Role("boss")
    let fn = {
        print("\(boss) takes this action.")
    }
    boss.action = fn
}
//circleRefrence()

//: ## closure capture list
//: capture list，它的作用就是让closure按值语义捕获变量。

func closureCaptureListExp0() {
    var i = 10
    var captureI = { [i] in print(i) }
    i = 11
    captureI() // 10
}
//closureCaptureListExp0()

func closureCaptureListExp1() {
    var c = Demo()
    var captureC = { [c] in print(c.value) } // 这时闭包已经持有了c对象，其引用数是2
    c.value = "updated"
    c = Demo() // 即使替换了对象值，其原有的对象引用数-1，但闭包的强引用还是存在的
    captureC() // updated
}
//closureCaptureListExp1()

// 使用capture list与weak解决循环引用问题
func weakCaptureListExp0() {
    var boss = Role("boss")
    let fn = { [weak boss] in
        print("\(boss) takes action.")
    }
    boss = Role("hidden boss")
    boss.action = fn
    boss.action()
}
//weakCaptureListExp0()

//: Swift标准库中，有一个叫做withExtendedLifetime的函数，它有两个参数：第一个参数是它要“延长寿命”的对象；第二个参数是一个closure，在这个closure返回之前，第一个参数会一直“存活”在内存里。

extension Role {
    func levelUp() {
        let globalQueue = DispatchQueue.global()
//        globalQueue.async {
//            print("Before: \(self) level up")
//            usleep(1000)
//            print("After: \(self) level up")
//        }
        
        // 在这里更为安全的做法是使用capture list+weak+withExtendedLifetime的方法，可以让self不会出现循环引用的机会。
        globalQueue.async { [weak self] in
            withExtendedLifetime(self) {
                print("Before: \(self) level up")
                usleep(1000)
                print("After: \(self) level up")
            }
        }
    }
}

func weakCaputreListExp1() {
    var player: Role? = Role("P1")
    player?.levelUp()
    usleep(500)
    print("Player set to nil")
    player = nil
    dispatchMain()
}
weakCaputreListExp1()

//: [上一页](@previous) | [下一页](@next)

