//
//  HamburgerView.swift
//  Sidebar Manu Animation
//
//  Created by Igor Tkach on 5/15/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit

class HamburgerView: UIView {

  let imageView: UIImageView = {
    let view = UIImageView(image: UIImage(imageLiteralResourceName: "Hamburger"))
    view.contentMode = .center
    return view
  }()
  
  required override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    configure()
  }
  
  private func configure() {
    addSubview(imageView)
  }

  func setFractionOpen(_ fraction: CGFloat) {
    let angle = fraction * .pi / 2.0
    imageView.transform = CGAffineTransform(rotationAngle: angle)
  }
  
}
