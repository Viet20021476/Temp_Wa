//
//  ResultsVC.swift
//  WeatherApp
//
//  Created by Nguyễn Duy Việt on 28/09/2022.
//

import UIKit
import Alamofire

class ResultsVC: BaseViewController {
    
    var arrFilteredCity = [CityModel]()

    @IBOutlet weak var tableCityName: DynamicTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        setupTableCityName()
        // Do any additional setup after loading the view.        
    }
    
    func setupTableCityName() {
        tableCityName.delegate = self
        tableCityName.dataSource = self
        
        let nib = UINib(nibName: "CityNameCell", bundle: nil)
        tableCityName.register(nib, forCellReuseIdentifier: "cityNameCell")
    
    }

}

extension ResultsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFilteredCity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableCityName.dequeueReusableCell(withIdentifier: "cityNameCell") as! CityNameCell
        let data = arrFilteredCity[indexPath.row]
            
        cell.lbCityName.text = data.admin_name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableCityName.deselectRow(at: indexPath, animated: true)
        let city = arrFilteredCity[indexPath.row]
                
        let vc = storyBoard.instantiateViewController(withIdentifier: "mainVC") as! WeatherVC
        vc.isFromResultsVC = true
        vc.lat = city.lat
        vc.lon = city.lng
                        
        present(vc, animated: true)
    }
}
