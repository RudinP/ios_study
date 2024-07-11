//
//  PhotoData.swift
//  HelloOperation
//
//  Created by 루딘 on 7/11/24.
//

import UIKit

class PhotoData{
    let url: URL
    var data: UIImage?
    
    init(url: String){
        self.url = URL(string: url)!
    }
}
