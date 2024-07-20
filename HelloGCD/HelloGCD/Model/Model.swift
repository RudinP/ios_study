//
//  Model.swift
//  HelloGCD
//
//  Created by 루딘 on 7/20/24.
//

import UIKit

class PhotoData{
    let url: URL
    var data: UIImage?
    
    init(url: String){
        self.url = URL(string: url)!
    }
}

struct PhotoDataSource{
    var list: [PhotoData]
    
    init(){
        var list = [PhotoData]()
        
        for num in 1...20 {
            let url = "https://kxcodingblob.blob.core.windows.net/mastering-ios/\(num).jpg"
            let data = PhotoData(url: url)
            list.append(data)
        }
        
        self.list = list
    }
}
