//
//  TableViewCell.swift
//  Kkugy
//
//  Created by 신승재 on 4/17/24.
//

import UIKit

class SummaryCell: UITableViewCell {
    private let backgroundCardView = UIView()
    private let titleLabel = UILabel()
    private let detailLabel = UILabel()
    private let dateLabel = UILabel()
    
    private let gradientLayer = CAGradientLayer()
    
    private var dateLeftConstraint: NSLayoutConstraint!
    private var dateRightConstraint: NSLayoutConstraint!
    
    private var leftConstraint: NSLayoutConstraint!
    private var rightConstraint: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundCardView.translatesAutoresizingMaskIntoConstraints = false
        backgroundCardView.backgroundColor = .accent
        //backgroundCardView.layer.masksToBounds = true
        backgroundCardView.layer.shadowColor = UIColor.black.cgColor
        backgroundCardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        backgroundCardView.layer.shadowRadius = 4
        backgroundCardView.layer.shadowOpacity = 0.1
        backgroundCardView.layer.cornerRadius = 10
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundCardView.addSubview(dateLabel)
        
        dateLabel.font = UIFont.systemFont(ofSize: 40)
        dateLabel.textColor = .white
        
        contentView.addSubview(backgroundCardView)

        
        NSLayoutConstraint.activate([
            backgroundCardView.heightAnchor.constraint(equalToConstant: 140),
            backgroundCardView.widthAnchor.constraint(equalToConstant: 290),
            backgroundCardView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            dateLabel.centerXAnchor.constraint(equalTo: backgroundCardView.centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: backgroundCardView.centerYAnchor)
        ])
        
        leftConstraint = backgroundCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        rightConstraint = backgroundCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = backgroundCardView.bounds
    }
    
    func configure(date: Date, indexPath: IndexPath) {
        dateLabel.text = formatDate(date)
        
        if indexPath.row % 2 == 0 {
            leftConstraint.isActive = true
            rightConstraint.isActive = false
        } else {
            leftConstraint.isActive = false
            rightConstraint.isActive = true
        }
    }
    
    
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "No Date" }
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 dd일"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}
