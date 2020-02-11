//
//  Colors.swift
//  NoteApp
//
//  Created by Anton Asetski on 2/11/20.
//  Copyright © 2020 Anton Asetski. All rights reserved.
//

import UIKit

class Color {
    
    private var colors: [String] =  ["#b9e7c3", "#d7eaae", " #f9f1a6", "#ffe39f", "#ffc78e"]

    var editButton: UIColor {
        return UIColor(hexString: "#4BB9D4")
    }

    var randomColor: String {
        return self.colors.randomElement() ?? "#d7eaae"
    }

    func getItemColor(_ item: Note) -> UIColor {
        return UIColor(hexString: item.color ?? String(self.randomColor))
    }

}
