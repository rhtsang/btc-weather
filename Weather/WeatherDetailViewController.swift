import RxSwift
import UIKit

class WeatherDetailViewController: UIViewController {

    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windDegreeLabel: UILabel!
    @IBOutlet weak var cloudinessLabel: UILabel!
    let selectedLocation = Variable("Your Location")
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        selectedLocation
            .asObservable()
            .subscribe(onNext: { (location) in
                self.windSpeedLabel.text = "Wind Speed:  \(WeatherDataViewModel.weatherData.value[self.selectedLocation.value]?.windSpeed ?? 0)"
                self.windDegreeLabel.text = "Wind Degree: \(WeatherDataViewModel.weatherData.value[self.selectedLocation.value]?.windDegree ?? 0)"
                self.cloudinessLabel.text = "Cloudiness: \(WeatherDataViewModel.weatherData.value[self.selectedLocation.value]?.cloud ?? 0)"
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
    }
}
