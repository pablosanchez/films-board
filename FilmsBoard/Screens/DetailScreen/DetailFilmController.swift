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
    
    
    
    @IBOutlet weak var buttonStyle: UIButton!
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

        self.buttonStyler()
        self.title = "Película"
        self.bindViews()
    }
    
    
    
    private func buttonStyler()
    {
        self.buttonStyle.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 15.0, bottom: 5.0, right: 15.0)
        
        self.buttonStyle.layer.cornerRadius = 2
        self.buttonStyle.layer.borderWidth = CGFloat(1.0)
        self.buttonStyle.layer.borderColor = UIColor(named: "Primary_Dark")?.cgColor
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
        
        
        
        
        var buttons: [UIBarButtonItem] = []
        
        buttons.append(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToList)))
        
        if viewModel.checkIfCanRemind() {
            buttons.append(UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(addReminder)))
        }
        
        
        navigationItem.rightBarButtonItems = buttons
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func watchTrailer(_ sender: Any) {
        viewModel.watchTrailer()
    }
    
    
    
    @objc func addToList() {
        let alertController = UIAlertController(title: "Añadir a la lista:", message: nil, preferredStyle: .actionSheet)
        let actionCancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        
        let deleteFromLists = UIAlertAction(title: "Borrar unna lista", style: .destructive  , handler: {(accion) in
            
            let alertDelete = UIAlertController(title: "Borrar una lista", message: "Nombre de la lista: ", preferredStyle: .alert)
            
            alertDelete.addTextField{ (tf) in
                tf.placeholder = "Nombre"
            }
            
            let actionYes = UIAlertAction(title: "Borrar", style: .destructive, handler: {(action) in
                guard let name = alertDelete.textFields?.first?.text
                    else { return }
                
                if name.capitalized != "Recordatorios"{
                    self.viewModel.deleteFromList(listName: name.capitalized)
                }
            })
            let actionNo = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            
            
            alertDelete.addAction(actionYes)
            alertDelete.addAction(actionNo)
            self.present(alertDelete, animated: true, completion: nil)
        })
        
        
        
        
        for listName in self.viewModel.retrieveListNames() {
            if listName != "Recordatorios" {
                let alert = UIAlertAction(title: listName, style: .default, handler: {(accion) in
                    self.viewModel.addFilmToList(listName: listName)
                })
                
                alertController.addAction(alert)
            }
        }
        
        alertController.addAction(actionCancel)
        alertController.addAction(deleteFromLists)
        
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    @objc func addReminder() {
        let alertController = UIAlertController(title: "Crear recordatorio", message: nil, preferredStyle: .actionSheet)
        let actionCancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        
        
        let createReminder = UIAlertAction(title: "Crear recordatorio", style: .default, handler: {(accion) in
            self.viewModel.addFilmToList(listName: "Recordatorios")
            self.viewModel.createReminder()
        })
        
        
        let removeReminder = UIAlertAction(title: "Eliminar recordatorio", style: .destructive  , handler: {(accion) in
            
            let alertDelete = UIAlertController(title: "Eliminar recordatorio", message: "¿Desea eliminar el recordatorio?", preferredStyle: .alert)
            
            let actionYes = UIAlertAction(title: "Sí", style: .destructive, handler: {(action) in
                self.viewModel.deleteFromList(listName: "Recordatorios")
                self.viewModel.removeReminder()
            })
            let actionNo = UIAlertAction(title: "No", style: .cancel, handler: nil)
            
            
            alertDelete.addAction(actionYes)
            alertDelete.addAction(actionNo)
            self.present(alertDelete, animated: true, completion: nil)
        })
        
        
        if viewModel.checkIfIsReminding() {
            alertController.addAction(removeReminder)
        } else {
            alertController.addAction(createReminder)
        }
        
        alertController.addAction(actionCancel)
        
        present(alertController, animated: true, completion: nil)
    }

}
