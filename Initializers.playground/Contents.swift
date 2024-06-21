import UIKit

//Required Initializer

class Person{
    let name: String
    
    required init(name: String) {
        self.name = name
    }
}

class Member: Person {
    var point = 0

    init() {
        point = 0
        super.init(name: "unknown")
    }
    
    required init(name: String) {
        point = 0
        super.init(name: name)
    }
}

//Failable Initializer
//init?
//init!

struct Position {
    let x: Double
    let y: Double
    
    init?(x: Double, y: Double){
        guard x >= 0.0, y >= 0.0 else {
            return nil // 초기화에 실패했다는 의미로 nil을 리턴
        }
        
        self.x = x
        self.y = y
    }
    
    init!(value: Double){
        guard value >= 0.0 else {
            return nil // 초기화에 실패했다는 의미로 nil을 리턴
        }
        
        self.x = value
        self.y = value
    }
    
    init(value: Int){
        self.init(value: Double(value))
    }
}

var a = Position(x: 12, y: 23)
var b = Position(x: -1, y: -1)
a?.x
a?.y
b?.x
b?.y

var c: Position = Position(value: 1)
var d: Position = Position(value: -1)

c.x
c.y

d.x
d.y
