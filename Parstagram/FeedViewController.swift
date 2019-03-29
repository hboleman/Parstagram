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
        query.includeKey("author");
        query.limit = 20;
        
        query.findObjectsInBackground { (posts, error) in
            if (posts != nil){
                self.posts = posts!;
                self.tableView.reloadData();
            }
        }
    }
    
    // TABLE VIEW RELATED
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell;
        
        let post = posts[indexPath.row];
        
        let user = post["author"] as! PFUser;
        cell.usernameLable.text = user.username;
        
        cell.captionLable.text = post["caption"] as? String;
        
        let imageFile = post["image"] as! PFFileObject;
        let urlString = imageFile.url!;
        let url = URL(string: urlString)!;
        
        cell.photoView.af_setImage(withURL: url);
        
        return cell;
    }
}
