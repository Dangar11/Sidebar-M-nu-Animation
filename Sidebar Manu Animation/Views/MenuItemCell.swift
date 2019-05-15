//
//  MenuItemCell.swift
//  Sidebar Manu Animation
//
//  Created by Igor Tkach on 5/15/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit


class MenuItemCell: UITableViewCell {
  @IBOutlet weak var menuItemImageView: UIImageView!
  
  func configureForMenuItem(_ menuItem: MenuItem) {
    menuItemImageView.image = menuItem.image
    menuItemImageView.image?.withRenderingMode(.alwaysTemplate)
    menuItemImageView.tintColor = .white
  }
}
