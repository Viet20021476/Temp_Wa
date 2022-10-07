//
//  SavedLocationVC.swift
//  WeatherApp
//
//  Created by Nguyễn Duy Việt on 03/10/2022.
//

import UIKit
import RealmSwift
import Alamofire
import MapKit

class SavedLocationVC: BaseViewController {
    
    @IBOutlet weak var tableSavedLocation: DynamicTableView!
    
    @IBOutlet weak var tvLearnMore: UITextView!
    var originalArrCity = [CityModel]()
    var changedArrCity = [CityModel]()
    
    var arrSavedLocation = [SavedLocation]()
    
    var currWeatherModel: WeatherModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupViews()
        setupData()
        setupNotification()
    }
    
    func setupViews() {
        setupTableSavedLocation()
        setupTextViewLearnMore()
    }
    
    func setupData() {
        bindSavedLocationData()
        setupLocalDB()
        getSavedLocationDataFromDB()
    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(addPlaceToSavedList(noti:)), name: NSNotification.Name(rawValue: ADD_PLACE_TO_SAVED_LIST), object: nil)
    }
    
    func setupTableSavedLocation() {
        tableSavedLocation.delegate = self
        tableSavedLocation.dataSource = self
        
        let nib = UINib(nibName: "SavedLocationCell", bundle: nil)
        tableSavedLocation.register(nib, forCellReuseIdentifier: "savedLocationCell")
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressSavedLocation(sender:)))
        tableSavedLocation.addGestureRecognizer(longPress)
    }
    
    func setupTextViewLearnMore() {
        //Util.adjustUITextViewHeight(arg: tvLearnMore)
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        let attributedString = NSMutableAttributedString(string:"Learn more about weather data and map data", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .light), .paragraphStyle: paragraph])
        let _ = attributedString.setAsLink(textToFind: "weather data", linkURL: "https://support.apple.com/en-gb/HT211777")
        let _ = attributedString.setAsLink(textToFind: "map data", linkURL: "https://gspe21-ssl.ls.apple.com/html/attribution-234.html")
        
        tvLearnMore.attributedText = attributedString
    }
    
    func bindSavedLocationData() {
        let s1 = SavedLocation(location: "My Location", time: "\(currWeatherModel!.city.name)", des: "\(currWeatherModel!.list[0].weather[0].description.capitalizingFirstLetter())", degree: "\(currWeatherModel!.list[0].main.temp)", highTemp: "\(currWeatherModel!.list[0].main.temp_max)", lowTemp: "\(currWeatherModel!.list[0].main.temp_min)")
        
        s1.id = UUID().uuidString
        s1.lat = currWeatherModel!.city.coord.lat
        s1.lon = currWeatherModel!.city.coord.lon
        
        arrSavedLocation.append(s1)
        
        tableSavedLocation.reloadData()
    }
    
    func getSavedLocationDataFromDB() {
        let data = realm?.objects(SavedLocation.self)
        
        for i in 0..<data!.count {
            let sl = SavedLocation(location: data![i].location, time: data![i].time, des: data![i].des, degree: data![i].degree, highTemp: data![i].highTemp, lowTemp: data![i].lowTemp)
            sl.id = data![i].id
            sl.lat = data![i].lat
            sl.lon = data![i].lon
            arrSavedLocation.append(sl)
            tableSavedLocation.insertSections(IndexSet(integer: arrSavedLocation.count - 1), with: .left)
        }
    }
    
    @objc func addPlaceToSavedList(noti: Notification) {
        let data = noti.userInfo!["data"] as! WeatherModel
        
        let temp = arrSavedLocation.filter( { $0.location == data.city.name } )
        if temp.count > 0 {
            let alert = UIAlertController(title: "This location is already exist", message: nil, preferredStyle: .alert)
            
            let acOK = UIAlertAction(title: "OK", style: .default)
            
            alert.addAction(acOK)
            present(alert, animated: true)
            return
        }
        
        let time = Util.getSubStringInRange(from: 11, to: 16, ofString: "\(data.list[1].dt_txt)")
        
        let sl = SavedLocation(location: "\(data.city.name)", time: time, des: "\(data.list[0].weather[0].description.capitalizingFirstLetter())", degree: "\(data.list[0].main.temp)", highTemp: "\(data.list[0].main.temp_max)", lowTemp: "\(data.list[0].main.temp_min)")
        
        sl.id = UUID().uuidString
        sl.lat = data.city.coord.lat
        sl.lon = data.city.coord.lon
        
        arrSavedLocation.append(sl)
        tableSavedLocation.insertSections(IndexSet(integer: arrSavedLocation.count - 1), with: .left)
        
        
        try! realm?.write({
            realm?.add(sl)
        })
        
        NotificationCenter.default.post(name: NSNotification.Name(DEACTIVE_SEARCH_CONTROLLER), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ADD_WEATHERVC_TO_WEATHERVC_LIST), object: nil, userInfo: ["data": CLLocationCoordinate2D(latitude: data.city.coord.lat, longitude: data.city.coord.lon)])
    }
    
    @objc func longPressSavedLocation(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: tableSavedLocation)
            if let indexPath = tableSavedLocation.indexPathForRow(at: touchPoint) {
                if indexPath.section == 0 {return}
                
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let acAddToFav = UIAlertAction(title: "Add to favorite", style: .default) { [self] ac in
                    NotificationCenter.default.post(name: NSNotification.Name(ADD_PLACE_TO_FAVORITE_LIST), object: nil, userInfo: ["data": arrSavedLocation[indexPath.section], "idx": indexPath.section])
                }
                let acDelete = UIAlertAction(title: "Delete", style: .destructive) { [self] ac in
                    NotificationCenter.default.post(name: NSNotification.Name(REMOVE_IN_FAVORITE_CORRESPOND_TO_SAVED_LIST), object: nil, userInfo: ["id": arrSavedLocation[indexPath.section].id])
                    NotificationCenter.default.post(name: NSNotification.Name(DELETE_WEATHERVC_FROM_WEATHERVC_LIST), object: nil, userInfo: ["idx": indexPath.section])
                    
                    try! self.realm?.write({
                        realm?.delete(realm!.objects(SavedLocation.self)[indexPath.section - 1])
                    })
                    
                    arrSavedLocation.remove(at: indexPath.section)
                    tableSavedLocation.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
                    
                }
                let acCancel = UIAlertAction(title: "Cancel", style: .cancel)
                
                alert.addAction(acAddToFav)
                alert.addAction(acDelete)
                alert.addAction(acCancel)
                
                present(alert, animated: true)
            }
        }
    }
    
    @IBAction func tapOnTWC(_ sender: Any) {
        guard let url = URL(string: "https://weather.com/vi-VN/weather/today/l/VMXX0006:1:VM?Goto=Redirected") else {return}
        
        UIApplication.shared.open(url)
    }
    
}

extension SavedLocationVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrSavedLocation.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableSavedLocation.dequeueReusableCell(withIdentifier: "savedLocationCell") as! SavedLocationCell
        let data = arrSavedLocation[indexPath.section]
        
        cell.lbLocation.text = data.location
        cell.lbTime.text = data.time
        cell.lbDes.text = data.des
        cell.lbDegree.text = "\(data.degree)°"
        cell.lbHighTemp.text = "H:\(data.highTemp)°"
        cell.lbLowTemp.text = "L:\(data.lowTemp)°"
        
        Util.roundCorner(views: [cell], radius: 14)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableSavedLocation.deselectRow(at: indexPath, animated: true)
        
        NotificationCenter.default.post(name: NSNotification.Name(CHANGE_CURR_PAGE), object: nil, userInfo: ["idx": indexPath.section])
        NotificationCenter.default.post(name: NSNotification.Name(REMOVE_SAVED_AND_FAVORITE_LIST_OBSERVER), object: nil)
        
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = .clear
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 0 {return nil}
        
        let delete = UIContextualAction(style: .normal, title: nil) { [self] (action, view, completionHandler) in
            NotificationCenter.default.post(name: NSNotification.Name(REMOVE_IN_FAVORITE_CORRESPOND_TO_SAVED_LIST), object: nil, userInfo: ["id": arrSavedLocation[indexPath.section].id])
            NotificationCenter.default.post(name: NSNotification.Name(DELETE_WEATHERVC_FROM_WEATHERVC_LIST), object: nil, userInfo: ["idx": indexPath.section])
            
            try! self.realm?.write({
                self.realm?.delete(realm!.objects(SavedLocation.self)[indexPath.section - 1])
            })
            
            self.arrSavedLocation.remove(at: indexPath.section)
            self.tableSavedLocation.deleteSections(IndexSet(integer: indexPath.section), with: .left)
        }
        
        delete.backgroundColor = UIColor(hexString: "#262626")
        delete.image = UIImage(named: "bin")
        // swipe
        let swipe = UISwipeActionsConfiguration(actions: [delete])
        
        return swipe
    }
    
}

