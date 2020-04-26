import UIKit

class RuleListViewController: UITableViewController {
    var world: World?

    override func viewDidLoad() {
        super.viewDidLoad()

        let backgroundView = UIView()
        backgroundView.backgroundColor = Appearance.backgroundColor
        tableView.backgroundView = backgroundView
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Rule.presets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rule = Rule.presets[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "RuleCell", for: indexPath)
        cell.textLabel?.text = rule.name
        cell.detailTextLabel?.text = rule.rule
        cell.accessoryType = world?.rule.name == rule.name ? .checkmark : .none

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRule = Rule.presets[indexPath.row]
        world?.rule = selectedRule

        tableView.reloadData()
    }

    @IBAction func close(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}
