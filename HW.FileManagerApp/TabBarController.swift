//
//  ViewController.swift
//  HW.FileManagerApp
//
//  Created by Роман on 22.01.2022.
//

import UIKit

class TabBarController: UITabBarController {
    
    private let fileManager = FileManager.default
    
    var contentForImagesVC: [URL] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let documentsUrl = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let content = try fileManager.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            contentForImagesVC = content
        } catch {
            print(error.localizedDescription)
        }
        
        let imagesVC = ImagesViewController()
        contentForImagesVC.sort {
            $0.absoluteString < $1.absoluteString
        }
        imagesVC.contentArray = contentForImagesVC
        
        let settingsVC = SettingsViewController()
        settingsVC.sortImages = { [weak self] in
            guard let self = self else { return }
            let sortingFlag = UserDefaults.standard.bool(forKey: "sortingFlag")
            if sortingFlag == false {
                let sortedByAlphabet = self.contentForImagesVC.sorted {
                    $0.absoluteString < $1.absoluteString
                }
                self.contentForImagesVC = sortedByAlphabet
                imagesVC.contentArray = sortedByAlphabet
                imagesVC.reload()
                UserDefaults.standard.set(true, forKey: "sortingFlag")
                let alertController = UIAlertController(title: "Отсортировано в алфавитном порядке", message: nil, preferredStyle: .alert)
                self.present(alertController, animated: true, completion: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.dismiss(animated: true, completion: nil)
                }
            } else {
               let sortedReversedAlphabet = self.contentForImagesVC.sorted {
                    $0.absoluteString > $1.absoluteString
                }
                self.contentForImagesVC = sortedReversedAlphabet
                imagesVC.contentArray = sortedReversedAlphabet
                imagesVC.reload()
                UserDefaults.standard.set(false, forKey: "sortingFlag")
                let alertController = UIAlertController(title: "Отсортировано в обратном порядке", message: nil, preferredStyle: .alert)
                self.present(alertController, animated: true, completion: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.dismiss(animated: true, completion: nil)
                }
            }
        }
        let navImagesVC = createNavigationController(rootVC: imagesVC, title: "Фото", image: UIImage(systemName: "photo.circle.fill")!)
        let navSettingVC = createNavigationController(rootVC: settingsVC, title: "Настройки", image: UIImage(systemName: "gearshape.fill")!)
        
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        navigationItem.hidesBackButton = true
        
        viewControllers = [navImagesVC, navSettingVC]
    }
    
    func createNavigationController(rootVC: UIViewController, title: String, image: UIImage) -> UIViewController {
        rootVC.navigationItem.title = title
        let navController = UINavigationController(rootViewController: rootVC)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        return navController
    }
}

