//
//  NoticationServicesDelegate.swift
//  Countdown
//
//  Created by Choong Kai Wern on 22/01/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import Foundation

protocol NotificationServicesDelegate {
    func nameOfIdentifiers() -> String
    func contentOfNotification() -> String
    func willRepeat() -> Bool
    func dateFormat() -> DateComponentFormat
    func date() -> Date
}
