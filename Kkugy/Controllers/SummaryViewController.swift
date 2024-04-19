//
//  SummaryViewController.swift
//  Kkugy
//
//  Created by 신승재 on 4/10/24.
//

import UIKit
import CoreData

class SummaryViewController: UIViewController {
    // MARK: - Properties
    private var tableView: UITableView!
    private var chatRooms: [ChatRoom] = []
    private var summarys: [Summary] = []
    
    private var context: NSManagedObjectContext! = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchChatRooms()
        setupUI()
        fetchSummarys()
    }
    
    // MARK: - Function
    func setupUI() {
        view.setGradientBackground()
        
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.register(SummaryCell.self, forCellReuseIdentifier: "SummaryCell")

        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])

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
    
    func fetchSummarys() {
        let request: NSFetchRequest<Summary> = Summary.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "createDate", ascending: false)
        request.sortDescriptors = [sortDescriptor]

        do {
            summarys = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print("Error fetching summarys: \(error)")
        }
    }
    
    func createNewSummary(content: String) {
        let summary = Summary(context: context)
        summary.createDate = Date()
        summary.content = content
        do {
            try context.save()
            fetchSummarys()
        } catch {
            print("Failed to create new summary: \(error)")
        }
    }
    
    @IBAction func didTapBarButton(_ sender: Any) {
        NetworkManager.shared.categorizeForSummary(chatRooms: chatRooms, completion: { result in
            switch result {
            case .success(let response):
                print("AI Response: \(response)")
                self.createNewSummary(content: response)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        })
    }
}

// MARK: - Extension Table View
extension SummaryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return summarys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryCell", for: indexPath) as! SummaryCell
        let date = summarys[indexPath.row].createDate
        cell.configure(date: date!, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true  // Allow all rows to be editable
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Handle deletion logic here, such as removing the data from CoreData and updating the tableView
            let summaryToDelete = summarys[indexPath.row]
            context.delete(summaryToDelete)
            summarys.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            // Save changes in CoreData
            do {
                try context.save()
                fetchSummarys() // Optionally refetch data if needed
            } catch {
                print("Error deleting summary: \(error)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailVC") as? DetailViewController {
            detailVC.hidesBottomBarWhenPushed = true
            detailVC.currentSummary = summarys[indexPath.row]
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
}
