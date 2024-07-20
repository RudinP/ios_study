//
//  ViewController.swift
//  HelloGCD
//
//  Created by 루딘 on 7/16/24.
//

import UIKit

class ViewController: UIViewController {
    
    let serialQueue = DispatchQueue(label: "SerialQueue") // serial Queue
    let concurrentQueue = DispatchQueue(label: "ConcurrentQueue", attributes: .concurrent) // concurrent Queue
    
    @IBAction func sync(_ sender: Any) {
        concurrentQueue.sync {
            for _ in 0 ..< 3 {
                print("Hello")
            }
            
            print("# Point 1")
        }
        
        print("# Point 2")
    }
    @IBAction func async(_ sender: Any) {
        concurrentQueue.async {
            for _ in 0 ..< 3 {
                print("Hello")
            }
            
            print("# Point 1")
        }
        
        print("# Point 2")
    }
    @IBAction func delay(_ sender: Any) {
        let delay = DispatchTime.now() /*현재 시간을 리턴*/ + 10
        
        concurrentQueue.asyncAfter(deadline: delay) {
            print("# Point 1")
        }
        
        print("# Point 2")
    }
    @IBAction func concurrent(_ sender: Any) {
        //일반 코드
        var start = Date.now
        
        for index in 0 ..< 50 {
            print(index, terminator: " ")
            
            Thread.sleep(forTimeInterval: 0.1)
        }
        
        print()
        
        var end = Date.now
        
        print("serial: \(end.timeIntervalSinceReferenceDate - start.timeIntervalSinceReferenceDate)")
        
        start = Date.now
        
        DispatchQueue.concurrentPerform(iterations: 50) { index in
            print(index, terminator: " ")
            
            Thread.sleep(forTimeInterval: 0.1)
        }

        print()
        
        end = Date.now
        
        print("concurrent: \(end.timeIntervalSinceReferenceDate - start.timeIntervalSinceReferenceDate)")

    }
    
    var currentWorkItem: DispatchWorkItem?
    @IBAction func submitWorkItem(_ sender: Any) {
        currentWorkItem = DispatchWorkItem(block: { [weak self] in
            
            for num in 0 ..< 100 {
                //isCancelled 속성을 저장해둔 workItem을 통해 접근
                guard let item = self?.currentWorkItem, !item.isCancelled else {return}
                
                print(num, separator: "", terminator: " ")
                Thread.sleep(forTimeInterval: 0.1)
            }
        })
        
        if let currentWorkItem{
            concurrentQueue.async(execute: currentWorkItem)
        }
        
        currentWorkItem?.notify(queue: concurrentQueue){
            print("Done")
        }
    }
    @IBAction func cancelWorkItem(_ sender: Any) {
        //취소
        currentWorkItem?.cancel()
    }
    
    let group = DispatchGroup() //그룹 생성
    
    @IBAction func runGroup(_ sender: Any) {
        concurrentQueue.async(group: group) {
            for _ in 0 ..< 10 {
                print("💩")
                Thread.sleep(forTimeInterval: 0.1)
            }
        }
        concurrentQueue.async(group: group) {
            for _ in 0 ..< 10 {
                print("🤕")
                Thread.sleep(forTimeInterval: 0.1)
            }
        }
        serialQueue.async(group: group) {
            for _ in 0 ..< 10 {
                print("👁️")
                Thread.sleep(forTimeInterval: 0.1)
            }
        }
        group.notify(queue: DispatchQueue.main){
            print("Done")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

