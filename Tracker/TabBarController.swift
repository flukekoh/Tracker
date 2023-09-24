//
//  TabBarController.swift
//  Tracker
//
//  Created by Артем Кохан on 05.04.2023.
//

import Foundation
import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let trackerViewController = TrackerViewController()
        
        trackerViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("tabbar.trackers", comment: "Трекеры"), image: UIImage(systemName: "record.circle.fill"), selectedImage: nil)
        
        let statisticsViewController = StatisticsViewController()
        
        let statisticsViewModel = StatisticsViewModel()
        statisticsViewController.statisticsViewModel = statisticsViewModel
        
        statisticsViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("tabbar.statistics", comment: "Статистика"), image: UIImage(systemName: "hare.fill"), selectedImage: nil)
        
        self.viewControllers = [trackerViewController, statisticsViewController]
    }
}
