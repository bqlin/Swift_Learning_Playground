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

### Protocol在编码中的意义

通过定义protocol和在extension中添加默认实现，可以节省一部分实现的代码。同时也是因为两个不同的对象是遵循了相同的protocol，这两个对象就具有了一定的多态语义，可以在使用分支操作中合并一部分重复的代码。

再往深一步，甚至可以对MVC的一些常规操作进行MVVM改进：

MVC中常常通过传递一个M给V，从而进行配置，仔细想想，V这时做的事情不就是VM+C做的事情吗。要过渡到MVVM，可以这么做：

1. 把从M到V中间的为展示做数据转换的过程抽取成VM。
2. 把V要的信息提取成协议，保留通过M配置V的方法，把M类型换成协议。
3. 让VM遵循协议，传递给V进行配置。

架构的改变无非是为了让代码重用性、灵活性更高，那么这么做带来的好处是什么？

- 减少了C通过VM配置V的逻辑。
- 更好的数据隐藏。这时V的UI属性可以完全私有，通过协议表达该V需要的数据，然后在内部设置。
- 以上的改动其实没有影响VM的实现或接口，只是将C的逻辑移到了V里面去做，同时也没有显式依赖VM。

### MVVM的思考

- VM是为V服务的，所以每个VM都只服务于一个V。但准确来说，是服务于一种呈现信息组合。如果有几个V呈现的信息是相同的，只是布局方式不一样，那么也可以公用这个VM。
- VM是强持有M的，一个M对应一个VM。因为VM就是对M的数据进行处理，对M的依赖性极强，没法通用与多个M。
- 在MVC里面，从M到V的数据转换的过程常常在M、V、C中流转，当然是放在这三个之中的哪个都不合适。这个不合适体现在丢失了灵活性。不说C（因为C本来就很难重用），M、V一旦带上了VM的逻辑，带上的那个其实是带上了对另一方的依赖，限制了使用场景。例如M带上了VM的逻辑。M就只能用在能用上VM，也就是说跟V需要的数据一致的地方。如果V带上VM的逻辑，就直接依赖了M，不能接受其他的数据类型了。既然有依赖，就会丢失灵活性、可重用性。VM的出现，是让V、M更纯粹了，纯粹也意味着更通用了。

当然，为了预防无脑地套用规则导致代码无意义地增长，可以遵循以下一些原则：

- 如果是一次性的配置，无需要重用，那就用最简单的方式实现。既然不需要考虑重用、灵活，那自然用简洁直接的方式开干就行。

### Table View中的分区表达

项目中带Section的table view有多个，带分区的数据结构，说白就是对一组数据进行分组，并添加描述信息，又或者说不能的分区展示不同的数据。简单地可分为以下几种：

- 使用类型声明
- delegate实现处添加枚举，返回需要的值

设置列表使用了类型包含组内项对象属性，用类型属性表达组所附带的信息。因为设置项每个都是固定的（固定的名称、固定的数量），即使要添加，也是需要添加显式的类型声明。所以这个页面使用类型表达分区是最合适的。

```swift
class SettingsViewModel {
    static let section: [SettingsRepresentable.Type] = [Date.self, Temperature.self]
}

protocol SettingsRepresentable {
    static var name: String { get }
    static var count: Int { get }

    var labelText: String { get }
    var accessory: UITableViewCell.AccessoryType { get }
}

extension SettingsViewModel {
    struct Date: SettingsRepresentable {
        static let name = "Date format"
        static let count = DateMode.allCases.count

        let dateMode: DateMode
        var labelText: String {
            switch dateMode {
                case .text:
                    return "Fri, 01 December"
                case .digit:
                    return "F, 12/01"
            }
        }

        var accessory: UITableViewCell.AccessoryType {
            UserDefaults.dateMode == dateMode ? .checkmark : .none
        }
    }

    struct Temperature: SettingsRepresentable {
        // ...
    }
}
```

位置列表也有分区的table view，但这是使用了内部定义结构体，返回代理所需要的数据。

```swift
extension LocationsViewController {
    private enum Section: Int, CaseIterable {
        case current
        case favourite
        var title: String {
            switch self {
            case .current:
                return "Current Location"
            case .favourite:
                return "Favourite Locations"
            }
        }
        static var count: Int {
            Section.allCases.count
        }
    }
}
```

这里主要是因为列表项内容是一样的，只是分组方式不一样而已，这里的列表项是不固定的，分组方式是固定的。

### 数据绑定

上面从MVC到MVVM，通过抽取出VM的方式的只是MVVM的一部分，C每次更新数据仍需全部刷新，并不能实现按需加载与刷新。