//
//  DetailViewController.swift
//  Kkugy
//
//  Created by 신승재 on 4/11/24.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK: - Properties
    var scrollView: UIScrollView!
    
    
    // MARK: - IBOutlets
    
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        initializeSetup()
    }
    
    // MARK: - Function
    func initializeSetup() {
        view.setGradientBackground()
        
        scrollView = UIScrollView()
        self.view.setupScrollView(scrollView)
    }
}

// MARK: - Extension
