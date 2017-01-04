//
//  ItemCell.swift
//  DreamLister
//
//  Created by Jorge Gomez on 2016-12-17.
//  Copyright © 2016 Jorge Gomez. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

  @IBOutlet weak var thumb: UIImageView!
  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var price: UILabel!
  @IBOutlet weak var details: UILabel!

  func configureCell(item: Item){
    title.text = item.title
    price.text = "$\(item.price)"
    details.text = item.details
    thumb.image = item.toImage?.image as? UIImage
  }


}
