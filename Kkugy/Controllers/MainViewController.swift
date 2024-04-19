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
    
    private var scrollView: UIScrollView!
    private var recentTableView: UITableView!
    private var historyTableView: UITableView!
    private var mainTitleLabel: UILabel!
    private var subTitleLabel: UILabel!
    private var underlineView: UIView!
    private var recentButton: UIButton!
    private var oldButton: UIButton!
    private var messageCellTop: MessageCell!
    private var messageCellBottom: MessageCell!
    
    private var chatRooms: [ChatRoom] = []
    private var messages: [Message] = []
    
    private var context: NSManagedObjectContext! = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

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
        
        DispatchQueue.main.async {
            self.positionUnderlineView(under: self.recentButton, animated: false)
        }
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
       
        recentButton = UIButton()
        recentButton.setTitleColor(.accent, for: .normal)
        recentButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        recentButton.setTitle("Recent", for: .normal)
        recentButton.addTarget(self, action: #selector(toggleButtonTapped(_:)), for: .touchUpInside)
        recentButton.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(recentButton)
        
        oldButton = UIButton()
        oldButton.setTitleColor(.gray, for: .normal)
        oldButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        oldButton.setTitle("Old", for: .normal)
        oldButton.addTarget(self, action: #selector(toggleButtonTapped(_:)), for: .touchUpInside)
        oldButton.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(oldButton)
        
        underlineView = UIView()
        underlineView.backgroundColor = .accent
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(underlineView)
        
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
            subTitleLabel.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 20),
            
            recentButton.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 10),
            recentButton.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 23),
            
            oldButton.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 10),
            oldButton.leadingAnchor.constraint(equalTo: recentButton.trailingAnchor, constant: 20),
            
            
            historyTableView.topAnchor.constraint(equalTo: recentButton.bottomAnchor, constant: 10),
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
    
    func positionUnderlineView(under button: UIButton, animated: Bool) {
        let animationDuration = animated ? 0.3 : 0.0
        UIView.animate(withDuration: animationDuration) {
            self.underlineView.frame = CGRect(x: button.frame.minX,
                                              y: button.frame.maxY,
                                              width: button.frame.width,
                                              height: 3)
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
    
    @objc private func toggleButtonTapped(_ sender: UIButton) {
        positionUnderlineView(under: sender, animated: true)
        switch(sender) {
        case recentButton:
            recentButton.setTitleColor(.accent, for: .normal)
            oldButton.setTitleColor(.gray, for: .normal)
            
            chatRooms.reverse()
            historyTableView.reloadData()
        case oldButton:
            recentButton.setTitleColor(.gray, for: .normal)
            oldButton.setTitleColor(.accent, for: .normal)
            
            chatRooms.reverse()
            historyTableView.reloadData()
        default:
            break
        }
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true 
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let chatRoomToDelete = chatRooms[indexPath.row]
            context.delete(chatRoomToDelete)
            chatRooms.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            do {
                try context.save()
            } catch {
                print("Failed to delete chat room: \(error)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}
