//
//  RootVC.swift
//  WeatherApp
//
//  Created by Nguyễn Duy Việt on 05/10/2022.
//

import UIKit
import Parchment
import MapKit
import RealmSwift

class RootVC: BaseViewController {
    
    var lat = 0.0
    var lon = 0.0
    
    var currWeatherModel: WeatherModel?
    
    let weatherPagingViewController = PagingViewController()
    
    var arrSubVC = [UIViewController]()
    
    let locationManager = CLLocationManager()
    var coordinates: CLLocationCoordinate2D?
    
    var pageIdx = 0
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var viewTabBar: Gradient!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
        setupData()
        setupNotification()
        view.bringSubviewToFront(viewTabBar)
    }
    
    func setupView() {
        setupPageVC()
    }
    
    func setupData() {
        setupLocalDB()
        getCurrLocation()
        getWeatherVCDataFromDB()
    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(addNewWeatherVC(noti:)), name: NSNotification.Name(ADD_WEATHERVC_TO_WEATHERVC_LIST), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteWeatherVC(noti:)), name: NSNotification.Name(DELETE_WEATHERVC_FROM_WEATHERVC_LIST), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeCurrWeatherVCPage(noti:)), name: NSNotification.Name(CHANGE_CURR_PAGE), object: nil)
    }
    
    func setupPageVC() {
        let currWeatherVC = storyBoard.instantiateViewController(withIdentifier: "mainVC") as! WeatherVC
        currWeatherVC.isCurrUserLocation = true
        
        arrSubVC = [currWeatherVC]
        
        weatherPagingViewController.delegate = self
        weatherPagingViewController.dataSource = self
        
        addChild(weatherPagingViewController)
        view.addSubview(weatherPagingViewController.view)
        weatherPagingViewController.didMove(toParent: self)
        weatherPagingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            weatherPagingViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherPagingViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weatherPagingViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            weatherPagingViewController.view.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        
        weatherPagingViewController.menuBackgroundColor = .clear
        
        weatherPagingViewController.borderColor = .clear
        weatherPagingViewController.indicatorColor = #colorLiteral(red: 0.2308155, green: 0.6831951737, blue: 0.8844338655, alpha: 1)
        
        weatherPagingViewController.collectionView.isHidden = true
        weatherPagingViewController.menuItemSize = .fixed(width: 0, height: 0)
    }
    
    func getCurrLocation() {
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
    
    func getWeatherVCDataFromDB() {
        let data = realm?.objects(SavedLocation.self)
        
        for i in 0..<data!.count {
            let weatherVC = storyBoard.instantiateViewController(withIdentifier: "mainVC") as! WeatherVC
            weatherVC.isFromCateVC = true
            weatherVC.lat = data![i].lat
            weatherVC.lon = data![i].lon
            
            arrSubVC.append(weatherVC)
            weatherPagingViewController.reloadData()
        }
        
        pageControl.numberOfPages = arrSubVC.count
        pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        pageControl.setIndicatorImage(UIImage(systemName: "location.fill"), forPage: 0)
    }
    
    @objc func addNewWeatherVC(noti: NSNotification) {
        let currLoc = noti.userInfo!["data"] as! CLLocationCoordinate2D
        
        let newWeatherVC = storyBoard.instantiateViewController(withIdentifier: "mainVC") as! WeatherVC
        newWeatherVC.isFromCateVC = true
        newWeatherVC.lat = currLoc.latitude
        newWeatherVC.lon = currLoc.longitude
        
        arrSubVC.append(newWeatherVC)
        pageControl.numberOfPages += 1
        weatherPagingViewController.reloadData()
    }
    
    @objc func deleteWeatherVC(noti: NSNotification) {
        let idx = noti.userInfo!["idx"] as! Int
        
        arrSubVC.remove(at: idx)
        pageControl.numberOfPages -= 1
        weatherPagingViewController.reloadData()
    }
    
    @objc func changeCurrWeatherVCPage(noti: NSNotification) {
        let idx = noti.userInfo!["idx"] as! Int
        
        print(idx)
        
        weatherPagingViewController.select(index: idx, animated: true)
        weatherPagingViewController.reloadData()
        
        pageControl.currentPage = idx
    }
    
    @IBAction func tapOnCategory(_ sender: Any) {
        let vc = CategoryVC(nibName: "CategoryVC", bundle: nil)
        let vc0 = arrSubVC[0] as! WeatherVC
        vc.currWeatherModel = vc0.currWeatherModel
        
        navigationController?.pushViewController(vc, animated: true)
    }
    //    @IBAction func tapOnCategory(_ sender: Any) {
    //        if navigationController!.containsViewController(ofKind: CategoryVC.self) {
    //            navigationController?.popViewController(animated: true)
    //            return
    //        }
    //
    //        let vc = CategoryVC(nibName: "CategoryVC", bundle: nil)
    //        let vc0 = arrSubVC[0] as! WeatherVC
    //        vc.currWeatherModel = vc0.currWeatherModel
    //
    //        navigationController?.pushViewController(vc, animated: true)
    //    }
    
    @IBAction func tapOnMap(_ sender: Any) {
        let vc = MapVC(nibName: "MapVC", bundle: nil)
        let weatherVC = arrSubVC[pageIdx] as! WeatherVC
        vc.coordinates = CLLocationCoordinate2D(latitude: weatherVC.lat, longitude: weatherVC.lon)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func selectWeatherVCPage(_ sender: UIPageControl) {
        let idx = sender.currentPage
        weatherPagingViewController.select(index: idx, animated: true)
        weatherPagingViewController.reloadData()
    }
}

extension RootVC: PagingViewControllerDelegate {
    func pagingViewController(_ pagingViewController: PagingViewController, didScrollToItem pagingItem: PagingItem, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) {
        let item = pagingItem as! PagingIndexItem
        pageIdx = item.index
        pageControl.currentPage = item.index
    }
}


extension RootVC: PagingViewControllerDataSource {
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        return arrSubVC.count
    }
    
    func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        return arrSubVC[index]
    }
    
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        return PagingIndexItem(index: index, title: "")
    }
}

extension RootVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        coordinates = locValue
        lat = locValue.latitude
        lon = locValue.longitude
    }
}
