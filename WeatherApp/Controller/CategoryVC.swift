//
//  CategoryVC.swift
//  WeatherApp
//
//  Created by Nguyễn Duy Việt on 28/09/2022.
//

import UIKit
import Alamofire
import RealmSwift
import Parchment

class CategoryVC: BaseViewController {
        
    var searchController = UISearchController()
    var moreButton: UIBarButtonItem?
    let choiceDropDown = DropDown()
    var isShowingDropDown = false
    
    var originalArrCity = [CityModel]()
    var changedArrCity = [CityModel]()
    
    var arrChoice = [Choice]()
    var arrSavedLocation = [SavedLocation]()
    var arrSubVC = [UIViewController]()
    
    let resultsVC = ResultsVC()
    
    var currWeatherModel: WeatherModel?
    
    let pagingViewController = PagingViewController()
    var titles = ["Saved", "Favorite"]
    var arrCatePagingItems = [CatePagingItem]()
    
    var slVC: SavedLocationVC?
    var flVC: FavoriteLocationVC?
    
    @IBOutlet weak var viewBlur: UIView!
    @IBOutlet weak var tableSavedLocation: DynamicTableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupViews()
        setupData()
        setupNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupViews() {
        setupSearchBar()
        setupNavBar()
        setupPageVC()
        view.bringSubviewToFront(viewBlur)
    }
    
    func setupPageVC() {
        arrCatePagingItems.append(CatePagingItem(index: 0, imgPaging: "p_bookmark"))
        arrCatePagingItems.append(CatePagingItem(index: 1, imgPaging: "p_star"))
        
        slVC = SavedLocationVC(nibName: "SavedLocationVC", bundle: nil)
        slVC!.currWeatherModel = self.currWeatherModel
        flVC = FavoriteLocationVC(nibName: "FavoriteLocationVC", bundle: nil)
        
        arrSubVC.append(slVC!)
        arrSubVC.append(flVC!)
        
        pagingViewController.dataSource = self
        
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
        pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pagingViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pagingViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pagingViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pagingViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -5)
        ])
        
        pagingViewController.menuBackgroundColor = .clear

        pagingViewController.borderColor = .clear
        pagingViewController.indicatorColor = #colorLiteral(red: 0.2308155, green: 0.6831951737, blue: 0.8844338655, alpha: 1)
                
        pagingViewController.register(CatePagingCell.self, for: CatePagingItem.self)
    }
    
    func setupData() {
        bindChoiceData()
        getCityFromAPI()
    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(deactiveSearchController), name: NSNotification.Name(rawValue: DEACTIVE_SEARCH_CONTROLLER), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(removeSubVCObserver), name: NSNotification.Name(rawValue: REMOVE_SAVED_AND_FAVORITE_LIST_OBSERVER), object: nil)
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Weather"
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        moreButton = UIBarButtonItem(image: UIImage(named: "ic_more")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(dropDownMoreChoice))
        navigationItem.rightBarButtonItem = moreButton
        
        choiceDropDown.anchorView = moreButton
        choiceDropDown.dataSource = ["Edit List", "Notifications", "Celsius", "Fahrenheit", "Report an Issue"]
        choiceDropDown.bottomOffset = CGPoint(x: -50, y: 40)
        
        choiceDropDown.cellNib = UINib(nibName: "ChoiceCell", bundle: nil)
        
        choiceDropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? ChoiceCell else { return }
            let data = self.arrChoice[index]
            
            // Setup your custom UI components
            cell.imgSymbol.image = UIImage(named: "\(data.imgSymbol)")
            
            if data.isChecked {
                cell.imgCheck.isHidden = false
            } else {
                cell.imgCheck.isHidden = true
            }
        }
        
        choiceDropDown.selectionAction = { [unowned self] (index: Int, item: String) in

            if index == 4 {
                let vc = ReportVC(nibName: "ReportVC", bundle: nil)
                present(vc, animated: true)
            }
            
            arrChoice[index].isChecked = !arrChoice[index].isChecked
            
            if arrChoice[index].isChecked {
                if index == 0 {
                    pagingViewController.contentInteraction = .none
                }
                if index == 2 {
                    arrChoice[3].isChecked = false
                } else if index == 3 {
                    arrChoice[2].isChecked = false
                }
            } else {
                if index == 0 {
                    pagingViewController.contentInteraction = .scrolling
                }
            }
            
            choiceDropDown.reloadAllComponents()
        }
    }
    
    func setupSearchBar() {
        searchController = UISearchController(searchResultsController: resultsVC)
        navigationItem.searchController = searchController
        searchController.searchBar.barStyle = .black
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.searchTextField.textColor = .white
        searchController.searchBar.setImage(UIImage(named: "ic_magnifying_glass"), for: .search, state: .normal)
        searchController.searchBar.placeholder = "Search for a city or airport"
        
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func bindChoiceData() {
        let c1 = Choice(isChecked: false, des: "Edit List", imgSymbol: "ic_edit")
        let c2 = Choice(isChecked: false, des: "Notifications", imgSymbol: "ic_noti")
        let c3 = Choice(isChecked: false, des: "Celsius", imgSymbol: "ic_c")
        let c4 = Choice(isChecked: false, des: "Fahrenheit", imgSymbol: "ic_f")
        let c5 = Choice(isChecked: false, des: "Report an Issue", imgSymbol: "ic_report_issue_gra")
        
        arrChoice.append(c1)
        arrChoice.append(c2)
        arrChoice.append(c3)
        arrChoice.append(c4)
        arrChoice.append(c5)
        
        choiceDropDown.reloadAllComponents()
    }

    func getCityFromAPI() {
        if let url = URL(string: "https://raw.githubusercontent.com/Viet20021476/github_Viet20021476.github.io/master/city.list.json") {
            AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil, requestModifier: nil).responseJSON { response in
                let dict = response.value as! [NSDictionary]
                self.originalArrCity = dict.map( { CityModel.deserialize(from: $0)! })
            }
        }
    }
    
    func filterCityByName(searchName: String) {
        changedArrCity = originalArrCity.filter({ city in
            city.city.lowercased().contains(searchName.lowercased())
        })
        
    }
    
    @objc func dropDownMoreChoice() {
        choiceDropDown.show()
    }
    
    @objc func deactiveSearchController() {
        self.searchController.isActive = false
        viewBlur.isHidden = true
    }
    
    @objc func removeSubVCObserver() {
        NotificationCenter.default.removeObserver(slVC!, name: NSNotification.Name(rawValue: ADD_PLACE_TO_SAVED_LIST), object: nil)
        NotificationCenter.default.removeObserver(flVC!, name: NSNotification.Name(rawValue: ADD_PLACE_TO_FAVORITE_LIST), object: nil)
    }
}

extension CategoryVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.isFirstResponder {
            viewBlur.isHidden = false
            
        }
        filterCityByName(searchName: searchController.searchBar.text!)
        resultsVC.arrFilteredCity = changedArrCity
        resultsVC.tableCityName.reloadData()
    }
    
}

extension CategoryVC: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewBlur.isHidden = true
        searchBar.resignFirstResponder()
    }
}

extension CategoryVC: PagingViewControllerDataSource {
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        return arrSubVC.count
    }

    func pagingViewController(_ pagingViewController: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        return arrSubVC[index]
    }

    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        return CatePagingItem(index: index, imgPaging: arrCatePagingItems[index].imgPaging)
    }
}
