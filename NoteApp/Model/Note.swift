import UIKit
import RealmSwift

class Note: Object {
    
    @objc dynamic var title: String? = ""
    @objc dynamic var body: String? = ""
    @objc dynamic var isExpanded = false
    @objc dynamic var color: String? = ""
}
