//: ## 错误处理（Error Handling）
//:
//: 错误用遵循 `Error` 协议的类型的值来表示。
//:
enum PrinterError: Error {
    case outOfPaper
    case noToner
    case onFire
}

//: 使用`throw`抛出错误并使用`throws`来标记可能引发错误的函数。 如果在函数中抛出错误，函数会立即返回，并且调用该函数的代码会处理错误。
//:
func send(job: Int, toPrinter printerName: String) throws -> String {
    if printerName == "Never Has Toner" {
        throw PrinterError.noToner
    }
    return "Job sent"
}

//: 有几种方法可以处理错误。一种方法是使用`do`-`catch`。 在`do`块中，你可以通过在它前面写'try`来标记可能引发错误的代码。在`catch`块内，错误自动被赋予名称`error`，除非你给它一个不同的名字。
do {
    let printerResponse = try send(job: 1040, toPrinter: "Bi Sheng")
    print(printerResponse)
} catch {
    print(error)
}

//: - Experiment:
//: printer 名字修改为 `"Never Has Toner"`，来让其`send(job:toPrinter:)`抛出错误。
//:
do {
	try send(job: 112, toPrinter: "Never Has Toner")
} catch {
	print("send error: \(error)")
}

//: 你可以提供多个处理特定错误的`catch`块。 你在`catch`之后写一个模式匹配就像在switch中的`case`一样。
//:
do {
    let printerResponse = try send(job: 1440, toPrinter: "Gutenberg")
    print(printerResponse)
} catch PrinterError.onFire {
    print("I'll just put this over here, with the rest of the fire.")
} catch let printerError as PrinterError {
    print("Printer error: \(printerError).")
} catch {
    print(error)
}

//: - Experiment:
//: 添加代码以在`do`块中抛出错误。你需要抛出什么样的错误，错误由第一个`catch`块处理？还是第二个、第三个？
//:
do {
	let printerResponse = try send(job: 999999990, toPrinter: "Never Has Toner")
	print(printerResponse)
} catch PrinterError.onFire {
	print("I'll just put this over here, with the rest of the fire.")
} catch let printerError as PrinterError {
	print("Printer error: \(printerError).")
} catch {
	print(error)
}

//: Another way to handle errors is to use `try?` to convert the result to an optional. If the function throws an error, the specific error is discarded and the result is `nil`. Otherwise, the result is an optional containing the value that the function returned.
//: 处理错误的另一种方法是使用`try?`将结果转换为可选类型。如果函数抛出错误，则丢弃特定错误，结果为`nil`。 否则，结果是一个包含函数返回值的可选类型。
//:
let printerSuccess = try? send(job: 1884, toPrinter: "Mergenthaler")
let printerFailure = try? send(job: 1885, toPrinter: "Never Has Toner")

//: 使用`defer`编写一个代码块，该代码块在函数返回前、函数所有其他代码后执行。无论函数是否抛出错误，都会执行代码。你可以使用`defer`来编写彼此相邻的设置和清理代码，即使它们需要在不同的时间执行。
//:
var fridgeIsOpen = false
let fridgeContent = ["milk", "eggs", "leftovers"]

func fridgeContains(_ food: String) -> Bool {
    fridgeIsOpen = true
    defer {
        fridgeIsOpen = false
		print("总在返回前最后执行！")
    }

    let result = fridgeContent.contains(food)
	print("fridgeContains will return result")
    return result
}
fridgeContains("banana")
print(fridgeIsOpen)



//: [Previous](@previous) | [Next](@next)
