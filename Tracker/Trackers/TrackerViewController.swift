//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Артем Кохан on 05.04.2023.
//

import Foundation
import UIKit

final class TrackerViewController: UIViewController {
    
    private var completedTrackers: Set<TrackerRecord> = []
    var currentDate: Date?
    
    private var visibleCategories: [TrackerCategory] = []
    private var categories: [TrackerCategory] = []
    
    private var onReload: EmptyClosure?
    
    private let trackerStore = TrackerStore()
    private let trackerCategoryStore = TrackerCategoryStore()
    private let trackerRecordStore = TrackerRecordStore()
    private let analyticsService = AnalyticsService()
    private var trackerToEdit: Tracker?
    
    // MARK: - UI
    private let trackerHeaderLabel: UILabel = {
        let trackerHeaderLabel = UILabel()
        trackerHeaderLabel.text = NSLocalizedString("main.title", comment: "Заголовок Трекеры")
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
        searchTextField.backgroundColor = UIColor(named: "SearchFieldColor")
        searchTextField.textColor = UIColor(named: "SearchFieldTextColor")
        searchTextField.tokenBackgroundColor = UIColor(named: "SearchFieldColor")
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
    
    private let placeholderImage: UIImageView = {
        let placeholderImage = UIImageView()
        placeholderImage.translatesAutoresizingMaskIntoConstraints = false
        placeholderImage.image = UIImage(named: "NoTrackersImage")
        
        return placeholderImage
    }()
    
    private let placeholderLabel: UILabel = {
        let placeholderLabel = UILabel()
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        placeholderLabel.text = "Что будем отслеживать?"
        placeholderLabel.textColor = .black
        
        return placeholderLabel
    }()
    
    private let placeholderStack: UIStackView = {
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
    
    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("filters", comment: "Кнопка Фильтры"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        button.layer.cornerRadius = 16
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(didTapFilterButton), for: .touchUpInside)
        return button
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        currentDate = datePicker.date
        
        reloadData()
        setupView()
        setupHierarchy()
        setupLayout()
        
        setupPlaceholderImage()
        reloadPlaceholder()
        onReload = {
            self.collectionView.reloadData()
            self.didChangedDatePicker()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsService.report(event: "open", params: ["screen": "Main"])
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analyticsService.report(event: "close", params: ["screen": "Main"])
    }
    
    private func reloadData() {
        
        trackerRecordStore.delegate = self
        trackerStore.delegate = self
        
        guard let currentDate = currentDate else { return }
        
        try? trackerStore.loadFilteredTrackers(date: currentDate, searchString: (searchTextField.text ?? "").lowercased())
        try? trackerRecordStore.loadCompletedTrackers(by: currentDate)
        
        didChangedDatePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.reloadData()
    }
    
    // MARK: - Setups
    
    private func setupView() {
        view.backgroundColor = UIColor(named: "White") 
    }
    
    private func setupHierarchy() {
        view.addSubview(addTrackerUIButton)
        view.addSubview(trackerHeaderLabel)
        view.addSubview(searchTextField)
        view.addSubview(datePicker)
        setupPlaceholderImage()
        view.addSubview(collectionView)
        view.addSubview(filterButton)
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
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            filterButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupPlaceholderImage() {
        placeholderStack.addArrangedSubview(placeholderImage)
        placeholderStack.addArrangedSubview(placeholderLabel)
        
        view.addSubview(placeholderStack)
    }
    
    @objc
    private func didChangedDatePicker() {
        reloadVisibleCategories()
    }
    
    @objc
    private func didTapFilterButton() {
        analyticsService.report(event: "click", params: [
            "screen": "Main",
            "item": "filter"
        ])
        
        let filterViewController = FilterViewController()
        
        filterViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: filterViewController)
        
        present(navigationController, animated: true)
    }
    
    private func reloadVisibleCategories() {
        
        let filterText = (searchTextField.text ?? "").lowercased()
        currentDate = datePicker.date
        
        do {
            try trackerStore.loadFilteredTrackers(date: currentDate ?? Date(), searchString: filterText)
            try trackerRecordStore.loadCompletedTrackers(by: currentDate ?? Date())
        } catch {}
        collectionView.reloadData()
        reloadPlaceholder()
    }
    
    private func reloadPlaceholder() {
        if trackerStore.numberOfTrackers == 0 {
            placeholderStack.isHidden = false
            filterButton.isHidden = true
        } else {
            placeholderStack.isHidden = true
            filterButton.isHidden = false
        }
    }
    
    @objc
    private func didTapAddTrackerButton() {
        analyticsService.report(event: "click", params: [
            "screen": "Main",
            "item": "add_track"
        ])
        
        let trackerCreationViewController = TrackerTypeViewController()
        
        trackerCreationViewController.onDone = {
            self.onReload?()
        }
        
        trackerCreationViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: trackerCreationViewController)
        
        present(navigationController, animated: true)
    }
    
    private func pinTracker(_ tracker: Tracker) {
        try? trackerStore.pinTracker(for: tracker)
        reloadVisibleCategories()
    }
    
    private func editTracker(_ tracker: Tracker) {
        analyticsService.report(event: "click", params: [
            "screen": "Main",
            "item": "edit"
        ])
        trackerToEdit = tracker
        
        let trackerFormViewController = TrackerCreationViewController(tracker: tracker, isEdition: true)
        
        trackerFormViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: trackerFormViewController)
        navigationController.isModalInPresentation = true
        present(navigationController, animated: true)
    }
    
    private func deleteTracker(_ tracker: Tracker) {
        let alert = UIAlertController(
            title: nil,
            message: "Уверены что хотите удалить трекер?",
            preferredStyle: .actionSheet
        )
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            guard let self else { return }
            self.analyticsService.report(event: "click", params: [
                "screen": "Main",
                "item": "delete"
            ])
            try? self.trackerStore.deleteTracker(tracker)
            reloadVisibleCategories()
        }
        
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    
}

extension TrackerViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        trackerStore.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        trackerStore.numberOfRowsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TrackerCell.identifier,
                for: indexPath
            ) as? TrackerCell,
            let tracker = trackerStore.tracker(at: indexPath)
        else {
            return UICollectionViewCell()
        }
        
        let isCompletedToday = completedTrackers.contains { $0.completionDate == currentDate && $0.trackerId == tracker.id }
        
        cell.configure(with: tracker, isCompletedToday: isCompletedToday, completedDays: tracker.completedDaysCount, cell: cell)
        cell.delegate = self
        
        return cell
    }
}

extension TrackerViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private func isTrackerCompletedToday(id: UUID) -> Bool {
        completedTrackers.contains{ trackerRecord in
            let isSameDay = Calendar.current.isDate(trackerRecord.completionDate, inSameDayAs: datePicker.date)
            return trackerRecord.trackerId == id && isSameDay
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TrackerHeader.identifier, for: indexPath) as? TrackerHeader else { return UICollectionReusableView() }
        
        guard let titleCategory = trackerStore.headerLabelInSection(indexPath.section) else { return UICollectionReusableView() }
        view.configureHeader(title: titleCategory)
        
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        
        let indexPath = indexPaths[0]
        
        guard
            let tracker = trackerStore.tracker(at: indexPath)
        else { return nil }

        return UIContextMenuConfiguration(actionProvider:  { actions in
            UIMenu(children: [
                UIAction(title: tracker.isPinned ? "Открепить" : "Закрепить") { [weak self] _ in
                    self?.pinTracker(tracker)
                },
                UIAction(title: "Редактировать") { [weak self] _ in
                    self?.editTracker(tracker)
                },
                UIAction(title: "Удалить", attributes: .destructive) { [weak self] _ in
                    self?.deleteTracker(tracker)
                    
                }
            ])
        })
    }
}

extension TrackerViewController: TrackerCellDelegate {
    func completeTracker(of cell: TrackerCell, with tracker: Tracker) {
        let trackerRecord = TrackerRecord(trackerId: tracker.id, completionDate: datePicker.date)
        try? trackerRecordStore.add(trackerRecord)
        
        cell.configure(with: tracker, isCompletedToday: true, completedDays: tracker.completedDaysCount, cell: cell)
    }
    
    func uncompleteTracker(of cell: TrackerCell, with tracker: Tracker) {
        if let recordToRemove = completedTrackers.first(where: { $0.completionDate == currentDate && $0.trackerId == tracker.id }) {
            try? trackerRecordStore.remove(recordToRemove)
            cell.configure(with: tracker, isCompletedToday: true, completedDays: tracker.completedDaysCount, cell: cell)
        } else {
            let trackerRecord = TrackerRecord(trackerId: tracker.id, completionDate: currentDate ?? Date())
            try? trackerRecordStore.add(trackerRecord)
        }
    }
}

extension TrackerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        reloadVisibleCategories()
        
        return true
    }
}

extension TrackerViewController: TrackerCreationViewControllerDelegate {
    func didTapConfirmButton(category: TrackerCategory, trackerToAdd: Tracker) {
        dismiss(animated: true)
        try? trackerStore.addTracker(trackerToAdd, with: category)
    }
    
    func didTapCancelButton() {
        reloadVisibleCategories()
        dismiss(animated: true)
    }
    
    func didUpdateTracker(with data: Tracker.Data) {
        guard let trackerToEdit else { return }
        dismiss(animated: true)
        try? trackerStore.updateTracker(trackerToEdit, with: data)
        self.trackerToEdit = nil
        reloadVisibleCategories()
    }
}

extension TrackerViewController: TrackerStoreDelegate {
    func didUpdate() {
        reloadPlaceholder()
        collectionView.reloadData()
    }
}

extension TrackerViewController: TrackerRecordStoreDelegate {
    func didUpdateRecords(_ records: Set<TrackerRecord>) {
        completedTrackers = records
    }
}

extension TrackerViewController: FilterViewControllerDelegate {
    func loadAllTrackers() {
        do {
            try trackerStore.loadAllTrackers()
            try trackerRecordStore.loadAllCompletedTrackers()
        } catch {}
        
        dismiss(animated: true)
    }
    
    func loadTodayTrackers() {
        searchTextField.text = ""
        datePicker.date = Date()
        currentDate = datePicker.date
        
        do {
            try trackerStore.loadFilteredTrackers(date: currentDate ?? Date(), searchString: "")
            try trackerRecordStore.loadCompletedTrackers(by: currentDate ?? Date())
        } catch {}
        
        dismiss(animated: true)
    }
    
    func loadCompletedTrackers() {
        do {
            try trackerStore.loadCompletedTrackers(isCompleted: true, date: currentDate ?? Date())
            try trackerRecordStore.loadAllCompletedTrackers()
        } catch {}
        dismiss(animated: true)
    }
    
    func loadUncompletedTrackers() {
        do {
            try trackerStore.loadCompletedTrackers(isCompleted: false, date: currentDate ?? Date())
            try trackerRecordStore.loadAllCompletedTrackers()
        } catch {}
        dismiss(animated: true)
    }
}

