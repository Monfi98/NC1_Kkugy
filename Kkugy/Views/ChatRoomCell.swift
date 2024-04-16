//
//  ChatRoomCell.swift
//  Kkugy
//
//  Created by 신승재 on 4/16/24.
//

import UIKit

class ChatRoomCell: UITableViewCell {
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lastDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(nameLabel)
        addSubview(lastDateLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: lastDateLabel.leadingAnchor, constant: -10),
            
            lastDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            lastDateLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configure(with chatRoom: ChatRoom) {
        nameLabel.text = "\(chatRoom.id)"
        lastDateLabel.text = formatDate(chatRoom.lastDate)
    }
    
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "No Date" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
