//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Артем Кохан on 05.04.2023.
//

import Foundation
import UIKit

final class TrackerViewController: UIViewController {
    
    var completedTrackers: [TrackerRecord] = []
    var currentDate: Date?
    
    private var visibleCategories: [TrackerCategory] = []
    private var categories: [TrackerCategory] = []
    
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        
        datePicker.calendar.firstWeekday = 2
        datePicker.clipsToBounds = true
        datePicker.backgroundColor = .white
        datePicker.tintColor = .blue
        
        datePicker.calendar = Calendar(identifier: .iso8601)
        datePicker.maximumDate = Date()
        
        let date = Date() // выбираем текущую дату
        let dateString = dateFormatter.string(from: date) // форматируем дату в соответствии с выбранным форматом

        datePicker.setDate(dateFormatter.date(from: dateString)!, animated: false)
        
        datePicker.addTarget(self, action: #selector(didChangedDatePicker), for: .valueChanged)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker

    }()
    
    // MARK: - LC
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadData()
        setupView()
        setupHierarchy()
        setupLayout()
        
        setupPlaceholderImage()
        
        onReload = {
            self.visibleCategories = TrackerCategoryData.shared.array
            self.collectionView.reloadData()
            self.didChangedDatePicker()
        }
    }
    
    func reloadData() {
        categories = TrackerCategoryData.shared.array
        didChangedDatePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.reloadData()
        
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
            
            datePicker.widthAnchor.constraint(equalToConstant: 120),
            datePicker.centerYAnchor.constraint(equalTo: trackerHeaderLabel.centerYAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            placeholderStack.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            placeholderStack.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
            
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
    func didChangedDatePicker() {
        reloadVisibleCategories()
    }
    
    private func reloadVisibleCategories() {
        let calendar = Calendar.current
        let filterWeekday = calendar.component(.weekday, from: datePicker.date)
        let filterText = (searchTextField.text ?? "").lowercased()
        
        visibleCategories = categories.compactMap { category in
            
            let trackers = category.trackers.filter { tracker in
                
                let textCondition = filterText.isEmpty || tracker.name.lowercased().contains(filterText)
                
                let dateCondition = tracker.schedule.contains { weekDay in
                    weekDay.rawValue == filterWeekday
                } == true
                
                return textCondition && dateCondition
            }
            
            if trackers.isEmpty {
                return nil
            }
            return TrackerCategory(
                title: category.title,
                trackers: trackers
            )
        }
        
        collectionView.reloadData()
        reloadPlaceholder()
    }
    
    private func reloadPlaceholder() {
        placeholderStack.isHidden = !categories.isEmpty
    }
        
    @objc
    func didTapAddTrackerButton() {
        let trackerCreationViewController = TrackerTypeViewController()
        
        trackerCreationViewController.onDone = {
            self.onReload?()
        }
        
        //        trackerCreation.delegate = self
        trackerCreationViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: trackerCreationViewController)
        
        present(navigationController, animated: true)
    }
}

extension TrackerViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.identifier, for: indexPath) as? TrackerCell else { return UICollectionViewCell() }
        
        let cellData = visibleCategories
        let tracker = cellData[indexPath.section].trackers[indexPath.row]
        
        cell.delegate = self
        let isCompletedToday = isTrackerCompletedToday(id: tracker.id)
        let completedDays = completedTrackers.filter {
            $0.trackerId == tracker.id
        }.count
        
        cell.configure(with: tracker, isCompletedToday: isCompletedToday, completedDays: completedDays, indexPath: indexPath)
        
        return cell
    }
    
    private func isTrackerCompletedToday(id: UInt) -> Bool {
        completedTrackers.contains{ trackerRecord in
            let isSameDay = Calendar.current.isDate(trackerRecord.completionDate, inSameDayAs: datePicker.date)
            return trackerRecord.trackerId == id && isSameDay
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TrackerHeader.identifier, for: indexPath) as? TrackerHeader else { return UICollectionReusableView() }
        
        let titleCategory = visibleCategories[indexPath.section].title
        view.configureHeader(title: titleCategory)
        
        return view
    }
}

extension TrackerViewController: TrackerCellDelegate {
    func completeTracker(id: UInt, at indexPath: IndexPath) {
        let trackerRecord = TrackerRecord(trackerId: id, completionDate: datePicker.date)
        completedTrackers.append(trackerRecord)
        
        collectionView.reloadItems(at: [indexPath])
    }
    
    func uncompleteTracker(id: UInt, at indexPath: IndexPath) {
        completedTrackers.removeAll { trackerRecord in
            let isSameDay = Calendar.current.isDate(trackerRecord.completionDate, inSameDayAs: datePicker.date)
            return trackerRecord.trackerId == id && isSameDay
        }
        
        collectionView.reloadItems(at: [indexPath])
    }
}

extension TrackerViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        
        reloadVisibleCategories()
        
        return true
    }
    
}

extension TrackerViewController: TrackerFormViewControllerDelegate {
    func didTapConfirmButton(categoryLabel: String, trackerToAdd: Tracker) {
        dismiss(animated: true)
        guard let categoryIndex = categories.firstIndex(where: { $0.title == categoryLabel }) else { return }
        let updatedCategory = TrackerCategory(
            title: categoryLabel,
            trackers: categories[categoryIndex].trackers + [trackerToAdd]
        )
        categories[categoryIndex] = updatedCategory
        collectionView.reloadData()
    }
    
    func didTapCancelButton() {
        dismiss(animated: true)
    }
}
