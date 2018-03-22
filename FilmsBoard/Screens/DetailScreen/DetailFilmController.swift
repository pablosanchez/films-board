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

    @IBOutlet weak var backImagePortrait: UIImageView!
    @IBOutlet weak var backImageLandscape: UIImageView!
    
    @IBOutlet weak var mainImagePortrait: UIImageView!
    @IBOutlet weak var mainImageLandscape: UIImageView!
    
    
    
    @IBOutlet weak var mediaTitle: UILabel!
    @IBOutlet weak var mediaYear: UILabel!
    @IBOutlet weak var mediaDescription: UILabel!
    @IBOutlet weak var mediaGenres: UILabel!
    
    @IBOutlet weak var mediaRating: CosmosView!
    
    
    
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

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToList))
        
        navigationController?.navigationBar.barTintColor = UIColor.init(named: "Primary_Dark")
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.isOpaque = true
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        
        self.bindViews()
    }
    
    
    
    private func bindViews() {
        self.backImagePortrait.sd_setImage(with: URL(string: viewModel.backImage),
                                   placeholderImage: nil, options: [], completed: nil)
        self.backImageLandscape.sd_setImage(with: URL(string: viewModel.backImage),
                                           placeholderImage: nil, options: [], completed: nil)
        
        
        self.mainImagePortrait.sd_setImage(with: URL(string: viewModel.mainImage),
                                           placeholderImage: nil, options: [], completed: nil)
        self.mainImageLandscape.sd_setImage(with: URL(string: viewModel.mainImage),
                                           placeholderImage: nil, options: [], completed: nil)
        
        
        self.mediaTitle.text = viewModel.title
        self.mediaYear.text = viewModel.year
        self.mediaDescription.text = viewModel.overview
        self.mediaGenres.text = "Unkown"
        self.mediaRating.rating = Double(viewModel.rating / 2)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func watchTrailer(_ sender: Any) {
        
    }
    
    
    
    @objc func addToList(_ sender: Any) {
        let alertController = UIAlertController(title: "Añadir a la lista:", message: nil, preferredStyle: .actionSheet)
        let actionCancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        
        let deleteFromLists = UIAlertAction(title: "Borrar de las listas", style: .destructive  , handler: {(accion) in
            
            let alertDelete = UIAlertController(title: "Borrar de las listas", message: "Nombre de la lista: ", preferredStyle: .alert)
            
            alertDelete.addTextField{ (tf) in
                tf.placeholder = "Nombre"
            }
            
            let actionYes = UIAlertAction(title: "Borrar", style: .destructive, handler: {(action) in
                guard let name = alertDelete.textFields?.first?.text
                    else { return }
                
                self.viewModel.deleteFromList(listName: name.capitalized)
            })
            let actionNo = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            
            
            alertDelete.addAction(actionYes)
            alertDelete.addAction(actionNo)
            self.present(alertDelete, animated: true, completion: nil)
        })
        
        
        
        for listName in self.viewModel.retrieveListNames() {
            let alert = UIAlertAction(title: listName, style: .default, handler: {(accion) in
                self.viewModel.addFilmToList(listName: listName)
            })
            
            alertController.addAction(alert)
        }
        
        alertController.addAction(actionCancel)
        alertController.addAction(deleteFromLists)
        
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func addReminder(_ sender: Any) {
        
    }

}
