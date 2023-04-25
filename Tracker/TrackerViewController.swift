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
    
    private var workArray = TrackerCategoryData.shared.array
    private var onReload: EmptyClosure?
    
    // MARK: - UI
    let trackerHeaderLabel: UILabel = {
        let trackerHeaderLabel = UILabel()
        trackerHeaderLabel.text = "Трекеры"
        trackerHeaderLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        trackerHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return trackerHeaderLabel
    }()
    
    private lazy var addTrackerUIButton: UIButton = {
        let addTrackerUIButton = UIButton.systemButton(
            with: UIImage(named: "PlusButton")!,
            target: self, action: #selector(didTapAddTrackerButton))
        addTrackerUIButton.tintColor = .black
        addTrackerUIButton.translatesAutoresizingMaskIntoConstraints = false
        
        return addTrackerUIButton
    }()
    
    private lazy var searchTextField: UISearchTextField = {
        let searchTextField = UISearchTextField()
        searchTextField.delegate = self
        searchTextField.placeholder = "Поиск"
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        return searchTextField
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (self.view.frame.width / 2) - 30, height: 142)
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
    
    private lazy var datePicker: UIDatePicker = {
        
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
        
        onReload = {
            self.workArray = TrackerCategoryData.shared.array
            self.collectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.reloadData()
        print(workArray)
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
        setupPlaceholderImage()
        view.addSubview(collectionView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            addTrackerUIButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 6),
            addTrackerUIButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            addTrackerUIButton.heightAnchor.constraint(equalToConstant: 42),
            addTrackerUIButton.widthAnchor.constraint(equalToConstant: 42),
            
            trackerHeaderLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackerHeaderLabel.trailingAnchor.constraint(equalTo: datePicker.leadingAnchor, constant: 12),
            trackerHeaderLabel.topAnchor.constraint(equalTo: addTrackerUIButton.bottomAnchor, constant: 1),
            trackerHeaderLabel.heightAnchor.constraint(equalToConstant: 41),
            
            searchTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchTextField.topAnchor.constraint(equalTo: trackerHeaderLabel.bottomAnchor, constant: 7),
            searchTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            datePicker.widthAnchor.constraint(equalToConstant: 77),
            datePicker.centerYAnchor.constraint(equalTo: trackerHeaderLabel.centerYAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            placeholderStack.heightAnchor.constraint(equalToConstant: 80),
            placeholderStack.widthAnchor.constraint(equalToConstant: 80),
            placeholderStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderStack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 35),
            
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 24),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupPlaceholderImage() {
        placeholderStack.addArrangedSubview(placeholderImage)
        placeholderStack.addArrangedSubview(placeholderLabel)
        
        view.addSubview(placeholderStack)
    }
    
    @objc
    func didChangedDatePicker(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: selectedDate)
        if let selectedWeekday = Weekday(rawValue: weekday) {
            updateCollectionViewWithWeekday(selectedWeekday)
        }
    }
    
    func updateCollectionViewWithWeekday(_ selectedWeekday: Weekday) {
        // Создаем новый массив, содержащий только элементы, соответствующие выбранному дню недели
        workArray = TrackerCategoryData.shared.array
        
        var temporary = [TrackerCategory]()
        
        for var item in workArray {
            
            let filteredTrackers = item.trackers.filter { $0.schedule.contains(where: { $0 == selectedWeekday }) }
            
            if !filteredTrackers.isEmpty {
                item.trackers = filteredTrackers
            }
            temporary.append(item)
        }
        
        workArray = temporary
        // Обновляем отображение коллекции
        collectionView.reloadData()
    }
    
    @objc
    func didTapAddTrackerButton() {
        let trackerCreationViewController = TrackerTypeViewController()
        
        trackerCreationViewController.onDone = {
            self.onReload?()
        }
        
        //        trackerCreation.delegate = self
        let navigationController = UINavigationController(rootViewController: trackerCreationViewController)
        present(navigationController, animated: true)
    }
}

extension TrackerViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        workArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        workArray[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.identifier, for: indexPath) as? TrackerCell
        cell?.model = workArray[indexPath.section].trackers[indexPath.row]
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TrackerHeader.identifier, for: indexPath) as! TrackerHeader
        switch indexPath.section {
        case 0:
            header.labelText = workArray[indexPath.section].title
        case 1:
            header.labelText = workArray[indexPath.section].title
        case 2:
            header.labelText = workArray[indexPath.section].title
        default:
            header.labelText = "Zagolovok"
        }
        
        return header
    }
}

extension TrackerViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        if text != "" {
            
            workArray = TrackerCategoryData.shared.array
        } else {
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            
            var temporary = [TrackerCategory]()
            
            for var item in workArray {
                
//                let filteredData = workArray.filter { $0.name.contains(newString) }
                
                let filteredTrackers = item.trackers.filter { $0.name.contains(newString) }
                
//                if !filteredTrackers.isEmpty {
                    item.trackers = filteredTrackers
//                }
                temporary.append(item)
            }
            
            workArray = temporary
        }
        
        collectionView.reloadData()
        return true
    }
}
