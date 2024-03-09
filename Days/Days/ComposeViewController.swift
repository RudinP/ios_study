//
//  ComposeViewController.swift
//  Days
//
//  Created by 루딘 on 3/7/24.
//

import UIKit

extension Notification.Name{
    static let eventDidInsert = Notification.Name("eventDidInsert")
}

class ComposeViewController: UIViewController {

    var data: ComposeData?
    
    var selectedBackgroundColorIndexPath: IndexPath?
    var selectedTextColorIndexPath: IndexPath?
    
    let colors: [UIColor] = [
        .systemRed,
        .systemOrange,
        .systemYellow,
        .systemGreen,
        .systemBlue,
        .systemPurple,
        .systemPink,
        .systemTeal,
        .systemIndigo,
        .systemGray,
        .black,
        .white
    ]
    
    @IBOutlet weak var backgroundColorCollectionView: UICollectionView!
    @IBOutlet weak var textColorCollectionView: UICollectionView!
    @IBOutlet weak var titleField: UITextField!
    
    @IBAction func save(_ sender: Any) {
        guard let title = titleField.text else {return}
        data?.title = title
        //dump(data)
        if let data{
            let event = Event(data: data)
            events.append(event)
            
            NotificationCenter.default.post(name: .eventDidInsert, object: nil)
            dismiss(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var item = Int.random(in: 0 ..< colors.count)
        selectedBackgroundColorIndexPath = IndexPath(item: item, section: 0)
        data?.backgroundColor = colors[item]
        backgroundColorCollectionView.reloadData()
        
        item = Int.random(in: 0 ..< colors.count)
        selectedTextColorIndexPath = IndexPath(item: item, section: 0)
        data?.textColor = colors[item]
        textColorCollectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if titleField.isFirstResponder{
            titleField.resignFirstResponder()
        }
    }
}

extension ComposeViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        save(self)
        
        return true
    }
}

extension ComposeViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ColorCollectionViewCell.self), for: indexPath) as! ColorCollectionViewCell
        
        if indexPath.item == colors.count {
            cell.colorImageView.image = UIImage(named: "color-picker")
            cell.colorImageView.tintColor = nil
        } else {
            let target = colors[indexPath.item]
            cell.colorImageView.image = UIImage(named: "color-picker")?.withRenderingMode(.alwaysTemplate)
            cell.colorImageView.tintColor = target
        }
        
        cell.checkmarkImageView.isHidden = true
        
        if let selectedBackgroundColorIndexPath, selectedBackgroundColorIndexPath == indexPath, collectionView == backgroundColorCollectionView{
            cell.checkmarkImageView.isHidden = false
        } else if let selectedTextColorIndexPath, selectedTextColorIndexPath == indexPath, collectionView == textColorCollectionView{
            cell.checkmarkImageView.isHidden = false
        }
        //흰색이면 이미지뷰 틴트 컬러 변경, 흰색은 마지막에 있으니 count - 1
        if indexPath.item == colors.count - 1 {
            cell.checkmarkImageView.tintColor = .gray
        } else {
            cell.checkmarkImageView.tintColor = .white
        }
        return cell
    }
}

extension ComposeViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == colors.count {
            let colorPicker = UIColorPickerViewController()
            colorPicker.title = collectionView == backgroundColorCollectionView ? "배경색" : "글자색"
            colorPicker.supportsAlpha = false
            colorPicker.delegate = self
            
            present(colorPicker, animated: true)
        } else {
            //마지막 셀이 아니라면 컬러를 선택한 것.
            let target = colors[indexPath.item]
            
            if collectionView == backgroundColorCollectionView{
                data?.backgroundColor = target
            } else {
                data?.textColor = target
            }
            if collectionView == backgroundColorCollectionView{
                //이전에 선택했던 배경색의 체크 마크 없애기
                if let selectedBackgroundColorIndexPath, selectedBackgroundColorIndexPath != indexPath{
                    if let cell = collectionView.cellForItem(at: selectedBackgroundColorIndexPath) as? ColorCollectionViewCell{
                        cell.checkmarkImageView.isHidden = true
                    }
                }
                selectedBackgroundColorIndexPath = indexPath
            } else {
                if let selectedTextColorIndexPath, selectedTextColorIndexPath != indexPath{
                    if let cell = collectionView.cellForItem(at: selectedTextColorIndexPath) as? ColorCollectionViewCell{
                        cell.checkmarkImageView.isHidden = true
                    }
                }
                selectedTextColorIndexPath = indexPath
            }
            
            if let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell{
                cell.checkmarkImageView.isHidden = false
            }
        }
        
    }
}

extension ComposeViewController: UIColorPickerViewControllerDelegate{
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        
    }
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        if !continuously{
            let indexPath = IndexPath(item: colors.count, section: 0)
            
            if viewController.title == "배경색"{
                data?.backgroundColor = color
                
                if let selectedBackgroundColorIndexPath, selectedBackgroundColorIndexPath != indexPath{
                    if let cell = backgroundColorCollectionView.cellForItem(at: selectedBackgroundColorIndexPath) as? ColorCollectionViewCell{
                        cell.checkmarkImageView.isHidden = true
                    }
                }
                selectedBackgroundColorIndexPath = indexPath
                
                if let cell = backgroundColorCollectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell{
                    cell.checkmarkImageView.isHidden = false
                }
            } else {
                data?.textColor = color
                
                if let selectedTextColorIndexPath, selectedTextColorIndexPath != indexPath{
                    if let cell = textColorCollectionView.cellForItem(at: selectedTextColorIndexPath) as? ColorCollectionViewCell{
                        cell.checkmarkImageView.isHidden = true
                    }
                }
                selectedTextColorIndexPath = indexPath
                
                if let cell = textColorCollectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell{
                    cell.checkmarkImageView.isHidden = false
                }
            }
        }
    }
}
