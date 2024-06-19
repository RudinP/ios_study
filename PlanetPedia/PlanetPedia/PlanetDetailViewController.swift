//
//  PlanetDetailViewController.swift
//  PlanetPedia
//
//  Created by 루딘 on 6/19/24.
//

import UIKit

class PlanetDetailViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var planet: Planet? //ViewController 생성 시 해당 값을 채울 수 없기 때문에 optional
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let planet {
            let img = UIImage(named: planet.englishName.lowercased())
            backgroundImageView.image = img
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
