import Foundation
import SmolWeatherLib

class SmolConsoleApp {
    let service: WeatherService;
    
    init?() {
        guard CommandLine.arguments.count > 1 else {
            print("No appid environment variable set!");
            return nil;
        }

        let appid = CommandLine.arguments[1]

        self.service = WeatherService(appid: appid)
        self.waitForInput()
    }

    func run() {
        self.waitForInput();
    }

    func waitForInput() {
        print("Please type in a city name:")
        let city = readLine();

        self.processInput(city)
    }


    func processInput(_ city: String?) -> Void {
        guard let city = city else {
            return;
        }

        self.service.loadWeather(byCity: city) { data in 
            print("Weather for \(city): \(data)");
        }
    }
}

let app = SmolConsoleApp();

if app != nil {
    while (true) {
        app!.run()
    }
}