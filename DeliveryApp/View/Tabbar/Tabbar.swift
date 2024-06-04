//
//  Tabbar.swift
//  HepsiburadaClone
//
//  Created by Rabia Abdioğlu on 15.05.2024.
//

import UIKit

class TabbarVC: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.frame.size.height = 100
        tabBar.frame.origin.y = view.frame.height - 100
    }
    
    override func viewDidLoad() {
 
        
        
        view.backgroundColor = .white
        
        let borderLayer = CALayer()
        borderLayer.frame = CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 1)
        borderLayer.backgroundColor = UIColor.systemGray4.cgColor
        tabBar.layer.addSublayer(borderLayer)
        
        tabBar.alpha = 1.0
        tabBar.backgroundColor = .white
        
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -4)
        UITabBarItem.appearance().setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 14, weight: .regular)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 14, weight: .bold)], for: .selected)
        UITabBar.appearance().tintColor = UIColor.clrGreen
        UITabBar.appearance().unselectedItemTintColor = .clrLightGray
        
        
        super.viewDidLoad()
        
        setupViewControllers()
        
        self.delegate = self
    }
    
    private func setupViewControllers() {
        
        // MARK: - TabBar Configuration
        
        let homePageVC = HomePageVC()
        let basketPageVC = BasketPageVC()
        let favoritesPageVC = FavoritePageVC()
        
        homePageVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "home"), tag: 0)
        
        basketPageVC.tabBarItem = UITabBarItem(title: "Basket", image: UIImage(named: "cart"),tag: 1)
        
        favoritesPageVC.tabBarItem = UITabBarItem(title: "Favorite", image: UIImage(named: "favorite"), tag: 2)
  
        let viewControllers = [homePageVC, basketPageVC, favoritesPageVC]
        
        self.viewControllers = viewControllers.map { UINavigationController(rootViewController: $0) }
    }
}
