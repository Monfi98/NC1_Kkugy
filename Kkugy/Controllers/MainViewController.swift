//
//  ViewController.swift
//  Kkugy
//
//  Created by 신승재 on 4/10/24.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    // MARK: - Properties
    var scrollView: UIScrollView!
    
    var context: NSManagedObjectContext! = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
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
        
        addToScrollView()
    }
    
    
    func addToScrollView() {
    
        // 첫 번째 rectangle
        let rectangle = RoundedTranslucentView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        
        rectangle.addGestureRecognizer(tapGesture)
        rectangle.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(rectangle)
        
        // 두번째 제목
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.text = "History"
        textLabel.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        textLabel.textAlignment = .left
        scrollView.addSubview(textLabel)
        
        
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundImage = UIImage()
        scrollView.addSubview(searchBar)

       
        
        // 두 번째 사각형
        let rectangle2 = RoundedTranslucentView()
        rectangle2.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(rectangle2)
        
        // 세 번째 사각형
        let rectangle3 = RoundedTranslucentView()
        rectangle3.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(rectangle3)
        
        NSLayoutConstraint.activate([
            
            rectangle.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 10),
            rectangle.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            rectangle.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            rectangle.heightAnchor.constraint(equalToConstant: 140),
            
            textLabel.topAnchor.constraint(equalTo: rectangle.bottomAnchor, constant: 40),
            textLabel.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            
            searchBar.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -8),
            
            
            rectangle2.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            rectangle2.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            rectangle2.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            rectangle2.heightAnchor.constraint(equalToConstant: 250),
            
            rectangle3.topAnchor.constraint(equalTo: rectangle2.bottomAnchor, constant: 20),
            rectangle3.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            rectangle3.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            rectangle3.heightAnchor.constraint(equalToConstant: 250),
            rectangle3.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20), // 마지막 요소의 bottomAnchor를 scrollView의 contentLayoutGuide의 bottomAnchor에 연결
        ])
    }
    
    func fetchChatRooms() -> [ChatRoom] {
        let request: NSFetchRequest<ChatRoom> = ChatRoom.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "lastDate", ascending: false)
        request.sortDescriptors = [sortDescriptor]

        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching chat rooms: \(error)")
            return []
        }
    }
    
    // MARK: - @IBAction Function
    @IBAction func didTapBarButton(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let chatVC = storyboard.instantiateViewController(withIdentifier: "ChatView") as? ChatViewController {
            chatVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(chatVC, animated: true)
        }
    }
    
    
    // MARK: - @obj Function
    @objc func viewTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let chatVC = storyboard.instantiateViewController(withIdentifier: "ChatView") as? ChatViewController {
            chatVC.hidesBottomBarWhenPushed = true
            let mostRecentChatRoom = fetchChatRooms()[0]
            chatVC.currentChatRoom = mostRecentChatRoom
            navigationController?.pushViewController(chatVC, animated: true)
        }
    }
}

// MARK: - Extension


// rectangle3.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20),
// scroll view를 사용할때 마지막 요소에 들어가는 auto layout
