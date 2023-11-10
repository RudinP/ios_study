//
//  ViewController.swift
//  LocalNotificationPractice
//
//  Created by 루딘 on 11/10/23.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    var timeInterval: TimeInterval = 1
    
    @IBOutlet weak var pickerView: UIPickerView!{
        didSet{
            pickerView.delegate = self
            pickerView.dataSource = self
        }
    }
    @IBOutlet weak var inputField: UITextField!
    
    @IBAction func schedule(_ sender: Any) {
        let content = UNMutableNotificationContent()
        content.title = "Hello"
        content.body = inputField.text ?? "Empty Body"
        content.badge = 123
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        let request = UNNotificationRequest(identifier: "test", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {(error) in
            if let error = error{
                print(error)
            } else{
                print("done")
            }
        })
        
        inputField.text = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().setBadgeCount(0)
    }
    
    
}

extension ViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 60
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        timeInterval = TimeInterval(row + 1)
        print(timeInterval)
        }
}

extension ViewController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row + 1)
    }
}

