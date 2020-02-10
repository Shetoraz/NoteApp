import UIKit

class TableViewController: UITableViewController {
    
    var model = Model()
    var colors: [String] =  ["#b9e7c3", "#d7eaae", " #f9f1a6", "#ffe39f", "#ffc78e"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.notes?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath)
        if let item = self.model.notes?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.backgroundColor = UIColor(hexString: item.color ?? "#d7eaae")
            cell.detailTextLabel?.text = item.body
        }
        return cell
    }
    
    // MARK: - Swipe actions
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let editAction = UITableViewRowAction(style: .default, title: "Edit") { (_ , indexPath) in
            let editMenu = UIAlertController(title: "Edit note", message: "", preferredStyle: .alert)
            editMenu.addTextField { (titleField) in
                titleField.text = self.model.notes?[indexPath.row].title }
            editMenu.addTextField { (bodyField) in
                bodyField.text = self.model.notes?[indexPath.row].body }
            let saveAction = UIAlertAction(title: "Save", style: .cancel) { (_ ) in
                let titl = editMenu.textFields![0]
                let body = editMenu.textFields![1]
                self.model.edit(indexPath.row, text: body.text!, theme: titl.text!)
                tableView.reloadData()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            editMenu.addAction(cancelAction)
            editMenu.addAction(saveAction)
            
            self.present(editMenu, animated: true, completion: nil)
        }
        
        // SUBMARK: - Delete
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (_ , indexPath) in
            self.model.delete(indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade) }
        deleteAction.backgroundColor = .red
        editAction.backgroundColor = UIColor(hexString: "#4BB9D4")
        
        return [deleteAction, editAction]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.model.expand(indexPath.row)
        guard let item = self.model.notes?[indexPath.row] else { return }
        if item.isExpanded {
            tableView.cellForRow(at: indexPath)?.detailTextLabel?.numberOfLines = 0
        } else {
            tableView.cellForRow(at: indexPath)?.detailTextLabel?.numberOfLines = 1
        }
        tableView.beginUpdates()
        tableView.endUpdates()
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Add button
    
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
        
        // SUBMARK: - Elements in alert
        
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
            self.model.create(item: newNote)
            self.tableView.reloadData()
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (_ ) in
            self.tableView.reloadData()
        }
        alert.addAction(add)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
}
