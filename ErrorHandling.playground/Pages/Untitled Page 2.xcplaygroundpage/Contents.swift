
import Foundation

func processFile(path: String) {
    //파일을 열고
    let file = FileHandle(forReadingAtPath:  path)
    
    //함수가 끝나기 전까지 실행되지 않으며, 런타임 에러 발생한 것이 아니라면 함수가 끝나는 시점에 실행
    //여기에서는 언제나 끝날 때 close 함수가 실행되는 것
    defer {
        //닫기
        file?.closeFile()
    }
    
    if path.hasSuffix(".jpg"){
        return
    }

}

func testDefer(){
    defer{
        print(1)
    }
    defer{
        print(2)
    }
    defer{
        print(3)
    }
}

testDefer()
