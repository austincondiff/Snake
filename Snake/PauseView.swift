//
//  PauseView.swift
//  Snake
//
//  Created by Austin Condiff on 5/12/23.
//

import SwiftUI

struct PauseView: View {
    @EnvironmentObject var model: GameViewModel

    var body: some View {
        Text("Paused")
        Button("Resume") {
            // do something
        }
        Button("Main Menu") {
            // do something
        }
    }
}

struct PauseView_Previews: PreviewProvider {
    static var previews: some View {
        PauseView()
    }
}
