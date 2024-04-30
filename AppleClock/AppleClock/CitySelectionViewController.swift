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
    var filteredList = [Section]()
    
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
        filteredList = list
    }
    
    @objc func closeVC(){
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchBar = UISearchBar()
        searchBar.placeholder = "검색"
        searchBar.delegate = self
        
        let btn = UIButton(type: .custom)
        btn.setTitle("취소", for: .normal)
        btn.setTitleColor(.systemOrange, for: .normal)
        btn.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        btn.widthAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [searchBar, btn])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.widthAnchor.constraint(greaterThanOrEqualToConstant: view.bounds.width - 40).isActive = true
        navigationItem.titleView = stack
        
        setupList()
        tableView.reloadData()
    }
}

extension CitySelectionViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //공백을 입력할 경우 별도로 서치 필요 X, 모든 결과를 보여주기
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            filteredList = list
            tableView.reloadData()
            tableView.isHidden = filteredList.isEmpty
            return
        }
        //검색어가 입력되었을 경우
        //이전 검색 시 사용했을 경우를 위해 removeAll로 배열 초기화
        filteredList.removeAll()
        
        for section in list{
            let items = section.items.filter{ $0.title.lowercased().contains(searchText.lowercased()) }
            
            //비어있지 않은 경우 == 검색 결과 존재
            if !items.isEmpty {
                filteredList.append(Section(title: section.title, items:  items))
            }
        }
        
        tableView.reloadData()
        tableView.isHidden = filteredList.isEmpty
    }
}

extension CitySelectionViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredList[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        cell.textLabel?.text = filteredList[indexPath.section].items[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filteredList[section].title
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        let consonantsAndAlphabets: [String] = ["ㄱ", "ㄴ", "ㄷ", "ㄹ", "ㅁ", "ㅂ", "ㅅ", "ㅇ", "ㅈ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

        return consonantsAndAlphabets
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return filteredList.firstIndex(where: {$0.title.uppercased() == title.uppercased()}) ?? 0
    }
}

extension CitySelectionViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let target = filteredList[indexPath.section].items[indexPath.row]
        
        NotificationCenter.default.post(name: .timeZoneDidSelect, object: nil, userInfo: ["timeZone": target.timeZone])
        
        dismiss(animated: true)
    }
}

extension Notification.Name{
    static let timeZoneDidSelect = Notification.Name(rawValue: "timeZoneDidSelect")
}
