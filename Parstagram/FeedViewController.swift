//
//  FeedViewController.swift
//  Parstagram
//
//  Created by Hunter Boleman on 3/21/19.
//  Copyright © 2019 Hunter Boleman. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage
import MessageInputBar

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageInputBarDelegate {
    //-------------------- Class Setup --------------------//
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Create posts
    var posts = [PFObject]();
    
    // For Message Input Bar
    let commentBar = MessageInputBar();
    var showCommentBar = false;
    
    // VIEW DID BLANK
    override func viewDidLoad() {
        super.viewDidLoad()
        // For keyboard setup
        commentBar.inputTextView.placeholder = "Add a comment...";
        commentBar.sendButton.title = "Post";
        commentBar.delegate = self;
        
        tableView.delegate = self;
        tableView.dataSource = self;
        
        tableView.keyboardDismissMode = .interactive
        
        // For hiding keyboard
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)), name: UIResponder.keyboardWillHideNotification , object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        
        let query = PFQuery(className:"Posts");
        query.includeKeys(["author", "comments", "comments.author"]);
        query.limit = 20;
        
        query.findObjectsInBackground { (posts, error) in
            if (posts != nil){
                self.posts = posts!;
                self.tableView.reloadData();
            }
        }
    }
    
    //-------------------- Button Actions --------------------//
    
    // Logout Button
    @IBAction func onLogoutButton(_ sender: Any) {
        PFUser.logOut();
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController");
        
        let delegate = UIApplication.shared.delegate as! AppDelegate;
        delegate.window?.rootViewController = loginViewController;
    }
    
    //-------------------- Message Input Bar Related --------------------//
    
    // Keyboard Post Button
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        // Create comment
        
        // Clear and dismiss keyboard
        hideKeyboard();
    }
    
    // To Hide Keyboard
    @objc func keyboardWillBeHidden(note: Notification){
        hideKeyboard();
    }
    
    // Shared Function for Hiding Keyboard
    func hideKeyboard(){
        commentBar.inputTextView.text = nil;
        showCommentBar = false;
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
    }
    
    // Message Input Bar Functions
    override var inputAccessoryView: UIView? {
        return commentBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return showCommentBar;
    }
    
    //-------------------- Table View Related --------------------//
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let post = posts[section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        return comments.count + 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.section];
        let comments = (post["comments"] as? [PFObject]) ?? [];
        
        // For Post Cell
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell;
            
            let user = post["author"] as! PFUser;
            cell.usernameLable.text = user.username;
            
            cell.captionLable.text = post["caption"] as? String;
            
            let imageFile = post["image"] as! PFFileObject;
            let urlString = imageFile.url!;
            let url = URL(string: urlString)!;
            
            cell.photoView.af_setImage(withURL: url);
            
            return cell;
        }
            // For Comment Cell
        else if indexPath.row <= comments.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell;
            let comment  = comments[indexPath.row - 1]
            cell.commentLable.text =  comment["text"] as? String
            
            let user = comment["author"] as! PFUser
            cell.nameLable.text = user.username
            
            return cell;
        }
            // For Add Comment Section
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell")!;
            
            return cell;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        let comments = (post["comments"] as? [PFObject]) ?? [];
        
        // To figure out if you are in the add comment cell
        if (indexPath.row == comments.count + 1){
            showCommentBar = true;
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder()
        }
        
//        comment["text"] = "This is a random comment"
//        comment["post"] = post
//        comment["author"] = PFUser.current()!
//
//        post.add(comment, forKey: "comments")
//
//        post.saveInBackground { (success, error) in
//            if success {
//                print("Comment saved!")
//            }
//            else {
//                print("ERROR: comment could not be saved!: \(error)")
//            }
//        }
    }
    
}
