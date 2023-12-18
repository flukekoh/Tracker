//
//  CategoriesViewController.swift
//  Tracker
//
//  Created by Артем Кохан on 05.09.2023.
//

import UIKit

protocol CategoriesViewControllerDelegate: AnyObject {
    func didConfirm(_ category: TrackerCategory)
}

final class CategoriesViewController: UIViewController {
    
    private let categoriesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.identifier)
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = false
        tableView.alwaysBounceVertical = false
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 16, right: 0)
        
        return tableView
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
        placeholderLabel.text = "Привычки и события можно объединить по смыслу"
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
    
    private lazy var addButton: UIButton = {
        let addButton = UIButton(type: .system)
        
        addButton.backgroundColor = .black
        addButton.setTitleColor(.white, for: .normal)
        
        addButton.setTitle("Добавить категорию", for: .normal)
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setTitleColor(.white, for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        addButton.layer.cornerRadius = 16
        
        addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        
        return addButton
    }()
    
    weak var delegate: CategoriesViewControllerDelegate?
    private let viewModel: CategoriesViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupHierarchy()
        setupLayout()
        
        viewModel.delegate = self
        viewModel.loadCategories()
    }
    
    init(selectedCategory: TrackerCategory?) {
        viewModel = CategoriesViewModel(selectedCategory: selectedCategory)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        title = "Категория"
        view.backgroundColor = .white
        
        categoriesTableView.dataSource = self
        categoriesTableView.delegate = self
    }
    
    private func setupHierarchy() {
        view.addSubview(categoriesTableView)
        view.addSubview(addButton)
        
        placeholderStack.addArrangedSubview(placeholderImage)
        placeholderStack.addArrangedSubview(placeholderLabel)
        
        view.addSubview(placeholderStack)
    }
    private func setupLayout() {
        NSLayoutConstraint.activate([
            categoriesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            categoriesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            categoriesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            categoriesTableView.bottomAnchor.constraint(equalTo: addButton.topAnchor),
            
            addButton.leadingAnchor.constraint(equalTo: categoriesTableView.leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: categoriesTableView.trailingAnchor, constant: -16),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addButton.heightAnchor.constraint(equalToConstant: 60),
            
            placeholderStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            placeholderStack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            placeholderStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    @objc
    private func didTapAddButton() {
        let categoryCreationViewController = CategoryCreationViewController()
        categoryCreationViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: categoryCreationViewController)
        present(navigationController, animated: true)
    }
}

extension CategoriesViewController: CategoriesViewModelDelegate {
    
    func didUpdateCategories() {
        placeholderStack.isHidden = !viewModel.categories.isEmpty
        categoriesTableView.reloadData()
    }
    
    func didSelectCategory(_ category: TrackerCategory) {
        delegate?.didConfirm(category)
    }
    
}

extension CategoriesViewController: CategoryCreationViewControllerDelegate {
    func didConfirm(_ data: TrackerCategory.Data) {
        viewModel.handleCategoryFormConfirm(data: data)
        dismiss(animated: true)
    }
}

extension CategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let categoryCell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.identifier) as? CategoryCell else { return UITableViewCell() }
        
        let category = viewModel.categories[indexPath.row]
        let isSelected = viewModel.selectedCategory == category
        var position: CustomItem.Position
        
        switch indexPath.row {
        case 0:
            position = viewModel.categories.count == 1 ? .alone : .first
        case viewModel.categories.count - 1:
            position = .last
        default:
            position = .middle
        }
        
        categoryCell.configure(with: category.title, isSelected: isSelected, position: position)
        
        return categoryCell
    }
}

extension CategoriesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectCategory(at: indexPath)
    }
}
