//
//  MainTabbarViewController.swift
//  QuanLyCongViec
//
//  Created by Quang Viện on 20/07/2023.
//

import Foundation
import ESTabBarController_swift

class MainTabbarViewController: ESTabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().backgroundColor = UIColor.white
        setViewControllers([nameWorkVC,createNoteVC,userVC], animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    lazy var nameWorkVC: UIViewController =  {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController")
        viewController.view.backgroundColor = UIColor(hex: "E3EFFF")
        viewController.tabBarItem = ESTabBarItem(CustomStyleTabBarContentView(),
                                                 title: "Công việc",
                                                 image: UIImage(named: "portfolio"),
                                                 selectedImage: UIImage(named: "portfolio"))
        let nav = UINavigationController(rootViewController: viewController)
        nav.setNavigationBarHidden(true, animated: true)
        return nav
    } ()
    
    lazy var createNoteVC: UIViewController =  {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateNoteViewController")
        viewController.view.backgroundColor = UIColor(hex: "E3EFFF")
        viewController.tabBarItem = ESTabBarItem(CustomStyleTabBarContentView(),
                                                 title: "Thêm công việc",
                                                 image: UIImage(named: "more"),
                                                 selectedImage: UIImage(named: "more"))
        let nav = UINavigationController(rootViewController: viewController)
        nav.setNavigationBarHidden(true, animated: true)
        return nav
    } ()
    
    lazy var userVC: UIViewController =  {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserViewController")
        viewController.view.backgroundColor = UIColor(hex: "E3EFFF")
        viewController.tabBarItem = ESTabBarItem(CustomStyleTabBarContentView(),
                                                 title: "Hồ sơ",
                                                 image: UIImage(named: "user"),
                                                 selectedImage: UIImage(named: "user"))
        let nav = UINavigationController(rootViewController: viewController)
        nav.setNavigationBarHidden(true, animated: true)
        return nav
    } ()
}
