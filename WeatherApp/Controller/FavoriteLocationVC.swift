//
//  FavoriteLocationVC.swift
//  WeatherApp
//
//  Created by Nguyễn Duy Việt on 03/10/2022.
//

import UIKit
import RealmSwift

class FavoriteLocationVC: BaseViewController {

    @IBOutlet weak var tableFavoriteLocation: DynamicTableView!
    @IBOutlet weak var tvLearnMore: UITextView!
    
    var arrFavoriteLocation = [FavoriteLocation]()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        setupNotification()
        setupData()
    }

    func setupView() {
        setupTableFavoriteLocation()
        setupTextViewLearnMore()
    }
    
    func setupData() {
        setupLocalDB()
        getFavoriteLocationDataFromDB()
    }
    
    func setupTableFavoriteLocation() {
        tableFavoriteLocation.delegate = self
        tableFavoriteLocation.dataSource = self
        
        let nib = UINib(nibName: "SavedLocationCell", bundle: nil)
        tableFavoriteLocation.register(nib, forCellReuseIdentifier: "savedLocationCell")
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressToDelete(sender:)))
        tableFavoriteLocation.addGestureRecognizer(longPress)
    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(addPlaceToFavoriteList), name: NSNotification.Name(ADD_PLACE_TO_FAVORITE_LIST), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeCorrespondToSavedList(noti:)), name: NSNotification.Name(REMOVE_IN_FAVORITE_CORRESPOND_TO_SAVED_LIST), object: nil)
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
    
    func getFavoriteLocationDataFromDB() {
        let data = realm?.objects(FavoriteLocation.self)
        
        for i in 0..<data!.count {
            let sl = FavoriteLocation(id: data![i].id, location: data![i].location, time: data![i].time, des: data![i].des, degree: data![i].degree, highTemp: data![i].highTemp, lowTemp: data![i].lowTemp, indexInSavedLocation: data![i].indexInSavedLocation)
            sl.lat = data![i].lat
            sl.lon = data![i].lon
            arrFavoriteLocation.append(sl)
            tableFavoriteLocation.insertSections(IndexSet(integer: arrFavoriteLocation.count - 1), with: .left)
        }
    }
    
    @objc func addPlaceToFavoriteList(noti: Notification) {
        let data = noti.userInfo!["data"] as! SavedLocation
        let idx = noti.userInfo!["idx"] as! Int
        
        
        let fl = FavoriteLocation(id: data.id, location: data.location, time: data.time, des: data.des, degree: data.degree, highTemp: data.highTemp, lowTemp: data.lowTemp, indexInSavedLocation: idx)
        
        fl.lat = data.lat
        fl.lon = data.lon
        
        arrFavoriteLocation.append(fl)
        tableFavoriteLocation.insertSections(IndexSet(integer: arrFavoriteLocation.count - 1), with: .left)
        
        try! realm?.write({
            realm?.add(fl)
        })
    }
    
    @objc func longPressToDelete(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: tableFavoriteLocation)
            if let indexPath = tableFavoriteLocation.indexPathForRow(at: touchPoint) {
                
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
                let acDelete = UIAlertAction(title: "Remove from favorite list", style: .destructive) { [self] ac in
                    try! self.realm?.write({
                        realm?.delete(realm!.objects(FavoriteLocation.self)[indexPath.section])
                    })
                    
                    arrFavoriteLocation.remove(at: indexPath.section)
                    tableFavoriteLocation.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
                }
                let acCancel = UIAlertAction(title: "Cancel", style: .cancel)
                
                alert.addAction(acDelete)
                alert.addAction(acCancel)
                
                present(alert, animated: true)
            }
        }
    }
    
    @objc func removeCorrespondToSavedList(noti: NSNotification) {
        let id = noti.userInfo!["id"] as! String
        
        if let index = arrFavoriteLocation.firstIndex(where: {$0.id == id}) {
            try! self.realm?.write({
                realm?.delete(realm!.objects(FavoriteLocation.self)[index])
            })
            
            arrFavoriteLocation.remove(at: index)
            tableFavoriteLocation.deleteSections(IndexSet(integer: index), with: .fade)
        }
    }
    
    @IBAction func tapOnTWC(_ sender: Any) {
        guard let url = URL(string: "https://weather.com/vi-VN/weather/today/l/VMXX0006:1:VM?Goto=Redirected") else {return}
        
        UIApplication.shared.open(url)
    }
}

extension FavoriteLocationVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrFavoriteLocation.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableFavoriteLocation.dequeueReusableCell(withIdentifier: "savedLocationCell") as! SavedLocationCell
        let data = arrFavoriteLocation[indexPath.section]
        
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
        tableFavoriteLocation.deselectRow(at: indexPath, animated: true)
        
        NotificationCenter.default.post(name: NSNotification.Name(CHANGE_CURR_PAGE), object: nil, userInfo: ["idx": arrFavoriteLocation[indexPath.section].indexInSavedLocation])
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

}
