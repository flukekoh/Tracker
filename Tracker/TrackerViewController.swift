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
    
    // MARK: - UI
    let trackerHeaderLabel: UILabel = {
        let trackerHeaderLabel = UILabel()
        trackerHeaderLabel.text = "Трекеры"
        trackerHeaderLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        trackerHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return trackerHeaderLabel
    }()
    
    let addTrackerUIButton: UIButton = {
        let addTrackerUIButton = UIButton.systemButton(
            with: UIImage(named: "PlusButton")!,
            target: self, action: #selector(didTapAddTrackerButton))
        addTrackerUIButton.tintColor = .black
        addTrackerUIButton.translatesAutoresizingMaskIntoConstraints = false
        
        return addTrackerUIButton
    }()
    
    let searchTextField: UISearchTextField = {
        let searchTextField = UISearchTextField()
        searchTextField.placeholder = "Поиск"
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        return searchTextField
    }()
    
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
    
    let placeholderImage: UIImageView = {
        let placeholderImage = UIImageView()
        placeholderImage.translatesAutoresizingMaskIntoConstraints = false
        placeholderImage.image = UIImage(named: "NoTrackersImage")
        
        return placeholderImage
    }()
    
    let placeholderLabel: UILabel = {
        let placeholderLabel = UILabel()
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        placeholderLabel.text = "Что будем отслеживать?"
        placeholderLabel.textColor = .black
        
        return placeholderLabel
    }()
    
    let placeholderStack: UIStackView = {
        let placeholderStack = UIStackView()
        placeholderStack.translatesAutoresizingMaskIntoConstraints = false
        placeholderStack.axis = .vertical
        placeholderStack.alignment = .center
        placeholderStack.spacing = 8
        
        return placeholderStack
    }()
    
    let datePicker: UIDatePicker = {
        
        let datePicker = UIDatePicker()
        
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.addTarget(self, action: #selector(didChangedDatePicker), for: .valueChanged)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    // MARK: - LC
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupHierarchy()
        setupLayout()
        
        setupPlaceholderImage()
    }
    
    // MARK: - Setups
    
    private func setupView() {
        view.backgroundColor = .white
    }
    
    private func setupHierarchy() {
        view.addSubview(addTrackerUIButton)
        view.addSubview(trackerHeaderLabel)
        view.addSubview(searchTextField)
        view.addSubview(datePicker)
        view.addSubview(collectionView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            addTrackerUIButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            addTrackerUIButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13),
            addTrackerUIButton.heightAnchor.constraint(equalToConstant: 18),
            addTrackerUIButton.widthAnchor.constraint(equalToConstant: 19),
            
            trackerHeaderLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackerHeaderLabel.topAnchor.constraint(equalTo: addTrackerUIButton.bottomAnchor, constant: 13),
            trackerHeaderLabel.heightAnchor.constraint(equalToConstant: 41),
            trackerHeaderLabel.widthAnchor.constraint(equalToConstant: 254),
            
            searchTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            searchTextField.topAnchor.constraint(equalTo: trackerHeaderLabel.bottomAnchor),
            searchTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            
            datePicker.widthAnchor.constraint(equalToConstant: 120),
            datePicker.centerYAnchor.constraint(equalTo: trackerHeaderLabel.centerYAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupPlaceholderImage() {
        placeholderStack.addArrangedSubview(placeholderImage)
        placeholderStack.addArrangedSubview(placeholderLabel)
    }
    
    @objc
    func didChangedDatePicker(_ sender: UIDatePicker) {
        currentDate = sender.date
        collectionView.reloadData()
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
