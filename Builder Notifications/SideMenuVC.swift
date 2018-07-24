//
//  SideMenuVC.swift
//  Builder Notifications
//
//  Created by Shea Paris on 23/07/18.
//  Copyright © 2018 Gary Baker. All rights reserved.
//

import UIKit

class SideMenuVC: UITableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        NotificationCenter.default.post(name: NSNotification.Name("toggleSideMenu"), object: nil)
        switch indexPath.row {
        case 0:NotificationCenter.default.post(name: NSNotification.Name("ShowNotifications"), object: nil)    case 1:NotificationCenter.default.post(name: NSNotification.Name("ShowAccount"), object: nil)
        case 2:NotificationCenter.default.post(name: NSNotification.Name("ShowAdmin"), object: nil)
        default: break
        }
    }
}
