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
//
    
    let trackerHeaderLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupTrackersHeader()
        
        setupPlusButton()
        
        setupSearchTextField()
        
        setupDatePicker()
        
        setupCollectionView()
    }
    
    func setupTrackersHeader() {
       
        
        trackerHeaderLabel.text = "Трекеры"
        
        view.addSubview(trackerHeaderLabel)
        
        trackerHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Констрейнты для навигационной панели
        trackerHeaderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        trackerHeaderLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 88).isActive = true
        
        trackerHeaderLabel.heightAnchor.constraint(equalToConstant: 41).isActive = true
        trackerHeaderLabel.widthAnchor.constraint(equalToConstant: 254).isActive = true
    }
        
    func setupPlusButton() {
        
        let addTrackerUIButton = UIButton.systemButton(
            with: UIImage(named: "PlusButton")!,
            target: self, action: #selector(didTapAddTrackerButton))
        
        view.addSubview(addTrackerUIButton)
        
        addTrackerUIButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Констрейнты для навигационной панели
        addTrackerUIButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        addTrackerUIButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45).isActive = true
        
        addTrackerUIButton.heightAnchor.constraint(equalToConstant: 18).isActive = true
        addTrackerUIButton.widthAnchor.constraint(equalToConstant: 19).isActive = true
           
    }
    
    func setupDatePicker() {
        let datePicker = UIDatePicker()
        
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        
        //        myNavigationItem. = rightDatePicker
        
        view.addSubview(datePicker)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        // Установите констрейнты для навигационной панели
//        datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        datePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 91).isActive = true
        datePicker.heightAnchor.constraint(equalToConstant: 34).isActive = true
    }
    
    func setupSearchTextField() {
        
        let searchTextField = UISearchTextField()
        
        view.addSubview(searchTextField)
        
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        
        // Установите констрейнты для навигационной панели
        searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16).isActive = true
        searchTextField.topAnchor.constraint(equalTo: trackerHeaderLabel.bottomAnchor, constant: 7).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    func setupCollectionView() {
        
        let trackerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        trackerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        trackerCollectionView.backgroundColor = .white
        trackerCollectionView.register(
            TrackerCell.self,
            forCellWithReuseIdentifier: TrackerCell.identifier
        )
        trackerCollectionView.register(
            TrackerCategoryLabel.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "header"
        )
        
        view.addSubview(trackerCollectionView)
        
        trackerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // Установите констрейнты для навигационной панели
        trackerCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trackerCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        trackerCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        trackerCollectionView.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    
    
    
    
    
    
    @objc
    func didTapAddTrackerButton() {
        let trackerCreationViewController = TrackerTypeViewController()
        
//        trackerCreation.delegate = self
        let navigationController = UINavigationController(rootViewController: trackerCreationViewController)
        present(navigationController, animated: true)
    }
}
