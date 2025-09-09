//
//  FinishedViewController.swift
//  EcoAlert
//
//  Created by Rodrigo Belarmino de Oliveira on 08/09/25.
//

import UIKit


class FinishedViewController: UIViewController {
	


	@IBOutlet weak var dataFinished: UITextView!
	var receivedText: String?
	
	@IBOutlet weak var imgCapturedImage: UIImageView!
	override func viewDidLoad() {
        super.viewDidLoad()
		
		imgCapturedImage.image = UIImage(named: "captureExample")
		dataFinished.text = receivedText
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
