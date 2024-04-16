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
    var rescentTableView: UITableView!
    var historyTableView: UITableView!
    var mainTitleLabel: UILabel!
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
        
        mainTitleLabel = UILabel()
        mainTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        mainTitleLabel.text = "최근 대화"
        mainTitleLabel.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        mainTitleLabel.textAlignment = .left
        scrollView.addSubview(mainTitleLabel)
        
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
        
        historyTableView = UITableView()
        historyTableView.dataSource = self
        historyTableView.delegate = self
        historyTableView.isScrollEnabled = false
        historyTableView.translatesAutoresizingMaskIntoConstraints = false
        
        historyTableView.register(ChatRoomCell.self, forCellReuseIdentifier: "ChatRoomCell")
        scrollView.addSubview(historyTableView)
        
        NSLayoutConstraint.activate([
            
            mainTitleLabel.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 10),
            mainTitleLabel.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            mainTitleLabel.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            
            rectangle.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: 10),
            rectangle.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            rectangle.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            rectangle.heightAnchor.constraint(equalToConstant: 140),
            
            subTitleLabel.topAnchor.constraint(equalTo: rectangle.bottomAnchor, constant: 40),
            subTitleLabel.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            subTitleLabel.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            
            searchBar.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -8),
            
            
            historyTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            historyTableView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            historyTableView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            historyTableView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: 0),
        ])
        
        tableViewHeightConstraint = historyTableView.heightAnchor.constraint(equalToConstant: 0)
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
        historyTableView.layoutIfNeeded()
        tableViewHeightConstraint?.constant = historyTableView.contentSize.height
    }
    
    func navigateToChatView(index: Int?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let chatVC = storyboard.instantiateViewController(withIdentifier: "ChatView") as? ChatViewController {
            chatVC.hidesBottomBarWhenPushed = true
            
            if let idx = index {
                chatVC.currentChatRoom = chatRooms[idx]
            } else {
                chatVC.currentChatRoom = nil
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
        switch(tableView) {
        case historyTableView:
            return chatRooms.count
            
        case rescentTableView:
            return 0
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch(tableView) {
        case historyTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell", for: indexPath) as! ChatRoomCell
            let chatRoom = chatRooms[indexPath.row]
            cell.configure(with: chatRoom)
            return cell
            
        case rescentTableView:
            let cell = UITableViewCell()
            return cell
            
        default:
            let cell = UITableViewCell()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == historyTableView {
            navigateToChatView(index: indexPath.row)
        }
    }
}
