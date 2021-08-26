//
//  ViewController.swift
//  RTE2021_UIKit_iOS
//
//  Created by Max Cobb on 10/08/2021.
//

import UIKit
import AgoraRtcKit
import AgoraRtmKit
import AgoraUIKit_iOS

class ViewController: UIViewController {

    static let appID: String = <#Agora App ID#>

    lazy var usernameField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "username"
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        tf.textContentType = .username
        return tf
    }()

    lazy var inputInstructions: UILabel = {
        let lbl = UILabel()
        lbl.text = "Input username to continue"
        return lbl
    }()

    lazy var submitButton: UIButton = {
        let btn = UIButton(type: .roundedRect)
        btn.setTitle("Join", for: .normal)
        btn.addTarget(self, action: #selector(joinChannel), for: .touchUpInside)
        return btn
    }()
    func placeFields() {
        [self.inputInstructions, self.usernameField, self.submitButton]
            .enumerated().forEach { (idx, field) in
            self.view.addSubview(field)
            field.frame = CGRect(
                origin: CGPoint(
                    x: 25,
                    y: Int(self.view.safeAreaInsets.top) + 50 + idx * 55),
                size: CGSize(width: self.view.bounds.width - 50, height: 50)
            )
            field.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        }
    }
    @objc func joinChannel() {
        let username = self.usernameField.text ?? ""
        if username.isEmpty {
            return
        }
        let agoraAVC = SeeMembersViewController(appId: ViewController.appID, username: username)
        self.present(agoraAVC, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .systemBackground
        self.placeFields()
    }

}
