//
//  ViewController.swift
//  ChopinLiszt
//
//  Created by Michele Galvagno on 05/03/2019.
//  Copyright © 2019 Michele Galvagno. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    // MARK: - Properties & Outlets
    var shoppingList = [String]()
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    // MARK: - Actions
    @IBAction func editTapped(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
        deleteButton.isEnabled = !deleteButton.isEnabled
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        deleteList()
    }
    
    // MARK: - Views Management
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ChopinLiszt"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
//        navigationItem.leftBarButtonItem = editButtonItem
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteList))
    }
    
    // MARK: - Methods
    // Triggers an alert where the user can type into
    @objc func addItem() {
        tableView.isEditing = false
        
        let alertController = UIAlertController(title: "Item", message: "Type in something to buy...", preferredStyle: .alert)
        alertController.addTextField()
        
        let alertAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak alertController] _ in
            guard let item = alertController?.textFields?[0].text else { return }
            self?.submit(item)
        }
        
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
    
    // Inserts items in the array and then in the table-view
    func submit(_ item: String) {
        shoppingList.insert(item, at: 0)
        
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        deleteButton.isEnabled = true
        editButton.isEnabled = true
        
        return
    }
    
    // Deletes every item in the list on tap
    /* @objc */ func deleteList() {
        shoppingList.removeAll()
        
        tableView.reloadData()
        deleteButton.isEnabled = false
        editButton.isEnabled = false
    }
    
    // MARK: - Table View Data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        
        return cell
    }
    
    // Mark: - Table View Delegate Methods
    // Enable deselecting animation (to look nice)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Enable swipe-to-delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        shoppingList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    // Allow global editing
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        tableView.setEditing(tableView.isEditing, animated: true)
    }
}

