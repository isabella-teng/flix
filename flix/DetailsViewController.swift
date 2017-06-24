//
//  DetailsViewController.swift
//  flix
//
//  Created by Isabella Teng on 6/22/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var backDropImageView: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var ratingsLabel: UILabel!
    
    var movie: [String: Any]? //movies are dictionaries
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let movie = movie {
            titleLabel.text = movie["title"] as? String
            titleLabel.adjustsFontSizeToFitWidth = true
            titleLabel.adjustsFontForContentSizeCategory = true
            releaseDateLabel.text = "Release Date: " + (movie["release_date"] as? String)!
            overviewLabel.text = movie["overview"] as? String
            overviewLabel.sizeToFit()
            ratingsLabel.text =  "Rating: " + ("\(movie["vote_average"]!)/10")
//            print(titleLabel.text as! String)
            let backdropPathString = movie["backdrop_path"] as! String
            let posterPathString = movie["poster_path"] as! String
            let baseURLString = "https://image.tmdb.org/t/p/w500"
            
            let backdropURLString = URL(string: baseURLString + backdropPathString)!
            let posterURLString = URL(string: baseURLString + posterPathString)!
            
            backDropImageView.af_setImage(withURL: backdropURLString)
            posterImageView.af_setImage(withURL: posterURLString)
            posterImageView.layer.borderWidth = 3
            posterImageView.layer.borderColor = UIColor.white.cgColor
            
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
