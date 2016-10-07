//
//  ActionMenuButton.swift
//  Action Menu Button

//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software
//  and associated documentation files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all copies or
//  substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
//  BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
//  DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit

public class MenuButton: UIButton {
	
	public var radius:CGFloat = 0
	
	fileprivate var touchUpInsideHandler:(Void) -> (Void)
	fileprivate var amButton:ActionMenuButton!
	
	fileprivate var endAngle:CGFloat {
		get {
			let index = amButton.menuButtons.index(of: self)!
			let angleSpan = (amButton.endAngle - amButton.startAngle)
			var count = CGFloat(amButton.menuButtons.count - 1)
			if angleSpan.truncatingRemainder(dividingBy: 360) == 0 {
				count += 1
			}
			let deltaAngle = angleSpan / count
			return amButton.startAngle + (CGFloat(index) * deltaAngle)
		}
	}
	
	fileprivate var endPoint:CGPoint {
		get {
			let sinTheta = sin(Double(endAngle) * M_PI/180)
			let cosineTheta = cos(Double(endAngle) * M_PI/180)
			let x = cosineTheta * Double(amButton.radiusToMenuButton)
			let y = sinTheta * Double(amButton.radiusToMenuButton)
			return CGPoint (x: x, y: y)
		}
	}
	
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public init(withRadius radius:CGFloat, touchUpInsideHandler:@escaping (Void) -> (Void)) {
		self.touchUpInsideHandler = touchUpInsideHandler
		super.init(frame: CGRect(x: 0,
		                         y: 0,
		                         width: radius*2,
		                         height: radius*2))
		self.adjustsImageWhenHighlighted = true
		layer.cornerRadius = radius
		clipsToBounds = true

		addTarget(self, action: #selector(pressedButton), for: .touchUpInside)
	}
	
	public func pressedButton() {
		print(endAngle)
		amButton.dismissMenu(sender: self)
	}
}

public class ActionMenuButton: UIButton {
	
	fileprivate var isMenuShown:Bool = false
	fileprivate var menuButtons:[MenuButton] = [MenuButton]()
	@IBInspectable var radiusToMenuButton:CGFloat = 0
	@IBInspectable var startAngle:CGFloat = 0 {
		didSet {
			if oldValue != startAngle {
				var angle = startAngle
				while angle < 0 {
					angle += 360
				}
				startAngle = angle
			}
		}
	}
	@IBInspectable var endAngle:CGFloat = 0 {
		didSet {
			if oldValue != endAngle {
				var angle = endAngle
				while angle < 0 {
					angle += 360
				}
				endAngle = angle
			}
		}
	}
	
	@IBInspectable var animationDuration:Double = 0
	
	private var centerAngle:CGFloat {
		get {
			return (endAngle + startAngle)/2
		}
	}
	
	private var startPoint:CGPoint {
		get {
			let sinTheta = sin(Double(centerAngle) * M_PI/180)
			let cosineTheta = cos(Double(centerAngle) * M_PI/180)
			let x = cosineTheta * Double(radiusToMenuButton)
			let y = sinTheta * Double(radiusToMenuButton)
			return CGPoint(x: x, y: y)
		}
	}
	
	private func adjustAngles() {
		while endAngle < startAngle {
			endAngle += 360
		}
	}
	
	private func pointForAngle(_ angle:CGFloat) -> CGPoint {
		let sinTheta = sin(Double(angle) * M_PI/180)
		let cosineTheta = cos(Double(angle) * M_PI/180)
		let x = cosineTheta * Double(radiusToMenuButton)
		let y = sinTheta * Double(radiusToMenuButton)
		return CGPoint(x: x, y: y)
	}
	
	public func add(menuButton:MenuButton) {
		menuButton.amButton = self
		menuButton.center = self.center
		menuButtons.append(menuButton)
	}
 
	private func animateMenuButtonsToStartPoint() {
		UIView.animate(withDuration: animationDuration/2, animations: {
			for button in self.menuButtons {
				button.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
				button.center = CGPoint(x: self.center.x + self.startPoint.x,
				                        y: self.center.y + self.startPoint.y)
			}
		}) { (finished) in
			if finished {
				self.animateMenuButtonsToEndPoint()
			}
		}
	}
	
	private func animateMenuButtonsToCenter() {
		UIView.animate(withDuration: animationDuration/2, animations: {
			for button in self.menuButtons {
				button.transform = CGAffineTransform.identity.scaledBy(x: 0.5, y: 0.5)
				button.center = self.center
			}
		}) { (finished) in
			if finished {
				for button in self.menuButtons {
					button.removeFromSuperview()
					button.layer.removeAllAnimations()
				}
			}
		}
	}
	
	private func animateMenuButtonsToEndPoint() {
		for button in menuButtons {
			button.layer.removeAllAnimations()
			let clockwise = (endAngle > startAngle) ? (abs(button.endAngle) > abs(centerAngle)):(abs(button.endAngle) < abs(centerAngle))
			let path = UIBezierPath(arcCenter: center,
			                        radius: radiusToMenuButton,
			                        startAngle: centerAngle * CGFloat(M_PI / 180.0),
			                        endAngle: button.endAngle * CGFloat(M_PI / 180.0),
			                        clockwise: clockwise)
			let animation = CAKeyframeAnimation(keyPath: "position")
			animation.path = path.cgPath
			animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
			animation.calculationMode = kCAAnimationPaced
			animation.fillMode = kCAFillModeForwards
			animation.isRemovedOnCompletion = false
			animation.repeatCount = 0
			animation.duration = animationDuration / 2
			button.layer.add(animation, forKey: "animate position along path")
			button.center = CGPoint(x: center.x + button.endPoint.x,
			                        y: center.y + button.endPoint.y)
		}
	}
	
	private func animateMenuButtonsToTappedAngle(_ angle:CGFloat) {
		for button in menuButtons {
			button.isUserInteractionEnabled = false
			button.layer.removeAllAnimations()
			let clockwise = (endAngle > startAngle) ? (abs(button.endAngle) < abs(angle)):(abs(button.endAngle) > abs(angle))
			let path = UIBezierPath(arcCenter: center,
			                        radius: radiusToMenuButton,
			                        startAngle: button.endAngle * CGFloat(M_PI / 180.0),
			                        endAngle: angle * CGFloat(M_PI / 180.0),
			                        clockwise: clockwise)
			let animation = CAKeyframeAnimation(keyPath: "position")
			animation.path = path.cgPath
			animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
			animation.calculationMode = kCAAnimationPaced
			animation.fillMode = kCAFillModeForwards
			animation.isRemovedOnCompletion = false
			animation.repeatCount = 0
			animation.duration = animationDuration / 2
			button.layer.add(animation, forKey: "animate position along path")
			button.center = CGPoint(x: center.x + pointForAngle(angle).x,
			                        y: center.y + pointForAngle(angle).y)
		}
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + animationDuration / 2) {
			self.animateMenuButtonsToCenter()
		}
	}
	
	public func toggleMenu() {
		isUserInteractionEnabled = false
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + animationDuration) {
			self.isUserInteractionEnabled = true
			for button in self.menuButtons {
				button.isUserInteractionEnabled = true
			}
		}
		if !isMenuShown {
			showMenu()
		} else {
			dismissMenu()
		}
	}
	
	fileprivate func showMenu() {
		adjustAngles()
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + animationDuration) {
			self.isMenuShown = true
		}
		for button in menuButtons {
			button.isUserInteractionEnabled = false
			button.center = center
			button.transform = CGAffineTransform.identity.scaledBy(x: 0.5, y: 0.5)
			if let superview = superview {
				superview.insertSubview(button, belowSubview: self)
			}
		}
		animateMenuButtonsToStartPoint()
	}
	
	fileprivate func dismissMenu() {
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + animationDuration) {
			self.isMenuShown = false
		}
		animateMenuButtonsToTappedAngle(centerAngle)
	}
	
	fileprivate func dismissMenu(sender:MenuButton) {
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + animationDuration) {
			self.isMenuShown = false
		}
		if let superview = superview {
			superview.exchangeSubview(at: superview.subviews.index(of: menuButtons.last!)!,
			                          withSubviewAt: superview.subviews.index(of: sender)!)
		}
 		animateMenuButtonsToTappedAngle(sender.endAngle)
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + animationDuration/2) {
			sender.touchUpInsideHandler()
		}
	}
}
