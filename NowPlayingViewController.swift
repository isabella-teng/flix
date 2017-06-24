//
//  NowPlayingViewController.swift
//  flix
//
//  Created by Isabella Teng on 6/21/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//
//To do: adjust two lines if not fit in details, make pretty. add animated error message w/ pods. alert message when network fails

import UIKit
import AlamofireImage
//import PKHUD


class NowPlayingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UISearchBarDelegate{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies: [[String: Any]] = []
    var refreshControl: UIRefreshControl!
    
    //add alert message
    let alertController = UIAlertController(title: "Error", message: "Cannot Get Movies", preferredStyle: .alert)
    
    
    //for search bar, adds in strings that match text typed in
    var filteredMovies: [[String: Any]] = []
    var searchActive: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        HUD.flash(.success, delay: 1.0)
        
        //adds refresh control at top
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NowPlayingViewController.didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
//        filteredMovies = movies
        
        activityIndicator.startAnimating()
        
        fetchMovies()
        
    }
    
    func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        fetchMovies()
    }
    
    func fetchMovies() { //Created functions so as not to repeat code
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: . reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            //This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let movies = dataDictionary["results"] as! [[String: Any]]
                self.movies = movies
                self.filteredMovies = movies
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                
            }
        }
        task.resume()
    }
    

    //updates filteredMovies based on text in the search box
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredMovies is the same as the original data
        // When user has entered text into the search box, use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the item should NOT be included
        
        filteredMovies = searchText.isEmpty ? movies : movies.filter { (item: [String: Any]) -> Bool in
            // If dataItem matches the searchText, return true to include it
    
            return (item["title"] as! String).range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
//        if(filteredMovies.count == 0){
//            searchActive = false;
//        } else {
//            searchActive = true;
//        }

        tableView.reloadData()
    }
    
    //turn off the grey default behavior when cell is clicked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if (searchActive){
//            return filteredMovies.count
//        }
        return filteredMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        cell.titleLabel.text = title
        cell.titleLabel.adjustsFontSizeToFitWidth = true
        cell.overviewLabel.text = overview
        
        let posterPathString = movie["poster_path"] as! String
        let baseURLString = "https://image.tmdb.org/t/p/w500"
        
        let posterURL = URL(string: baseURLString + posterPathString)!
        cell.posterImageView.af_setImage(withURL: posterURL)
        
        activityIndicator.stopAnimating()
        
        return cell
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //cell is the sender
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell) { //get the movie
            let movie = movies[indexPath.row]
            let detailViewController = segue.destination as! DetailsViewController //send over the entire movie
            detailViewController.movie = movie
        }
    }

}
