 //
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by Chengjiu Hong on 1/15/17.
//  Copyright © 2017 Chengjiu Hong. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {


    @IBOutlet weak var networkErrorButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies : [NSDictionary]?
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        networkErrorButton.isHidden = true
        
        //Initialize a UIRefreshControl
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(MoviesViewController.refreshControlAction(sender:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        collectionView.insertSubview(refreshControl, at: 0)
        
        
        //make API call
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        // Display HUD right before the request is made
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            // Hide HUD once the network request comes back (must be done on main UI thread)
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(dataDictionary)
                    self.movies = dataDictionary["results"] as? [NSDictionary]
                    //Tableview is always get done before the network connection!!!!!
                    //MUST reload the tableview again after the network has been made
                    self.collectionView.reloadData()
                }
            }
            else{
                self.networkErrorButton.isHidden = false
            }
        }
        task.resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if let movies = movies{
            return movies.count
        }else{
            return 0
        }
    
    }
    

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MoviieCollectionViewCell //Downcast into MovieCell class object

        let movie = movies![indexPath.row] //get single movie
        //let title = movie["title"] as! String
        //let overview = movie["overview"] as! String
        let baseURL = "http://image.tmdb.org/t/p/w500"
        let posterPath = movie["poster_path"] as! String
        let imageURL = NSURL(string: baseURL + posterPath)
        cell.posterView.setImageWith(imageURL as! URL)
        //cell.titleLabel.text = title
        //cell.overviewLabel.text = overview
        print ("row \(indexPath.row)")
        return cell
    }
    
    //refresh function call
    func refreshControlAction(sender:AnyObject) {
        
        // ... Create the URLRequest `myRequest` ...
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        // Configure session so that completion handler is executed on main UI thread
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            // ... Use the new data to update the data source ...
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(dataDictionary)
                    self.movies = dataDictionary["results"] as? [NSDictionary]
                    // Reload the tableView now that there is new data
                    self.collectionView.reloadData()
                }
            }
            
            // Tell the refreshControl to stop spinning
            self.refreshControl.endRefreshing()
        }
        task.resume()
    }
    
    @IBAction func networkErrorBtnAction(_ sender: Any) {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        // Display HUD right before the request is made
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            // Hide HUD once the network request comes back (must be done on main UI thread)
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if let data = data {
                self.networkErrorButton.isHidden = true
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(dataDictionary)
                    self.movies = dataDictionary["results"] as? [NSDictionary]
                    //Tableview is always get done before the network connection!!!!!
                    //MUST reload the tableview again after the network has been made
                    self.collectionView.reloadData()
                }
            }
            else{
                self.networkErrorButton.isHidden = false
            }
        }
        task.resume()
    }

}
