import Foundation

//: # 解决继承问题：基类的默认参数
//: 如果派生类中继承而来的方法带有默认参数，不要修改它，通常这不会带来你期望的结果。

class inherit0 {
    class Shape {
        enum Color { case red, yellow, green }
        
        func draw(color: Color = .red) {
            print("A \(color) shape.")
        }
    }
    
    class Square: Shape {
        override func draw(color: Color = .yellow) {
            print("A \(color) square.")
        }
    }
    
    class Circle: Shape {
        override func draw(color: Color = .green) {
            print("A \(color) circle.")
        }
    }
    
    // 符合预期
    static func test0() {
        let s = Square()
        let c = Circle()
        s.draw() // A yellow square
        c.draw() // a green circle
    }
    
    // 当我们希望通过多态来动态选择调用的方法时，结果就不是我们预期的，子类的默认参数没有效果，都使用了基类的默认参数。
    static func test1() {
        let s: Shape = Square()
        let c: Shape = Circle()
        s.draw() // A red square.
        c.draw() // A red circle.
    }
}

print("inherit0 test:")
inherit0.test0()
inherit0.test1()

//: 因为在Swift里，继承而来的方法调用是在运行时动态派发的，Swift会在运行时动态选择一个对象真正要调用的方法。但是，方法的参数，出于性能的考虑，却是静态绑定的，编译器会根据调用方法的对象的类型，绑定函数的参数。
//: 为了能在重定义继承方法的同时，又继承到基类的默认参数，可以通过extension来解决，这种解决方案解决了在使用多态时行为不一致的问题。

class inherit1 {
    class Shape {
        enum Color { case red, yellow, green }
        
        func doDraw(of color: Color) {
            print("A \(color) shape.")
        }
    }
    
    class Square: Shape {
        // draw是extension方法，不能被重写
        // override func draw(color: Color = .yellow) {
        //    print("A \(color) square.")
        // }
        
        override func doDraw(of color: Color) {
            print("A \(color) square.")
        }
    }
    
    class Circle: Shape {
        // draw是extension方法，不能被重写
        // override func draw(color: Color = .green) {
        //    print("A \(color) circle.")
        // }
        
        override func doDraw(of color: Color) {
            print("A \(color) circle.")
        }
    }
    
    static func test0() {
        let s = Square()
        let c = Circle()
        s.draw() // A red square.
        c.draw() // A red circle.
    }
    
    static func test1() {
        let s: Shape = Square()
        let c: Shape = Circle()
        s.draw() // A red square.
        c.draw() // A red circle.
    }
}

extension inherit1.Shape {
    func draw(color: Color = .red) {
        doDraw(of: color)
    }
}

print("inherit1 test:")
inherit1.test0()
inherit1.test1()

//: 总结：永远也不要改写继承而来的方法的默认参数，因为它执行的是静态绑定的语义。

//: [上一页](@previous) | [下一页](@next)
