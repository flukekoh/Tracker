//
//  StaticticsViewController.swift
//  Tracker
//
//  Created by Артем Кохан on 05.04.2023.
//

import Foundation
import UIKit

final class StatisticsViewController: UIViewController {
    var statisticsViewModel: StatisticsViewModel?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("statistics.title", comment: "Статистика")
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        return label
    }()
    
    private let placeholderImage: UIImageView = {
        let placeholderImage = UIImageView()
        placeholderImage.translatesAutoresizingMaskIntoConstraints = false
        placeholderImage.image = UIImage(named: "NoStatistics")
        
        return placeholderImage
    }()
    
    private let placeholderLabel: UILabel = {
        let placeholderLabel = UILabel()
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        placeholderLabel.text = "Анализировать пока нечего"
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
    
    private let statisticsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        return stack
    }()
    
    private let completedTrackersView = StatisticsView(name: "Трекеров завершено")
    private let trackerRecordStore = TrackerRecordStore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupHierarchy()
        setupLayout()
        
        statisticsViewModel?.onTrackersChange = { [weak self] trackers in
            guard let self else { return }
            self.checkContent(with: trackers)
            self.setupCompletedTrackersBlock(with: trackers.count)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        statisticsViewModel?.viewWillAppear()
    }
    
    func setupView() {
        view.backgroundColor = .white
    }
    
    func setupHierarchy() {
        view.addSubview(titleLabel)
        placeholderStack.addArrangedSubview(placeholderImage)
        placeholderStack.addArrangedSubview(placeholderLabel)
        view.addSubview(placeholderStack)
        view.addSubview(statisticsStack)
        statisticsStack.addArrangedSubview(completedTrackersView)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
           
            placeholderStack.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            placeholderStack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        
            statisticsStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            statisticsStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            statisticsStack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func checkContent(with trackers: [TrackerRecord]) {
        if trackers.isEmpty {
            placeholderStack.isHidden = false
            statisticsStack.isHidden = true
        } else {
            placeholderStack.isHidden = true
            statisticsStack.isHidden = false
        }
    }
    
    private func setupCompletedTrackersBlock(with count: Int) {
        completedTrackersView.setNumber(count)
    }
}
