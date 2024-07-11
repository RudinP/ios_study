//
//  EmojiPrintOperation.swift
//  HelloOperation
//
//  Created by 루딘 on 7/6/24.
//

import Foundation

class EmojiPrintOperation: Operation{
    let type: String
    
    init(type: String) {
        self.type = type
    }
    
    //중요. 필수.
    override func main() {
        for _ in 1 ..< 100 {
            //작업이 취소되면 isCancelled 속성에 true가 저장된다.
            guard !isCancelled else {return} //return으로 인해 종료된다.
            
            print(type, separator: " ", terminator: " ")
            Thread.sleep(forTimeInterval: 0.9)
        }
    }
}
