//
//  DetailViewController.swift
//  Kkugy
//
//  Created by 신승재 on 4/11/24.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK: - Properties
    private var closeButton: UIButton!
    private var scrollView: UIScrollView!
    private var titleLabel: UILabel!
    private var textView: UITextView!
    private var rectangle: UIView!
    
    var currentSummary: Summary?
    
    // MARK: - IBOutlets
    
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Function
    func setupUI() {
        view.backgroundColor = .accent
        
        scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.setupScrollView(scrollView)
        
        closeButton = UIButton(type: .system)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        closeButton.tintColor = .white
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        view.addSubview(closeButton)
        
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.text = formatDate(currentSummary?.createDate)
        scrollView.addSubview(titleLabel)
        
        rectangle = RoundedTranslucentView()
        rectangle.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(rectangle)
        
        textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.textColor = .black
        textView.font = UIFont.systemFont(ofSize: 16)
        //textView.isScrollEnabled = false
        textView.isEditable = false
        textView.text = currentSummary?.content
        scrollView.addSubview(textView)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            closeButton.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 20),
            
            titleLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -20),
            
            rectangle.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            rectangle.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 20),
            rectangle.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -20),
            rectangle.heightAnchor.constraint(equalToConstant: 550),

            rectangle.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: 0),
            
            textView.topAnchor.constraint(equalTo: rectangle.topAnchor, constant: 10),
            textView.leadingAnchor.constraint(equalTo: rectangle.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: rectangle.trailingAnchor, constant: -20),
            textView.bottomAnchor.constraint(equalTo: rectangle.bottomAnchor, constant: -20),

            
        ])
    }
    
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "No Date" }
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 dd일"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    @objc private func closeButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Extension
