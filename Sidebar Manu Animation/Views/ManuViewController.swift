//
//  ManuViewController.swift
//  Sidebar Manu Animation
//
//  Created by Igor Tkach on 5/15/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit


protocol MenuDelegate: class {
  func didSelectMenuItem(_ item: MenuItem)
}

class MenuViewController: UITableViewController {
  
  weak var delegate: MenuDelegate?
  
  let maxCellHeight: CGFloat = 120
  private var datasource: MenuDataSource = MenuDataSource()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = datasource
    tableView.isScrollEnabled = false
  }
  
  
  
  override func tableView(_ tableView: UITableView,
                          heightForRowAt indexPath: IndexPath) -> CGFloat {
    let proposedHeight = tableView.safeAreaLayoutGuide.layoutFrame.height/CGFloat(datasource.menuItems.count)
    return min(maxCellHeight, proposedHeight)
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //Pass selected menuItem to the delegate
    let item = datasource.menuItems[indexPath.row]
    delegate?.didSelectMenuItem(item)
    
    
    //remove highlights
    DispatchQueue.main.async {
      tableView.deselectRow(at: indexPath, animated: true)
    }
  }
}
