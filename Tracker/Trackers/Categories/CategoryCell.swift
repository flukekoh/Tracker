//
//  CategoryCell.swift
//  Tracker
//
//  Created by Артем Кохан on 05.09.2023.
//
import UIKit

final class CategoryCell: UITableViewCell {
    
    private lazy var customItem = CustomItem()
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    private let checkmarkImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "checkmark")
        return imageView
    }()
    
    static let identifier = "WeekdayCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupContent()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with label: String, isSelected: Bool, position: CustomItem.Position) {
        customItem.configure(with: position)
        self.label.text = label
        checkmarkImage.isHidden = !isSelected
    }
}

private extension CategoryCell {
    func setupContent() {
        selectionStyle = .none
        contentView.addSubview(customItem)
        contentView.addSubview(label)
        contentView.addSubview(checkmarkImage)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            customItem.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            customItem.topAnchor.constraint(equalTo: contentView.topAnchor),
            customItem.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            customItem.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            label.leadingAnchor.constraint(equalTo: customItem.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: customItem.centerYAnchor),
            label.trailingAnchor.constraint(equalTo: customItem.trailingAnchor, constant: -83),
            
            checkmarkImage.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            checkmarkImage.trailingAnchor.constraint(equalTo: customItem.trailingAnchor, constant: -16)
        ])
    }
}
