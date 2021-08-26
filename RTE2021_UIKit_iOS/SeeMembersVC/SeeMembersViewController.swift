//
//  SeeMembersViewController.swift
//  RTE2021_UIKit_iOS
//
//  Created by Max Cobb on 12/08/2021.
//

import UIKit
import AgoraRtmKit

/// View Controller for seeing everyone that is online
class SeeMembersViewController: UIViewController, UIViewControllerTransitioningDelegate {

    var username: String

    // Agora Properties
    var appId: String
    var token: String?
    var rtmId: String = UIDevice.current.identifierForVendor!.uuidString
    var rtmkit: AgoraRtmKit?
    var rtmChannel: AgoraRtmChannel?

    // Table And UserData
    var speakerTable: UITableView?
    /// A list of every RTM member who is online
    var onlineMembers: [String] = [] // rtm User Ids
    /// Look up an RTM user's username by their ID
    var usernameLookups: [String: String] = [:] // [rtm id: username]


    init(appId: String, username: String) {
        self.appId = appId
        self.username = username
        super.init(nibName: nil, bundle: nil)
        self.connectAgoraRtm()
    }

    static var labelHeight: CGFloat = 50

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .secondarySystemBackground
        self.addLabelTitle()
        self.createSpeakerTable()
        self.connectAgoraRtm()
    }

    func addLabelTitle() {
        let lbl = UILabel()
        lbl.text = "Tap user to call"
        self.view.addSubview(lbl)
        lbl.frame = CGRect(
            origin: CGPoint(
                x: 25,
                y: Int(self.view.safeAreaInsets.top)),
            size: CGSize(width: self.view.bounds.width - 50, height: 50)
        )
        lbl.autoresizingMask = [.flexibleBottomMargin, .flexibleRightMargin]
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("logout")
        self.rtmkit?.logout()
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func startVideoCall(with peer: String) {
        /// - TODO: Start video call
        // Create a random string for the channel name
        let callChannel = UUID().uuidString
        self.rtmkit?.send(AgoraRtmMessage(text: "videoCall:\(callChannel)"), toPeer: peer)
        self.presentVideoViewer(with: callChannel)
    }

    func presentVideoViewer(with channel: String) {
        let videoVC = AgoraVideoViewController(appId: ViewController.appID, channel: channel, token: <#Channel Token#>)
        self.present(videoVC, animated: true)
    }
}
