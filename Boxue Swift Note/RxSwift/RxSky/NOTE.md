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

更节省时间的方式：mock调用链路，让其变成同步操作。

个人觉得，对于开发这来说，测试工作应该是促进开发工作的。所以它在开发的不同阶段应有不同的使命，因此也不需要把测试用例一次性写得完美。

- 在开发过程中，测试仅用于验收单元功能的可用性；
- 在开发结束自测阶段，测试则用于验收单元功能的鲁棒性；