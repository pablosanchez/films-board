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
    
    
    private let viewModel: DetailFilmViewModel
    
    
    
    init(viewModel: DetailFilmViewModel)
    {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Película"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        
        navigationController?.navigationBar.barTintColor = UIColor.init(named: "Primary_Dark")
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.isOpaque = true
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func watchTrailer(_ sender: Any) {
        
    }
    
    
    
    @IBAction func addToList(_ sender: Any) {
        
    }
    
    
    
    @IBAction func addReminder(_ sender: Any) {
        
    }

}
