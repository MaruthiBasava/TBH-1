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
    var data: MutualMessageList?
    
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
            self?.tableView.dg_stopLoading()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor.basavaRed())
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        
        segmentedControl.layer.cornerRadius = 15.0;
        segmentedControl.layer.borderColor = UIColor.basavaRed().cgColor
        segmentedControl.layer.borderWidth = 1.0
        segmentedControl.layer.masksToBounds = true
    }

    private func loadMessages() {
        if segmentedControl.selectedSegmentIndex == matchesIndex {
            messageService.getMutualMessages()
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { messageList in
                    self.data = messageList
                    self.tableView.reloadData()
                }, onError: { error in
                    print(error)
                    self.showGenericError()
                })
                .addDisposableTo(disposeBag)
        }
        else if segmentedControl.selectedSegmentIndex == receivedIndex {
            messageService.getReceivedAnonymousMessages()
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { messageList in
                    self.data = messageList
                    self.tableView.reloadData()
                }, onError: { error in
                    print(error)
                    self.showGenericError()
                })
                .addDisposableTo(disposeBag)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        
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
            cell.label.text = data!.messages[indexPath.row].message
        }
        else if segmentedControl.selectedSegmentIndex == receivedIndex {
        
        }
    
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data != nil {
            return data!.messages.count
        }
        
        return 0
    }
}
