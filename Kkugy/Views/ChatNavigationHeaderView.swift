//
//  ChatNavigationHeaderView.swift
//  Kkugy
//
//  Created by 신승재 on 4/15/24.
//

import UIKit

class ChatNavigationHeaderView: UIView {
    private let backButton = UIButton(type: .system)
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    
    var backButtonAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        backgroundColor = .clear
        
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .accent
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        imageView.image = UIImage(named: "profile")
        imageView.backgroundColor = .gray
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        
        nameLabel.text = "이성국(꾸기)"
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        
        addSubview(backButton)
        addSubview(imageView)
        addSubview(nameLabel)
    }
    
    private func setupConstraints() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            imageView.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 16),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 30),
            imageView.heightAnchor.constraint(equalToConstant: 30),
            
            nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    @objc private func backButtonTapped() {
        backButtonAction?()
    }
    
}
