//
//  RoundedTranslucentView.swift
//  Kkugy
//
//  Created by 신승재 on 4/11/24.
//

import UIKit

class RoundedTranslucentView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        self.layer.cornerRadius = 15
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2) // 그림자의 방향 및 거리
        self.layer.shadowRadius = 4 // 그림자의 퍼짐 정도
        self.layer.shadowOpacity = 0.1 // 그림자의 투명도
        
        self.clipsToBounds = false
    }
    
}
