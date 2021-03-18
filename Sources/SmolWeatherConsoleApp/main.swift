import SmolWeatherLib

while(true) { main(); }

func main() {
    print("Please type in a city name:")
    let city = readLine();

    processInput(city)
}


func processInput(_ city: String?) -> Void {
    guard let city = city else {
        return;
    }

    print("Weather for \(city)");
}