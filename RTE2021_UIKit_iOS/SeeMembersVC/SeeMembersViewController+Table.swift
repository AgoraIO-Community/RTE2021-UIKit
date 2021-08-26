//
//  SeeMembersViewController+Table.swift
//  RTE2021_UIKit_iOS
//
//  Created by Max Cobb on 12/08/2021.
//

import UIKit
import AgoraRtmKit

extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .label
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

extension SeeMembersViewController: UITableViewDelegate, UITableViewDataSource {
    func createSpeakerTable() {
        let newTable = UITableView()
        self.view.addSubview(newTable)
        newTable.frame = self.view.bounds
        newTable.frame.size.height -= 50
        newTable.frame.origin.y = 50
        newTable.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin]
        newTable.delegate = self
        newTable.dataSource = self
        newTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.speakerTable = newTable
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.onlineMembers.count == 0 {
            tableView.setEmptyMessage("No users online")
        } else {
            tableView.restore()
        }

        return self.onlineMembers.count
    }

    func numberOfSections(in tableView: UITableView) -> Int { 1 }

    func tableView(
        _ tableView: UITableView, cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let rtmId = self.onlineMembers[indexPath.row]
        cell.accessoryView = UIImageView(image: UIImage(systemName: "phone"))
        cell.imageView?.image = UIImage(systemName: "person.circle")
        cell.textLabel?.text = self.usernameLookups[rtmId] ?? rtmId
        return cell
    }
    /// Tells the delegate a row is selected
    /// - Parameters:
    ///   - tableView: A table view informing the delegate about the new row selection.
    ///   - indexPath: An index path locating the new selected row in tableView.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.cellForRow(at: indexPath)?.isSelected = false
        }
        // Show a popup confirming you want to call this member

        let alert = UIAlertController(title: "Call Member?", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
            self.rtmkit?.send(
                AgoraRtmMessage(text: "callme"),
                toPeer: self.onlineMembers[indexPath.row]
            ) { messageSendStatus in
                if messageSendStatus != .ok {
                    print("failed to send message: \(messageSendStatus.rawValue)")
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true)
    }
}
