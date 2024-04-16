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
    var tableView: UITableView!
    var subTitleLabel: UILabel!
    var searchBar: UISearchBar!
    
    var chatRooms: [ChatRoom] = []
    
    var context: NSManagedObjectContext! = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var tableViewHeightConstraint: NSLayoutConstraint?
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        fetchChatRooms()
        setupUI()
        updateTableViewHeight()
    }

    
    // MARK: - Function
    func setupUI() {
        view.setGradientBackground()
        
        scrollView = UIScrollView()
        view.setupScrollView(scrollView)
        
        let rectangle = RoundedTranslucentView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        
        rectangle.addGestureRecognizer(tapGesture)
        rectangle.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(rectangle)
        
        subTitleLabel = UILabel()
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.text = "History"
        subTitleLabel.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        subTitleLabel.textAlignment = .left
        scrollView.addSubview(subTitleLabel)
        
        searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundImage = UIImage()
        scrollView.addSubview(searchBar)
        
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(ChatRoomCell.self, forCellReuseIdentifier: "ChatRoomCell")
        scrollView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            
            rectangle.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 10),
            rectangle.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            rectangle.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            rectangle.heightAnchor.constraint(equalToConstant: 140),
            
            subTitleLabel.topAnchor.constraint(equalTo: rectangle.bottomAnchor, constant: 40),
            subTitleLabel.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            subTitleLabel.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            
            searchBar.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -8),
            
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: 0),
        ])
        
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeightConstraint?.isActive = true
    }
    
    func fetchChatRooms() {
        let request: NSFetchRequest<ChatRoom> = ChatRoom.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "lastDate", ascending: false)
        request.sortDescriptors = [sortDescriptor]

        do {
            chatRooms = try context.fetch(request)
        } catch {
            print("Error fetching chat rooms: \(error)")
        }
    }
    
    func updateTableViewHeight() {
        tableView.layoutIfNeeded()
        tableViewHeightConstraint?.constant = tableView.contentSize.height
    }
    
    func navigateToChatView(index: Int?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let chatVC = storyboard.instantiateViewController(withIdentifier: "ChatView") as? ChatViewController {
            chatVC.hidesBottomBarWhenPushed = true
            
            if let idx = index {
                chatVC.currentChatRoom = chatRooms[idx]
            } else {
                chatVC.currentChatRoom = nil  // 인덱스가 제공되지 않은 경우
            }
            
            navigationController?.pushViewController(chatVC, animated: true)
        }
    }
    
    // MARK: - @IBAction Function
    @IBAction func didTapBarButton(_ sender: UIBarButtonItem) {
        navigateToChatView(index: nil)
    }
    
    
    // MARK: - @obj Function
    @objc func viewTapped() {
        navigateToChatView(index: 0)
    }
}

// MARK: - Extension Table View
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell", for: indexPath) as! ChatRoomCell
        
        let chatRoom = chatRooms[indexPath.row]
        cell.configure(with: chatRoom)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToChatView(index: indexPath.row)
    }
}
