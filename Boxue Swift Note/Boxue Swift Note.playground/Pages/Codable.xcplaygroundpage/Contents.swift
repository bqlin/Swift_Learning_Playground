import Foundation

//: # Codable解析JSON

var response = """
"""
func responseData() -> Data {
    return response.data(using: .utf8)!
}
func data2String(_ data: Data) -> String {
    return String(data: data, encoding: .utf8)!
}

response = """
{
    "title": "How to parse JSON in Swift 4",
    "series": "What's new in Swift 4",
    "creator": "Mars",
    "type": "free"
}
"""

enum EpisodeType: String, Codable {
    case free
    case paid
}

struct Episode0: Codable {
    var title: String
    var series: String
    var creator: String
    var type: EpisodeType
}

//: 简单使用Codable。这里模型的字段与JSON的完全一致。

func simpleDecodeEncodeExp() {
    // decode
    let decoder = JSONDecoder()
    let episode0 = try! decoder.decode(Episode0.self, from: responseData())
    dump(episode0)

    // encode
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    let dataFromJSON = try! encoder.encode(episode0)
    print(data2String(dataFromJSON))
}

// simpleDecodeEncodeExp()

//: 自定义字段映射。当JSON的字段名称与模型的字段名称不一致时，则需要进行自定义映射。

response = """
{
    "title": "How to parse JSON in Swift 4",
    "series": "What's new in Swift 4",
    "creator": "Mars",
    "type": "free",
    "created_by": "Mars",
}
"""
struct Episode1: Codable {
    var title: String
    var series: String
    var creator: String
    let createdBy: String
    var type: EpisodeType
}

// 将JSON中的created_by映射为模型的createdBy：

extension Episode1 {
    enum CodingKeys: String, CodingKey {
        case title
        case series
        case creator
        case createdBy = "created_by"
        case type
    }
}

func customKeyMapExp() {
    // decode
    let decoder = JSONDecoder()
    let model = try! decoder.decode(Episode1.self, from: responseData())
    dump(model)

    // encode
    let inputModel = Episode1(
        title: "How to parse JSON in Swift 4",
        series: "What's new in Swift 4",
        creator: "Bq",
        createdBy: "Mars",
        type: .free
    )
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    let outputString = data2String(try! encoder.encode(inputModel))
    print(outputString)
    
}
//customKeyMapExp()


/*:
 通过修改encoder的属性也可以修改编码的一些行为。

 encoder.dateEncodingStrategy = .iso8601

 可以把Date对象转换成可读的日期字符串。

 decoder.nonConformingFloatDecodingStrategy =
     .convertFromString(
         positiveInfinity: "+Infinity",
         negativeInfinity: "-Infinity",
         nan: "NaN")

 可以把+Infinity、-Infinity、NaN字符串值转变为浮点语言的类型值。
 */

struct Episode2: Codable {
    var title: String
    var series: String
    let createdBy: String
    var type: EpisodeType
    let createdAt: Date
    let duration: Float
    var origin: Data

    enum CodingKeys: String, CodingKey {
        case title
        case series
        case createdBy = "created_by"
        case type
        case createdAt = "created_at"
        case duration
        case origin
    }
}

func codecPropertyExp() {
    let episode = Episode2(title: "How to parse JSON in Swift 4", series: "What's new in Swift 4", createdBy: "Mars", type: .free, createdAt: Date(), duration: 20.33, origin: "a".data(using: .utf8)!)
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    // 修改Date编码方式
    encoder.dateEncodingStrategy = .iso8601
    // 修改Data编码方式
    encoder.dataEncodingStrategy = .base64
    let data = try! encoder.encode(episode)
    print(data2String(data))
    
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    decoder.dataDecodingStrategy = .base64
    decoder.nonConformingFloatDecodingStrategy = .convertFromString(positiveInfinity: "+Infinity", negativeInfinity: "-Infinity", nan: "NaN")
    response = """
    {
    "title": "How to parse JSON in Swift 4",
    "series": "What's new in Swift 4",
    "created_by": "Mars",
    "type": "free",
    "created_at": "2017-08-23T01:42:42Z",
    "origin": "Ym94dWVpby5jb20=",
    "duration": "NaN",
    }
    """
    let outputModel = try! decoder.decode(Episode2.self, from: responseData())
    dump(outputModel)
    dump(String(data: outputModel.origin, encoding: .utf8)!)
}
//codecPropertyExp()

//: 嵌套结构的JSON解析

func wrappedModelExp() {
    // 只取字典中的list字段的数组
    response = """
    {
    "list": [
    {
    "title": "How to parse JSON in Swift 4 - I",
    "series": "What's new in Swift 4",
    "created_by": "Mars",
    "type": "free",
    "created_at": "2017-08-23T01:42:42Z",
    "duration": "NaN",
    "origin": "Ym94dWVpby5jb20=",
    "url": "boxueio.com"
    },
    {
    "title": "How to parse JSON in Swift 4 - II",
    "series": "What's new in Swift 4",
    "created_by": "Mars",
    "type": "free",
    "created_at": "2017-08-23T01:42:42Z",
    "duration": "NaN",
    "origin": "Ym94dWVpby5jb20=",
    "url": "boxueio.com"
    }
    ]
    }
    """
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    decoder.dataDecodingStrategy = .base64
    decoder.nonConformingFloatDecodingStrategy = .convertFromString(positiveInfinity: "+Infinity", negativeInfinity: "-Infinity", nan: "NaN")
    
    let listWrap = try! decoder.decode([String: [Episode2]].self, from: responseData())
    print(type(of: listWrap))
    let result = listWrap["list"]!
    print(result)
}
//wrappedModelExp()

//: 自定义日期解析

struct DateWrapped: Codable {
    var date: Date
}
func dateEncodeExp() {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .custom({ (date, encoder) in
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let string = formatter.string(from: date)
        var container = encoder.singleValueContainer()
        try container.encode(string)
    })
    let model = DateWrapped(date: Date())
    let data = try! encoder.encode(model)
    print(data2String(data))
}
//dateEncodeExp()

//: 自定义解码过程

struct Episode3: Codable {
    var title: String
    var createdAt: Date
    var comment: String?
    var duration: Int
    var slices: [Float]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.comment = try container.decodeIfPresent(String.self, forKey: .comment)
        
        let meta = try container.nestedContainer(keyedBy: MetaCodingKeys.self, forKey: .meta)
        self.duration = try meta.decode(Int.self, forKey: .duration)
        
        var unkeyedContainer = try meta.nestedUnkeyedContainer(forKey: .slices)
        var percentages: [Float] = []
        while !unkeyedContainer.isAtEnd {
            let sliceDuration = try unkeyedContainer.decode(Float.self)
            percentages.append(sliceDuration / Float(duration))
        }
        self.slices = percentages
    }
}

extension Episode3 {
    enum MetaCodingKeys: String, CodingKey {
        case duration
        case slices
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case createdAt = "created_at"
        case comment
        case meta
    }
    
    // 因为json结构与模型定义的结构不一致，所以还要定义model的编码方法
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(title, forKey: .title)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(comment, forKey: .comment)
        
        var meta = container.nestedContainer(keyedBy: MetaCodingKeys.self, forKey: .meta)
        try meta.encode(duration, forKey: .duration)
        try meta.encode(slices, forKey: .slices)
    }
}

func customDecodeExp() {
    // 注意，这里需要把meta中的字段扁平化
    // 此处注意null与“null”的区别！
    response = """
    {
    "title": "How to parse a json - IV",
    "comment": null,
    "created_at": "2017-08-24 00:00:00 +0800",
    "meta": {
    "duration": 500,
    "slices": [125, 250, 375]
    }
    }
    """
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
        let string = try! decoder.singleValueContainer().decode(String.self)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        return formatter.date(from: string)!
    })
    var episode = try! decoder.decode(Episode3.self, from: responseData())
    dump(episode)
    
    episode.comment = nil
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    let encodedData = try! encoder.encode(episode)
    print(data2String(encodedData))
}
//customDecodeExp()

//: [上一页](@previous) | [下一页](@next)
