//
//  DetailFilmController.swift
//  FilmsBoard
//
//  Created by Javier Garcia on 14/3/18.
//  Copyright © 2018 Pablo. All rights reserved.
//

import UIKit
import Cosmos
import MBProgressHUD

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

    private var progressIndicator: MBProgressHUD!

    private let viewModel: DetailFilmViewModel

    init(viewModel: DetailFilmViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()


        self.title = "Película"


        self.buttonStyler()
        self.requestData()
    }
    
    
    
    private func buttonStyler()
    {
        self.buttonStyle.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 15.0, bottom: 5.0, right: 15.0)
        
        self.buttonStyle.layer.cornerRadius = 2
        self.buttonStyle.layer.borderWidth = CGFloat(1.0)
        self.buttonStyle.layer.borderColor = UIColor(named: "Primary_Dark")?.cgColor
    }
    
    
    private func bindViews() {
        self.backImagePortrait.sd_setImage(with: URL(string: self.viewModel.backImage), completed: nil)
        self.backImageLandscape.sd_setImage(with: URL(string: self.viewModel.backImage), completed: nil)
        self.mainImagePortrait.sd_setImage(with: URL(string: self.viewModel.mainImage), completed: nil)
        self.mainImageLandscape.sd_setImage(with: URL(string: self.viewModel.mainImage), completed: nil)
        
        
        self.mediaTitle.text = self.viewModel.title
        self.mediaYear.text = self.viewModel.releaseDate
        self.mediaDescription.text = self.viewModel.overview
        self.mediaGenres.text = self.viewModel.genres
        self.mediaRating.rating = self.viewModel.rating
        
        
        
        
        var buttons: [UIBarButtonItem] = []
        
        buttons.append(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToList)))
        
        if viewModel.checkIfCanRemind() {
            buttons.append(UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(addReminder)))
        }
        
        
        navigationItem.rightBarButtonItems = buttons
    }
    
    


    
    

    @IBAction func watchTrailer(_ sender: Any) {
        viewModel.watchTrailer()
    }
}

extension DetailFilmController {

    @objc func addToList() {
        let alertController = UIAlertController(title: "Añadir a la lista:", message: nil, preferredStyle: .actionSheet)
        let actionCancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)

        let deleteFromLists = UIAlertAction(title: "Borrar de las listas", style: .destructive) { (action) in

            let alertDelete = UIAlertController(title: "Borrar de las listas", message: "Nombre de la lista: ", preferredStyle: .alert)

            alertDelete.addTextField{ (tf) in
                tf.placeholder = "Nombre"
            }

            let actionYes = UIAlertAction(title: "Borrar", style: .destructive) { (action) in
                guard let name = alertDelete.textFields?.first?.text
                    else { return }

                if name.capitalized != "Recordatorios"{
                    self.viewModel.deleteFromList(listName: name.capitalized)
                }
            }
            let actionNo = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)

            alertDelete.addAction(actionYes)
            alertDelete.addAction(actionNo)
            self.present(alertDelete, animated: true, completion: nil)
        }

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

        self.present(alertController, animated: true, completion: nil)
    }

    @objc func addReminder() {
        let alertController = UIAlertController(title: "Crear recordatorio", message: nil, preferredStyle: .actionSheet)
        let actionCancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)

        let createReminder = UIAlertAction(title: "Crear recordatorio", style: .default) { (action) in
            self.viewModel.addFilmToList(listName: "Recordatorios")
            self.viewModel.createReminder()
        }

        let removeReminder = UIAlertAction(title: "Eliminar recordatorio", style: .destructive) { (action) in
            let alertDelete = UIAlertController(title: "Eliminar recordatorio", message: "¿Desea eliminar el recordatorio?", preferredStyle: .alert)

            let actionYes = UIAlertAction(title: "Sí", style: .destructive) { (action) in
                self.viewModel.deleteFromList(listName: "Recordatorios")
                self.viewModel.removeReminder()
            }
            let actionNo = UIAlertAction(title: "No", style: .cancel, handler: nil)

            alertDelete.addAction(actionYes)
            alertDelete.addAction(actionNo)
            self.present(alertDelete, animated: true, completion: nil)
        }

        if viewModel.checkIfIsReminding() {
            alertController.addAction(removeReminder)
        } else {
            alertController.addAction(createReminder)
        }

        alertController.addAction(actionCancel)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension DetailFilmController {

    private func initNavigationItem() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToList))

        if viewModel.checkIfCanRemind() {
            let remindButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(addReminder))
            self.navigationItem.rightBarButtonItems = [addButton, remindButton]
        } else {
            self.navigationItem.rightBarButtonItem = addButton
        }
    }

    private func requestData() {
        self.progressIndicator = MBProgressHUDBuilder.makeProgressIndicator(view: self.view)
        self.viewModel.getDetails()
    }
}


extension DetailFilmController: DetailFilmViewModelDelegate {

    func detailFilmViewModelDidUpdateData(_ viewModel: DetailFilmViewModel) {
        self.progressIndicator.hide(animated: true)
        self.bindViews()
    }

    func detailFilmViewModel(_ viewModel: DetailFilmViewModel, didGetError error: String) {
        self.progressIndicator.hide(animated: true)
        SCLAlertViewBuilder()
            .setTitle("Aviso")
            .setSubtitle(error)
            .setCloseButtonTitle("Ok")
            .setCircleIconImage(UIImage(named: "ic-no-network"))
            .show()
    }
}
