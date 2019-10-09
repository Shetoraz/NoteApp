import UIKit

class TableViewController: UITableViewController {
    
    var notes = [Note]()
    
    let first  = Note(title: "Store", body: "Buy some milk")
    let second = Note(title: "School", body: "Make Homework")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notes.append(first)
        notes.append(second)
        
    }
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath)
        
        cell.textLabel?.text = notes[indexPath.row].title
        cell.detailTextLabel?.text = notes[indexPath.row].body
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.detailTextLabel?.numberOfLines = 0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.beginUpdates()
        tableView.endUpdates()
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        
        var titleField = UITextField()
        var bodyField  = UITextField()
        
        let alert = UIAlertController(title: "New note", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertText) in
            alertText.placeholder = "Name"
            titleField = alertText
        }
        alert.addTextField { (alertText) in
            alertText.placeholder = "Body"
            bodyField = alertText
        }
        
        let add = UIAlertAction(title: "Add", style: .default) { (action) in
            
            var newNote = Note()
            
            if titleField.text!.isEmpty {
                newNote.title = "Empty"
            } else {
                newNote.title = titleField.text!
            }
            
            if bodyField.text!.isEmpty {
                newNote.body = "Empty"
            } else {
                newNote.body = bodyField.text!
            }
            self.notes.append(newNote)
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
    
}








