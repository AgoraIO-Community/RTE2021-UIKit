//
//  AgoraVideoViewController.swift
//  RTE2021_UIKit_iOS
//
//  Created by Max Cobb on 12/08/2021.
//

import UIKit
import AgoraUIKit_iOS

class AgoraVideoViewController: UIViewController {
    var channel: String
    var appId: String
    var token: String?
    var agoraViewer: AgoraVideoViewer?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.agoraViewer = AgoraVideoViewer(
            connectionData: AgoraConnectionData(appId: self.appId, appToken: self.token)
        )
        self.agoraViewer?.fills(view: self.view)
        self.agoraViewer?.join(channel: self.channel, as: .broadcaster)
    }

    init(appId: String, channel: String, token: String? = nil) {
        self.channel = channel
        self.appId = appId
        self.token = token
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .tertiarySystemBackground
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.agoraViewer?.exit()
    }
}

