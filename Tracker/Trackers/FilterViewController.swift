//
//  FilterViewController.swift
//  Tracker
//
//  Created by Артем Кохан on 19.09.2023.
//

import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func loadAllTrackers()
    func loadTodayTrackers()
    func loadCompletedTrackers()
    func loadUncompletedTrackers()
}

final class FilterViewController: UIViewController {
    
    weak var delegate: FilterViewControllerDelegate?
    
    private var tableData: [String]? {
        return ["Все трекеры", "Трекеры на сегодня", "Завершенные", "Не завершенные"]
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupHierarchy()
        setupLayout()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        title = NSLocalizedString("filters", comment: "Кнопка Фильтры")
    }
    
    private func setupHierarchy() {
        view.addSubview(tableView)
    }
    
    private func setupLayout(){
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(integerLiteral: (tableData?.count ?? 0) * 75)),
        ])
    }
}

extension FilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0: //Все трекеры
            delegate?.loadAllTrackers()
        case 1: //Трекеры на сегодня
            delegate?.loadTodayTrackers()
        case 2: //Завершенные
            delegate?.loadCompletedTrackers()
        case 3: //Не завершенные
            delegate?.loadUncompletedTrackers()
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}

extension FilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let customCell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier) as? CustomCell
        else { return UITableViewCell() }
        
        var position: CustomItem.Position
        var value: String = ""
        
        let data = tableData?[indexPath.row]
        
        position = .first
        
        customCell.configure(label: tableData?[indexPath.row] ?? "", value: value, position: position)
        return customCell
    }
    
    
}
