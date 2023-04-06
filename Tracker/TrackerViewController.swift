//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Артем Кохан on 05.04.2023.
//

import Foundation
import UIKit

final class TrackerViewController: UIViewController {
    
//    var categories: [TrackerCategory]
//    var completedTrackers: [TrackerRecord]
//    var currentDate: Date
//    var visibleCategories: [TrackerCategory]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupPlusButton()
        
        setupDatePicker()
        
        setupSearchTextField()
        
        setupCollectionView()
    }
    
    func setupPlusButton() {
        let navigationBar = UINavigationBar()
        
        let myNavigationItem = UINavigationItem()
        
        let leftButton = UIBarButtonItem(image: UIImage(named: "PlusButton"), style: .plain, target: self, action: #selector(saveButtonTapped))
        
        myNavigationItem.leftBarButtonItem = leftButton
        
        
        
        //        В правом NavBarItem добавлен UIDatePicker c Preferred Style, равным Compact, и Mode — Date. При изменении даты отображаются трекеры привычек, которые должны быть видны в день недели, выбранный в UIDatePicker.
        //
        
        
        
        myNavigationItem.title = "Трекеры"
        
        navigationBar.setItems([myNavigationItem], animated: false)
        
        view.addSubview(navigationBar)
        
        // Установите автоподсказки для настройки констрейнтов
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        // Установите констрейнты для навигационной панели
        navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        navigationBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
    }
    func setupCollectionView() {
        let trackerCollectionView = UICollectionView()
        
        view.addSubview(trackerCollectionView)
        
        trackerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // Установите констрейнты для навигационной панели
        trackerCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trackerCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        trackerCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        trackerCollectionView.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    func setupSearchTextField() {
        
        let searchTextField = UISearchTextField()
        
        view.addSubview(searchTextField)
        
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        
        // Установите констрейнты для навигационной панели
        searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    func setupDatePicker() {
        let datePicker = UIDatePicker()
        
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        
        //        myNavigationItem. = rightDatePicker
        
        view.addSubview(datePicker)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        // Установите констрейнты для навигационной панели
        datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        datePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        datePicker.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    
    
    
    @objc
    func saveButtonTapped() {
        
    }
}
