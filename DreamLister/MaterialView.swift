//
//  MaterialView.swift
//  DreamLister
//
//  Created by Jorge Gomez on 2016-12-17.
//  Copyright © 2016 Jorge Gomez. All rights reserved.
//

import UIKit

private var materialKey = false

extension UIView{

  @IBInspectable var materialDesign: Bool {
    get {
      return materialKey
    }
    set {
      materialKey = newValue
      
      if materialKey {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 5.0
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 5.0
        self.layer.shadowOffset  = CGSize(width: 0.0, height: 0.15)
        self.layer.shadowColor = UIColor(red: 200/255, green: 0/255, blue: 0/255, alpha: 1.0).cgColor
      }
      else {
        self.layer.cornerRadius = 0
        self.layer.shadowOpacity = 0
        self.layer.shadowRadius = 0
        self.layer.shadowColor = nil
      }
    }
  }
}

