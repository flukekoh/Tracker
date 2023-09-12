//
//  TrackerCreationViewController.swift
//  Tracker
//
//  Created by Артем Кохан on 07.04.2023.
//

import Foundation
import UIKit

extension UICollectionView {
    struct GeometricParams {
        let cellCount: CGFloat
        let leftInset: CGFloat
        let rightInset: CGFloat
        let topInset: CGFloat
        let bottomInset: CGFloat
        let height: CGFloat
        let cellSpacing: CGFloat
        let paddingWidth: CGFloat
        
        init(
            cellCount: CGFloat,
            leftInset: CGFloat,
            rightInset: CGFloat,
            topInset: CGFloat,
            bottomInset: CGFloat,
            height: CGFloat,
            cellSpacing: CGFloat)
        {
            self.cellCount = cellCount
            self.leftInset = leftInset
            self.rightInset = rightInset
            self.topInset = topInset
            self.bottomInset = bottomInset
            self.height = height
            self.cellSpacing = cellSpacing
            self.paddingWidth = leftInset + rightInset + CGFloat(cellCount - 1) * cellSpacing
        }
    }
}


extension UIColor {
    static let black = UIColor(named: "Black")!
    static let gray = UIColor(named: "Gray")!
    static let lightGray = UIColor(named: "Light Gray")!
    static let white = UIColor(named: "White")!
    static let background = UIColor(named: "Background")!
    static let red = UIColor(named: "Red")!
    static let blue = UIColor(named: "Blue")!
    static let fullBlack = UIColor(named: "Full Black")!
    static let fullWhite = UIColor(named: "Full White")!
    
    static let selection = [
        UIColor(named: "Color selection 1")!,
        UIColor(named: "Color selection 2")!,
        UIColor(named: "Color selection 3")!,
        UIColor(named: "Color selection 4")!,
        UIColor(named: "Color selection 5")!,
        UIColor(named: "Color selection 6")!,
        UIColor(named: "Color selection 7")!,
        UIColor(named: "Color selection 8")!,
        UIColor(named: "Color selection 9")!,
        UIColor(named: "Color selection 10")!,
        UIColor(named: "Color selection 11")!,
        UIColor(named: "Color selection 12")!,
        UIColor(named: "Color selection 13")!,
        UIColor(named: "Color selection 14")!,
        UIColor(named: "Color selection 15")!,
        UIColor(named: "Color selection 16")!,
        UIColor(named: "Color selection 17")!,
        UIColor(named: "Color selection 18")!,
    ]
}

enum Choice {
    case regular
    case unregular
}

protocol TrackerFormViewControllerDelegate: AnyObject {
    func didTapCancelButton()
    func didTapConfirmButton(category: TrackerCategory, trackerToAdd: Tracker)
}

final class TrackerCreationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    private let choice: Choice
    
    private var tableData: [String]? {
        switch choice {
        case .regular:
            return ["Категория", "Расписание"]
        case .unregular:
            return ["Категория"]
        }
    }
    
    private let emojis = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪",
    ]
    
    private let colors = UIColor.selection
    private let params = UICollectionView.GeometricParams(
        cellCount: 6,
        leftInset: 28,
        rightInset: 28,
        topInset: 24,
        bottomInset: 24,
        height: 52,
        cellSpacing: 5
    )
    
    private var schedule = [Weekday]()
    
    private var category: TrackerCategory?
    private var emoji: String?
    private var color: UIColor?
    
    weak var delegate: TrackerFormViewControllerDelegate?
    // MARK: - UI
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 0.3)
        tableView.layer.cornerRadius = 16
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.isScrollEnabled = false
        tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var emojisCollection: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.dataSource = self
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isScrollEnabled = false
        view.allowsMultipleSelection = false
        view.register(
            SelectionTitle.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SelectionTitle.identifier
        )
        view.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.identifier)
        return view
    }()
    
    private lazy var colorsCollection: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.dataSource = self
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isScrollEnabled = false
        view.allowsMultipleSelection = false
        view.register(
            SelectionTitle.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SelectionTitle.identifier
        )
        view.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.identifier)
        return view
    }()
    
    private lazy var textField: UITextField = {
        let textField = TextField()
        
        textField.placeholder = "Введите название трекера"
        textField.delegate = self
        textField.layer.cornerRadius = 16
        textField.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 0.3)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let cancelButton: UIButton = {
        let cancelButton = UIButton()
        
        cancelButton.setTitleColor(.red, for: .normal)
        cancelButton.layer.borderColor = UIColor.red.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.setTitle("Отменить", for: .normal)
        
        cancelButton.setTitleColor(UIColor.red, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cancelButton.layer.cornerRadius = 24
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        return cancelButton
    }()
    
    private lazy var confirmButton: UIButton = {
        let confirmButton = UIButton(type: .system)
        
        confirmButton.backgroundColor = UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1)
        confirmButton.setTitleColor(.white, for: .normal)
        
        confirmButton.setTitle("Создать", for: .normal)
        
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        confirmButton.layer.cornerRadius = 24
        
        confirmButton.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        
        return confirmButton
    }()
    
    private let buttonsStack: UIStackView = {
        let buttonsStack = UIStackView()
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        buttonsStack.spacing = 8
        buttonsStack.distribution = .fillEqually
        
        return buttonsStack
    }()
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - LC
    init(choice: Choice) {
        self.choice = choice
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupHierarchy()
        setupLayout()
        setupEmojis()
        setupColors()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc
    private func didChangedLabelTextField(_ sender: UITextField) {
        
    }
    // MARK: - Setups
    
    private func setupView() {
        view.backgroundColor = .white
        title = "Новая привычка"
    }
    
    private func setupHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(textField)
        contentView.addSubview(tableView)
        
        contentView.addSubview(emojisCollection)
        contentView.addSubview(colorsCollection)
        
        view.addSubview(buttonsStack)
        buttonsStack.addArrangedSubview(cancelButton)
        buttonsStack.addArrangedSubview(confirmButton)
    }
    
    private func setupLayout() {
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75),
            
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(integerLiteral: (tableData?.count ?? 0) * 75)),
            
            emojisCollection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            emojisCollection.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32),
            emojisCollection.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            emojisCollection.heightAnchor.constraint(
                equalToConstant: CGFloat(emojis.count) / params.cellCount * params.height + 18 + params.topInset + params.bottomInset
            ),
            
            colorsCollection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            colorsCollection.topAnchor.constraint(equalTo: emojisCollection.bottomAnchor, constant: 16),
            colorsCollection.trailingAnchor.constraint(equalTo: emojisCollection.trailingAnchor),
            colorsCollection.heightAnchor.constraint(
                equalToConstant: CGFloat(colors.count) / params.cellCount * params.height + 18 + params.topInset + params.bottomInset
            ),
            
            buttonsStack.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonsStack.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonsStack.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            buttonsStack.topAnchor.constraint(equalTo: colorsCollection.bottomAnchor, constant: 16),
            buttonsStack.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let customCell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier) as? CustomCell
        else { return UITableViewCell() }
        
        var position: CustomItem.Position
        var value: String = ""
        
        let data = tableData?[indexPath.row]
        
        if indexPath.row == 0 {
            position = .first
            value = category?.title ?? ""
        } else {
            position = .last
            for dayitem in schedule {
                value = value + ", \(dayitem.shortForm)"
            }
            if !schedule.isEmpty {
                value.remove(at: value.startIndex)
            }
        }
        
        customCell.configure(label: tableData?[indexPath.row] ?? "", value: value, position: position)
        return customCell
    }
    
    @objc
    func buttonTapped() {
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let categoriesViewController = CategoriesViewController(selectedCategory: nil)
            categoriesViewController.delegate = self
            let navigationController = UINavigationController(rootViewController: categoriesViewController)
            present(navigationController, animated: true)
        case 1:
            let scheduleViewController = ScheduleViewController()
            scheduleViewController.delegate = self
            let navigationController = UINavigationController(rootViewController: scheduleViewController)
            present(navigationController, animated: true)
            
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func setupEmojis(){
        
    }
    func setupColors(){
        
    }
    
    @objc
    func didTapCancelButton() {
        delegate?.didTapCancelButton()
    }
    
    @objc
    func categoryUIButtonTapped() {
        
    }
    
    @objc
    func didTapConfirmButton() {
        let newTracker = Tracker(
            id: UUID(),
            name: textField.text ?? "ERROR",
            emoji: emoji ?? "",
            color: color ?? UIColor(),
            completedDaysCount: 0,
            schedule: schedule
        )
        guard let category = category else { return }
        delegate?.didTapConfirmButton(category: category, trackerToAdd: newTracker)
        dismiss(animated: true)
    }
    
    @objc
    func scheduleUIButtonTapped() {
        let scheduleViewController = ScheduleViewController()
        
        scheduleViewController.modalPresentationStyle = .fullScreen
        
        scheduleViewController.delegate = self
        self.present(scheduleViewController, animated: true, completion: nil)
        
    }
}

extension TrackerCreationViewController {
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TrackerCreationViewController: ScheduleViewControllerDelegate {
    func didConfirm(_ schedule: [Weekday]) {
        self.schedule = schedule
        tableView.reloadData()
    }
}

class TextField: UITextField {
    private let textPadding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 41)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}

extension TrackerCreationViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case emojisCollection: return emojis.count
        case colorsCollection: return colors.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case emojisCollection:
            guard let emojiCell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.identifier, for: indexPath) as? EmojiCell else { return UICollectionViewCell() }
            let emoji = emojis[indexPath.row]
            emojiCell.configure(with: emoji)
            return emojiCell
        case colorsCollection:
            guard let colorCell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.identifier, for: indexPath) as? ColorCell else { return UICollectionViewCell() }
            let color = colors[indexPath.row]
            colorCell.configure(with: color)
            return colorCell
        default:
            return UICollectionViewCell()
        }
    }
}

extension TrackerCreationViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SelectionCellProtocol else { return }
        switch collectionView {
        case emojisCollection: emoji = emojis[indexPath.row]
        case colorsCollection: color = colors[indexPath.row]
        default: break
        }
        cell.select()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SelectionCellProtocol else { return }
        cell.deselect()
    }
}
extension TrackerCreationViewController: CategoriesViewControllerDelegate {
    func didConfirm(_ category: TrackerCategory) {
        self.category = category
        tableView.reloadData()
        dismiss(animated: true)
    }
}

extension TrackerCreationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let availableSpace = collectionView.frame.width - params.paddingWidth
        let cellWidth = availableSpace / params.cellCount
        return CGSize(width: cellWidth, height: params.height)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int) -> UIEdgeInsets
    {
        UIEdgeInsets(
            top: params.topInset,
            left: params.leftInset,
            bottom: params.bottomInset,
            right: params.rightInset
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        params.cellSpacing
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath) -> UICollectionReusableView
    {
        guard
            kind == UICollectionView.elementKindSectionHeader,
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: SelectionTitle.identifier,
                for: indexPath
            ) as? SelectionTitle
        else { return UICollectionReusableView() }
        
        var label: String
        switch collectionView {
        case emojisCollection: label = "Emoji"
        case colorsCollection: label = "Цвет"
        default: label = ""
        }
        
        view.configure(with: label)
        
        return view
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(
            collectionView,
            viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
            at: indexPath
        )
        
        return headerView.systemLayoutSizeFitting(
            CGSize(
                width: collectionView.frame.width,
                height: UIView.layoutFittingExpandedSize.height
            ),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
}
