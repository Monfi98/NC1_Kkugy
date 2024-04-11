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
//        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
}
