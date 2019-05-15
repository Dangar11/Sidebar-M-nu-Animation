//
//  DetailViewController.swift
//  Sidebar Manu Animation
//
//  Created by Igor Tkach on 5/15/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit


class DetailViewController: UIViewController {
  @IBOutlet weak var backgroundImageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor(named: "rw-dark")
  }
  
  var menuItem: MenuItem? {
    didSet {
      prepare(menuItem)
    }
  }
  
  func prepare(_ menuItem: MenuItem?) {
    if let newMenuItem = menuItem {
      backgroundImageView?.image = newMenuItem.bigImage
    }
  }
}
