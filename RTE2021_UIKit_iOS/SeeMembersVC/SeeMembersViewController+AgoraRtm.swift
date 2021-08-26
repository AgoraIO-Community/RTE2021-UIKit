//
//  SeeMembersViewController+AgoraRtm.swift
//  RTE2021_UIKit_iOS
//
//  Created by Max Cobb on 12/08/2021.
//

import UIKit
import AgoraRtmKit

extension SeeMembersViewController {
    /// Connect to Agora's Real-time Messaging network
    func connectAgoraRtm() {
        // Create connection to RTM
        rtmkit = AgoraRtmKit(appId: self.appId, delegate: self)
        rtmkit?.login(byToken: self.token, user: self.rtmId) { loginCode in
            if loginCode != .ok {
                print("Could not log in: \(loginCode.rawValue)")
                return
            }
            self.rtmChannel = self.rtmkit?.createChannel(withId: "lobby", delegate: self)

            self.rtmChannel?.join(completion: { (errcode) in
                if errcode == .channelErrorOk {
                    self.shareUserID()
                }
            })
        }

    }

    /// Share RTC userID to either a specific RTM user, or the entire RTM channel
    /// - Parameter username: RTM user to send data to, omit to send to entire channel.
    func shareUserID(to username: String? = nil) {
        if let user = username {
            self.rtmkit?.send(AgoraRtmMessage(text: "username:\(self.username)"), toPeer: user)
        } else {
            self.rtmChannel?.send(AgoraRtmMessage(text: "username:\(self.username)"))
        }
    }

    func disconnect() {
        self.rtmChannel?.leave()
        self.rtmkit?.logout()
    }
}

extension SeeMembersViewController: AgoraRtmDelegate, AgoraRtmChannelDelegate {
    func channel(_ channel: AgoraRtmChannel, memberJoined member: AgoraRtmMember) {
        self.shareUserID(to: member.userId)
    }
    func channel(
        _ channel: AgoraRtmChannel,
        memberLeft member: AgoraRtmMember
    ) {
        guard let index = self.onlineMembers.firstIndex(of: member.userId) else {
            return
        }
        self.onlineMembers.remove(at: index)
        self.speakerTable?.reloadData()
    }

    func channel(
        _ channel: AgoraRtmChannel,
        messageReceived message: AgoraRtmMessage,
        from member: AgoraRtmMember
    ) {
        self.splitDecodeMessage(message: message, fromPeer: member.userId)
    }

    func rtmKit(
        _ kit: AgoraRtmKit, messageReceived message: AgoraRtmMessage, fromPeer peerId: String
    ) {
        if message.text == "callme" {
            DispatchQueue.main.async {
                let alert = UIAlertController(
                    title: "Start chat with \(self.usernameLookups[peerId] ?? "unknown")?",
                    message: nil, preferredStyle: .actionSheet
                )
                alert.addAction(UIAlertAction(title: "Start Video Call", style: .default, handler: { _ in
                    self.startVideoCall(with: peerId)
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        self.splitDecodeMessage(message: message, fromPeer: peerId)
    }

    func splitDecodeMessage(message: AgoraRtmMessage, fromPeer peerId: String) {
        let splitText = message.text.split(separator: ":")
        if splitText.count > 1 {
            switch splitText[0] {
            case "username":
                self.usernameLookups[peerId] = String(splitText[1])
                if !self.onlineMembers.contains(peerId) {
                    self.onlineMembers.append(peerId)
                }
                self.speakerTable?.reloadData()
            case "videoCall":
                // join video call!
                self.presentVideoViewer(with: String(splitText[1]))
            default:
                print("unknown value: \(splitText[0])")
            }
        }

    }
}
