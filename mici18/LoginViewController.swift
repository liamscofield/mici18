//
//  LoginViewController.swift
//  mici18
//
//  Created by AlienLi on 15/1/6.
//  Copyright (c) 2015年 ALN. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var registerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        self.title = "登录"
        
        
        registerButton.addTarget(self, action: "register:", forControlEvents: UIControlEvents.TouchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func register(button: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        
        let registerVC = sb.instantiateViewControllerWithIdentifier("RegisterViewController") as? RegisterViewController
        self.navigationController?.pushViewController(registerVC!, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
