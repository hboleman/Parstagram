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

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Create posts
    var posts = [PFObject]();

    
    // VIEW DID BLANK
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self;
        tableView.dataSource = self;
        // Do any additional setup after loading the view.
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
    
    // Logout Button
    @IBAction func onLogoutButton(_ sender: Any) {
        PFUser.logOut();
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController");
        
        let delegate = UIApplication.shared.delegate as! AppDelegate;
        delegate.window?.rootViewController = loginViewController;
    }
    
    // TABLE VIEW RELATED
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let post = posts[section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        return comments.count + 1
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
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell;
            let comment  = comments[indexPath.row - 1]
            cell.commentLable.text =  comment["text"] as? String
            
            let user = comment["author"] as! PFUser
            cell.nameLable.text = user.username
            
            return cell;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        
        //let comment = PFObject(className: "Comments")
        let comment = PFObject(className: "Comments")
        comment["text"] = "This is a random comment"
        comment["post"] = post
        comment["author"] = PFUser.current()!
        
        post.add(comment, forKey: "comments")
        
        post.saveInBackground { (success, error) in
            if success {
                print("Comment saved!")
            }
            else {
                print("ERROR: comment could not be saved!: \(error)")
            }
        }
    }
    
}
