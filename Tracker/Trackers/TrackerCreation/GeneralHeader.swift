//
//  GeneralHeader.swift
//  Tracker
//
//  Created by Артем Кохан on 15.05.2023.
//

import UIKit

final class GeneralHeader: UICollectionReusableView {
    
    static let identifier = "GeneralHeader"
    
    var labelText: String? {
        didSet {
            label.text = labelText
        }
    }
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 19)
        return label
    }()
    
    func configureHeader(title: String) {
        label.text = title
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
