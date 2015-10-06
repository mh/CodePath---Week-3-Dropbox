//
//  MessageSwipeViewController.swift
//  Mailbox
//
//  Created by matt hunter on 10/3/15.
//  Copyright © 2015 matt hunter. All rights reserved.
//

import UIKit

var MessageArchived = true

class MessageSwipeViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var messageView: UIImageView!
    @IBOutlet weak var archiveImageView: UIImageView!
    @IBOutlet weak var laterImageView: UIImageView!
    
    var messageOriginalCenter: CGPoint!
    var archiveOriginalCenter: CGPoint!

    @IBOutlet var messageContainerView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "onCustomPan:")
        messageView.addGestureRecognizer(panGestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resetEverythingAction(sender: AnyObject) {
        print("Button Pressed: Reset!")
        messageView.hidden = false
        backgroundView.hidden = false
        
        messageView.frame.origin.x = 0
        backgroundView.frame.origin.x = 0
        archiveImageView.hidden = false
        laterImageView.hidden = false
    }
    

    @IBAction func onMessageSwipe(sender: UIPanGestureRecognizer) {
    }
    
    func onCustomPan(panGestureRecognizer: UIPanGestureRecognizer) {
        let point = panGestureRecognizer.locationInView(messageView)
        let velocity = panGestureRecognizer.velocityInView(messageView)
        let translation = panGestureRecognizer.translationInView(messageView)
    
        if  panGestureRecognizer.state == UIGestureRecognizerState.Began {
            messageOriginalCenter = messageView.center
            archiveOriginalCenter = archiveImageView.center

            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
        
            // Move the message
            messageView.center = CGPoint(x: messageOriginalCenter.x + translation.x, y: messageOriginalCenter.y)
            
            // *** CONDITIONS START HERE ***
            
            // *** SWIPE RIGHT: ARCHIVE THE MESSAGE ***
            if messageView.frame.origin.x >= 60 && messageView.frame.origin.x < 260 {
                print("Archive X: \(archiveImageView.center.x) vs. Message X: \(messageView.center.x)")
            
                // Change the background color
                backgroundView.backgroundColor = UIColor(red: 97/255, green: 217/255, blue: 97/255, alpha: 1)

                // Set the icon & move the icon
                archiveImageView.image = UIImage(named: "archive_icon")
                archiveImageView.center.x = archiveOriginalCenter.x + (messageView.frame.origin.x - 60)

                
            // *** SWIPE ALL THE WAY RIGHT DELETE THE MESSAGE ***
            } else if messageView.frame.origin.x >= 260 {
                archiveImageView.image = UIImage(named: "delete_icon")
                archiveImageView.center.x = archiveOriginalCenter.x + (messageView.frame.origin.x - 60)
                backgroundView.backgroundColor = UIColor(red: 238/255, green: 84/255, blue: 13/255, alpha: 1)
    
            }
            
            // *** SWIPE LEFT TO SAVE FOR LATER ***
            else if messageView.frame.origin.x <= -60 && messageView.frame.origin.x > -260 {
                // Save this message for later
                laterImageView.image = UIImage(named: "later_icon")
                backgroundView.backgroundColor = UIColor(red: 1, green: 204/255, blue: 0, alpha: 1)
            }
            
            else if messageView.frame.origin.x <= -260 {
                laterImageView.image = UIImage(named: "list_icon")
                backgroundView.backgroundColor = UIColor(red: 206/255, green: 150/255, blue: 98/255, alpha: 1)
               // r 206 g 150 b 98
                print("<= 260")
            }
                
            // *** RETURN THINGS BACK TO NORMAL
            else {
                archiveImageView.frame.origin.x = 20
                laterImageView.frame.origin.x = 280
                backgroundView.backgroundColor = UIColor.grayColor()
            }
        
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            print("Gesture ended at: \(point)")
            print("Original Message view X: \(messageView.frame.origin.x)")
            
            // *** START ANIMATIONS
            
            // SWIPE RIGHT
                
            // *** ARCHIVE: IF THE PERSON SWIPES A LITTLE BIT WITHOUT COMMITTING, BOUNCE IT BACK FOR THEM
            if messageView.frame.origin.x > 0 && messageView.frame.origin.x < 60 {
                
                UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    self.messageView.frame.origin.x = 0
                    }, completion: nil)
                
            }
            
            // *** ARCHIVE: IF THE PERSON COMMITTED, SWIPE IT ALL THE WAY AND SHOW THE NEXT SCREEN
            else if messageView.frame.origin.x >= 60 {
                
                if velocity.x > 0 {
                    // Assume they want out and take it off the screen
                    print("feedImageView Y Start: \(feedImageView.frame.origin.y)")
                    UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                        self.messageView.frame.origin.x = 320
                        feedImageView.frame.origin.y = -86
                        }, completion: {
                            _ in self.backgroundView.hidden = true
                    })
                    
                        print("feedImageView Y End: \(feedImageView.frame.origin.y)")
                    
                    
                } else {
                    // They are just putting it back, bounce it back in place
                    UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                        self.messageView.frame.origin.x = 0
                        }, completion: nil)

                }
                hideActionIcons()
                
              
            // SWIPE LEFT
                
            // bounce back in place if they start then stop
                
            } else if messageView.frame.origin.x < 0 && messageView.frame.origin.x >= -60 {
                print("Message View Location \(messageView.frame.origin.x)")
                UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    self.messageView.frame.origin.x = 0
                    }, completion: nil)
                feedImageView.hidden = true
                print("Current view X: \(messageView.frame.origin.x)")
                print("Back to the start")
        
            // Swipe me off the screen now because I ended it
            } else if messageView.frame.origin.x < -60  && messageView.frame.origin.x > -260 {
                
                UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    self.messageView.frame.origin.x = -320
                    self.backgroundView.hidden = true
                    self.hideActionIcons()
                    }, completion:  {
                        _ in rescheduleImageView.hidden = false
                })
                
                print("it's between -60 and - 260")
            } else if messageView.frame.origin.x <= -260 {
                hideActionIcons()
                UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    self.messageView.frame.origin.x = -320
                    self.backgroundView.hidden = true
                    self.hideActionIcons()
                    }, completion:  {
                        _ in listImageView.hidden = false
                })
                
                print("greater than 260")
            
            }

        }
        
    }
    
    
    
    func hideActionIcons() {
        archiveImageView.hidden = true
        laterImageView.hidden = true
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //   if velocity.x > 0 {
    //     UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.3,initialSpringVelocity: 3.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
    //        self.messageView.center.x = rightBounds
    //       }, completion: nil)
    //}
    
    /*
    
    /// Check the velocity to see how serious they are about this action. If > 0 then keep going
    if velocity.x > 0 {
    // Animate this off the screen
    
    print("VELOCITY")
    } else if velocity.x < 0 {
    print("NOOO")
    }
*/
    
    
    
    
    
    // need boundaries for how far someone swiped
    
    // did you swipe left or right?
    
    // if right to archive: check out far the swipe, take the check with you, change the background color
    // i
    

}
