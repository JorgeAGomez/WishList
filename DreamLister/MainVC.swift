//
//  MainVC.swift
//  DreamLister
//
//  Created by Jorge Gomez on 2016-12-17.
//  Copyright © 2016 Jorge Gomez. All rights reserved.
//

import UIKit
import Foundation
import CoreData


class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

  @IBOutlet weak var segmentedControl: UISegmentedControl!
  @IBOutlet weak var tableView: UITableView!
  
  var controller: NSFetchedResultsController<Item>!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    
    attemptFetch()
    self.hideKeyboardWhenTappedAround()
    
    let fetchRequest : NSFetchRequest<Store> = Store.fetchRequest()
      
    do {
      
        let stores = try context.fetch(fetchRequest)
      
        if stores.count == 0 {
        
          createStores()
        
        }
      } catch {
      
        print("FETCHING STORES FAILED!")
      
      }
    
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ItemDetailsVC" {
      if let destination = segue.destination as? ItemDetailsVC {
        if let item = sender as? Item {
          destination.itemToEdit = item
        }
      }
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let objects = controller.fetchedObjects, objects.count > 0 {
      
      let item = objects[indexPath.row]
      performSegue(withIdentifier:"ItemDetailsVC", sender: item)
    }
    
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let sections = controller.sections {
      let sectionInfo = sections[section]
      return sectionInfo.numberOfObjects
    }
    
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemCell
    configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
    
    return cell
  }
  
  func configureCell(cell: ItemCell, indexPath: NSIndexPath){
    let item = controller.object(at: indexPath as IndexPath)
    cell.configureCell(item: item)
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    
    if let sections = controller.sections {
      return sections.count
    }
    
    return 0
  }
  
  //makes sure the rows stays at this height
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 150
  }
  
  func attemptFetch(){
    let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
    
    //sorting items in tableView
    let dateSort = NSSortDescriptor(key: "created", ascending: true)
    let priceSort = NSSortDescriptor(key: "price", ascending: true)
    let titleSort = NSSortDescriptor(key: "title", ascending: false)
    
    if segmentedControl.selectedSegmentIndex == 0 {
      
        fetchRequest.sortDescriptors = [dateSort]
    
    } else if segmentedControl.selectedSegmentIndex == 1 {
    
      fetchRequest.sortDescriptors = [priceSort]
    
    } else if segmentedControl.selectedSegmentIndex == 2{
    
      fetchRequest.sortDescriptors = [titleSort]
    
    }
    
    let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    
    controller.delegate = self
    self.controller = controller
    
    do {
      try controller.performFetch()
    } catch {
      let error = error as NSError
      print("\(error)")
    }
  }
  
  
  @IBAction func segmentChange(_ sender: Any) {
    
    attemptFetch()
    tableView.reloadData()
  
  }
  
  
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    
    switch(type){
      
      case.insert:
        if let indexPath = newIndexPath {
          tableView.insertRows(at: [indexPath], with: .fade)
        }
        break
      case.delete:
        if let indexPath = indexPath{
          tableView.deleteRows(at: [indexPath], with: .fade)
        }
        break
      case.update:
        if let indexPath = indexPath{
          let cell = tableView.cellForRow(at: indexPath) as! ItemCell
          configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        }
        break
      
      case.move:
        if let indexPath = indexPath{
          tableView.deleteRows(at: [indexPath], with: .fade)
        }
        if let indexPath = newIndexPath{
          tableView.insertRows(at: [indexPath], with: .fade)
        }
        break
    }
  
  }
  

  func createStores(){
    let store1 = Store(context: context)
    store1.name = "Best Buy"
    
    let store2 = Store(context: context)
    store2.name = "Amazon"
    
    let store3 = Store(context: context)
    store3.name = "Memory Express"
    
    let store4 = Store(context: context)
    store4.name = "Future shop"
    
    let store5 = Store(context: context)
    store5.name = "Walmart"
    
    let store6 = Store(context: context)
    store6.name = "Apple"
  }
  
}

  
  extension UIViewController
  {
    func hideKeyboardWhenTappedAround()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    func dismissKeyboard()
    {
        view.endEditing(true)
    }
  }

