//
//  MoreTableViewController.swift
//  RideJournal
//
//  Created by Alexander Willems on 16/11/2018.
//  Copyright © 2018 Alexander Willems. All rights reserved.
//
import UIKit
import SafariServices
import MessageUI

class MoreTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func emailButtonTapped(_ sender: Any) {
        guard MFMailComposeViewController.canSendMail() else {
            print("Can not send mail")
            return
        }
        
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setToRecipients(["alexander.superman@hotmail.com"])
        mailComposer.setSubject("Complaint")
        present(mailComposer, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller:
        MFMailComposeViewController, didFinishWith result:
        MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}
