
import UIKit

class ViewController: UIViewController {
    
    var value = 0
    
    let firstQueue = DispatchQueue(label: "First")
    let secondQueue =  DispatchQueue(label: "Second")
    
    let syncQueue = DispatchQueue(label: "Sync")
    
    let group = DispatchGroup()
    
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBAction func start(_ sender: Any) {
        value = 0
        
        for _ in 1 ... 1000{
            firstQueue.async(group: group, execute: {
                self.syncQueue.sync {
                    self.value += 1
                }
            })
            
            secondQueue.async(group: group, execute: {
                self.syncQueue.sync {
                    self.value += 1
                }
            })
        }
        
        group.notify(queue: .main){
            self.valueLabel.text = "\(self.value)"
        }
    }
    
    let lock = NSLock()
    @IBAction func mutex(_ sender: Any) {
        value = 0
        
        for _ in 1 ... 1000{
            firstQueue.async(group: group, execute: {
                self.lock.lock()
                self.value += 1
                self.lock.unlock()
                
            })
            
            secondQueue.async(group: group, execute: {
                self.lock.lock()
                self.value += 1
                self.lock.unlock()
            })
        }
        
        group.notify(queue: .main){
            self.valueLabel.text = "\(self.value)"
        }
    }
    
    let sem = DispatchSemaphore(value: 1)
    @IBAction func semaphore(_ sender: Any) {
        value = 0
        
        for _ in 1 ... 1000{
            firstQueue.async(group: group, execute: {
                self.sem.wait()
                self.value += 1
                self.sem.signal()
                
            })
            
            secondQueue.async(group: group, execute: {
                self.sem.wait()
                self.value += 1
                self.sem.signal()
            })
        }
        
        group.notify(queue: .main){
            self.valueLabel.text = "\(self.value)"
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

