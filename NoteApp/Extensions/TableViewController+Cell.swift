//
//  TableViewController+Cell.swift
//  NoteApp
//
//  Created by Anton Asetski on 2/11/20.
//  Copyright © 2020 Anton Asetski. All rights reserved.
//

import UIKit

public extension UITableViewCell {
    class var reuseIdentifier: String { return String(describing: self) }
}

