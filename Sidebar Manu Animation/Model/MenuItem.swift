//
//  MenuItem.swift
//  Sidebar Manu Animation
//
//  Created by Igor Tkach on 5/15/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit


struct MenuItem: Decodable {
  var colorArray: [CGFloat]
  var bigImageName: String
  var imageName: String
}

extension MenuItem {
  var image: UIImage {
    let image = UIImage(imageLiteralResourceName: imageName)
    return image
  }
  
  var bigImage: UIImage {
    return UIImage(imageLiteralResourceName: bigImageName)
  }
  
}

