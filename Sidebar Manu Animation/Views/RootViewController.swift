//
//  RootViewController.swift
//  Sidebar Manu Animation
//
//  Created by Igor Tkach on 5/15/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit

extension UIView {
  func embedInsideSafeArea(_ subview: UIView) {
    addSubview(subview)
    subview.translatesAutoresizingMaskIntoConstraints = false
    subview.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
    subview.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
    subview.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
    subview.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
  }
}

class RootViewController: UIViewController {

  let menuWidth: CGFloat = 100.0
  lazy var threshold = menuWidth/2.0
  var menuContainer = UIView(frame: .zero)
  var detailContainer = UIView(frame: .zero)
  
  var hamburgerView: HamburgerView?
  
  
  lazy var scroller: UIScrollView = {
    let scroller = UIScrollView(frame: .zero)
    scroller.isPagingEnabled = true
    scroller.delaysContentTouches = false
    scroller.bounces = false
    scroller.showsHorizontalScrollIndicator = false
    scroller.delegate = self
    return scroller
  }()
  
  var menuViewController: MenuViewController?
  var detailViewController: DetailViewController?
  
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
      view.backgroundColor = UIColor(named: "rw-dark")
      view.embedInsideSafeArea(scroller)
      installMenuContainer()
      installDetailContainer()
      
      
      menuViewController = installFromStoryboard("MenuViewController", into: menuContainer) as? MenuViewController
      detailViewController = installFromStoryboard("DetailViewController", into: detailContainer) as? DetailViewController
      //tells MenuViewController that RootViewController is the delegate
      menuViewController?.delegate = self
      
      //initial state of the humbergerMenu
      hamburgerView?.setFractionOpen(1.0)
  
      // toogle the burger button
      if let detailViewController = detailViewController {
        installBurger(in: detailViewController)
      }
    }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  
  
  func installMenuContainer() {
    
    //Add menuContainer to scrollerView and make some constraint
    scroller.addSubview(menuContainer)
    menuContainer.translatesAutoresizingMaskIntoConstraints = false
    menuContainer.backgroundColor = .orange
    
    menuContainer.leadingAnchor.constraint(equalTo: scroller.leadingAnchor).isActive = true
    menuContainer.topAnchor.constraint(equalTo: scroller.topAnchor).isActive = true
    menuContainer.bottomAnchor.constraint(equalTo: scroller.bottomAnchor).isActive = true
    
    // set width for 80 and height all of the screen scroller content
    menuContainer.widthAnchor.constraint(equalToConstant: menuWidth).isActive = true
    menuContainer.heightAnchor.constraint(equalTo: scroller.heightAnchor).isActive = true
    
  }
  
  
  
  func installDetailContainer() {
    
    scroller.addSubview(detailContainer)
    detailContainer.translatesAutoresizingMaskIntoConstraints = false
    detailContainer.backgroundColor = .red
    
    detailContainer.trailingAnchor.constraint(equalTo: scroller.trailingAnchor).isActive = true
    detailContainer.topAnchor.constraint(equalTo: scroller.topAnchor).isActive = true
    detailContainer.bottomAnchor.constraint(equalTo: scroller.bottomAnchor).isActive = true
    
    detailContainer.leadingAnchor.constraint(equalTo: menuContainer.trailingAnchor).isActive = true
    detailContainer.widthAnchor.constraint(equalTo: scroller.widthAnchor).isActive = true
    
  }

}


//MARK: - UIScrollViewDelegate
extension RootViewController: UIScrollViewDelegate {
  
  // set isPagingEnabled based on horizontal offset is above threshold value
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offset = scrollView.contentOffset
    scrollView.isPagingEnabled = offset.x < threshold
    
    let fraction = calculateMenuDisplayFraction(scrollView)
    updateViewVisibility(menuContainer, fraction: fraction)
    hamburgerView?.setFractionOpen(1.0 - fraction)
  }
  
  //
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    
    let offset = scrollView.contentOffset
    if offset.x > threshold {
      hideMenu()
    }
  }
  
  
  //3
  
  func moveMenu(nextPosition: CGFloat) {
    let nextOffset = CGPoint(x: nextPosition, y: 0)
    scroller.setContentOffset(nextOffset, animated: true)
  }
  
  func hideMenu() {
    moveMenu(nextPosition: menuWidth)
  }
  
  func showMenu() {
    moveMenu(nextPosition: 0)
  }
  
  func toggleMenu() {
    let menuIsHidden = scroller.contentOffset.x > threshold
    if menuIsHidden {
      showMenu()
    } else {
      hideMenu()
    }
  }
  
}


//MARK: - NAVIGATION CONTROLLER
extension RootViewController {
  
  //ebmed navigationController
  func installNavigationController(_ rootController: UIViewController) -> UINavigationController {
    let nav = UINavigationController(rootViewController: rootController)
    
    nav.navigationBar.barTintColor = UIColor(named: "rw-dark")
    nav.navigationBar.tintColor = UIColor(named: "rw-light")
    nav.navigationBar.isTranslucent = false
    nav.navigationBar.clipsToBounds = true
    
    //Install NavigationController as a child view controller of RootViewController
    addChild(nav)
    
    return nav
  }
  
  func installFromStoryboard(_ identifier: String, into container: UIView) -> UIViewController {
    guard let viewController = storyboard?.instantiateViewController(withIdentifier: identifier) else {
      fatalError("broken storyboard expected \(identifier) to be available")
    }
    let nav = installNavigationController(viewController)
    container.embedInsideSafeArea(nav.view)
    return viewController
  }
  
}

//MARK: - Delegate from Menu to Detail

extension RootViewController: MenuDelegate {
  func didSelectMenuItem(_ item: MenuItem) {
    detailViewController?.menuItem = item
  }
  
  
}


//MARK: - Burger Menu
extension RootViewController {
  func installBurger(in viewController: UIViewController) {
    let action = #selector(burgerTapped(_ :))
    let tapGastureRecognizer = UITapGestureRecognizer(target: self, action: action)
    
    let burger = HamburgerView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    burger.addGestureRecognizer(tapGastureRecognizer)
    viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: burger)
    hamburgerView = burger
  }
  
  @objc func burgerTapped(_ sender: Any) {
    toggleMenu()
  }
}

//MARK: - Animated Burger Menu with side menu
extension RootViewController {
  
  func transformForFraction(_ fraction: CGFloat, ofWidth widht: CGFloat) -> CATransform3D {
  
    
    var identity = CATransform3DIdentity
    identity.m34 = -1.0 / 1000.0
    
    let angle = -fraction * .pi/2.0
    let xOffset = widht/2.0 + widht * fraction/4.0
    
    let rotateTransform = CATransform3DRotate(identity, angle, 0.0, 1.0, 0.0)
    let translateTransform = CATransform3DMakeTranslation(xOffset, 0.0, 0.0)
    return CATransform3DConcat(rotateTransform, translateTransform)
  }
}

//
extension RootViewController {
  
  //converts the raw horizontal offset into a fraction of 1.0 relative to the menu width. This value is clamped between 0.0 and 1.0.
  func calculateMenuDisplayFraction(_ scrollView: UIScrollView) -> CGFloat {
    let fraction = scrollView.contentOffset.x / menuWidth
    let clamped = min(max(0, fraction), 1.0)
    return clamped
  }
  
  //applies the transform generated by the fraction to a views layer. The anchorPoint is the hinge around which the transform applies, so CGPoint(x: 1.0, y: 0.5) means the right hand edge and vertical center.
  func updateViewVisibility(_ container: UIView, fraction: CGFloat) {
    container.layer.anchorPoint = CGPoint(x: 1.0, y: 0.5)
    container.layer.transform = transformForFraction(fraction, ofWidth: menuWidth)
    container.alpha = 1.0 - fraction
  }
  
}
