//
//  MessageCell.swift
//  Kkugy
//
//  Created by 신승재 on 4/12/24.
//
import UIKit

class MessageCell: UITableViewCell {
    let messageLabel = UILabel()
    let messageBackgroundView = UIView()
    let timeLabel = UILabel()
    
    var leadingConstraint: NSLayoutConstraint?
    var trailingConstraint: NSLayoutConstraint?
    var timeLabelConstraint: NSLayoutConstraint?
    var timeLabelBottomConstraint: NSLayoutConstraint?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        messageBackgroundView.backgroundColor = .lightGray
        messageBackgroundView.layer.cornerRadius = 12
        messageBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(messageBackgroundView)
        
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont.systemFont(ofSize: 15)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(messageLabel)
        
        timeLabel.font = UIFont.systemFont(ofSize: 10)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(timeLabel)
        
        let maxWidth = UIScreen.main.bounds.width * 0.6
        
        NSLayoutConstraint.activate([
            messageBackgroundView.topAnchor.constraint(equalTo: topAnchor, constant: 3),
            messageBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3),
            
            messageBackgroundView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 20),
            messageBackgroundView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20),
            messageBackgroundView.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth),
            
            messageLabel.topAnchor.constraint(equalTo: messageBackgroundView.topAnchor, constant: 10),
            messageLabel.bottomAnchor.constraint(equalTo: messageBackgroundView.bottomAnchor, constant: -10),
            messageLabel.leadingAnchor.constraint(equalTo: messageBackgroundView.leadingAnchor, constant: 10),
            messageLabel.trailingAnchor.constraint(equalTo: messageBackgroundView.trailingAnchor, constant: -10)
        ])
        
        leadingConstraint = messageBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        trailingConstraint = messageBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -100)
        leadingConstraint?.isActive = true
        trailingConstraint?.isActive = true
    }
    
    func configure(with message: String, date: Date, isSender: Bool, showTime: Bool) {
        messageLabel.text = message
        timeLabel.text = formatTime(date)
        timeLabel.isHidden = !showTime
        
        messageBackgroundView.backgroundColor = isSender ? .accent : .white
        messageLabel.textColor = isSender ? .white : .black
        messageLabel.textAlignment = isSender ? .right : .left
        
        timeLabelConstraint?.isActive = false
        
        leadingConstraint?.isActive = !isSender
        trailingConstraint?.isActive = isSender
        
        if isSender {
            leadingConstraint?.constant = 100
            trailingConstraint?.constant = -20
            timeLabelConstraint = timeLabel.trailingAnchor.constraint(equalTo: messageBackgroundView.leadingAnchor, constant: -5)
            timeLabelBottomConstraint = timeLabel.bottomAnchor.constraint(equalTo: messageBackgroundView.bottomAnchor)
        } else {
            leadingConstraint?.constant = 20
            trailingConstraint?.constant = -100
            timeLabelConstraint = timeLabel.leadingAnchor.constraint(equalTo: messageBackgroundView.trailingAnchor, constant: 5)
            timeLabelBottomConstraint = timeLabel.bottomAnchor.constraint(equalTo: messageBackgroundView.bottomAnchor)
            
        }
        
        timeLabelConstraint?.isActive = true
        timeLabelBottomConstraint?.isActive = true
        
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "a h시 m분"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}
