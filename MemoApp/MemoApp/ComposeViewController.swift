//
//  ComposeViewController.swift
//  MemoApp
//
//  Created by 루딘 on 11/4/23.
//

import UIKit

class ComposeViewController: UIViewController {
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var memoTextView: UITextView!
   
    @IBAction func save(_ sender: Any) {
        guard let memo = memoTextView.text, memo.count > 0 else{
            alert(message: "메모를 입력하세요")
            return
        }
        let newMemo = Memo(content: memo)
        Memo.dummyMemoList.append(newMemo)
        
        NotificationCenter.default.post(name: ComposeViewController.newMemoDidInsert, object: nil)
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension ComposeViewController{
    static let newMemoDidInsert = Notification.Name(rawValue: "newMemoDidInsert")
}
