//
//  PinCodeViewModel.swift
//  PinCodeScreen
//
//  Created by Denis Kuzmin on 07.02.2022.
//

import SwiftUI
import Combine

class PinCodeViewModel: ObservableObject {
    @Published var symbol: String = String()
    @Published var pinCodeArray: [Color] = []
    var shouldNavigate = false
    var shouldShake = false
    var isActiveButtons = true
    
    private var disposables = Set<AnyCancellable>()
    
    @UserDefault(key: "pinCode", defaultValue: "1234") var pinCode: String
    
    init() {
        pinCode = "5609"
        let pinCodeLength = pinCode.count
        pinCodeArray = Array(repeating: .gray, count: pinCodeLength)
    }
    
    func start() {
        let pinCodeLength = pinCode.count
        pinCodeArray = Array(repeating: .gray, count: pinCodeLength)
        $symbol
            .dropFirst()
            .scan("") {accumulator, element in
                if accumulator.count == pinCodeLength && element != "\u{2327}" && element != "\u{232B}" {
                    return element
                }
                switch element {
                case "\u{2327}":
                    return ""
                case "\u{232B}":
                    var result = accumulator
                    if result.count > 0 && result.count < pinCodeLength {
                        result.removeLast()
                    } else {
                        result = ""
                    }
                    return result
                default:
                    return accumulator + element
                }
            }
            .map {
                for num in 0 ... pinCodeLength - 1 {
                    self.pinCodeArray[num] = $0.count > num ? .green : .gray
                }
                if $0.count == pinCodeLength && $0 != self.pinCode {
                    self.pinCodeArray = Array(repeating: .red, count: pinCodeLength)
                    self.isActiveButtons = false
                    self.shouldShake.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.isActiveButtons = true
                        self.pinCodeArray = Array(repeating: .gray, count: pinCodeLength)
                    }
                }
                return $0
            }
            .filter { $0 == self.pinCode }
            .first()
            .sink(receiveCompletion: { _ in
                self.shouldNavigate = true
            }, receiveValue: { _ in })
            .store(in: &disposables)
    }
}
