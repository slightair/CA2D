import UIKit

class RuleListViewController: UITableViewController {
    var world: World?

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Rule.presets.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let rule = Rule.presets[indexPath.row]

        let cell = tableView.dequeueReusableCellWithIdentifier("RuleCell")!
        cell.textLabel!.text = rule.name
        cell.detailTextLabel!.text = rule.rule
        cell.accessoryType = world?.rule.name == rule.name ? .Checkmark : .None

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedRule = Rule.presets[indexPath.row]
        world?.rule = selectedRule

        tableView.reloadData()
    }

    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
