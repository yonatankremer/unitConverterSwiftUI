//
//  ContentView.swift
//  UnitConverter2
//
//  Created by Yonatan Kremer on 11/7/23.
//

import SwiftUI
import Foundation

struct ContentView: View {
    
    
    //variables ->//
    
    
    
    
    //main unit types
    
    let mainCategories = ["Length","Weight","Temperature"]
    
    
    
    //sub unit types
    
    let subType0 = ["cm","m","inch","foot","km","mile","yard"]
    let subType1 = ["g","kg","lb","oz","ton"]
    let subType2 = ["C°","F°","K°"]
    
    
    //------------------------------------------------------------------
    
    //@State variables ->//
    
    
    
    
    
    
    //chosen main type
    @State private var mainStateTypeList = ["cm","m","inch","foot","km","mile","yard"]
    
    @State private var mainStateTypeListOut = ["cm","m","inch","foot","km","mile","yard"]
    
    @State private var mainStateTypeInt = 0
    
    
    //chosen sub type
    @State private var subUnitTypeIn = 0
    @State private var subUnitTypeOut = 1
    
    
    //alerts
    @State private var conversionAlert = false
    
    //user input
    @State private var input = 0.0
    @State private var output = 0.0
    
    
    //focus states
    @FocusState private var kbFocus: Bool
    
    
    //------------------------------------------------------------------
    
    var body: some View {
        
        NavigationView {
            
            ZStack{
                
                LinearGradient(stops: [
                    Gradient.Stop(color: .white, location: 0),
                    Gradient.Stop(color: .white, location: 0.6),
                    Gradient.Stop(color: .gray, location: 1)],
                    startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                
                VStack(alignment: .center) {
                    
                    
                    //main unit selection
                    Text("Unit Converter")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                    
                    Picker("", selection: $mainStateTypeInt) {
                        ForEach (0..<mainCategories.count, id: \.self)
                        {
                            Text(mainCategories[$0])
                        }
                        
                    }.pickerStyle(PalettePickerStyle()).padding()
                        .onChange(of: mainStateTypeInt) {
                            switch mainStateTypeInt {
                                case 0: mainStateTypeList = subType0
                                case 1: mainStateTypeList = subType1
                                case 2: mainStateTypeList = subType2
                                default: mainStateTypeList = subType0
                            }
                            mainStateTypeListOut = mainStateTypeList
                            mainStateTypeListOut.remove(at: subUnitTypeIn)
                        }.padding()
                    
                    
                    
                    
                    //sub unit selection - in
                    Text("Select in type").padding(.top)
                    Picker("", selection: $subUnitTypeIn)
                    {
                        ForEach(0..<mainStateTypeList.count, id: \.self)
                        {
                            Text("\(mainStateTypeList[$0])")
                        }
                        
                    }.onChange(of: subUnitTypeIn)
                    {
                        mainStateTypeListOut = mainStateTypeList
                        mainStateTypeListOut.remove(at: subUnitTypeIn)
                    }
                    
                    
                    
                    
                    //user input
                    Text("Enter amount").padding(.top)
                    TextField("", value: $input, format: .number)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.center)
                        .focused($kbFocus)
                    
                    
                    
                    
                    
                    
                    //sub unit selection - out
                    Text("Select out type").padding(.top)
                    Picker("", selection: $subUnitTypeOut)
                    {
                        ForEach(0..<mainStateTypeListOut.count, id: \.self)
                        {
                            Text(mainStateTypeListOut[$0])
                        }
                    }
                    
                    
                    
                    //conversion
                    Button("Convert!")
                    {
                        output = mainConvert(mainType: mainStateTypeInt, inTypeP: subUnitTypeIn, outTypeP: subUnitTypeOut, amount: input)
                        
                        conversionAlert = true
                        
                    }.buttonStyle(.borderedProminent).controlSize(.large).padding()
                    
                    
                    
                    
                    //conversion alert
                }.alert(isPresented: $conversionAlert) {
                    Alert(title: Text("Conversion complete!"), message: Text("\(output.formatted()) \(mainStateTypeListOut[subUnitTypeOut])"), dismissButton: .default(Text("Done")))
                }
                
                
                
                
                
                
                //focus
                
            }.onTapGesture {
                if kbFocus {kbFocus = false}
            }
        }
    }
    
}



//------------------------------------------------------------------



//functions

func mainConvert(mainType: Int, inTypeP: Int, outTypeP: Int, amount: Double) -> Double
{
    
    var outType = outTypeP
    
    if inTypeP <= outTypeP {outType += 1}
    
    var returnVal: Double
    
    switch mainType {
    case 0: returnVal = lengthConvert(inTypeP, outType, amount)
        
    case 1: returnVal = weightConvert(inTypeP, outType, amount)
        
    case 2: returnVal = tempConvert(inTypeP, outType, amount)
        
        
    default: returnVal = Double.nan
        
    }
    
    returnVal.round(.toNearestOrAwayFromZero)
    return returnVal
}





func lengthConvert(_ inType: Int, _ outType: Int, _ amount: Double) -> Double
{
    
    
    if inType == outType {return amount}
        
    switch (inType, outType) {
        
    case (0,1): return amount / 100
    case (0,2): return amount * 0.393701
    case (0,3): return lengthConvert(0,2,amount) / 12
    case (0,4): return amount / 100_000
    case (0,5): return lengthConvert(0,3,amount) / 5280
    case (0,6): return lengthConvert(0,3,amount) / 3
        
    case (1,0): return amount * 100
    case (2,0): return amount * 2.54
    case (3,0): return lengthConvert(2,0,amount) * 12
    case (4,0): return amount * 100_000
    case (5,0): return lengthConvert(3,0,amount) * 5280
    case (6,0): return lengthConvert(3,0,amount) * 3

        
    default: return lengthConvert(0,outType,lengthConvert(inType,0,amount))
        
    }
}



func weightConvert(_ inType: Int, _ outType: Int, _ amount: Double) -> Double
{
    if inType == outType {return amount}
    
    switch (inType, outType) {
        
    case (0,1): return amount / 1000
    case (0,2): return amount * 0.00220462
    case (0,3): return weightConvert(0, 2,amount) * 16
    case (0,4): return amount / 1_000_000
    
    case (1,0): return amount * 1000
    case (2,0): return amount * 453.592
    case (3,0): return weightConvert(0, 2,amount) / 16
    case (4,0): return amount * 1_000_000
        
    default: return
        weightConvert(0, outType, weightConvert(inType,0,amount))
        
    }
}



func tempConvert(_ inType: Int, _ outType: Int, _ amount: Double) -> Double
{
    if inType == outType {return amount}
    
    switch (inType, outType) {
        
    case (0,1): return (amount * (9/5)) + 32
    case (0,2): return amount + 273.15
    
    case (1,0): return (amount - 32) * (5/9)
    case (2,0): return amount - 273.15
        
    default: return
        tempConvert(0, outType, tempConvert(inType,0,amount))
        
    }
}




#Preview {
    ContentView()
}
