//
//  CoinManager.swift
//  Crypto-exchange
//
//  Created by Даниил Симахин on 19.05.2022.
//

import Foundation

protocol CoinManagerDelegate {
    func didFailWithError(error: Error)
    func didUpdateCurrencyPrice(price: String, currencyBase: String, currencyQuote: String)
}

struct CoinManager {
    let url = "https://rest.coinapi.io/v1/exchangerate"
    let apikey = "CB487E37-DA4E-4C68-8413-97955096C414"
    let currencyBase = ["USD", "EUR", "RUB", "BTC", "ETH", "USDT", "USDC", "BNB", "SOL", "DOGE", "SHIB", "CAKE"]
    let currencyQuote = ["AUD", "BRL", "CAD", "EUR", "GBP", "HKD", "IDR", "ILS", "INR", "JPY", "MXN", "NOK", "NZD", "PLN", "RON", "RUB", "SEK", "SGD", "USD", "ZAR"]
    var delegate: CoinManagerDelegate?
    
    func performRequest(base currencyBase: String, quote currencyQuote: String) {
        let urlString = "\(url)/\(currencyBase)/\(currencyQuote)?apikey=\(apikey)"
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil {
                delegate?.didFailWithError(error: error!)
                return
            }
            guard let safeData = data else { return }
            guard let bitcoinPrice = self.parseJSON(safeData) else { return }
            let priceString = String(format: "%.2f", bitcoinPrice)
            self.delegate?.didUpdateCurrencyPrice(price: priceString, currencyBase: currencyBase, currencyQuote: currencyQuote)
        }
        task.resume()
    }
    
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decode = try decoder.decode(CoinData.self, from: data)
            return decode.rate
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
