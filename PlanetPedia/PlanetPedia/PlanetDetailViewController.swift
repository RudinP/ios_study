//
//  PlanetDetailViewController.swift
//  PlanetPedia
//
//  Created by 루딘 on 6/19/24.
//

import UIKit

class PlanetDetailViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    private let planet: Planet
    
    init?(planet: Planet, coder: NSCoder){
        self.planet = planet
        
        super.init(coder: coder)
    }
    
    //failable initializer
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let img = UIImage(named: planet.englishName.lowercased())
        backgroundImageView.image = img
        
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
