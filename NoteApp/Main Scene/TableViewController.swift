import UIKit

class TableViewController: UITableViewController {
    
    let model = Model()
    let colors = Color()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.notes?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: UITableViewCell.reuseIdentifier)
        if let item = self.model.notes?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.textLabel?.font = UIFont(name: "Futura-Bold", size: 20)
            cell.detailTextLabel?.font = UIFont(name: "Futura", size: 15)
            cell.backgroundColor = self.colors.getItemColor(item)
            cell.detailTextLabel?.text = item.body
        }
        return cell
    }
    
    // MARK: - Swipe actions
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let editAction = UITableViewRowAction(style: .default, title: R.string.localizable.edit()) { (_ , _) in
            let editMenu = UIAlertController(title: R.string.localizable.editNote(),
                                             message: "",
                                             preferredStyle: .alert)
            editMenu.addTextField { (titleField) in
                titleField.text = self.model.notes?[indexPath.row].title }
            editMenu.addTextField { (bodyField) in
                bodyField.text = self.model.notes?[indexPath.row].body }
            editMenu.addAction(UIAlertAction(title: R.string.localizable.cancel(),
                                             style: .destructive,
                                             handler: nil))
            editMenu.addAction(UIAlertAction(title: R.string.localizable.save(),
                                             style: .cancel) { (_ ) in
                                                if let title = editMenu.textFields?[0].text {
                                                    if let body = editMenu.textFields?[1].text {
                                                        self.model.edit(indexPath.row, text: body, theme: title)
                                                        self.tableView.reloadData() }}})
            self.present(editMenu, animated: true, completion: nil)
        }
        let deleteAction = UITableViewRowAction(style: .default,
                                                title: R.string.localizable.delete()) { (_ , _) in
                                                    self.model.delete(indexPath.row)
                                                    self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        deleteAction.backgroundColor = .red
        editAction.backgroundColor = self.colors.editButton
        
        return [deleteAction, editAction]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.model.expand(indexPath.row)
        guard let item = self.model.notes?[indexPath.row] else { return }
        if item.isExpanded {
            self.tableView.cellForRow(at: indexPath)?.detailTextLabel?.numberOfLines = 0
        } else {
            self.tableView.cellForRow(at: indexPath)?.detailTextLabel?.numberOfLines = 1
        }
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
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

        let alert = UIAlertController(title: R.string.localizable.newNote(), message: "", preferredStyle: .alert)
        alert.setValue(controller, forKey: "contentViewController")
        
        let height = NSLayoutConstraint(item: alert.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: view.frame.height * 0.3)
        
        alert.view.addConstraint(height)

        alert.addTextField { (alertText) in
            alertText.placeholder = R.string.localizable.topic()
            titleField = alertText
        }
        alert.addAction(UIAlertAction(title: R.string.localizable.add(), style: .default) { (_ ) in
            let newNote = Note()
            if titleField.text!.isEmpty {
                newNote.title = R.string.localizable.empty()
            } else {
                newNote.title = titleField.text!
            }
            if textView.text!.isEmpty {
                newNote.body = R.string.localizable.empty()
            } else {
                newNote.body = textView.text!
            }
            newNote.color = self.colors.randomColor
            self.model.create(item: newNote)
            self.tableView.reloadData()
            self.tableView.beginUpdates()
            self.tableView.endUpdates() })
        alert.addAction(UIAlertAction(title: R.string.localizable.cancel(), style: .default) { (_ ) in
            self.tableView.reloadData()
        })
        present(alert, animated: true)
    }
}
