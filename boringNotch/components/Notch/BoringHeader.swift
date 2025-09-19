//
//  BoringHeader.swift
//  boringNotch
//
//  Created by Harsh Vardhan  Goswami  on 04/08/24.
//

import SwiftUI

struct BoringHeader: View {
    @EnvironmentObject var vm: BoringViewModel

    var body: some View {
        HStack {
            Text("Notes")
                .font(.system(.headline, design: .rounded))
                .foregroundStyle(.white)
                .padding(.leading, 12)

            Spacer()
        }
        .padding(.trailing, 12)
        .frame(maxWidth: .infinity)
        .opacity(vm.notchState == .closed ? 0 : 1)
        .blur(radius: vm.notchState == .closed ? 20 : 0)
        .animation(.smooth.delay(0.1), value: vm.notchState)
    }
}

#Preview {
    BoringHeader().environmentObject(BoringViewModel())
}
