//
//  ReportVC.swift
//  WeatherApp
//
//  Created by Nguyễn Duy Việt on 26/09/2022.
//

import UIKit

class ReportVC: UIViewController {
    
    @IBOutlet weak var tableOverallConditions: DynamicTableView!
    @IBOutlet weak var tableTemperature: DynamicTableView!
    @IBOutlet weak var tableWind: DynamicTableView!
    @IBOutlet weak var tableOtherConditions: DynamicTableView!
    @IBOutlet weak var collectionDescription: UICollectionView!
    @IBOutlet weak var viewNav: UIView!
    @IBOutlet weak var tvFeedbackOnline: UITextView!
    
    var arrOverallCondition = [OverallConditions]()
    var arrTemperature = [Temperature]()
    var arrWind = [Wind]()
    var arrOtherConditions = [OtherConditions]()
    var arrDescription = [Description]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupViews()
        setupData()
        view.bringSubviewToFront(viewNav)
    }
    
    override func viewDidLayoutSubviews() {
        tableOverallConditions.tableFooterView = UIView(frame: CGRect(x: CGFloat.leastNonzeroMagnitude, y: CGFloat.leastNonzeroMagnitude, width: CGFloat.leastNonzeroMagnitude, height: CGFloat.leastNonzeroMagnitude))
    }
    
    func setupViews() {
        setupTableOverallConditions()
        setupTableTemperature()
        setupTableWind()
        setupTableOtherConditions()
        setupCollectionDescription()
        setupTvFeedbackOnline()
    }
    
    func setupData() {
        bindOverallConditionsData()
        bindTemperatureData()
        bindWindData()
        bindTableOtherConditionsData()
        bindDescriptionData()
    }
    
    func setupTableOverallConditions() {
        tableOverallConditions.delegate = self
        tableOverallConditions.dataSource = self
        
        let nib = UINib(nibName: "OverallConditionsCell", bundle: nil)
        tableOverallConditions.register(nib, forCellReuseIdentifier: "overallConditionsCell")
        
        Util.roundCorner(views: [tableOverallConditions], radius: 10)
    }
    
    func setupTableTemperature() {
        tableTemperature.delegate = self
        tableTemperature.dataSource = self
        
        let nib = UINib(nibName: "TemperatureCell", bundle: nil)
        tableTemperature.register(nib, forCellReuseIdentifier: "temperatureCell")
        
        Util.roundCorner(views: [tableTemperature], radius: 10)
    }
    
    func setupTableWind() {
        tableWind.delegate = self
        tableWind.dataSource = self
        
        let nib = UINib(nibName: "WindCell", bundle: nil)
        tableWind.register(nib, forCellReuseIdentifier: "windCell")
        
        Util.roundCorner(views: [tableWind], radius: 10)
    }
    
    func setupTableOtherConditions() {
        tableOtherConditions.delegate = self
        tableOtherConditions.dataSource = self
        
        let nib = UINib(nibName: "OtherConditionsCell", bundle: nil)
        tableOtherConditions.register(nib, forCellReuseIdentifier: "otherConditionsCell")
        
        Util.roundCorner(views: [tableOtherConditions], radius: 10)
    }
    
    func setupCollectionDescription() {
        collectionDescription.delegate = self
        collectionDescription.dataSource = self
        
        let nib = UINib(nibName: "DescriptionCell", bundle: nil)
        collectionDescription.register(nib, forCellWithReuseIdentifier: "descriptionCell")
        
    }
    
    func setupTvFeedbackOnline() {
        let attributedString = NSMutableAttributedString(string:"If you have comments about the Weather app, provide feedback online.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .medium)])
        let linkWasSet = attributedString.setAsLink(textToFind: "provide feedback online", linkURL: "https://www.apple.com/feedback/weather/")
        
        tvFeedbackOnline.attributedText = attributedString
    }
    
    func bindOverallConditionsData() {
        let oc1 = OverallConditions(imgWeather: "ic_moon", weather: "Clear", weatherSpecific: [], isOpenSubView: false)
        
        let oc2 = OverallConditions(
            imgWeather: "ic_cloud",
            weather: "Clouds",
            weatherSpecific: [
                WeatherSpecific(weatherSpe: "Partly Cloudy", isChecked: false),
                WeatherSpecific(weatherSpe: "Mostly Cloudy", isChecked: false),
                WeatherSpecific(weatherSpe: "Fully Cloudy", isChecked: false)
            ],
            isOpenSubView: false
        )
        
        let oc3 = OverallConditions(
            imgWeather: "ic_rain",
            weather: "Rain",
            weatherSpecific: [
                WeatherSpecific(weatherSpe: "Light", isChecked: false),
                WeatherSpecific(weatherSpe: "Medium", isChecked: false),
                WeatherSpecific(weatherSpe: "Heavy", isChecked: false)
            ],
            isOpenSubView: false
        )
        
        let oc4 = OverallConditions(
            imgWeather: "ic_sleet",
            weather: "Sleet",
            weatherSpecific: [
                WeatherSpecific(weatherSpe: "Light", isChecked: false),
                WeatherSpecific(weatherSpe: "Medium", isChecked: false),
                WeatherSpecific(weatherSpe: "Heavy", isChecked: false)
            ],
            isOpenSubView: false
        )
        
        let oc5 = OverallConditions(
            imgWeather: "ic_snowflake",
            weather: "Snow",
            weatherSpecific: [
                WeatherSpecific(weatherSpe: "Light", isChecked: false),
                WeatherSpecific(weatherSpe: "Medium", isChecked: false),
                WeatherSpecific(weatherSpe: "Heavy", isChecked: false)
            ],
            isOpenSubView: false
        )
        
        arrOverallCondition.append(oc1)
        arrOverallCondition.append(oc2)
        arrOverallCondition.append(oc3)
        arrOverallCondition.append(oc4)
        arrOverallCondition.append(oc5)
        
        tableOverallConditions.reloadData()
    }
    
    func bindTemperatureData() {
        let t1 = Temperature(imgTemp: "ic_temp_hot", des: "It's warmer", isChecked: false)
        let t2 = Temperature(imgTemp: "ic_temp_accurate", des: "Seems accurate", isChecked: false)
        let t3 = Temperature(imgTemp: "ic_temp_cold", des: "It's colder", isChecked: false)
        
        arrTemperature.append(t1)
        arrTemperature.append(t2)
        arrTemperature.append(t3)
        
        tableTemperature.reloadData()
    }
    
    func bindWindData() {
        let wind1 = Wind(imgSymbol: "ic_greater", des: "It's windier", isChecked: false)
        let wind2 = Wind(imgSymbol: "ic_equal", des: "Seems accurate", isChecked: false)
        let wind3 = Wind(imgSymbol: "ic_less", des: "It's less windy", isChecked: false)
        
        arrWind.append(wind1)
        arrWind.append(wind2)
        arrWind.append(wind3)
        
        tableWind.reloadData()
    }
    
    func bindTableOtherConditionsData() {
        let oc1 = OtherConditions(imgWeather: "ic_rainbow", des: "Rainbow", isChecked: false)
        let oc2 = OtherConditions(imgWeather: "ic_lightning", des: "Lightning", isChecked: false)
        let oc3 = OtherConditions(imgWeather: "ic_hail", des: "Hail", isChecked: false)
        let oc4 = OtherConditions(imgWeather: "ic_smoke", des: "Smoke", isChecked: false)
        let oc5 = OtherConditions(imgWeather: "ic_fog", des: "Fog", isChecked: false)
        let oc6 = OtherConditions(imgWeather: "ic_haze", des: "Haze", isChecked: false)
        
        arrOtherConditions.append(oc1)
        arrOtherConditions.append(oc2)
        arrOtherConditions.append(oc3)
        arrOtherConditions.append(oc4)
        arrOtherConditions.append(oc5)
        arrOtherConditions.append(oc6)
        
        tableOtherConditions.reloadData()
    }
    
    func bindDescriptionData() {
        let d1 = Description(des: "Plesant", isClicked: false)
        let d2 = Description(des: "Unplesant", isClicked: false)
        let d3 = Description(des: "Hot", isClicked: false)
        let d4 = Description(des: "Chilly", isClicked: false)
        let d5 = Description(des: "Muggy", isClicked: false)
        let d6 = Description(des: "Dry", isClicked: false)
        let d7 = Description(des: "Windy", isClicked: false)
        let d8 = Description(des: "Calm", isClicked: false)
        
        arrDescription.append(d1)
        arrDescription.append(d2)
        arrDescription.append(d3)
        arrDescription.append(d4)
        arrDescription.append(d5)
        arrDescription.append(d6)
        arrDescription.append(d7)
        arrDescription.append(d8)
        
        collectionDescription.reloadData()
    }
    
    @IBAction func tapOnSubmit(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func tapOnCancel(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension ReportVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.tableOverallConditions {
            return arrOverallCondition.count
        } else {
            return 1
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableOverallConditions {
            return arrOverallCondition[section].weatherSpecific.count
        } else if tableView == self.tableTemperature {
            return arrTemperature.count
        } else if tableView == self.tableWind {
            return arrWind.count
        } else if tableView == self.tableOtherConditions {
            return arrOtherConditions.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableOverallConditions {
            let cell = tableOverallConditions.dequeueReusableCell(withIdentifier: "overallConditionsCell") as! OverallConditionsCell
            let data = arrOverallCondition[indexPath.section].weatherSpecific[indexPath.row]
            
            cell.lbWeatherSpecific.text = data.weatherSpe
            
            if data.isChecked {
                cell.imgCheck.isHidden = false
            } else {
                cell.imgCheck.isHidden = true
            }
            
            cell.selectionStyle = .none
            
            return cell
        } else if tableView == self.tableTemperature {
            let cell = tableTemperature.dequeueReusableCell(withIdentifier: "temperatureCell") as! TemperatureCell
            let data = arrTemperature[indexPath.row]
            
            cell.imgTemp.image = UIImage(named: "\(data.imgTemp)")
            cell.lbDes.text = data.des
            
            if data.isChecked {
                cell.imgCheck.isHidden = false
            } else {
                cell.imgCheck.isHidden = true
            }
            
            return cell
        } else if tableView == self.tableWind {
            let cell = tableWind.dequeueReusableCell(withIdentifier: "windCell") as! WindCell
            let data = arrWind[indexPath.row]
            
            cell.imgSymbol.image = UIImage(named: "\(data.imgSymbol)")
            cell.lbDes.text = data.des
            
            if data.isChecked {
                cell.imgCheck.isHidden = false
            } else {
                cell.imgCheck.isHidden = true
            }
            
            return cell
        } else if tableView == self.tableOtherConditions {
            let cell = tableOtherConditions.dequeueReusableCell(withIdentifier: "otherConditionsCell") as! OtherConditionsCell
            let data = arrOtherConditions[indexPath.row]
            
            cell.imgWeather.image = UIImage(named: "\(data.imgWeather)")
            cell.lbDes.text = data.des
            
            if data.isChecked {
                cell.imgCheck.isHidden = false
            } else {
                cell.imgCheck.isHidden = true
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == self.tableOverallConditions {
            let header = UIView()
            //header.frame = CGRect(x: 0, y: 0, width: 20, height: 50)
            header.backgroundColor = UIColor(hexString: "#262626")
            
            let imgWeather = UIImageView()
            imgWeather.translatesAutoresizingMaskIntoConstraints = false
            header.addSubview(imgWeather)
            
            imgWeather.topAnchor.constraint(equalTo: header.topAnchor, constant: 10).isActive = true
            imgWeather.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 20).isActive = true
            imgWeather.widthAnchor.constraint(equalToConstant: 30).isActive = true
            imgWeather.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            imgWeather.image = UIImage(named: "\(arrOverallCondition[section].imgWeather)")
            
            let lbWeather = UILabel()
            lbWeather.translatesAutoresizingMaskIntoConstraints = false
            header.addSubview(lbWeather)
            
            lbWeather.leadingAnchor.constraint(equalTo: imgWeather.trailingAnchor, constant: 15).isActive = true
            lbWeather.centerYAnchor.constraint(equalTo: imgWeather.centerYAnchor).isActive = true
            
            lbWeather.textColor = .white
            lbWeather.font = .systemFont(ofSize: 18, weight: .medium)
            lbWeather.text = arrOverallCondition[section].weather
            
            let sw = UISwitch()
            sw.translatesAutoresizingMaskIntoConstraints = false
            header.addSubview(sw)
            
            sw.isOn = arrOverallCondition[section].isOpenSubView
            
            sw.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -20).isActive = true
            sw.centerYAnchor.constraint(equalTo: imgWeather.centerYAnchor).isActive = true
            
            sw.addTarget(self, action: #selector(tapOnSwitch), for: .valueChanged)
            sw.tag = section
            
            
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.tableOverallConditions {
            return 50
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tableOverallConditions {
            if arrOverallCondition[indexPath.section].isOpenSubView {
                return UITableView.automaticDimension
            } else {
                return 0
            }
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableOverallConditions {
            
            let dataAtRow =  arrOverallCondition[indexPath.section].weatherSpecific[indexPath.row]
            
            dataAtRow.isChecked = !dataAtRow.isChecked
            
            if dataAtRow.isChecked {
                for i in 0..<arrOverallCondition[indexPath.section].weatherSpecific.count {
                    if arrOverallCondition[indexPath.section].weatherSpecific[i].weatherSpe != dataAtRow.weatherSpe {
                        arrOverallCondition[indexPath.section].weatherSpecific[i].isChecked = false
                    }
                }
            }
            
            tableOverallConditions.reloadData()
        } else if tableView == self.tableTemperature {
            let data = arrTemperature[indexPath.row]
            data.isChecked = !data.isChecked
            
            if data.isChecked {
                for i in 0..<arrTemperature.count {
                    if arrTemperature[i].des != data.des {
                        arrTemperature[i].isChecked = false
                    }
                }
            }
            tableTemperature.reloadData()
        } else if tableView == self.tableWind {
            let data = arrWind[indexPath.row]
            data.isChecked = !data.isChecked
            
            if data.isChecked {
                for i in 0..<arrWind.count {
                    if arrWind[i].des != data.des {
                        arrWind[i].isChecked = false
                    }
                }
            }
            tableWind.reloadData()
        } else if tableView == self.tableOtherConditions {
            let data = arrOtherConditions[indexPath.row]
            data.isChecked = !data.isChecked
            tableOtherConditions.reloadData()
        }
    }
    
    @objc func tapOnSwitch(sender: UISwitch) {
        let tag = sender.tag
        arrOverallCondition[tag].isOpenSubView = !arrOverallCondition[tag].isOpenSubView
        tableOverallConditions.reloadData()
    }
}

extension ReportVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrDescription.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionDescription.dequeueReusableCell(withReuseIdentifier: "descriptionCell", for: indexPath) as! DescriptionCell
        let data = arrDescription[indexPath.item]
        
        cell.lbDes.text = data.des
        
        if data.isClicked {
            cell.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        } else {
            cell.backgroundColor = UIColor(hexString: "#262626")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currDes = arrDescription[indexPath.item]
        currDes.isClicked = !currDes.isClicked
        
        if indexPath.item % 2 == 0 {
            let nextDes = arrDescription[indexPath.item + 1]
            if nextDes.isClicked {
                nextDes.isClicked = false
            }
        } else {
            let prevDes = arrDescription[indexPath.item - 1]
            if prevDes.isClicked {
                prevDes.isClicked = false
            }
        }
        collectionDescription.reloadData()
    }
}
