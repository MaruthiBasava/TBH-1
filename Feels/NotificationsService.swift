//
//  NotificationsService.swift
//  Feels
//
//  Created by Daniel Christopher on 11/4/16.
//  Copyright © 2016 IcyPickups LLC. All rights reserved.
//

import Foundation

@objc(TBHNotification)
class TBHNotification: NSObject, NSCoding {
    var title: String!
    var body: String!
    
    init(title: String, body: String) {
        self.title = title
        self.body = body
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let title = aDecoder.decodeObject(forKey: "title") as? String ?? ""
        let body = aDecoder.decodeObject(forKey: "body") as? String ?? ""
        self.init(title: title, body: body)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.body, forKey: "body")
    }
}

class NotificationsService {
    private let notificationsKey = "notifications"
    private let unreadCountKey = "unreadcount"
    
    func clearUnread() {
        UserDefaults.standard.set(0, forKey: unreadCountKey)
    }
    
    func addToUnread(notification: TBHNotification) {
        UserDefaults.standard.set(UserDefaults.standard.integer(forKey: unreadCountKey) + 1, forKey: unreadCountKey)
        
        var notifications: [TBHNotification] = []
        notifications.append(notification)
        if let decoded = UserDefaults.standard.object(forKey: notificationsKey) as? NSData {
            let notifs = NSKeyedUnarchiver.unarchiveObject(with: decoded as Data) as! [TBHNotification]
            for u in notifs {
                notifications.append(u)
            }
        }
        
        let data = NSKeyedArchiver.archivedData(withRootObject: notifications)
        UserDefaults.standard.set(data, forKey: notificationsKey)
    }
    
    func getAllNotifications() -> [TBHNotification] {
        return decodeArray(key: notificationsKey)
    }
    
    func numberOfUnread() -> Int {
        return UserDefaults.standard.integer(forKey: unreadCountKey)
    }
    
    private func decodeArray(key: String) -> [TBHNotification] {
        if let decoded = UserDefaults.standard.object(forKey: key) as? NSData {
            return NSKeyedUnarchiver.unarchiveObject(with: decoded as Data) as! [TBHNotification]
        }
        
        return []
    }
}
