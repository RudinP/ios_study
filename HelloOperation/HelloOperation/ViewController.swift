//
//  ViewController.swift
//  HelloOperation
//
//  Created by 루딘 on 7/6/24.
//

import UIKit

class ViewController: UIViewController {

    
    let queue = OperationQueue() // 백그라운드에서 실행
    var isCancelled = false
    
    @IBAction func startOperation(_ sender: Any) {
        isCancelled = true
        //클로저 형태
        queue.addOperation {
            for _ in 1 ... 30 {
                guard !self.isCancelled else {return}
                print("😀", separator: " ", terminator: " ")
                Thread.sleep(forTimeInterval: 0.3)
            }
        }
        
        //블록 형태
        //하나의 오퍼레이션에 두 개의 블록 추가할 수 있다는 장점
        let op = BlockOperation {
            for _ in 1 ... 30 {
                guard !self.isCancelled else {return}
                print("😡", separator: " ", terminator: " ")
                Thread.sleep(forTimeInterval: 0.6)
            }
        }
        queue.addOperation(op)
        
        //작업이 동시에 실행되는 것은 아니지만, 작업을 종류별로 구분하여 추가 가능-> 가독성 높아짐
        //아직 실행하지 않았거나 실행중인 오퍼레이션에 블록 추가는 문제 없지만, 실행이 끝난 오퍼레이션에 추가하면 크래시가 발생한다.
        op.addExecutionBlock {
            for _ in 1 ... 30 {
                guard !self.isCancelled else {return}
                print("🥶", separator: " ", terminator: " ")
                Thread.sleep(forTimeInterval: 0.5)
            }
        }
        
        let op2 = EmojiPrintOperation(type: "🤢")
        queue.addOperation(op2)
        
        op2.completionBlock = {
            print("Done")
        }
    }
    @IBAction func cancelOperation(_ sender: Any) {
        //큐에 추가된 모든 오퍼레이션이 취소되어야 하지만, 이미 실행중인 오퍼레이션은 취소 기능이 구현되어있지 않다면 불가능하다.
        queue.cancelAllOperations()
        isCancelled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

