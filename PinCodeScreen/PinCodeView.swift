//
//  ContentView.swift
//  PinCodeScreen
//
//  Created by Denis Kuzmin on 06.02.2022.
//

import SwiftUI

let buttons = [["1", "2", "3"],
               ["4", "5", "6"],
               ["7", "8", "9"],
               ["\u{232B}", "0", "\u{2327}"]]

struct PinCodeView: View {
    
    @ObservedObject var viewModel = PinCodeViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Please, enter Pin Code")
                Spacer()
                Spacer()
                HStack {
                    Spacer()
                    ForEach(0 ..< viewModel.pinCodeArray.count) { num in
                        Image(systemName: "circle.fill")
                            .foregroundColor(viewModel.pinCodeArray[num])
                            .padding(.horizontal)
                    }
                    .modifier(ShakeEffect(shakes: viewModel.shouldShake ? 2 : 0))
                    .animation(Animation.default.repeatCount(2).speed(2), value: viewModel.shouldShake)
                    Spacer()
                }
                NavigationLink(destination: MainView(), isActive: $viewModel.shouldNavigate) {
                    EmptyView()
                }
                Spacer()
                ForEach(0...3, id: \.self) { row in
                    HStack {
                        ForEach(buttons[row], id: \.self) { col in
                            Spacer()
                            Button(col) {
                                if viewModel.isActiveButtons {
                                    viewModel.symbol = String(col)
                                }
                            }
                            .font(.system(.largeTitle))
                            .padding()
                            Spacer()
                        }
                    }
                }
            }
            .onAppear(perform: viewModel.start)
        }
    }
}
