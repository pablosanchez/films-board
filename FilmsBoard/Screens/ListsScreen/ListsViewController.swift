//
//  ListsController.swift
//  FilmsBoard
//
//  Created by Javier Garcia on 24/3/18.
//  Copyright © 2018 Pablo. All rights reserved.
//

import UIKit

class ListsViewController: UIViewController {

    @IBOutlet weak var lists: UITableView!
    
    private let CELL_ID = "list_item"
    
    private let viewModel: ListsViewModel
    
    
    init(viewModel: ListsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Mis listas"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewList))
        
        self.initTableView()
        self.viewModel.delegate = self
        self.lists.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}



extension ListsViewController {
    private func initTableView() {
        let rowNib = UINib(nibName: "ListsViewCell", bundle: nil)
        self.lists.register(rowNib, forCellReuseIdentifier: CELL_ID)
        
        self.lists.dataSource = self
    }
    
    
    
    @objc private func addNewList() {
        let alertDelete = UIAlertController(title: "Añadir lista nueva", message: "Nombre de la lista: ", preferredStyle: .alert)
        
        alertDelete.addTextField{ (tf) in
            tf.placeholder = "Nombre"
        }
        
        let actionAccept = UIAlertAction(title: "Aceptar", style: .default, handler: {(action) in
            guard let name = alertDelete.textFields?.first?.text
                else { return }
            self.viewModel.addNewList(listName: name.capitalized)
        })
        let actionCancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        
        alertDelete.addAction(actionAccept)
        alertDelete.addAction(actionCancel)
        self.present(alertDelete, animated: true, completion: nil)
        
    }
}



extension ListsViewController: ListsViewModelDelegate {
    func updateTableView() {
        self.lists.reloadData()
    }
}





extension ListsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.retrieveListNames().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! ListsViewCell
        let name = viewModel.retrieveListNames()[indexPath.row]
        
        let list = List(listName: name,
                        count: viewModel.getListCount(listName: name))
        cell.viewModel = ListCellViewModel(model: list)
        
        return cell
    }
    
    
}




extension ListsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cell = tableView.cellForRow(at: indexPath) as! ListsViewCell
            
            if let vm = cell.viewModel {
                if self.viewModel.checkBasicList(listName: vm.title)
                {
                    let alertDelete = UIAlertController(title: "Error", message: "¡Esta lista es permanente, no se puede borrar!", preferredStyle: .alert)
                    
                    let actionOk = UIAlertAction(title: "Entendido", style: .cancel, handler: nil)
                    alertDelete.addAction(actionOk)
                    present(alertDelete, animated: true, completion: nil)
                } else {
                    self.viewModel.deleteList(listName: vm.title)
                    self.lists.reloadData()
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Eliminar"
    }
}





