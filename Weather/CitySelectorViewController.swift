import RxSwift
import SDWebImage
import UIKit

class CitySelectorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let data = WeatherDataViewModel()
    @IBOutlet weak var locationTableView: UITableView!
    let disposeBag = DisposeBag()
    var selectedLocation = "Your Location"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationTableView.delegate = self
        locationTableView.dataSource = self
        locationTableView.register(UINib(nibName: "LocationTableViewCell", bundle: nil), forCellReuseIdentifier: "LocationCell")
        locationTableView.rowHeight = 110
        WeatherDataViewModel
            .weatherData
            .asObservable()
            .subscribe(onNext: { (dict) in
                self.locationTableView.reloadData()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
    }

    @IBAction func refreshButtonPressed(_ sender: UIBarButtonItem) {
        data.refreshWeatherData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeatherDataViewModel.weatherData.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationTableViewCell
        let array = Array(WeatherDataViewModel.weatherData.value.values)
        cell.weatherIconImageView.sd_setImage(with: URL(string: "https://openweathermap.org/img/w/\(array[indexPath.row].iconName).png"), completed: nil)
        cell.locationLabel.text = array[indexPath.row].cityName
        cell.temperatureLabel.text = "\(array[indexPath.row].temperature) °C"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let array = Array(WeatherDataViewModel.weatherData.value.values)
        selectedLocation = array[indexPath.row].cityName
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "CitySelectorToCityDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "CitySelectorToCityDetail") {
            let destination = segue.destination as! WeatherDetailViewController
            destination.selectedLocation.value = selectedLocation
        }
    }
    
}
