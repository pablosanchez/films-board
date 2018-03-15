//
//  DetailFilmController.swift
//  FilmsBoard
//
//  Created by Javier Garcia on 14/3/18.
//  Copyright © 2018 Pablo. All rights reserved.
//

import UIKit
import Cosmos


class DetailFilmController: UIViewController {

    @IBOutlet weak var secondaryImage: UIImageView!
    @IBOutlet weak var mainImage: UIImageView!
    
    
    @IBOutlet weak var title_: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var description_: UILabel!
    @IBOutlet weak var genres: UILabel!
    
    @IBOutlet weak var rating: CosmosView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func watchTrailer(_ sender: Any) {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
