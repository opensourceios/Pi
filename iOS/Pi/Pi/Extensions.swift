//
//  Extensions.swift
//  Pi
//
//  Created by Rigoberto Molina on 6/12/16.
//  Copyright © 2016 Rigoberto Molina. All rights reserved.
//

import Foundation
import UIKit

public extension UIColor {
	convenience init(red: Int, green: Int, blue: Int) {
		assert(red >= 0 && red <= 255, "Invalid red component")
		assert(green >= 0 && green <= 255, "Invalid green component")
		assert(blue >= 0 && blue <= 255, "Invalid blue component")
		
		self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
	}
	
	convenience init(netHex:Int) {
		self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
	}
	
	convenience init(color: UniversalColor) {
		
		switch color {
		case .originalPinkTheme:
			self.init(red:(0xFF0053 >> 16) & 0xff, green:(0xFF0053 >> 8) & 0xff, blue:0xFF0053 & 0xff)
		case .pi_purple:
			self.init(red:(0x1129F4 >> 16) & 0xff, green:(0x1129F4 >> 8) & 0xff, blue:0x1129F4 & 0xff)
		case .ywmm:
			self.init(red:(0x33cd5f >> 16) & 0xff, green:(0x33cd5f >> 8) & 0xff, blue:0x33cd5f & 0xff)
		}
		
	}
}

public enum UniversalColor {
	case originalPinkTheme
	case pi_purple
	case ywmm
}

extension CAGradientLayer {
	class func gradientLayerForBounds(_ bounds: CGRect) -> CAGradientLayer {
		let layer = CAGradientLayer()
		layer.frame = bounds
		layer.colors = [
			// UIColor(netHex: 0x1AD6FD).cgColor,
			UIColor(netHex: 0x1129F4).cgColor,
			UIColor(netHex: 0xCF0000).cgColor
		]
		// layer.startPoint = CGPoint(x: 0.0, y: 1.0)
		// layer.endPoint = CGPoint(x: 1.0, y: 0.0)
		return layer
	}
}

extension UINavigationBar {
	
	func hideBottomHairline() {
		let navigationBarImageView = hairlineImageViewInNavigationBar(self)
		navigationBarImageView!.isHidden = true
	}
	
	func showBottomHairline() {
		let navigationBarImageView = hairlineImageViewInNavigationBar(self)
		navigationBarImageView!.isHidden = false
	}
	
	private func hairlineImageViewInNavigationBar(_ view: UIView) -> UIImageView? {
		if view.bounds.size.height <= 1.0 {
			return (view as! UIImageView)
		}
		
		let subviews = (view.subviews as [UIView])
		for subview: UIView in subviews {
			if let imageView: UIImageView = hairlineImageViewInNavigationBar(subview) {
				return imageView
			}
		}
		
		return nil
	}
}
