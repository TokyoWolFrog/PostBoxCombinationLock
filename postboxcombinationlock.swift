import SwiftUI

@main
struct PostBoxCombinationLockApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct CircleTextView: View {
    let total: Int
    let index: Int
    let circleLabel: String
    
    var body: some View {
        VStack {
            Text(circleLabel)
                .fontWeight(.bold)
                .font(.title)
                .foregroundColor(Color.white)
                .rotationEffect(
                    .radians(
                        -(Double.pi*2 / Double(total) * Double(index))
                    )
                )
            Spacer()
        }
        .padding()
        .rotationEffect(
            .radians(
                (Double.pi*2 / Double(total) * Double(index))
            )
        )
    }
}

struct CircleTextView_Previews: PreviewProvider {
    static var previews: some View {
        CircleTextView(total: 10, index: 0, circleLabel: "0")
    }
}

struct LockHandleView: View {
    let handleW: CGFloat
    let handleH: CGFloat
    
    var body: some View {
        ZStack{
            Circle()
                .fill(Color.gray)
                .frame(width: handleW, height: handleH)
            
            Circle()
                .fill(Color.white)
                .frame(width: handleW/8, height: handleH/8)
                .offset(x: 0, y: 0 - handleH/2 + handleH/8)
        }
    }
}

struct LockHandleView_Previews: PreviewProvider {
    static var previews: some View {
        LockHandleView(handleW: 125.0, handleH: 100.0)
    }
}

struct CombinationLockView: View {
    let lockW: CGFloat
    let lockH: CGFloat
    let rotateAngle: Double
    let circleTextList: [String]
    
    var body: some View {
        ZStack{
            Circle()
                .fill(Color.black)
                .frame(width: lockW, height: lockH)
            
            LockHandleView(handleW: lockW / 1.5 , handleH: lockH/1.5)
                .rotationEffect(
                    Angle.degrees(rotateAngle)
                )
                .animation(
                    .linear(duration: 1.5), value: rotateAngle
                )
            
            ForEach(0..<circleTextList.count){
                index in CircleTextView(total: circleTextList.count, index: index, circleLabel: circleTextList[index])
            }
        }
        .frame(width: 230, height: 230, alignment: .center)
    }
}

struct CombinationLockView_Previews: PreviewProvider {
    static var previews: some View {
        CombinationLockView(lockW: 250.0, lockH: 200.0, rotateAngle: 0.0, circleTextList: ["0", "1","2"])
    }
}

struct ContentView: View {
    let directions = ["左", "右"]
    let displayList = ["0" , "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    
    @State private var angle = 0.0
    @State private var selected = [0, 0, 0, 0, 0, 0, 0]
    @State private var buttonText = "開け方： １回目"
    
    @State private var stepNum = 0
    @State private var oldValue = 0
    
    var body: some View {
        VStack{
            Text("解錠ポスト番号：")
                .font(.title)
            HStack {
                Picker("方向One", selection: $selected[0]) {
                    ForEach(0..<directions.count) { id in
                        Text(directions[id])
                            .font(.title2)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                Picker("数値Two", selection: $selected[1]) {
                    ForEach(0..<displayList.count) { id in
                        Text(displayList[id])
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            .padding()
            
            HStack {
                Picker("方向Three", selection: $selected[2]) {
                    ForEach(0..<directions.count) { id in
                        Text(directions[id])
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                Picker("数値Four", selection: $selected[3]) {
                    ForEach(0..<displayList.count) { id in
                        Text(displayList[id])
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            .padding()
            
            HStack {
                Picker("方向Five", selection: $selected[4]) {
                    ForEach(0..<directions.count) { id in
                        Text(directions[id])
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                Picker("数値Six", selection: $selected[5]) {
                    ForEach(0..<displayList.count) { id in
                        Text(displayList[id])
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            .padding()
            
            // lockW: 250.0, lockH: 200.0
            CombinationLockView(lockW: 250.0, lockH: 200.0, rotateAngle: angle, circleTextList: displayList)
                .padding()
            
            HStack {
                Text("ダイヤルの印の現位置：")
                    .font(.title3)
                
                Picker("数値Seven", selection: $selected[6]) {
                    ForEach(0..<displayList.count) { id in
                        Text(displayList[id])
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .onChange(of: selected[6]){ newValue in
                    angle += -36.0 * Double((newValue > oldValue) ? oldValue + 10 - newValue: oldValue - newValue)
                    oldValue = newValue
                }
            }
            .padding()
            
            Button(buttonText) {
                if selected[stepNum] == 0 {
                    angle += -36.0 * Double((selected[stepNum + 1] >= oldValue) ? oldValue + 10 - selected[stepNum + 1]: oldValue - selected[stepNum + 1])
                    oldValue = selected[stepNum + 1]
                } else {
                    angle += 36.0 * Double((selected[stepNum + 1] <= oldValue) ? selected[stepNum + 1] + 10 - oldValue: selected[stepNum + 1] - oldValue)
                    oldValue = selected[stepNum + 1]
                }
                
                stepNum += 2
                if stepNum == 2 {
                    buttonText = "開け方： ２回目"
                } else if stepNum == 4 {
                    buttonText = "開け方： ３回目"
                } else {
                    buttonText = "開け方： １回目"
                    stepNum = 0
                }
                
            }
            .font(.largeTitle)
        }
        

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
