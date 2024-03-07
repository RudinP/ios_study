//
//  DateSelectionViewController.swift
//  Days
//
//  Created by 루딘 on 3/7/24.
//

import UIKit

class DateSelectionViewController: UIViewController {

    var data: ComposeData?
    
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func toggleCalendarMode(_ sender: UIBarButtonItem) {
        if datePicker.datePickerStyle == .inline{
            datePicker.preferredDatePickerStyle = .wheels
            sender.image = UIImage(systemName: "calendar")
        } else {
            datePicker.preferredDatePickerStyle = .inline
            sender.image = UIImage(systemName: "line.3.horizontal.decrease.circle")
        }
    }
    
    @IBAction func dateSelected(_ sender: UIDatePicker) {
        if let day = sender.date.days(from: Date.today) {
            daysLabel.text = if day >= 0 { "D-\(abs(day))" } else { "D+\(abs(day))"}
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        selectedDateLabel.text = formatter.string(from: sender.date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ComposeViewController{
            data?.date = datePicker.date
            vc.data = data
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateSelected(datePicker)
    }

}
