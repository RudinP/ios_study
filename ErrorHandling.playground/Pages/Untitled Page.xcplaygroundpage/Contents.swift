import UIKit

enum DataParsingError: Error {
    case invalidType
    case invalidField
    case missingRequiredField(String)
}

func parsing(data: [String: Any]) throws { //파라미터 다음 throws 키워드 사용 : throwing function
    guard let _ = data["name"] else {
        //리턴처럼 현재 스코프의 실행을 즉시 끝낸다.
        throw DataParsingError.missingRequiredField("name")
    }
    
    guard let _ = data["age"] as? Int else{
        throw DataParsingError.invalidType
    }
    
    //Parsing
}

try? parsing(data: [:]) //missingRequiredField Error



func test() throws {
    do{
        try parsing(data: [:])
    } catch {
        print("handle erro")
        if let error = error as? DataParsingError {
            switch error {
            case .invalidType:
                print("invalid Type")
            default:
                print("handle error")
            }
        }
    }
}

if let _ = try? parsing(data: [:]) { //성공 시 바인딩 실행 후 success 프린트
    print("success")
} else { //실패 시 바인딩에 실패하고 else 블럭 실행. fail 프린트
    print("fail")
}

try? parsing(data: [:])
