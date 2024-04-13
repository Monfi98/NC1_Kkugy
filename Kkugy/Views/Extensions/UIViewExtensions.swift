//
//  UIViewExtensions.swift
//  Kkugy
//
//  Created by 신승재 on 4/11/24.
//

import UIKit


extension UIView {
    
    // Default Gradient Background
    func setGradientBackground() {
        guard let BackgroundColor1 = UIColor(named: "BackgroundColor1") else { return }
        guard let BackgroundColor2 = UIColor(named: "BackgroundColor2") else { return }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [BackgroundColor1.cgColor, BackgroundColor2.cgColor]
        self.layer.addSublayer(gradientLayer)
    }
    
    // Translucent Background
    func setTranslucentBackground() {
        let overlay = CALayer()
        overlay.frame = self.bounds
        overlay.backgroundColor = UIColor.white.cgColor
        overlay.opacity = 0.2
        self.layer.addSublayer(overlay)
    }
    
    // Scroll View
    func setupScrollView(_ scrollView: UIScrollView) {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}
