//
//  RMCalculatorViewController.swift
//  Pi
//
//  Created by Rigoberto Molina on 7/26/16.
//  Copyright © 2016 Rigoberto Molina. All rights reserved.
//

import UIKit
import iosMath
import FXBlurView

class RMCalculatorViewController: UIViewController, UITextFieldDelegate, MMNumberKeyboardDelegate {
	
	// MARK: Properties
	var formulaTitle: String = ""
	var formulaEquation: String = ""
	var textFieldPlaceholders: [String] = []
	var numberOfTextFields: Int = 4
	var storyboardID: String = ""
	var subjectID: Int = 0
	var formulaID: Int = 0
	
	// IBOutlet Properties
	@IBOutlet weak var formulaTitleLabel: UILabel!
	@IBOutlet weak var formulaEquationLabel: MTMathUILabel!
	@IBOutlet weak var answerButton: UIButton!
	
	// Array of text fields
	var textFields: [CalculatorTextField] = []
	
	// Array of Keyboards
	var keyboards: [MMNumberKeyboard] = []
	
    // Array of toolbars
    var toolbars: [PiToolbar] = []
    
	// Posible values
	var possibleValues: [Double] = []
    
	/*
    
	init(fTitle: String, fEquation: String, fTextFields: UInt8, didClickAnswer: () -> Void) {
		super.init(nibName: nil, bundle: nil)
		self.formulaTitle = fTitle
		self.formulaEquation = fEquation
		self.numberOfTextFields = fTextFields
    }
    
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	*/
    
	// MARK: General
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let favoriteBarBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "star"), style: .plain, target: self, action: #selector(self.toggleFavorite))
		
		self.navigationItem.rightBarButtonItem = favoriteBarBtn
		
		if self.textFieldPlaceholders.count != self.numberOfTextFields {
			fatalError("Amount of placeholders must be equal to the number of text fields.")
		}
		
		var i = 202
		var t = 240
		
		for j in 0 ..< self.numberOfTextFields {
			
			let keyboard: MMNumberKeyboard = MMNumberKeyboard(frame: CGRect.zero)
			keyboard.allowsDecimalPoint = true
			keyboard.delegate = self
			
			let textField = CalculatorTextField(frame: CGRect(x: 22, y: i, width: 275, height: 40))
			textField.tag = j
			textField.placeholder = self.textFieldPlaceholders[j]
			textField.inputView = keyboard
			textField.delegate = self
			
            let toolbar = PiToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 44))
            
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
            
            let s1 = #selector(self.appendMinus)
            let s2 = #selector(self.appendTimes)
            let s3 = #selector(self.appendDivide)
            let s4 = #selector(self.appendPlus)
            let s5 = #selector(self.appendOpenP)
            let s6 = #selector(self.appendCloseP)
            let s7 = #selector(self.appendExponent)
            
            let minusButton = UIBarButtonItem(title: "-", style: .plain, target: self, action: s1)
            let timesButton = UIBarButtonItem(title: "x", style: .plain, target: self, action: s2)
            let divideButton = UIBarButtonItem(title: "÷", style: .plain, target: self, action: s3)
            let plusButton = UIBarButtonItem(title: "+", style: .plain, target: self, action: s4)
            let openParenthesisButton = UIBarButtonItem(title: "(", style: .plain, target: self, action: s5)
            let closeParenthesisButton = UIBarButtonItem(title: ")", style: .plain, target: self, action: s6)
            let exponentButton = UIBarButtonItem(title: "x²", style: .plain, target: self, action: s7)
            
            toolbar.items = [
                flexibleSpace,
                minusButton,
                flexibleSpace,
                plusButton,
                flexibleSpace,
                divideButton,
                flexibleSpace,
                timesButton,
                flexibleSpace,
                openParenthesisButton,
                flexibleSpace,
                closeParenthesisButton,
                flexibleSpace,
                exponentButton,
                flexibleSpace
            ]
            textField.inputAccessoryView = toolbar
            
			self.keyboards.append(keyboard)
			self.textFields.append(textField)
            self.toolbars.append(toolbar)
			self.view.addSubview(textField)
			i += 38 + 10
			t += 38 + 10
            self.answerButton.frame = CGRect(x: 35, y: t, width: 250, height: 45)
		}
		
		self.formulaTitleLabel.text = self.formulaTitle
		self.formulaEquationLabel.latex = self.formulaEquation
		self.formulaEquationLabel.textAlignment = .center
		
		self.answerButton.addTarget(self, action: #selector(self.didClickAnswer), for: .touchUpInside)
		
		let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.endViewEditing))
		self.view.addGestureRecognizer(gestureRecognizer)
		
        self.setupViewProperties()
    }
    
    func appendPlus() {
        for tf in self.textFields {
            if tf.isFirstResponder {
                tf.text?.append("+")
            }
        }
    }
    
    func appendMinus() {
        for tf in self.textFields {
            if tf.isFirstResponder {
                tf.text?.append("-")
            }
        }
    }
    
    func appendTimes() {
        for tf in self.textFields {
            if tf.isFirstResponder {
                tf.text?.append("*")
            }
        }
    }
    
    func appendDivide() {
        for tf in self.textFields {
            if tf.isFirstResponder {
                tf.text?.append("/")
            }
        }
    }
    
    func appendOpenP() {
        for tf in self.textFields {
            if tf.isFirstResponder {
                tf.text?.append("(")
            }
        }
    }
    
    func appendCloseP() {
        for tf in self.textFields {
            if tf.isFirstResponder {
                tf.text?.append(")")
            }
        }
    }
    
    func appendExponent() {
        let form: UIAlertController = UIAlertController(title: "Exponent", message: nil, preferredStyle: .alert)
        form.addTextField { (tf) in
            tf.placeholder = "Base"
        }
        form.addTextField { (tf) in
            tf.placeholder = "Power"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            (UIAlertAction) -> Void in
            
        }
        
        let doneAction = UIAlertAction(title: "Done", style: .default) {
            (UIAlertAction) -> Void in
            
            let base = Double(form.textFields!.first!.text!)!
            let power = Double(form.textFields!.last!.text!)!
            
            for tf in self.textFields {
                if tf.isFirstResponder {
                    tf.text?.append("\(pow(base, power))")
                }
            }
        }
        
        form.addAction(cancelAction)
        form.addAction(doneAction)
        
        self.present(form, animated: true) {
            () -> Void in
        }
    }
    
    /*
    func appendTextFieldText() {
        for (i, tf) in self.textFields.enumerated() {
            if tf.isFirstResponder {
                var text: String = ""
                for tbItem in self.toolbars[i].items! {
                    if tbItem.isEnabled {
                        
                    }
                }
                tf.text?.append(text)
            }
        }
    }
    */
    
    func setupViewProperties() {
        
        self.formulaTitleLabel.textColor = UIColor.black
        self.formulaEquationLabel.textColor = UIColor.black
        
        self.navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "star")
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "sayagata.png")!)
        
        self.answerButton.backgroundColor = UIColor(netHex: 0x7a2ee7)
        self.answerButton.layer.cornerRadius = 5
        self.answerButton.setTitleColor(UIColor.white, for: .normal)
    }
    
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	func endViewEditing() {
		self.view.endEditing(true)
    }
    
	func toggleFavorite() {
        
    }
    
	// Custom actions
	func didClickAnswer() {
        
        for tf in self.textFields {
            self.possibleValues.append(Double(tf.text!)!)
        }
        
		let id = self.storyboardID
		let answer = RMAnswerGenerator(id, values: self.possibleValues)
		let answerAlert = UIAlertController(title: "Answer", message: "\(answer)", preferredStyle: .alert)
		let action = UIAlertAction(title: "OK", style: .cancel) { (UIAlertAction) in
			self.possibleValues.removeAll()
		}
		answerAlert.addAction(action)
		self.present(answerAlert, animated: true) {
			
		}
	}
}
