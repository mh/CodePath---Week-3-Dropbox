//
//  MailboxViewController.swift
//  Mailbox
//
//  Created by matt hunter on 10/1/15.
//  Copyright © 2015 matt hunter. All rights reserved.
//

import UIKit

var feedImageView: UIImageView = UIImageView()
var listImageView: UIImageView = UIImageView()
var rescheduleImageView: UIImageView = UIImageView()


class MailboxViewController: UIViewController, UIScrollViewDelegate {
    
   // var feedImageView: UIImageView = UIImageView()
    @IBOutlet weak var feedScrollView: UIScrollView!
    
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var messageViewContainer: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedScrollView.contentSize = CGSize(width: 320, height: 1564)
        
        feedScrollView.contentSize = feedImageView.bounds.size
        
        // Define the List Image
        listImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 320, height: 568))
        listImageView.image = UIImage(named: "list")
        listImageView.userInteractionEnabled = true
        self.view.addSubview(listImageView)
        listImageView.hidden = true
        
        // Define the tap for List View
        let tapListView = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        listImageView.addGestureRecognizer(tapListView)
        
        // Define the Reschedule Image
        rescheduleImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 320, height: 568))
        rescheduleImageView.image = UIImage(named: "reschedule")
        rescheduleImageView.userInteractionEnabled = true
        self.view.addSubview(rescheduleImageView)
        rescheduleImageView.hidden = true
        
        
        let tapRescheduleView = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        rescheduleImageView.addGestureRecognizer(tapRescheduleView)
        
        
        
    }

    @IBAction func showMessageAction(sender: AnyObject) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Make sure this must not be private
    func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        print("tap working")
        listImageView.hidden = true
        rescheduleImageView.hidden = true
    }


    @IBAction func dismissListView(sender: UITapGestureRecognizer) {
       
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
