import Foundation
import Combine
import SwiftSoup

class NetworkManager {
    
    static func fetchData(completion: @escaping ([Card]) -> Void) {
        guard let url = URL(string: "https://cabinet.unimetriq.com/client/7ed6b58dc200779aae315c2eef5a6d5d") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Failed to load data: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("No data received")
                return
            }
            
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let html = String(data: data, encoding: .utf8) ?? ""
                    let document = try SwiftSoup.parse(html)
                    
                    print("HTML Document Loaded")
                    
                    let cardElements = try document.select("div.childItem")
                    let fetchedCards: [Card] = try cardElements.enumerated().compactMap { (index, element) -> Card? in
                        let statusText = try element.select("div.p-2.text-success > div.text-center").text()
                        let isAvailable = statusText == "Свободно"
                        
                        let priceText = try element.select("span.withTooltip").text()
                        let price = Int(priceText.replacingOccurrences(of: "₽", with: "").trimmingCharacters(in: .whitespaces)) ?? 0
                        
                        return Card(id: index + 1, isAvailable: isAvailable, price: price)
                    }
                    
                    print("Fetched Cards: \(fetchedCards)")
                    
                    DispatchQueue.main.async {
                        completion(fetchedCards)
                    }
                } catch {
                    print("Ошибка при парсинге HTML: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}

