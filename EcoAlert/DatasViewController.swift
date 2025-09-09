//
//  DatasViewController.swift
//  EcoAlert
//
//  Created by Rodrigo Belarmino de Oliveira on 07/09/25.
//

import UIKit

class DatasViewController: UIViewController {
	
	@IBOutlet weak var imgCapturedImage: UIImageView!
	@IBOutlet weak var textView: UITextView!
	
	var receivedTextFromMaps: NSAttributedString?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		imgCapturedImage.image = UIImage(named: "captureExample")
		
		if let receivedTextFromMaps = receivedTextFromMaps {
			textView.attributedText = receivedTextFromMaps
		}
		
	}
	@IBAction func sendButton(_ sender: UIButton) {
		
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
			if let finishedVC = storyboard.instantiateViewController(withIdentifier: "finishedViewController") as? FinishedViewController {
				finishedVC.receivedText = textView.text
				self.navigationController?.pushViewController(finishedVC, animated: true)
			}
	}
	
}
