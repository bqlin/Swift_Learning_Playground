//
//  main.swift
//  CPointerinSwift
//
//  Created by Bq Lin on 2021/1/28.
//  Copyright © 2021 Bq. All rights reserved.
//

import Foundation

/*:
 Swift指针类型命名方式：

 - Managed：表示指针指向的内容由ARC统一管理，指针只负责内容的访问，不负责内存的管理；
 - Unsafe：表示指针指向的内容需要开发者自行管理，所谓自行管理，是指从申请资源、init、deinit到资源回收这一揽子事情，都需要开发者自己来。因此，managed和unsafe是互斥的，它们不会同时出现在一个指针类型的名称中；
 - Buffer：表示一段内存地址的view，它可以让我们用不同的形式看待同一块内存地址，稍后我们会看到它的用法；
 - Raw：表示指针指向的内存没有类型信息，也就是C中的void *。不带raw的指针类型都会通过泛型参数的形式表示自己指向的内存中包含的对象类型；
 - Mutable：表示指针指向的内容可修改，否则指针指向的内存是只读的；
 */

// MARK: 分配、使用、回收内存

print("\n分配、使用、回收内存🚩")

// 指针的使用以下步骤缺一不可：
func alloc_init_deinit_dealloc_exp() {
    let ptrLength = 10
    // 1. allocate
    let intPtr = UnsafeMutablePointer<Int>.allocate(capacity: ptrLength)
    // 2. init，即清理分配的内存的旧数据，若不清理就直接赋值则可能会在释放旧数据时发生错误。
    intPtr.initialize(repeating: 66, count: ptrLength)
    // 3. use
    intPtr.dump(count: ptrLength)
    // 4. deinit
    intPtr.deinitialize(count: ptrLength)
    // 5. dealloc
    intPtr.deallocate()
}

// alloc_init_deinit_dealloc_exp()

extension UnsafeMutablePointer where Pointee: CustomStringConvertible {
    func dump(count: Int) {
        var info = ""
        for i in 0 ..< count {
            info += self[i].description + " "
        }
        print(info)
    }
}

func accessPointerExp() {
    let ptrLength = 10
    let intPtr = UnsafeMutablePointer<Int>.allocate(capacity: ptrLength)
    intPtr.initialize(repeating: 66, count: ptrLength)

    // 使用下标访问与赋值
    for i in 0 ..< ptrLength {
        intPtr[i] = i + 1
    }
    intPtr.dump(count: ptrLength)

    // 用指针算数运算
    for i in 0 ..< ptrLength {
        // 直接访问(intPtr + i)得到的是内存地址
        print((intPtr + i).pointee)
        (intPtr + i).pointee = ptrLength - i
    }
    intPtr.dump(count: ptrLength)

    // 调用指针的移动方法
    /*:
     - `intPtr.predecessor()`，移动到intPtr的上一个位置；
     - `intPtr.successor()`，移动到intPtr的下一个位置；
     - `intPtr.advanced(by: 2)`，移动到intPtr的下两个位置。但实际上，`advanced(by:)`的参数也可以是负数，表示移动到之前的位置，甚至可以是0，就表示当前位置；
     */
    var tmpPtr = intPtr
    for i in 0 ..< ptrLength {
        // 直接访问(intPtr + i)得到的是内存地址
        tmpPtr += 1
        tmpPtr.predecessor().pointee = i * 3
    }
    intPtr.dump(count: ptrLength)

    intPtr.deinitialize(count: ptrLength)
    intPtr.deallocate()
}

// accessPointerExp()

// MARK: 使用buffer改善内存访问

print("\n使用buffer改善内存访问🚩")

func bufferExp() {
    // 创建一个buffer，需要一个首地址
    let ptrLength = 10
    let head = UnsafeMutablePointer<Int>.allocate(capacity: ptrLength)
    let buffer = UnsafeMutableBufferPointer(start: head, count: ptrLength)

    head.initialize(repeating: 0, count: ptrLength)
    for i in 0 ..< ptrLength {
        head[i] = i * 2 - 1
    }
    head.dump(count: ptrLength)

    // 获取buffer信息
    print("""
    buffer info:
        is empty: \(buffer.isEmpty);
        count: \(buffer.count);
        max: \(buffer.max()!);
        first: \(buffer.first!);
        first where > 5: \(buffer.first(where: { $0 > 5 })!);
        slice: \(buffer[0...3]);
    """)
    for i in buffer[0...3] {
        print("slice element: \(i)")
    }

    // 操作buffer
    buffer[0] = 99
    print("""
        sort: \(buffer.sorted(by: >));
        reverse: \([Int](buffer.reversed()));
        map: \(buffer.map { $0 + 1 });
    """)
}

//bufferExp()

// MARK: 桥接C语言指针

func cPointerBridgeExp() {
    // 要说明的是，&ten这种用法只有在接受Swift Pointer家族类型的参数时，才会自动进行类型转换，把&ten变成对应的指针类型。
    var ten: CInt = 10
    printAddress(&ten)
    
    // 另外的访问变量指针的方式，这里的&ten则只是inout类型。
    withUnsafePointer(to: &ten) { ptr in
        printAddress(ptr)
    }
    
    // 以上的版本获得的指针式不可修改了，下面的函数可以返回一个可读写的指针类型。
    withUnsafeMutablePointer(to: &ten) { ptr in
        ptr.pointee = 20
    }
    print("new ten: \(ten)")
}
//cPointerBridgeExp()

// MARK: 不带类型的指针RawPointer
print("\n不带类型的指针RawPointer🚩")
/*:
 malloc是典型的生成RawPointer的函数，对应C语言的`void *`，所以也不能直接使用，必须要根据访问的目的进行类型转换。
 
 func malloc(_ __size: Int) -> UnsafeMutableRawPointer!
 */

func rawPointerExp() {
    let ptrLength = 10
    // 1. malloc，只负责申请内存，不会进行初始化
    let rawPointer = malloc(ptrLength * MemoryLayout<Int>.size)!
    // 2. 使用bindMemory转换类型
    let intPtr = rawPointer.bindMemory(to: Int.self, capacity: 5 * MemoryLayout<Int>.size)
}

/*:
 注意：
 - bindMemory其capacity值和malloc申请的大小可以不一致的，可以只使用一部分。
 - capacity的值，是根据to的类型计算的，因此不要让capacity等于无法和to类型大小对齐的值。
 - raw pointer只能被明确绑定一次，多次绑定到不同类型之后的行为是未定义的。
 */

// MARK: 类型指针的临时转换
print("\n类型指针的临时转换🚩")
// 除了把raw pointer一次性转换成一个typed pointer之外，我们也可以把一个typed pointer临时变成另外一种类型的指针，这就好比同一块内存区域上存在着多种不同的view。

func typedPointerMemoryLayoutTransformExp() {
    let intPtr = UnsafeMutablePointer<Int32>.allocate(capacity: 1)
    intPtr.initialize(to: 0x12345678)
    intPtr.withMemoryRebound(to: Int8.self, capacity: 1) { ptr in
        for i in 0 ..< (MemoryLayout<Int32>.size / MemoryLayout<Int8>.size) {
            print(String(format: "%x", ptr[i]))
        }
    }
    intPtr.deinitialize(count: 1)
    intPtr.deallocate()
}
//typedPointerMemoryLayoutTransformExp()

// MARK: C回调指针
print("\nC回调指针🚩")

class Foo {
    var foo = "Foo"
    init() {
        print("Foo get initialzied.")
    }
    deinit {
        print("Foo get released.")
    }
}

func cCallbackPointerExp() {
    let fooObj = Foo()
    // 为了确保在Swift创建的对象在C回调函数中可用，需要独立管理该对象的内存，即脱离ARC，由开发者自己控制引用计数。
    let unmanagedFoo = Unmanaged.passRetained(fooObj) // 引用计数+1
    
    // 要传递给`void*`，需要创建对应的RawPointer
    let unmanagedPtr = unmanagedFoo.toOpaque()
    aFuncWithCallback(unmanagedPtr) { ptr in
        // 重新将对象还原回来
        let fooObj = Unmanaged<Foo>.fromOpaque(ptr!).takeRetainedValue() // 引用计数-1
        print(fooObj.foo)
    }
}
cCallbackPointerExp()

