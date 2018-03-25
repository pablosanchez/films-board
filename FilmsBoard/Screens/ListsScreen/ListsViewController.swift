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

    private var addButton: UIBarButtonItem!
    
    private let viewModel: ListsViewModel

    weak var delegate: ListsViewControllerDelegate?
    
    init(viewModel: ListsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Mis listas"

        self.addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ListsViewController.addNewList))
        navigationItem.rightBarButtonItem = addButton
        
        self.initTableView()

        self.lists.dataSource = self
        self.lists.delegate = self
    }
}

extension ListsViewController {

    private func initTableView() {
        let rowNib = UINib(nibName: "ListsViewCell", bundle: nil)
        self.lists.register(rowNib, forCellReuseIdentifier: CELL_ID)
    }
    
    @objc
    private func addNewList() {
        let alertDelete = UIAlertController(title: "Añadir lista nueva", message: "Nombre de la lista: ", preferredStyle: .alert)
        
        alertDelete.addTextField{ (tf) in
            tf.placeholder = "Nombre"
        }
        
        let actionAccept = UIAlertAction(title: "Aceptar", style: .default) { (action) in
            guard let name = alertDelete.textFields?.first?.text
                else { return }
            self.viewModel.addNewList(listName: name.capitalized)
        }

        let actionCancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)

        alertDelete.addAction(actionAccept)
        alertDelete.addAction(actionCancel)

        let isIpad = self.traitCollection.horizontalSizeClass == .regular
            && self.traitCollection.verticalSizeClass == .regular

        if !isIpad {
            self.present(alertDelete, animated: true, completion: nil)
        } else {
            alertDelete.popoverPresentationController?.barButtonItem = self.addButton

            self.present(alertDelete, animated: true, completion: nil)
        }
    }
}

extension ListsViewController: ListsViewModelDelegate {

    // MARK: ListsViewModelDelegate methods
    func updateTableView() {
        self.lists.reloadData()
    }
}

extension ListsViewController: UITableViewDataSource {

    // MARK: UITableViewDataSource methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.retrieveListNames().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! ListsViewCell
        let name = viewModel.retrieveListNames()[indexPath.row]
        
        let list = List(listName: name, count: viewModel.getListCount(listName: name))
        cell.viewModel = ListCellViewModel(model: list)
        
        return cell
    }
}

extension ListsViewController: UITableViewDelegate {

    // UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ListsViewCell

        if let vm = cell.viewModel {
            self.delegate?.cellLitsTapped(listName: vm.title)
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cell = tableView.cellForRow(at: indexPath) as! ListsViewCell
            
            if let vm = cell.viewModel {
                if self.viewModel.checkBasicList(listName: vm.title) {
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

protocol ListsViewControllerDelegate: class {
    func cellLitsTapped(listName: String)
}
