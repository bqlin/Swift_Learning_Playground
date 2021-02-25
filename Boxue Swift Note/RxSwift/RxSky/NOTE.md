# 笔记

### 单元测试

#### 为测试调整访问权限

若需要在测试中能方法方法、属性，需要将private提升为internal。

#### 如何测试方法被调用？

mock该方法调用的整个链路。

如何mock？

原理：通过protocol、extension让目标类型允许接收自定义的对象，自实现protocol对应的方法。

1. 通过protocol声明与测试目标相同的方法；
2. 通过extension让目标对象遵循protocol；
3. 修改测试目标中的类型为protocol；
4. 在测试target中实现遵循protocol的自定义类型，并添加必要的测试标记；
5. 编写测试代码，传入上面自定义的类型。

#### 如何测试异步操作

使用expectation在期望的超时内等待异步执行完毕。个人是更倾向于这种，因为编写的测试代码更少。

```swift
func test_requestWeatherData() {
    let expect = expectation(description: "测试天气数据请求")
    WeatherDataManager.shared.requestWeatherDataAt(latitude: 52, longitude: 100) { (data, error) in
        dump(data)
        dump(error)

        XCTAssert(data != nil, "数据不为空")
        XCTAssert(error == nil, "没有产生错误")

        expect.fulfill()
    }

    waitForExpectations(timeout: 30, handler: nil)
}
```

更节省时间的方式：mock调用链路，让其变成同步操作。如果是UI测试，还可以获取XCUIApplication对象，设置其启动时到参数，然后在程序中获取，实现根据启动参数自动切换测试环境与生产环境。

```swift
// 测试环境标记
app.launchArguments += ["UI-TESTING"]

// 测试环境传递测试数据
let json = """
{
    "longitude" : 100,
    "latitude" : 52,
    "currently" : {
        "temperature" : 23,
        "humidity" : 0.91,
        "icon" : "snow",
        "time" : 1507180335,
        "summary" : "Light Snow"
    }
}
"""
app.launchEnvironment["FakeJSON"] = json

// 在代码中实现自动切换测试环境与生产环境
internal struct Config {
    private static func isUITesting() -> Bool {
        return ProcessInfo.processInfo.arguments.contains("UI-TESTING")
    }
    static var urlSession: URLSessionProtocol = {
        if isUITesting() {
            return DarkSkyURLSession()
        }
        else {
            return URLSession.shared
        }
    }()
}
```

个人觉得，对于开发这来说，测试工作应该是促进开发工作的。所以它在开发的不同阶段应有不同的使命，因此也不需要把测试用例一次性写得完美。

- 在开发过程中，测试仅用于验收单元功能的可用性；
- 在开发结束自测阶段，测试则用于验收单元功能的鲁棒性；

## 架构演进

在使用MVC写代码的过程中，MVC三个角色的代码量常常不太均衡，C常常接管M、V剩余的工作，例如为V写的格式化数据的代码。

> 没什么问题不能通过引入一个中间层来解决。

MVVM也是如此，其使用VM在M和C之间做了一层中间层。

![image](https://cdn.nlark.com/yuque/0/2021/png/1239802/1613798972061-4ce5d77f-0053-4188-99eb-787cfa3a675e.png?x-oss-process=image%2Fresize%2Cw_1500)

View Model的主要作用，就是要把Model和Controller隔离，为此，**它应该为Controller提供所有数据访问的接口**。

MVVM的实践准则：

- M、V仍是MVC原本的概念与职责：
  - V不应了解C的细节，它只是一个展示内容的白板。
  - M只关心数据是如何获取与存储。
- C只做桥接的工作。C不应了解任何M的细节。C在桥接M与V时，应是通过VM得到转换后的结果，在C中应只剩下直接赋值的代码，而没有具体的处理逻辑。
- VM拥有M。M不应了解拥有它的VM。

在构建VM时使用struct，这样有个好处，就是其属性的变更会让整个VM对象重新赋值，意味着在VM对象的didSet方法中可以监听到所有VM属性的didSet。