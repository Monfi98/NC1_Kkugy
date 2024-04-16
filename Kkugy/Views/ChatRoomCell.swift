//
//  ChatRoomCell.swift
//  Kkugy
//
//  Created by 신승재 on 4/16/24.
//

import UIKit

class ChatRoomCell: UITableViewCell {
    
    private let roundedView = RoundedTranslucentView()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lastDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
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
        contentView.addSubview(roundedView)
        roundedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            roundedView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            roundedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            roundedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            roundedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
        ])
        
        roundedView.addSubview(nameLabel)
        roundedView.addSubview(lastDateLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: roundedView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: roundedView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: roundedView.trailingAnchor, constant: -20),
            
            lastDateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            lastDateLabel.trailingAnchor.constraint(equalTo: roundedView.trailingAnchor, constant: -20),
            lastDateLabel.bottomAnchor.constraint(equalTo: roundedView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with chatRoom: ChatRoom) {
        nameLabel.text = "\(chatRoom.id)"
        lastDateLabel.text = formatDate(chatRoom.lastDate)
    }
    
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "No Date" }
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}
