import Foundation

//: # 错误处理
/*:
 Swift并没有异常处理这一说，类似的语法都归结为错误（error），语义更加具体明确了。
 
 Error是一个协议，没有具体的约定，只是一个类型的身份，只要遵循了它，就可以使用Swift的错误处理规则（throw、do...catch，说白了只是语法糖而已，本质上跟return、switch...case没有区别）。
 */

enum CarError: Error {
    case outOfFuel
}

struct Car {
    var fuel: Double
    
    /// - Throws: `CarError` if the car is out of fuel
    func start() throws -> String {
        guard fuel > 5 else {
            // How we press the error here?
            // return .failure(CarError.outOfFuel)
            throw CarError.outOfFuel
        }
        
        // return .success("Ready to go")
        return "Ready to go"
    }
}

let vw = Car(fuel: 2)
do {
    let message = try vw.start()
    print(message)
} catch CarError.outOfFuel {
    print("Cannot start due to out of fuel")
} catch {
    print("We have something wrong")
}

/*:
 ## NSError to Swift Error
 
 OC的NSError若是以这种形式声明方法签名的：
 
 ```
 + (BOOL)checkTemperature: (NSError **)error
 ```
 
 在桥接到Swift时，会转换成这样的签名：
 
 ```
 func checkTemperature() throws {
 // ...
 }
 ```
 
 这里要特别说明的是，只有返回`BOOL`或`nullable`对象，并通过`NSError **`参数表达错误的OC函数，桥接到Swift时，才会转换成Swift原生的throws函数。并且，由于throws已经足以表达失败了，因此，Swift也不再需要OC版本的BOOL返回值，它会被去掉，改成Void。
 
 在捕获时通过NSError类型和`error.code`进行筛选与匹配，例如：
 
 ```
 do {
    try vw.selfCheck()
 } catch let error as NSError
    where error.code == CarSensorError.overHeat.rawValue {
    // CarSensorErrorDomain
    print(error.domain)
    // The radiator is over heat
    print(error.userInfo["NSLocalizedDescription"] ?? "")
 }
 ```
 
 ## Swift Error to NSError
 
 - 类似的，方法签名会自动转换，在OC里，它会被添加一个AndReturnError后缀，并接受一个`NSError **`类型的参数，并且会自动生成error domain和error code。
 - 通过遵循并实现LocalizedError，可以为NSError提供以下信息：
    - errorDescription
    - failureReason
    - recoverySuggestion
    - helpAnchor
 - 另外通过实现CustomNSError，可以自定义NSError中的以下信息：
    - errorCode
    - errorUserInfo
 */

//: ## 处理作为函数参数的闭包的错误
//: 同步的闭包错误，通过在函数中使用rethrows关键字表达。

// 只有当rule抛出错误时，checkAll才会抛出错误
extension Sequence {
    func checkAll(by rule:
        (Iterator.Element) throws -> Bool) rethrows -> Bool {
        
        for element in self {
            guard try rule(element) else { return false }
        }
        return true
    }
}

//: 对于异步闭包的错误，则更为建议使用Result<T>的形式，包含两类不同的值，一个是错误一个是具体的值，类似于Optional。这样的类型也称为either type。但对于直接使用这种形式回调结果，可能会导致多重switch...case的嵌套，可以给Result添加一个flatMap扩展，使嵌套转变为链式闭包。

enum Result<T> {
    case success(T)
    case failure(Error)
}

extension Result {
    func flatMap<U>(transform: (T) -> Result<U>) -> Result<U> {
        switch self {
            case let .success(v):
                return transform(v)
            case let .failure(e):
                return .failure(e)
        }
    }
}

/**
 func osUpdate(postUpdate: @escaping (Result<Int>) -> Void) {
     DispatchQueue.global().async {
         // 1. Download package
         switch self.downLoadPackage() {
         case let .success(filePath):
             // 2. Check integration
             switch self.checkIntegration(of: filePath) {
             case let .success(checksum):
                 // 3. Do you want to continue from here?
                 // ...
             case let .failure(e):
                 postUpdate(.failure(e))
             }
             case let .failure(e):
                 postUpdate(.failure(e))
         }
     }
 }
 
 ⬇️
 
 func osUpdate(postUpdate: @escaping (Result<Int>) -> Void) {
     DispatchQueue.global().async {
         let result = self.downLoadPackage()
             .flatMap {
                 self.checkIntegration(of: $0)
             }
             // Chain other processes here
         
         postUpdate(result)
     }
 }
 */

//: 与try...catch...finally类似的finally的概念，对应到一般情况，有个对应的语法——defer，在defer闭包内的内容将在离开所在作用域的时候执行。


//: [上一页](@previous) | [下一页](@next)
