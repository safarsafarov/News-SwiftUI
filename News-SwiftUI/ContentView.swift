//
//  ContentView.swift
//  News-SwiftUI
//
//  Created by Safar Safarov on 2020/10/1.
//

import SwiftUI
import SwiftyJSON
import SDWebImageSwiftUI

struct ContentView: View {
    
    @ObservedObject var list = getData()
    
    var body: some View {
        NavigationView {
            
            List(list.datas){i in
                
                HStack(spacing: 15) {
                    
                    VStack(alignment: .leading, spacing: 10){
                        
                        Text(i.title).fontWeight(.heavy)
                        Text(i.desc)
                    }
                    
                    WebImage(url: URL(string: i.image)!, options: .highPriority, context: nil)
                    
                }.padding(.vertical, 15)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


// generate an API Key in NEWS API

struct dataType : Identifiable {
    var id :  String
    var title : String
    var desc : String
    var url : String
    var image : String
    
}

class getData : ObservableObject {
    
    @Published var datas = [dataType]()
    
    init() {
        let source = "https://newsapi.org/v2/top-headlines?country=us&apiKey=7b25cca186b2423abe8592421442a4b4"
        
        let url = URL(string: source)!
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: url) { (data, _, err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
            
            let json = try! JSON(data: data!)
            
            for i in json["articles"]{
                let title = i.1["title"].stringValue
                let description = i.1["description"].stringValue
                let url = i.1["url"].stringValue
                let image = i.1["urlToImage"].stringValue
                let id = i.1["publishedAt"].stringValue
                
                self.datas.append(dataType(id: id, title: title, desc: description, url: url, image: image))
            }
        }
        
    }
}
