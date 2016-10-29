//
//  NotificationsViewController.swift
//  Feels
//
//  Created by Daniel Christopher on 10/29/16.
//  Copyright © 2016 IcyPickups LLC. All rights reserved.
//

import UIKit

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
    
    var data: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        
        segmentedControl.layer.cornerRadius = 15.0;
        segmentedControl.layer.borderColor = UIColor.basavaRed().cgColor
        segmentedControl.layer.borderWidth = 1.0
        segmentedControl.layer.masksToBounds = true
        
        data.append("\"Your cute 😍\"")
        data.append("\"We should hang out 👌\"")
        data.append("\"We should start talking again\"")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        
    }
}

extension NotificationsViewController: UITableViewDelegate {
    
}

extension NotificationsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notification_cell") as! NotificationCell
        
        if segmentedControl.selectedSegmentIndex == matchesIndex {
            cell.label.text = data[indexPath.row]
        }
        else if segmentedControl.selectedSegmentIndex == receivedIndex {
        
        }
    
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
}
