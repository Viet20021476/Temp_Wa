

import UIKit
import CoreLocation
 
//search bar
extension CityViewController: UISearchBarDelegate {
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchBar.text == "" {
                isSearching = false
                tableView.reloadData()
            } else {
                isSearching = true
                filteredData = []
                let cities = cities.filter({$0.city.contains(searchText)})
                filteredData = cities.map({ city in
                    city.city
                })
                tableView.reloadData()
            }
        }
    }
 
//parse JSON from local.json
extension CityViewController {
    
    func readLocalJSONFile(forName name: String) -> Data? {
        do {
            if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
                let fileUrl = URL(fileURLWithPath: filePath)
                let data = try Data(contentsOf: fileUrl)
                
                return data
            }
        } catch {
            print("error: \(error)")
        }
        return nil
    }
    
    func parse(jsonData: Data) -> [City] {
        do {
            let decodedData = try JSONDecoder().decode( [City].self, from: jsonData)
            self.cities = decodedData
            return decodedData
        } catch {
            print("error: \(error)")
        }
        return []
    }
}
    
 
//local.json
struct City: Decodable {
    let city: String
    let lat: String
    let lng: String
    let country: String
}
 
//ip
struct CurrentCity: Decodable {
    let city: String
    let lat: Double
    let lon: Double
}
 
protocol CityListener {
    func listener(lat:String, lng: String)
}
 
class CityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var cityListener: CityListener? = nil
    var cities: [City] = []
    
    var filteredData = [String]()
    var isSearching = false
    
    var currentCity: CurrentCity?
 
 
    override func viewDidLoad() {
        super.viewDidLoad()
        //create req
        let url = "http://ip-api.com/json"
        getData(from: url)
 
        //local json parse
        let jsonData = readLocalJSONFile(forName: "local")
        if let data = jsonData {
                cities = parse(jsonData: data)
                tableView.reloadData()
        }
 
        // set delegate
        self.tableView.delegate = self
        self.tableView.dataSource = self
 
//        // set tableview size
//        tableView.frame = view.frame
//        tableView.keyboardDismissMode = .onDrag
        // set tableview
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
//        self.view.addSubview(tableView)
        
        //search bar
        searchBar.delegate = self
        searchBar.enablesReturnKeyAutomatically = false
        
        //city view controller swipe
        var leftGesture = UISwipeGestureRecognizer(target: self, action: Selector("swipeToHomeScreen:"))
        leftGesture.direction = .left
        self.view.addGestureRecognizer(leftGesture)
        func swipeToHomeScreen(sender:UISwipeGestureRecognizer) {
            self.navigationController?.popViewController(animated: true)
        }
   }
    
    func getData(from url: String) {
        
        //connect
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { [self]data, response, error in
            guard let data = data, error == nil else {
                print("Something went wrong.")
                return
            }
            var result: CurrentCity?
            do {
                result = try JSONDecoder().decode(CurrentCity?.self, from: data)
            } catch {
                print(String(describing: error))
            }
            guard let json = result else {
                return
            }
            
            var currentCityCoor = CLLocation(latitude: json.lat, longitude: json.lon)
            self.cities = self.cities.sorted(by: {
                let distance1 = (currentCityCoor.distance(from: CLLocation(latitude: Double($0.lat)! , longitude: Double($0.lng)!)))
                let distance2 = (currentCityCoor.distance(from: CLLocation(latitude: Double($1.lat)! , longitude: Double($1.lng)!)))
                return (distance1 < distance2)
            }
            )
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
//            tableView.reloadData()
        })
        task.resume()
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredData.count
        } else {
            return cities.count
        }
    }
    
    // set tableview rows
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self))! as UITableViewCell
        if isSearching {
            cell.textLabel?.text = filteredData[indexPath.row]
        } else {
 
            cell.textLabel?.text = """
                    \(cities[indexPath.row].city), \(cities[indexPath.row].country)
                    Latitude: \(cities[indexPath.row].lat), Longitude: \(cities[indexPath.row].lng)
                    """
        }
 
        cell.textLabel?.sizeToFit()
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row) cell was selected")
        cityListener?.listener(lat: cities[indexPath.row].lat, lng: cities[indexPath.row].lng)
        navigationController?.popViewController(animated: true)
    }
}
 

