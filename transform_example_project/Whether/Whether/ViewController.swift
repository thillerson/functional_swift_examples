//
//  ViewController.swift
//  Whether
//
//  Created by Tony Hillerson on 8/7/14.
//  Copyright (c) 2014 Tack Mobile. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

  @IBOutlet weak var collectionView: UICollectionView!
  
  private var weather:Array<(String,String)>?
  
  let zips = [
    "80003",
    "80216",
    "80303",
    "80111",
    "80205",
  ]
 
  override func viewDidLoad() {
    super.viewDidLoad()
    loadWeather()
  }
  
  func loadWeather() {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
      
      let results = self.zips
        .map { zip -> (String, NSURLRequest) in
          return (zip, self.zipToRequest(zip))
        }
        .map { zip, request -> (String, NSDictionary) in
          return (zip, self.requestToJSON(request))
        }
        .map { zip, json -> (String, String) in
          return (zip, self.jsonToWeatherDescription(json))
      }
      
      /* Terse form. Weirder, but more readable in another sense...
      let results =
        self.zips
          .map { ( $0, self.zipToRequest($0) ) }
          .map { ( $0.0, self.requestToJSON($0.1)) }
          .map { ( $0.0, self.jsonToWeatherDescription($0.1) ) }
      */
      
      dispatch_async(dispatch_get_main_queue(), { self.displayWeather(results) })
    }
  }
  
  func displayWeather(results:Array<(String, String)>) {
    weather = results
    collectionView.reloadData()
  }
  
  // MARK: Transforms
  
  /**
    Transform a zip code string into a Yahoo weather request
  */
  func zipToRequest(zip:String) -> NSURLRequest {
    let earl = NSURL(string: "http://query.yahooapis.com/v1/public/yql?format=json&q=select%20item%20from%20weather.forecast%20where%20location%3D%27\(zip)%27");
    return NSURLRequest(URL: earl)
  }
  
  /**
    Transform an NSURLRequest into a JSON NSDictionary. Could be improved to handle errors better
  */
  func requestToJSON(request:NSURLRequest) -> NSDictionary {
    var response: NSURLResponse?
    var error: NSErrorPointer = nil
    let data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: error)
    let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: error) as NSDictionary
    return json
  }
  
  /**
    Transform Yahoo Weather json dictionary into a weather description. Could be improved to handle errors better
  */
  func jsonToWeatherDescription(json:NSDictionary) -> String {
    let query = json["query"] as NSDictionary
    let results = query["results"] as NSDictionary
    let channel = results["channel"] as NSDictionary
    let item = channel["item"] as NSDictionary
    let condition = item["condition"] as NSDictionary
    let temp = condition["temp"] as String
    let description = condition["text"] as String
    let weatherText = "\(temp) and \(description)"
    
    return weatherText
  }
  
  //MARK: CollectionView Stuff
  
  func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
    if let data = weather {
      return data.count
    } else {
      return 0
    }
  }
  
  func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
    let (zip, description) = weather![indexPath.row]
    
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("weather_cell", forIndexPath: indexPath) as WeatherCell
    cell.zip!.text = "\(zip)"
    cell.text!.text = "\(description)"
    return cell
  }
  
  func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
    return CGSize(width: collectionView.frame.size.width, height: 55)
  }

  
}

