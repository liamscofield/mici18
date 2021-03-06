//
//  ContainerViewController.swift
//  mici18
//
//  Created by AlienLi on 14/12/24.
//  Copyright (c) 2014年 ALN. All rights reserved.
//

import UIKit

enum SlideOutState {
    case BothCollapsed
    case LeftPanelExpanded
    case RightPanelExpanded
}

class ContainerViewController: UIViewController, SideViewControllerDelegate {
    
    var centerVC: CenterTabBarController!
    let screenBounds = UIScreen.mainScreen().bounds
    let CenterVCOffset: CGFloat = 100.0
    var currentState: SlideOutState = .BothCollapsed
    var leftViewController: LeftSideViewController?
    var rightViewController: RightSideViewController?
    
    var translationX: CGFloat? = 0.0
    let animationSpeed = 0.3
    
    var tapForSlide: UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        centerVC = UIStoryboard.centerViewController()
        self.view.addSubview(centerVC.view)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "toggleLeftPanel", name: "toggleLeftPanel", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "toggleRightPanel", name: "toggleRightPanel", object: nil)
        
        self.addGesturesForSlide()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func toggleLeftPanel() {
        
        if currentState != .LeftPanelExpanded {
            
            self.addLeftPanelViewController()
            
            self.animateCenterViewControllerToRight()
            
        } else {
            
            self.animateCenterViewControllerToCenter()
        }
    }
    
    func addLeftPanelViewController(){
        
        if let leftVC = leftViewController {
            
        } else {
            
            leftViewController = UIStoryboard.leftViewController()
            leftViewController?.delegate = self
            self.view.insertSubview(leftViewController!.view, atIndex: 0)
            self.addChildViewController(leftViewController!)
        }
    }
    
    func animateCenterViewControllerToRight() ->Void {
        
        UIView.animateWithDuration(animationSpeed, animations: { () -> Void in
            
            self.centerVC.view.center = CGPointMake(UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height / 2)
            self.centerVC.view.transform = CGAffineTransformMakeScale(0.8, 0.8)
            self.currentState = .LeftPanelExpanded
            
            if let tap = self.tapForSlide {
                self.centerVC.view.removeGestureRecognizer(tap)
            }
            self.tapForSlide = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
            self.centerVC.view.addGestureRecognizer(self.tapForSlide!)
            
            
            self.translationX = 300
            
        })
    }
    
    func toggleRightPanel(){
        
        if currentState != .RightPanelExpanded {
            
            self.addRightPanelViewController()
            self.animateCenterViewControllerToLeft()
        }else {
            self.animateCenterViewControllerToCenter()
        }
    }
    func addRightPanelViewController() {
        
        if let rightVC = rightViewController {
            
        } else {
            rightViewController = UIStoryboard.rightViewController()
            rightViewController?.delegate = self
            self.view.insertSubview(rightViewController!.view, atIndex: 0)
            self.addChildViewController(rightViewController!)
        }
        
    }
    func animateCenterViewControllerToLeft() {
        UIView.animateWithDuration(animationSpeed, animations: { () -> Void in
            self.centerVC.view.center = CGPointMake(UIScreen.mainScreen().bounds.origin.x + self.screenBounds.width / 3.5, self.screenBounds.height / 2)
            var transform: CGAffineTransform = CGAffineTransformMakeScale(0.9, 0.9)
            self.centerVC.view.transform = transform
            self.currentState = .RightPanelExpanded
            self.translationX = -170
            if let tap = self.tapForSlide {
                self.centerVC.view.removeGestureRecognizer(tap)
            }
            self.tapForSlide = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
            self.centerVC.view.addGestureRecognizer(self.tapForSlide!)
            
        })
        
    }
    func animateCenterViewControllerToCenter() {
        
        UIView.animateWithDuration(animationSpeed, animations: { () -> Void in
            
           
            self.centerVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0)
            self.centerVC.view.center = CGPointMake(UIScreen.mainScreen().bounds.size.width / 2, UIScreen.mainScreen().bounds.size.height / 2)
            }) { (finished) -> Void in
                if finished {
                    self.translationX = 0
                    self.currentState = .BothCollapsed
                    self.leftViewController?.view.removeFromSuperview()
                    self.leftViewController = nil
                    self.rightViewController?.view.removeFromSuperview()
                    self.rightViewController = nil
                    
                    if let tap = self.tapForSlide {
                        self.centerVC.view.removeGestureRecognizer(tap)
                    }
            
                }
        }
    }
    
    
    func addGesturesForSlide() -> Void {
        
        var panForSlide: UIPanGestureRecognizer  = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        self.centerVC.view.addGestureRecognizer(panForSlide)
    }
    
    func handleTapGesture(recognizer: UITapGestureRecognizer) {
        if currentState != .BothCollapsed {
            animateCenterViewControllerToCenter()
            self.centerVC.view.removeGestureRecognizer(recognizer)
        }
        
        println("tap")
    }
    
    
    
    func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        
        var point: CGPoint = recognizer.translationInView(self.view)
        
        var screenWidth = UIScreen.mainScreen().bounds.width
        
        
        translationX = point.x + translationX!
        println("translationX: \(translationX)")
        
        if recognizer.view?.frame.origin.x >= 0 {
            
            recognizer.view?.center = CGPointMake(0.5 * screenWidth + (translationX! / screenWidth) * (screenWidth / 2), recognizer.view!.center.y)
            
            recognizer.view?.transform = CGAffineTransformScale(CGAffineTransformIdentity,1 -  0.2 * translationX! / screenWidth , 1 -  0.2 * translationX! / screenWidth)
            
            self.addLeftPanelViewController()
            self.rightViewController?.view.removeFromSuperview()
            self.rightViewController = nil
        } else {
            
            recognizer.view?.center = CGPointMake(0.5 * screenWidth + (translationX! / screenWidth) * (screenWidth / 2), recognizer.view!.center.y)
            
            recognizer.view?.transform = CGAffineTransformScale(CGAffineTransformIdentity,1 +  0.2 * translationX! / screenWidth , 1 +  0.2 * translationX! / screenWidth)
            
            self.addRightPanelViewController()
            self.leftViewController?.view.removeFromSuperview()
            self.leftViewController = nil
        }
        
        recognizer.setTranslation(CGPointZero, inView: self.view)
        
        if recognizer.state == .Ended {
            
            if translationX > 150.0 {
                
                self.addLeftPanelViewController()
                self.rightViewController?.view.removeFromSuperview()
                self.rightViewController = nil
                
                animateCenterViewControllerToRight()
                
                
            } else if translationX < -150 {
                
                self.addRightPanelViewController()
                self.leftViewController?.view.removeFromSuperview()
                self.leftViewController = nil
                
                animateCenterViewControllerToLeft()
                
            } else {
                
                animateCenterViewControllerToCenter()
                
            }
        }
    }
    
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    func selectItem(item: SelectItems){
        
        animateCenterViewControllerToCenter()
        
        switch item {
        case .avatar:
            NSNotificationCenter.defaultCenter().postNotificationName("ALNavatar", object:nil)
        case .guarantee:
            NSNotificationCenter.defaultCenter().postNotificationName("ALNguarantee", object: nil)
        case .recycleSchedule:
            NSNotificationCenter.defaultCenter().postNotificationName("ALNrecycleSchedule", object: nil)
        case .enshrine:
            NSNotificationCenter.defaultCenter().postNotificationName("ALNenshrine", object: nil)
        case .setting:
            NSNotificationCenter.defaultCenter().postNotificationName("ALNsetting", object: nil)
        case .coupon:
            NSNotificationCenter.defaultCenter().postNotificationName("ALNcoupon", object: nil)
        case .contribute:
            NSNotificationCenter.defaultCenter().postNotificationName("ALNcontribute", object: nil)
        case .increment:
            NSNotificationCenter.defaultCenter().postNotificationName("ALNincrement", object: nil)
        case .peripheral:
            NSNotificationCenter.defaultCenter().postNotificationName("ALNperipheral", object: nil)
        case .market:
            NSNotificationCenter.defaultCenter().postNotificationName("ALNmarket", object: nil)
        case .lifeService:
            NSNotificationCenter.defaultCenter().postNotificationName("ALNlifeService", object: nil)
        case .beautifulApp:
            NSNotificationCenter.defaultCenter().postNotificationName("ALNbeautifulApp", object: nil)
        case .tipsCollection:
            NSNotificationCenter.defaultCenter().postNotificationName("ALNtipsCollection", object: nil)
        case .login:
            NSNotificationCenter.defaultCenter().postNotificationName("ALNLogin", object: nil)
        default:
            break
        }
    
    }

    
}

private extension UIStoryboard {
    class func leftViewController() -> LeftSideViewController{
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LeftSideViewController") as LeftSideViewController
    }
    class func rightViewController() -> RightSideViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("RightSideViewController") as RightSideViewController
    }
    class func centerViewController() -> CenterTabBarController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CenterTabBarController") as CenterTabBarController
    }
    
}
