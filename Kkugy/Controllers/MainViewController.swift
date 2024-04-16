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
    var recentTableView: UITableView!
    var historyTableView: UITableView!
    var mainTitleLabel: UILabel!
    var subTitleLabel: UILabel!
    var searchBar: UISearchBar!
    var messageCellTop: MessageCell!
    var messageCellBottom: MessageCell!
    
    var chatRooms: [ChatRoom] = []
    var messages: [Message] = []
    
    var context: NSManagedObjectContext! = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var rectangleHeightConstraint: NSLayoutConstraint?
    private var recentTableViewHeightConstraint: NSLayoutConstraint?
    private var historyTableViewHeightConstraint: NSLayoutConstraint?
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        fetchChatRooms()
        loadPreviewMessages()
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
        
        
        messageCellTop = MessageCell()
        messageCellBottom = MessageCell()
        
        if messages.isEmpty {
            
            messageCellTop.configure(with:  "test", date: Date(), isSender: true, showTime: true)
            
            messageCellBottom.configure(with: "test", date: Date(), isSender: false, showTime: true)
        } else {
            let message1 = messages[0]
            messageCellTop.configure(with: message1.text ?? "", date: message1.date!, isSender: message1.isSender, showTime: true)
            
            let message2 = messages[1]
            messageCellBottom.configure(with: message2.text ?? "", date: message2.date!, isSender: message2.isSender, showTime: true)
        }
        messageCellTop.translatesAutoresizingMaskIntoConstraints = false
        messageCellBottom.translatesAutoresizingMaskIntoConstraints = false
        rectangle.addSubview(messageCellTop)
        rectangle.addSubview(messageCellBottom)
        
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
        historyTableView.backgroundColor = UIColor.clear
        historyTableView.separatorStyle = .none
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
            
            messageCellTop.topAnchor.constraint(equalTo: rectangle.topAnchor, constant: 10),
            messageCellTop.leadingAnchor.constraint(equalTo: rectangle.leadingAnchor),
            messageCellTop.trailingAnchor.constraint(equalTo: rectangle.trailingAnchor),
            
            messageCellBottom.topAnchor.constraint(equalTo: messageCellTop.bottomAnchor),
            messageCellBottom.leadingAnchor.constraint(equalTo: rectangle.leadingAnchor),
            messageCellBottom.trailingAnchor.constraint(equalTo: rectangle.trailingAnchor),
            messageCellBottom.bottomAnchor.constraint(equalTo: rectangle.bottomAnchor, constant: -10),
            
            subTitleLabel.topAnchor.constraint(equalTo: rectangle.bottomAnchor, constant: 30),
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
        
        historyTableViewHeightConstraint = historyTableView.heightAnchor.constraint(equalToConstant: 0)
        
        historyTableViewHeightConstraint?.isActive = true
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
        historyTableViewHeightConstraint?.constant = CGFloat(chatRooms.count * 85)
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
    
    func loadPreviewMessages() {
        guard let chatRoom = chatRooms.first else {
            print("No chat rooms available")
            return
        }
        
        if let messagesSet = chatRoom.messages as? Set<Message> {
            let sortedMessages = messagesSet.sorted {
                $0.date! > $1.date!
            }
            
            let recentMessages = Array(sortedMessages.prefix(2).reversed())
            self.messages = recentMessages
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
        // cell.selectionStyle = .none
    }
}
