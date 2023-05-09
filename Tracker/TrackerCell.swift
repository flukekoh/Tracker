//
//  TrackerCell.swift
//  Tracker
//
//  Created by Артем Кохан on 06.04.2023.
//

import Foundation
import UIKit

protocol TrackerCellDelegate: AnyObject {
    func completeTracker(id: UUID, at indexPath: IndexPath)
    func uncompleteTracker(id: UUID, at indexPath: IndexPath)
}

final class TrackerCell: UICollectionViewCell {
    static let identifier = "TrackerCell"
    
    weak var delegate: TrackerCellDelegate?
    
    private var isCompletedToday = false
    private var trackerId: UUID?
    private var indexPath: IndexPath?
    
    // MARK: - UI
    
    private lazy var mainContentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var emojiContentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var taskLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var daysCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
//        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.font = UIFont(name: "SFPro-Medium", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = 17
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let plusImage: UIImage = {
        let pointSize = UIImage.SymbolConfiguration(pointSize: 11)
        let image = UIImage(systemName: "plus", withConfiguration: pointSize) ?? UIImage()
        
        return image
    }()
    
    private let doneImage: UIImage = {
        let pointSize = UIImage.SymbolConfiguration(pointSize: 11)
        let image = UIImage(systemName: "checkmark", withConfiguration: pointSize) ?? UIImage()
        
        return image
    }()
    
    // MARK: - LC
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Setups
    func configure(with tracker: Tracker, isCompletedToday: Bool, completedDays: Int, indexPath: IndexPath) {
        self.trackerId = tracker.id
        self.isCompletedToday = isCompletedToday
        self.indexPath = indexPath
        
        let color = tracker.color
        
        setupView()
        setupHierarchy()
        setupLayout()
        
        mainContentView.backgroundColor = color
        button.backgroundColor = color
        
        taskLabel.text = tracker.name
        emojiLabel.text = tracker.emoji
        
        let wordDay = pluralizeDays(completedDays)
        daysCountLabel.text = "\(wordDay)"
        
        if isCompletedToday {
            button.setImage(doneImage, for: .normal)
            button.layer.opacity = 0.3
        } else {
            button.setImage(plusImage, for: .normal)
            button.layer.opacity = 1
        }
    }
    
    private func pluralizeDays(_ count: Int) -> String {
        let remainder10 = count % 10
        let remainder100 = count % 100
        
        if remainder10 == 1 && remainder100 != 11 {
            return "\(count) день"
        } else if remainder10 >= 2 && remainder10 <= 4 && (remainder100 < 10 || remainder100 >= 20) {
            return "\(count) дня"
        } else {
            return "\(count) дней"
        }
    }
    
    private func setupView() {
        backgroundColor = .clear
    }
    
    private func setupHierarchy() {
        addSubview(mainContentView)
        addSubview(daysCountLabel)
        addSubview(button)
        emojiContentView.addSubview(emojiLabel)
        mainContentView.addSubview(emojiContentView)
        mainContentView.addSubview(taskLabel)
        
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: emojiContentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiContentView.centerYAnchor),
            
            emojiContentView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 12),
            emojiContentView.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 12),
            emojiContentView.widthAnchor.constraint(equalToConstant: 24),
            emojiContentView.heightAnchor.constraint(equalToConstant: 24),
            
            taskLabel.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 12),
            taskLabel.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -12),
            taskLabel.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -12),
            
            mainContentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainContentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainContentView.topAnchor.constraint(equalTo: topAnchor),
            mainContentView.heightAnchor.constraint(equalToConstant: 90),
            
            daysCountLabel.topAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: 16),
            daysCountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            daysCountLabel.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: 8),
            daysCountLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            button.centerYAnchor.constraint(equalTo: daysCountLabel.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 34),
            button.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func buttonTapped() {
        guard let trackerId = trackerId, let indexPath = indexPath else {
            assertionFailure("No tracker Id or index")
            return
        }
        if isCompletedToday {
            delegate?.uncompleteTracker(id: trackerId, at: indexPath)
            
        } else {
            delegate?.completeTracker(id: trackerId, at: indexPath)
        }
    }
}
