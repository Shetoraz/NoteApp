//
//  Model.swift
//  NoteApp
//
//  Created by Anton Asetski on 2/10/20.
//  Copyright © 2020 Anton Asetski. All rights reserved.
//

import Foundation
import RealmSwift

class Model {
    
    private let realm = try! Realm()
    var notes : Results<Note>?
        
    init() {
        self.refresh()
    }
    
    // MARK: - Realm actions

    func refresh() {
        notes = realm.objects(Note.self)
    }
    
    func delete(_ index: Int) {
        if let item = self.notes?[index] {
            do {
                try self.realm.write {
                    self.realm.delete(item)
                }
            } catch {
                print ("Deleting Error", error)
            }
        }
    }
    
    func create(item: Note) {
        do {
            try self.realm.write {
                self.realm.add(item)
            }
        } catch {
            print("SAVING ERROR", error)
        }
    }
    
    func expand(_ index: Int) {
        if let item = self.notes?[index] {
            do {
                try self.realm.write {
                    item.isExpanded = !item.isExpanded
                }
            } catch {
                print("Expand Error", error)
            }
        }
    }
    
    func edit(_ index: Int, text: String, theme: String) {
        do {
            try self.realm.write {
                self.notes?[index].title = theme
                self.notes?[index].body = text
            }
        } catch {
            print("Edit problem", error)
        }
    }
}


