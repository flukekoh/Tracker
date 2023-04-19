//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Артем Кохан on 05.04.2023.
//

import Foundation
import UIKit

final class TrackerViewController: UIViewController {
    
    var completedTrackers: [TrackerRecord]?
    var currentDate: Date?
    var visibleCategories: [TrackerCategory]?
    
    let trackerHeaderLabel = UILabel()
    let addTrackerUIButton = UIButton.systemButton(
        with: UIImage(named: "PlusButton")!,
        target: self, action: #selector(didTapAddTrackerButton))
    let searchTextField = UISearchTextField()
//    let trackerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (self.view.frame.width / 2) - 10, height: 200)
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
        layout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 50)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .white
        view.register(
            TrackerCell.self,
            forCellWithReuseIdentifier: TrackerCell.identifier
        )
        view.register(TrackerHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackerHeader.identifier)
        view.dataSource = self
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupPlusButton()
        setupTrackersHeader()
        setupSearchTextField()
        setupDatePicker()
        setupCollectionView()
        setupPlaceholderImage()
    }
    
    func setupPlaceholderImage() {
        let placeholderImage = UIImageView()
        placeholderImage.translatesAutoresizingMaskIntoConstraints = false
        placeholderImage.image = UIImage(named: "NoTrackersImage")
        
        let placeholderLabel = UILabel()
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        placeholderLabel.text = "Что будем отслеживать?"
        placeholderLabel.textColor = .black
        
        let placeholderStack = UIStackView()
        placeholderStack.translatesAutoresizingMaskIntoConstraints = false
        placeholderStack.axis = .vertical
        placeholderStack.alignment = .center
        placeholderStack.spacing = 8
        
        placeholderStack.addArrangedSubview(placeholderImage)
        placeholderStack.addArrangedSubview(placeholderLabel)
    }
    
    func setupPlusButton() {
        
        addTrackerUIButton.tintColor = .black
        view.addSubview(addTrackerUIButton)
        
        addTrackerUIButton.translatesAutoresizingMaskIntoConstraints = false
        
        addTrackerUIButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        addTrackerUIButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13).isActive = true
        addTrackerUIButton.heightAnchor.constraint(equalToConstant: 18).isActive = true
        addTrackerUIButton.widthAnchor.constraint(equalToConstant: 19).isActive = true
    }
    
    func setupTrackersHeader() {
        
        trackerHeaderLabel.text = "Трекеры"
        trackerHeaderLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        view.addSubview(trackerHeaderLabel)
        
        trackerHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        trackerHeaderLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        trackerHeaderLabel.topAnchor.constraint(equalTo: addTrackerUIButton.bottomAnchor, constant: 13).isActive = true
        trackerHeaderLabel.heightAnchor.constraint(equalToConstant: 41).isActive = true
        trackerHeaderLabel.widthAnchor.constraint(equalToConstant: 254).isActive = true
    }
    
    func setupDatePicker() {
        let datePicker = UIDatePicker()
        
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.addTarget(self, action: #selector(didChangedDatePicker), for: .valueChanged)
        
        view.addSubview(datePicker)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        datePicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        datePicker.centerYAnchor.constraint(equalTo: trackerHeaderLabel.centerYAnchor).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
    }
    
    @objc
    func didChangedDatePicker(_ sender: UIDatePicker) {
        currentDate = sender.date
        collectionView.reloadData()
    }
    
    func setupSearchTextField() {
        
        searchTextField.placeholder = "Поиск"
        view.addSubview(searchTextField)
        
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        
        searchTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        searchTextField.topAnchor.constraint(equalTo: trackerHeaderLabel.bottomAnchor).isActive = true
        searchTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
    }
    
    func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    @objc
    func didTapAddTrackerButton() {
        let trackerCreationViewController = TrackerTypeViewController()
        
        //        trackerCreation.delegate = self
        let navigationController = UINavigationController(rootViewController: trackerCreationViewController)
        present(navigationController, animated: true)
    }
}

extension TrackerViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        TrackerData.shared.array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.identifier, for: indexPath) as? TrackerCell
        cell?.model = TrackerData.shared.array[indexPath.row]
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TrackerHeader.identifier, for: indexPath) as! TrackerHeader
        header.labelText = "Zagolovok"
        return header
    }
}
