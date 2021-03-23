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

        let semaphore = DispatchSemaphore(value: 0)

        self.service.loadWeather(byCity: city) { data in 
            print("""

                Weather for \(city): \(Int(round(data.main.temp)))°C (min. \(data.main.temp_min)°C, max. \(data.main.temp_max)°C)
                \(data.main.humidity)% humidity
                Wind: \(self.getWindArrow(forDegree: data.wind.deg)) | \(data.wind.speed) m/s

            """)

            semaphore.signal()
        }

        // wait for the response
        // else the user would be asked for input before the result was printed
        semaphore.wait()
    }

    private func getWindArrow(forDegree degree: Int16) -> Character {
        // 🡔 🡕 🡖 🡗 🡐 🡒 🡑 🡓
        // 45 deg per arrow + 22 initial
        switch (degree) {
            case 22...67:
                return "🡗"
            case 68...112:
                return "🡐"
            case 113...157:
                return "🡔"
            case 156...202:
                return "🡑"
            case 203...247:
                return "🡕"
            case 248...292:
                return "🡒"
            case 293...337:
                return "🡖"
            case 338...360, 0...21:
                return "🡓"
            default:
                // value is always between 0...360 deg
                // will never run into default
                return " "
        }
    }
}

let app = SmolConsoleApp();

// if appid is not set, `app` will be null
// if thats the case, just exit
if app != nil {
    // else keep calling #run()
    while (true) {
        app!.run()
    }
}