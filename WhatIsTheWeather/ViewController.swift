//
//  ViewController.swift
//  WhatIsTheWeather
//
//  Created by Gladston Joseph on 2/19/19.
//  Copyright © 2019 Gladston Joseph. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var cityTextField: UITextField!
    
    @IBOutlet var resultLabel: UILabel!
    
    @IBAction func getWeather(_ sender: Any) {
        view.endEditing(true)
        let cityName = cityTextField.text?.trimmingCharacters(in: .whitespaces)
        if cityName != "" {
            getWeatherData(city: cityName!)
        } else {
            resultLabel.text = "Please Enter a Valid City"
        }
    }
    
    func getWeatherData(city: String) {
        
        if let url = URL(string: "https://www.weather-forecast.com/locations/" + city.replacingOccurrences(of: " ", with: "-") + "/forecasts/latest") {
            
            let request = NSMutableURLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, respose, error in
                
                var message = ""
                
                if error != nil {
                    print(error!)
                } else {
                    if let unwrappedData = data {
                        let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                        
                        var stringSeperator = "Weather Today </h2>(1&ndash;3 days)</span><p class=\"b-forecast__table-description-content\"><span class=\"phrase\">"
                        
                        if let contentArray = dataString?.components(separatedBy: stringSeperator) {
                            if contentArray.count > 1 {
                                stringSeperator = "</span>"
                                let newContentArray = contentArray[1].components(separatedBy: stringSeperator)
                                if newContentArray.count > 1 {
                                    message = newContentArray[0].replacingOccurrences(of: "&deg;", with: "°")
                                    print(message)
                                }
                            }
                        }
                    }
                    
                    if message == "" {
                        message = "The weather couldn't be found. Please try again."
                    }
                    
                    DispatchQueue.main.sync(execute: {
                        self.resultLabel.text = message
                    })
                    
                }
            }
            task.resume()
        } else {
            resultLabel.text = "The weather couldn't be found. Please try again."
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
}

