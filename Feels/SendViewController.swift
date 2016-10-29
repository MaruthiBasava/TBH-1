//
//  SendViewController.swift
//  Feels
//
//  Created by Daniel Christopher on 10/16/16.
//  Copyright © 2016 IcyPickups LLC. All rights reserved.
//

import UIKit
import AddressBookUI
import RxSwift

class MessageTableViewCell: UITableViewCell {
    @IBOutlet weak var messageLabel: UILabel!
}

class SendViewController: UIViewController {
    
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var selectButton: UIButton!
    
    var recipientPhoneNumber: String!
    
    var selectedMessage: PresetMessageModel?
    
    let messageService = MessageService()
    let diposeBag = DisposeBag()
    
    fileprivate var items: [PresetMessageModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesTableView.makeRounded()
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        
        selectButton.makeRounded()
        
        messageService.getPossibleMessages()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { messages in
                self.items = messages!
                self.messagesTableView.reloadData()
            }, onError: { error in
                print(error)
            })
            .addDisposableTo(diposeBag)
    }
    
    @IBAction func back(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func send(_ sender: UIButton) {
        let messageCode = selectedMessage?.code
        let phoneNumber = recipientPhoneNumber
        messageService.sendMessageTo(messageCode: messageCode, phoneNumber: phoneNumber)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { success in
                self.dismiss(animated: true)
                print("sent")
            }, onError: { error in
                print(error)
            }).addDisposableTo(diposeBag)
    }
}

extension SendViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "message_cell") as! MessageTableViewCell
        
        cell.messageLabel.text = items[(indexPath as NSIndexPath).row].message
        
        return cell
    }
}

extension SendViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = items[indexPath.row]
        
        for message in items {
            if message.message == selectedItem.message {
                self.selectedMessage = message
            }
        }
    }
}
