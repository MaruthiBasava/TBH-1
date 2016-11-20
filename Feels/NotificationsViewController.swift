//
//  NotificationsViewController.swift
//  Feels
//
//  Created by Daniel Christopher on 10/29/16.
//  Copyright © 2016 IcyPickups LLC. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh
import RxSwift
import Contacts
import SwiftEventBus

class NotificationCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
}

class NotificationsViewController: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    let matchesIndex = 0
    let receivedIndex = 1
    let notificationCell = "notificationCell"
    
    private let disposeBag = DisposeBag()
    private var messageService = MessageService()
    
    var matches: MessageList?
    var received: MessageList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        
        // Initialize tableView
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.white
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self?.loadMessages()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor.basavaRed())
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        
        segmentedControl.layer.cornerRadius = 15.0;
        segmentedControl.layer.borderColor = UIColor.basavaRed().cgColor
        segmentedControl.layer.borderWidth = 1.0
        segmentedControl.layer.masksToBounds = true
        
        reloadFromCache()
        
        SwiftEventBus.onMainThread(self, name: EventBusEvents.receivedAnonymousMessage) { result in
            self.reloadFromCache()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("appearing")
        reloadFromCache()
    }
    
    func reloadFromCache() {
        messageService.getAnonymousMessagesFromCache()
            .subscribe(onNext: { messages in
                self.received = messages
                self.tableView.reloadData()
                }, onError: { error in
                    
                }, onCompleted: nil, onDisposed: nil)
            .addDisposableTo(disposeBag)
    }

    private func loadMessages() {
        if segmentedControl.selectedSegmentIndex == matchesIndex {
            messageService.getMutualMessages()
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { messageList in
                    self.matches = messageList
                    self.tableView.reloadData()
                    self.tableView.dg_stopLoading()
                }, onError: { error in
                    print(error)
                    self.tableView.dg_stopLoading()
                    self.showGenericError()
                })
                .addDisposableTo(disposeBag)
        }
        else if segmentedControl.selectedSegmentIndex == receivedIndex {
            messageService.getReceivedAnonymousMessages()
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { messageList in
                    self.received = messageList
                    self.tableView.reloadData()
                    self.tableView.dg_stopLoading()
                }, onError: { error in
                    print(error)
                    self.tableView.dg_stopLoading()
                    self.showGenericError()
                })
                .addDisposableTo(disposeBag)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        self.tableView.reloadData()
    }
    
    deinit {
        tableView.dg_removePullToRefresh()
    }
}

extension NotificationsViewController: UITableViewDelegate {
    
}

extension NotificationsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notification_cell") as! NotificationCell
        
        if segmentedControl.selectedSegmentIndex == matchesIndex {
            let match = matches!.messages[indexPath.row]
            cell.nameLabel.text = match.sender.name
            cell.label.text = matches!.messages[indexPath.row].message
        }
        else if segmentedControl.selectedSegmentIndex == receivedIndex {
            cell.nameLabel.text = "Anonymous"
            cell.label.text = received!.messages[indexPath.row].message
        }
    
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == matchesIndex {
            if matches != nil {
                return matches!.messages.count
            }
        }
        else if segmentedControl.selectedSegmentIndex == receivedIndex {
            if received != nil {
                return received!.messages.count
            }
        }
        
        return 0
    }
}
