import UIKit
import RealmSwift

class TableViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var notes : Results<Note>?
    
    // Cells colors. Can be changed with simple copy/paste HEX code.
    
    var colors: [String] =  ["#b9e7c3", "#d7eaae", " #f9f1a6", "#ffe39f", "#ffc78e"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        
    }
    
    //MARK: TABLEVIEW METHODS
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath)
        
        cell.textLabel?.text = notes?[indexPath.row].title
        cell.backgroundColor = UIColor(hexString: notes?[indexPath.row].color! ?? "#d7eaae")
        cell.detailTextLabel?.text = notes?[indexPath.row].body
        
        return cell
    }
    
    //MARK: SWIPE ACTIONS
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        //SUBMARK: EDIT
        
        let editAction = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
            
            let editMenu = UIAlertController(title: "Edit note", message: "", preferredStyle: .alert)
            
            editMenu.addTextField { (titleField) in
                titleField.text = self.notes?[indexPath.row].title
                
            }
            editMenu.addTextField { (bodyField) in
                bodyField.text = self.notes?[indexPath.row].body
                
            }
            let saveAction = UIAlertAction(title: "Save", style: .cancel) { (action) in
                let titl = editMenu.textFields![0]
                try! self.realm.write {
                    (self.notes?[indexPath.row].title = titl.text)!
                }
                let body = editMenu.textFields![1]
                try! self.realm.write {
                    (self.notes?[indexPath.row].body = body.text)!
                }
                tableView.reloadData()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            
            editMenu.addAction(cancelAction)
            editMenu.addAction(saveAction)
            
            self.present(editMenu, animated: true, completion: nil)
            
        }
        
        //SUBMARK: DELETE
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            do {
                try self.realm.write {
                    self.realm.delete((self.notes?[indexPath.row])!)
                }
            } catch {
                print ("Deleting Error", error)
            }
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        deleteAction.backgroundColor = .red
        editAction.backgroundColor = UIColor(hexString: "#4BB9D4")
        return [deleteAction, editAction]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = notes?[indexPath.row] {
            do {
                try realm.write {
                    item.isExpanded = !item.isExpanded
                }
            } catch {
                print ("SELECTED Error", error) 
            }
            
            if item.isExpanded {
                tableView.cellForRow(at: indexPath)?.detailTextLabel?.numberOfLines = 0
            } else {
                tableView.cellForRow(at: indexPath)?.detailTextLabel?.numberOfLines = 1
            }
            
            tableView.beginUpdates()
            tableView.endUpdates()
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }
    
    //MARK: ADD BUTTON
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        
        var titleField = UITextField()
        let textView = UITextView(frame: .zero)
        textView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let controller = UIViewController()
        textView.frame = controller.view.frame
        
        controller.view.addSubview(textView)
        
        let alert = UIAlertController(title: "New note", message: "", preferredStyle: .alert)
        alert.setValue(controller, forKey: "contentViewController")
        
        let height: NSLayoutConstraint = NSLayoutConstraint(item: alert.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: view.frame.height * 0.3)
        
        alert.view.addConstraint(height)
        
        //SUBMARK: ELEMENTS IN ALERT
        
        alert.addTextField { (alertText) in
            alertText.placeholder = "Theme"
            titleField = alertText
        }
        
        let add = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newNote = Note()
            
            if titleField.text!.isEmpty {
                newNote.title = "Empty"
            } else {
                newNote.title = titleField.text!
            }
            
            if textView.text!.isEmpty {
                newNote.body = "Empty"
            } else {
                newNote.body = textView.text!
            }
            newNote.color = self.colors.randomElement()!
            
            do {
                try self.realm.write {
                    self.realm.add(newNote)
                    textView.text = ""
                }
            } catch {
                print("SAVING ERROR", error)
            }
            
            self.tableView.reloadData()
            
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
            self.tableView.reloadData()
        }
        
        alert.addAction(add)
        alert.addAction(cancel)
        
        present(alert, animated: true)
        
    }
    
    //MARK: LOAD ITEMS
    
    func loadItems() {
        notes = realm.objects(Note.self)
        tableView.reloadData()
    }
}

//MARK: Translator extenstion (HEX - UICOLOR)

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
