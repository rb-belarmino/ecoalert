	//
	//  ViewController.swift
	//  EcoAlert
	//
	//  Created by Rodrigo Belarmino de Oliveira on 01/09/25.
	//

	import UIKit

	class ViewController: UIViewController {
		@IBOutlet weak var imgApple: UIImageView!
		@IBOutlet weak var imgLogo: UIImageView!
		
		override func viewDidLoad() {
			super.viewDidLoad()

			imgApple.image = UIImage(named: "apple")
			imgLogo.image = UIImage(named: "ecoalert")
		}

	}
