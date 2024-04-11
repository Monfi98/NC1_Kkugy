//
//  SummaryViewController.swift
//  Kkugy
//
//  Created by 신승재 on 4/10/24.
//

import UIKit

class SummaryViewController: UIViewController {
    // MARK: - Properties
    var scrollView: UIScrollView!
    
    // MARK: - IBOutlets
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.setGradientBackground()
        setUpScrollView()
        addRectanglesToScrollView()
    }
    
    // MARK: - Function
    func setUpScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func addRectanglesToScrollView() {
        // 첫 번째 사각형
        let rectangle1 = UIView()
        rectangle1.backgroundColor = .yellow
        rectangle1.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(rectangle1)
        
        // 두 번째 사각형
        let rectangle2 = UIView()
        rectangle2.backgroundColor = .cyan
        rectangle2.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(rectangle2)
        
        // 세 번째 사각형
        let rectangle3 = UIView()
        rectangle3.backgroundColor = .black
        rectangle3.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(rectangle3)
        
        NSLayoutConstraint.activate([
            rectangle1.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            rectangle1.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 0),
            rectangle1.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: 0),
            rectangle1.heightAnchor.constraint(equalToConstant: 250),
            
            rectangle2.topAnchor.constraint(equalTo: rectangle1.bottomAnchor, constant: 20),
            rectangle2.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 0),
            rectangle2.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: 0),
            rectangle2.heightAnchor.constraint(equalToConstant: 250),
            
            rectangle3.topAnchor.constraint(equalTo: rectangle2.bottomAnchor, constant: 20),
            rectangle3.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 0),
            rectangle3.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: 0),
            rectangle3.heightAnchor.constraint(equalToConstant: 250),
            rectangle3.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20), // 마지막 요소의 bottomAnchor를 scrollView의 contentLayoutGuide의 bottomAnchor에 연결
        ])
    }
}

// MARK: - Extension
