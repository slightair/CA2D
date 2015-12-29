import UIKit

class RuleListViewController: UITableViewController {

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Rule.presets.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let rule = Rule.presets[indexPath.row]

        let cell = tableView.dequeueReusableCellWithIdentifier("RuleCell")!
        cell.textLabel!.text = rule.name
        cell.detailTextLabel!.text = rule.rule

        return cell
    }

    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
