//
//  Home.swift
//  UI-628
//
//  Created by nyannyan0328 on 2022/08/03.
//

import SwiftUI

struct Home: View {
    @State var tools: [Tool] = [
            .init(icon: "scribble.variable", name: "Scribble", color: .purple),
            .init(icon: "lasso", name: "Lasso", color: .green),
            .init(icon: "plus.bubble", name: "Comment", color: .blue),
            .init(icon: "bubbles.and.sparkles.fill", name: "Enhance", color: .orange),
            .init(icon: "paintbrush.pointed.fill", name: "Picker", color: .pink),
            .init(icon: "rotate.3d", name: "Rotate", color: .indigo),
            .init(icon: "gear.badge.questionmark", name: "Settings", color: .yellow)
        ]
    
    @State var activeTool : Tool?
    @State var startedToolPosition : CGRect = .zero
    var body: some View {
        VStack{
            
            VStack(alignment: .leading) {
                
                ForEach($tools){$tool in
                    
                    ToolView(tools: $tool)
                    
                    
                }
            }
            .padding(.horizontal,10)
            .padding(.vertical,10)
           
            .background{
             
                RoundedRectangle(cornerRadius: 10,style: .continuous)
                    .fill(.white.shadow(.drop(color:.black.opacity(0.5),radius: 5,x: 5,y: 5)).shadow(.drop(color:.black.opacity(0.01),radius: 5,x: -5,y: -5)))
                    .frame(width:65)
                  .frame(maxWidth: .infinity,alignment: .leading)
                
            }
            .coordinateSpace(name: "AREA")
            .gesture(
            DragGesture()
                .onChanged({ value in
                    
                    guard let firstTool = tools.first else{return}
                    
                
                    if startedToolPosition == .zero{
                        
                        startedToolPosition = firstTool.toolPostion
                    }
                    let location = CGPoint(x: startedToolPosition.midX, y: value.location.y)
                    
                    
                    if let index = tools.firstIndex(where: { tool in
                        
                        tool.toolPostion.contains(location)
                    }),activeTool?.id != tools[index].id{
                        
                        
                        withAnimation(.interpolatingSpring(stiffness: 350, damping: 22)){
                            
                            activeTool = tools[index]
                        }
                    }
                    
                })
                .onEnded({ value in
                    
                    activeTool = nil
                    startedToolPosition = .zero
                })
            
            )
        }
        .padding(15)
        .padding(.top)
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .topLeading)
    }
    @ViewBuilder
    func ToolView(tools : Binding<Tool>)->some View{
        
        HStack(spacing:15){
            
            Image(systemName: tools.icon.wrappedValue)
                .font(.title2)
             .frame(width: 50,height: 50)
             .padding(.leading,activeTool?.id == tools.id ? 5 : 0)
             .background{
              
                 GeometryReader{proxy in
                     
                     let frame = proxy.frame(in: .named("AREA"))
                     
                     Color.clear
                         .preference(key :RectKey.self, value: frame)
                         .onPreferenceChange(RectKey.self) { value in
                             
                             tools.wrappedValue.toolPostion = value
                         }
                 }
             }
            
            if activeTool?.id == tools.id{
                
                Text(tools.name.wrappedValue)
                    .foregroundColor(.white)
                    .padding(.trailing,15)
                
                    
            }
            
            
    
        }
        .background{
         
            RoundedRectangle(cornerRadius: 10,style: .continuous)
                .fill(tools.wrappedValue.color.gradient)
        }
        .offset(x:activeTool?.id == tools.wrappedValue.id ? 60 : 0)
        
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct RectKey : PreferenceKey{
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
