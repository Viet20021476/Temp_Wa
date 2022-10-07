//
//  ViewController.swift
//  WeatherApp
//
//  Created by Nguyễn Duy Việt on 21/09/2022.
// ừhkfhfsđ

import UIKit
import Alamofire
import CoreLocation
import MapKit
import Parchment

extension WeatherVC: CityListener {
    
    func listener(lat: String, lng: String) {
        getWeatherDataAtCity(lat: Double(lat)!, lon: Double(lng)!)
        startBindingData()
    }
}
class WeatherVC: BaseViewController {
    
    var isFromResultsVC = false
    var isFromCateVC = false
    var isCurrUserLocation = false
    
    var lat = 0.0
    var lon = 0.0
    
    var currWeatherModel: WeatherModel?
    
    
    @IBOutlet weak var btnAddPlace: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var lbCityName: UILabel!
    @IBOutlet weak var lbDegree: UILabel!
    @IBOutlet weak var lbWeatherCondition: UILabel!
    @IBOutlet weak var lbHighTemp: UILabel!
    @IBOutlet weak var lbLowTemp: UILabel!
    @IBOutlet weak var lbWeatherFor: UILabel!
    
    @IBOutlet weak var tableFiveDayForecast: UITableView!
    @IBOutlet weak var hourWeatherView: UIView!
    @IBOutlet var collectionHourWeather: UICollectionView!
    @IBOutlet weak var viewForecast: UIView!
    @IBOutlet weak var viewTemperature: UIView!
    @IBOutlet weak var imgPreviewMap: UIImageView!
    @IBOutlet weak var collectionWeatherDetail: UICollectionView!
    
    @IBOutlet weak var viewReport: UIView!
    @IBOutlet weak var viewSeeMoreReport: UIView!
    @IBOutlet weak var viewOpenInMaps: UIView!
    @IBOutlet weak var tvLearnMore: UITextView!
    
    //var arrCities = [City]()
    var arrHourWeather = [HourWeather]()
    var arrWeatherForecast = [WeatherForecast]()
    var arrWeatherDetail = [WeatherDetail]()
    
    let locationManager = CLLocationManager()
    var coordinates: CLLocationCoordinate2D?
    
    let options = MKMapSnapshotter.Options()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
        setupData()
        setupEvent()
        if isCurrUserLocation {
            getCurrLocation()
        } else {
            setMapPreviewImage()
        }
        getWeatherDataAtCity(lat: lat, lon: lon)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        if !isFromResultsVC{
            navigationController?.setNavigationBarHidden(true, animated: animated)
            btnAddPlace.isHidden = true
            btnCancel.isHidden = true
        } else {
            btnAddPlace.isHidden = false
            btnCancel.isHidden = false
        }
        
        if isFromCateVC {
            navigationController?.setNavigationBarHidden(true, animated: animated)
            btnAddPlace.isHidden = true
            btnCancel.isHidden = true
        }
    }
    
    
    func setupViews() {
        startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.stopAnimating()
        }
        //setupScrollViewWeather()
        setupHourWeatherCollectionView()
        setupTableFiveDayForecast()
        setupWeatherDetailCollectionView()
        roundViewCorner()
        
        setupTextViewLearnMore()
        
        view.bringSubviewToFront(btnAddPlace)
        view.bringSubviewToFront(btnCancel)
    }
    
    func setupData() {
        bindHourWeatherData()
        bindWeatherForecastData()
        bindWeatherDetailData()
    }
    
    func setupHourWeatherCollectionView() {
        collectionHourWeather.delegate = self
        collectionHourWeather.dataSource = self
    }
    
    func setupTableFiveDayForecast() {
        tableFiveDayForecast.delegate = self
        tableFiveDayForecast.dataSource = self
    }
    
    func setupWeatherDetailCollectionView() {
        collectionWeatherDetail.delegate = self
        collectionWeatherDetail.dataSource = self
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
    
    
    func bindHourWeatherData() {
        let w1 = HourWeather(time: "9AM", currWeather: "rainy-day", degree: "20°")
        let w2 = HourWeather(time: "12AM", currWeather: "rainy-day", degree: "20°")
        let w3 = HourWeather(time: "3PM", currWeather: "rainy-day", degree: "20°")
        let w4 = HourWeather(time: "6PM", currWeather: "rainy-day", degree: "20°")
        
        let w5 = HourWeather(time: "9PM", currWeather: "rainy-day", degree: "20°")
        let w6 = HourWeather(time: "12AM", currWeather: "rainy-day", degree: "20°")
        let w7 = HourWeather(time: "3AM", currWeather: "rainy-day", degree: "20°")
        let w8 = HourWeather(time: "6PM", currWeather: "rainy-day", degree: "20°")
        
        arrHourWeather.append(w1)
        arrHourWeather.append(w2)
        arrHourWeather.append(w3)
        arrHourWeather.append(w4)
        arrHourWeather.append(w5)
        arrHourWeather.append(w6)
        arrHourWeather.append(w7)
        arrHourWeather.append(w8)
        
        collectionHourWeather.reloadData()
        
    }
    
    func bindWeatherForecastData() {
        let wf1 = WeatherForecast(day: "Today", imgWeather: "raining", probOfRain: "40%", minTemp: "10°", maxTemp: "20°")
        let wf2 = WeatherForecast(day: "Thu", imgWeather: "sun_with_cloud", probOfRain: "", minTemp: "10°", maxTemp: "20°")
        let wf3 = WeatherForecast(day: "Fri", imgWeather: "raining", probOfRain: "40%", minTemp: "10°", maxTemp: "20°")
        let wf4 = WeatherForecast(day: "Sat", imgWeather: "sun_with_cloud", probOfRain: "", minTemp: "10°", maxTemp: "20°")
        let wf5 = WeatherForecast(day: "Sun", imgWeather: "raining", probOfRain: "40%", minTemp: "10°", maxTemp: "20°")
        
        arrWeatherForecast.append(wf1)
        arrWeatherForecast.append(wf2)
        arrWeatherForecast.append(wf3)
        arrWeatherForecast.append(wf4)
        arrWeatherForecast.append(wf5)
        
        tableFiveDayForecast.reloadData()
        
    }
    
    func bindWeatherDetailData() {
        let wd1 = WeatherDetail(imgType: "ic_sun", type: "UV INDEX", imgIllustration: "sunrise", para: "6\nHigh", des: "Use sun protection until 16:00.")
        let wd2 = WeatherDetail(imgType: "ic_sunset", type: "SUNSET", imgIllustration: "ill_sunrise", para: "17:50", des: "Sunrise: 05:46")
        let wd3 = WeatherDetail(imgType: "ic_wind", type: "WIND", imgIllustration: "ill_wind", para: "", des: "")
        let wd4 = WeatherDetail(imgType: "ic_rainfall", type: "RAINFALL", imgIllustration: "", para: "0 mm", des: "Next expected is 6mm Wed.")
        let wd5 = WeatherDetail(imgType: "temperature", type: "FEELS LIKE", imgIllustration: "", para: "38°", des: "Humidity is making it feel hotter")
        let wd6 = WeatherDetail(imgType: "ic_humidity", type: "HUMIDITY", imgIllustration: "", para: "60%", des: "The dew point is 23° right now")
        let wd7 = WeatherDetail(imgType: "ic_visibility", type: "VISIBILITY", imgIllustration: "", para: "10 km", des: "Light haze is affecting visibility")
        let wd8 = WeatherDetail(imgType: "ic_pressure", type: "PRESSURE", imgIllustration: "ill_pressure", para: "", des: "")
        
        arrWeatherDetail.append(wd1)
        arrWeatherDetail.append(wd2)
        arrWeatherDetail.append(wd3)
        arrWeatherDetail.append(wd4)
        arrWeatherDetail.append(wd5)
        arrWeatherDetail.append(wd6)
        arrWeatherDetail.append(wd7)
        arrWeatherDetail.append(wd8)
        
        collectionWeatherDetail.reloadData()
    }
    
    func startBindingData() {
        lbCityName.text = currWeatherModel?.city.name
        lbDegree.text = "\(currWeatherModel!.list[0].main.temp)°"
        lbWeatherCondition.text = currWeatherModel!.list[0].weather[0].description.capitalizingFirstLetter()
        lbHighTemp.text = "H:\(currWeatherModel!.list[0].main.temp_max)°"
        lbLowTemp.text = "L:\(currWeatherModel!.list[0].main.temp_min)°"
        lbWeatherFor.text = "Weather for \(currWeatherModel!.city.name)"
    }
    
    func roundViewCorner() {
        Util.roundCorner(views: [hourWeatherView, viewForecast, viewTemperature, viewReport], radius: 20)
        Util.roundCorner(views: [imgPreviewMap], radius: 10)
    }
    
    func setupEvent() {
        tapOnImgPreviewMap()
        tapOnViewTemperature()
        tapOnOpenInMaps()
        tapOnViewSeeMoreReport()
    }
    
    func setMapPreviewImage() {
        let loc = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        options.region = MKCoordinateRegion(center: loc, latitudinalMeters: CLLocationDistance(exactly: 100)!, longitudinalMeters: CLLocationDistance(exactly: 100)!)
        options.size = CGSize(width: view.frame.width - 40, height: 200)
        options.mapType = .standard
        options.showsBuildings = true
        
        let snapshotter = MKMapSnapshotter(options: options)
        
        snapshotter.start { snapshot, error in
            if let snapshot = snapshot {
                self.imgPreviewMap.image = snapshot.image
            }
        }
    }
    
    func tapOnViewTemperature() {
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(gotoMapView))
        viewTemperature.addGestureRecognizer(tapGes)
    }
    
    func tapOnImgPreviewMap() {
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(gotoMapView))
        imgPreviewMap.addGestureRecognizer(tapGes)
    }
    
    func tapOnOpenInMaps() {
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(gotoMapView))
        viewOpenInMaps.addGestureRecognizer(tapGes)
    }
    
    func tapOnViewSeeMoreReport() {
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(goToReportVC))
        viewSeeMoreReport.addGestureRecognizer(tapGes)
    }
    
    @objc func gotoMapView() {
        let vc = MapVC(nibName: "MapVC", bundle: nil)
        vc.coordinates = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapOnMap(_ sender: Any) {
        let vc = MapVC(nibName: "MapVC", bundle: nil)
        vc.coordinates = coordinates
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapOnCategory(_ sender: Any) {
        if navigationController!.containsViewController(ofKind: CategoryVC.self) {
            navigationController?.popViewController(animated: true)
            return
        }
        
        let vc = CategoryVC(nibName: "CategoryVC", bundle: nil)
        vc.currWeatherModel = currWeatherModel
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapOnTWC(_ sender: Any) {
        guard let url = URL(string: "https://weather.com/vi-VN/weather/today/l/VMXX0006:1:VM?Goto=Redirected") else {return}
        
        UIApplication.shared.open(url)
    }
    
    @objc func goToReportVC() {
        let vc = ReportVC(nibName: "ReportVC", bundle: nil)
        present(vc, animated: true)
    }
    
    func getCurrLocation() {
        startAnimating()
        // Ask for Authorisation from the User.
        locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func getWeatherDataAtCity(lat: Double, lon: Double) {
        print("\(lat) \(lon)")
        if let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=7b4a0a06cd27be649c3b898b94d1c4ac&units=metric&cnt=0") {
            
            AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil, requestModifier: nil).responseJSON { response in
                let dict = response.value as! [String: Any]
                self.currWeatherModel = WeatherModel.deserialize(from: dict)!
                self.startBindingData()
            }
        }
    }
    
    @IBAction func addPlace(_ sender: Any) {
        dismiss(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: DEACTIVE_SEARCH_CONTROLLER), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ADD_PLACE_TO_SAVED_LIST), object: nil, userInfo: ["data": currWeatherModel!])
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: ADD_WEATHERVC_TO_WEATHERVC_LIST), object: nil, userInfo: ["data": CLLocationCoordinate2D(latitude: data.city.coord.lat, longitude: data.city.coord.lon)])
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    @IBAction func addACity(_ sender: Any) {
        let vc = CityViewController()
        vc.cityListener = self
        vc.title = "City"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension WeatherVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionHourWeather {
            return arrHourWeather.count
        } else if collectionView == self.collectionWeatherDetail {
            return arrWeatherDetail.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionHourWeather {
            let cell = collectionHourWeather.dequeueReusableCell(withReuseIdentifier: "hourWeatherCell", for: indexPath) as! HourWeatherCell
            let data = arrHourWeather[indexPath.item]
            
            cell.lbTime.text = data.time
            cell.imgWeather.image = UIImage(named: "\(data.currWeather)")
            cell.lbDegree.text = data.degree
            
            return cell
        } else if collectionView == self.collectionWeatherDetail {
            let cell = collectionWeatherDetail.dequeueReusableCell(withReuseIdentifier: "weatherDetailCell", for: indexPath) as! WeatherDetailCell
            let data = arrWeatherDetail[indexPath.item]
            
            if data.type != "UV INDEX" {
                cell.uvProgressBar.isHidden = true
            }
            
            if data.type != "RAINFALL" {
                cell.lbLast24hours.isHidden = true
            }
            
            cell.imgType.image = UIImage(named: "\(data.imgType)")
            cell.lbType.text = data.type
            cell.imgIllustration.image = UIImage(named: "\(data.imgIllustration)")
            cell.lbPara.text = data.para
            cell.lbDes.text = data.des
            
            Util.roundCorner(views: [cell], radius: 20)
            cell.uvProgressBar.layer.masksToBounds = true
            cell.uvProgressBar.layer.cornerRadius = 2
            
            return cell
        }
        return UICollectionViewCell()
    }
    
}

extension WeatherVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrWeatherForecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableFiveDayForecast.dequeueReusableCell(withIdentifier: "forecastCell") as! WeatherForecastCell
        let data = arrWeatherForecast[indexPath.row]
        
        if data.probOfRain == "" {
            cell.lbProbOfRain.isHidden = true
            cell.imgWeather.centerYAnchor.constraint(equalTo: cell.lbDay.centerYAnchor).isActive = true
        }
        
        cell.lbDay.text = data.day
        cell.imgWeather.image = UIImage(named: "\(data.imgWeather)")
        cell.lbProbOfRain.text = data.probOfRain
        cell.lbMinTemp.text = data.minTemp
        cell.lbMaxTemp.text = data.maxTemp
        
        cell.selectionStyle = .none
        
        return cell
    }
}

extension WeatherVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        if !isFromResultsVC && !isFromCateVC {
            lat = locValue.latitude
            lon = locValue.longitude
            getWeatherDataAtCity(lat: lat, lon: lon)
        }
        
        coordinates = locValue
        
        options.region = MKCoordinateRegion(center: coordinates!, latitudinalMeters: CLLocationDistance(exactly: 100)!, longitudinalMeters: CLLocationDistance(exactly: 100)!)
        options.size = CGSize(width: view.frame.width - 40, height: 200)
        options.mapType = .standard
        options.showsBuildings = true
        
        let snapshotter = MKMapSnapshotter(options: options)
        
        snapshotter.start { snapshot, error in
            if let snapshot = snapshot {
                self.imgPreviewMap.image = snapshot.image
            }
        }
    }
}


