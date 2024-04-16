//
//  CitySelectionViewController.swift
//  AppleClock
//
//  Created by 루딘 on 4/16/24.
//

import UIKit

struct Item{
    let title: String
    let timeZone: TimeZone
}

struct Section{
    let title: String
    let items: [Item]
}

class CitySelectionViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var list = [Section]()
    
    func setupList(){
        var dict = [String: [TimeZone]]()
        
        for id in TimeZone.knownTimeZoneIdentifiers{
            guard let city = id.components(separatedBy: "/").last else {continue}
            
            var timeZoneList = [TimeZone(identifier: id)!]
            let key = city.chosung ?? "Unknown"
            
            //해당 초성 배열이 있는 경우
            if let list = dict[key] {
                timeZoneList.append(contentsOf: list)
            }
            //해당 초성 배열이 없는 경우
            dict[key] = timeZoneList
        }
        
        for (key, value) in dict{
            let items = value.sorted {
                guard let lhs = $0.city, let rhs = $1.city else {return false}
                return lhs < rhs
            }.map {
                Item(title: $0.city ?? $0.identifier, timeZone: $0)
            }
            
            let section = Section(title: key, items: items)
            list.append(section)
        }
        
        list.sort{$0.title < $1.title}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupList()
        tableView.reloadData()
    }
}

extension CitySelectionViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        cell.textLabel?.text = list[indexPath.section].items[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return list[section].title
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        let consonantsAndAlphabets: [String] = ["ㄱ", "ㄴ", "ㄷ", "ㄹ", "ㅁ", "ㅂ", "ㅅ", "ㅇ", "ㅈ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

        return consonantsAndAlphabets
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return list.firstIndex(where: {$0.title.uppercased() == title.uppercased()}) ?? 0
    }
}
