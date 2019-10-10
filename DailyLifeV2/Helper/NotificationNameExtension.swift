//
//  NotificationNameExtension.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 10/1/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import Foundation
import UIKit

extension Notification.Name {
    static let OpenSearchVC: Notification.Name = Notification.Name(rawValue: "OpenSearchVC")

    static let MoveToTabbarIndex0: Notification.Name = Notification.Name(rawValue: "MoveToTabbarIndex0")

    static let OpenOrCloseSideMenu: Notification.Name = Notification.Name(rawValue: "OpenOrCloseSideMenu")

    static let MoveToTopic: Notification.Name = Notification.Name(rawValue: "MoveToTopic")

    static let CloseSideMenyByEdgePan: Notification.Name = Notification.Name(rawValue: "CloseSideMenyByEdgePan")

    static let reload: Notification.Name = Notification.Name(rawValue: "reload")

    static let searchVCToReadingVC: Notification.Name = Notification.Name(rawValue: "searchVCToReadingVC")

    static let NavigateToWebViewVCFromFirstCell: Notification.Name = Notification.Name(rawValue: "NavigateToWebViewVCFromFirstCell")

    static let shareAction: Notification.Name = Notification.Name(rawValue: "shareAction")

}
