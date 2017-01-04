//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Jorge Gomez on 2016-12-18.
//  Copyright © 2016 Jorge Gomez. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  @IBOutlet weak var detailsTextField: CustomTextField!
  @IBOutlet weak var priceTextField: CustomTextField!
  @IBOutlet weak var titleTextField: CustomTextField!
  @IBOutlet weak var storePicker: UIPickerView!
  @IBOutlet weak var saveButton: UIButton!
  @IBOutlet weak var deleteButton: UIBarButtonItem!
  @IBOutlet weak var thumbImage: UIImageView!
  
  
  var stores = [Store]()
  var itemToEdit: Item?
  var imagePicker: UIImagePickerController!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let topItem = self.navigationController?.navigationBar.topItem {
          topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
      
        storePicker.delegate = self
        storePicker.dataSource = self
      
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
      
        getStores()
      
        if itemToEdit != nil {
          
          loadItemInfo()
        
        }
        self.hideKeyboardWhenTappedAround()
      
        
    
    }
  
  
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      return stores.count
    }
  
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) ->
      
      String? {
      let store = stores[row]
      return store.name
      
    }
  
    //number of columns
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
      
        return 1
    }
  
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//      
//    }
  
    func getStores(){
      
      let fetchRequest : NSFetchRequest<Store> = Store.fetchRequest()
      
      do {
        self.stores = try context.fetch(fetchRequest)
        self.storePicker.reloadAllComponents()
      } catch {
      
        print("FETCHING STORES FAILED!")
      
      }
    }

  @IBAction func saveButton(_ sender: Any) {
    
    var newItem: Item!
    
    //creates an entity Image
    let picture = Image(context: context)
    
    //The picture selected gets store in the image entity
    picture.image = thumbImage.image
    
    
    //if itemToEdit is null means that we pressed the + sign to create a new item. 
    //Therefore we create a new Item entity. Otherwise we use the item selected from tableView.
    if itemToEdit == nil {
    
       newItem = Item(context: context)
      
    }
    else {
      //item passed from tapping item in tableView
       newItem = itemToEdit
      
    }
    
    //Then the entity image is assigned to the current Item entity selected
    newItem.toImage = picture

    
    //SETUP all the text fields.
    
    if let title = titleTextField.text {
      
      newItem.title = title
      
    }
    
    if let price = priceTextField.text{
    
      newItem.price = (price as NSString).intValue
    
    }
    
    if let details = detailsTextField.text {
    
        newItem.details = details
    
    }
    
    //inComponents is 0 because we only have 1 column.
    newItem.toStore = stores[storePicker.selectedRow(inComponent: 0)]
    
    //SAVES data to CoreData
    ad.saveContext()
    
    
    //go back to previous viewController
    _ = navigationController?.popViewController(animated: true)
  }
  
  func loadItemInfo(){
    
    if let item = itemToEdit {
    
      titleTextField.text = item.title
      priceTextField.text = "\(item.price)"
      detailsTextField.text = item.details
      thumbImage.image = item.toImage?.image as? UIImage
      
      if let store = item.toStore {
        var count = 0
        for i in stores {
          if i.name == store.name! {
            storePicker.selectRow(count, inComponent: 0, animated: true)
          }
          count += 1
        }
      }
    }
  }
  
  @IBAction func deletePressed(_ sender: Any) {
    
    if itemToEdit != nil {
      
      context.delete(itemToEdit!)
      ad.saveContext()
    }
    
    _ = navigationController?.popViewController(animated: true)
  }
  
  
  @IBAction func addImageButton(_ sender: Any) {
  
    present(imagePicker, animated: true, completion: nil)
  
  }
  
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
  
    if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
      
        thumbImage.image = image
      
    }
    
    imagePicker.dismiss(animated: true, completion: nil)
  }
  
}
