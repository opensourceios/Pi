//
//  RMDashboardViewController.swift
//  Pi
//
//  Created by Rigoberto Molina on 7/28/16.
//  Copyright © 2016 Rigoberto Molina. All rights reserved.
//

import UIKit
import LocalAuthentication

class RMDashboardViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	@IBOutlet weak var profilePicture: UIImageView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		// setupProfileImageView()
		authenticateUser()
        // Do any additional setup after loading the view.
    }
	
	func authenticateUser() {
		let context = LAContext()
		var error: NSError?
		let reason = "TouchID Authentication is needed to access Pi."
		
		if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
			context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: { (success, EvalPolicyError) in
				if success {
                    
				} else {
					print(EvalPolicyError?.localizedDescription)
					
					switch EvalPolicyError!._code {
					case LAError.systemCancel.rawValue:
						print("Authentication was cancelled by the system.")
					case LAError.userCancel.rawValue:
						print("Authentication was cancelled by the user.")
					case LAError.userFallback.rawValue:
						print("User selected to enter custom password.")
						OperationQueue.main.addOperation({
							self.showPasswordAlert()
						})
					default:
						print("Authentication failed.")
						OperationQueue.main.addOperation({
							self.showPasswordAlert()
						})
					}
					
				}
			})
		} else {
			switch error!.code {
			case LAError.touchIDNotEnrolled.rawValue:
				print("TouchID is not enrolled.")
			case LAError.passcodeNotSet.rawValue:
				print("A passcode has not been set.")
			default:
				print("TouchID is not available.")
			}
			print(error?.localizedDescription)
			
			self.showPasswordAlert()
		}
		
	}
	
	func showPasswordAlert() {
		
	}
	
	func setupProfileImageView() {
		self.profilePicture.isUserInteractionEnabled = true
		self.profilePicture.contentMode = .scaleAspectFill
		self.profilePicture.clipsToBounds = true
		self.profilePicture.layer.cornerRadius = 75
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.showImagePicker))
		self.profilePicture.addGestureRecognizer(tapGestureRecognizer)
	}
	
	func showImagePicker() {
		let imagePicker = UIImagePickerController()
		imagePicker.sourceType = .photoLibrary
		imagePicker.delegate = self
		
		self.present(imagePicker, animated: true) { 
			print("Image Picker Presented")
		}
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
		let photo = info[UIImagePickerControllerOriginalImage]
		self.profilePicture.image = photo as? UIImage
		self.dismiss(animated: true) {
			print("Image Picker Dismissed.")
		}
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
