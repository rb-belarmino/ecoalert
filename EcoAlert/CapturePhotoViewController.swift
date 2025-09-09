import UIKit
import AVFoundation

class CapturePhotoViewController: UIViewController {
	
	@IBOutlet weak var vwCamera: UIView!
	@IBOutlet weak var imgGalery: UIImageView!
	@IBOutlet weak var imgCamera: UIImageView!
	@IBOutlet weak var imgCapturedImage: UIImageView!
	
	
	var captureSession: AVCaptureSession?
	var previewLayer: AVCaptureVideoPreviewLayer?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		imgGalery.image = UIImage(named: "gallery")
		imgCamera.image = UIImage(named: "camera-icon")
		// Não inicializa a câmera aqui!
	}
	
	func setupCamera() {
		captureSession = AVCaptureSession()
		guard let captureSession = captureSession else { return }
		guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
		guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else { return }
		
		if captureSession.canAddInput(videoInput) {
			captureSession.addInput(videoInput)
		} else {
			return
		}
		previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
		previewLayer?.videoGravity = .resizeAspectFill
		previewLayer?.frame = vwCamera.bounds
		
		if let previewLayer = previewLayer {
			vwCamera.layer.addSublayer(previewLayer)
		}
		
		captureSession.startRunning()
	}
	
	@IBAction func btnCamera(_ sender: UIButton) {
		guard captureSession == nil else { return }
		setupCamera()
	}
	@IBAction func btnCapturedImage(_ sender: UIButton) {
		imgCapturedImage.image = UIImage(named: "captureExample")
		
		let alert = UIAlertController(title: "Imagem Capturada", message: "Você será direcionado para a próxima tela!", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in self.performSegue(withIdentifier: "map", sender: self)}))
		alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
		present(alert, animated: true, completion: nil)
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		previewLayer?.frame = vwCamera.bounds
	}
}
