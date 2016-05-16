//
//  ComplicationController.swift
//  BitFreeze WatchKit Extension
//
//  Created by Gabriel Neves Ferreira on 03/05/16.
//  Copyright © 2016 Ipsum. All rights reserved.
//

import ClockKit
import WatchConnectivity



class ComplicationController: NSObject, CLKComplicationDataSource {
    
    
    
    override init() {
        super.init()
       
    }
    
    
    var data : [[String : NSObject]] = []
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirectionsForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.Backward])
    }
    
    func getTimelineStartDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        let currentDate = NSDate()
        let beginDate = currentDate.dateByAddingTimeInterval(NSTimeInterval(-24 * 60 * 60))
     
        handler(beginDate)
        
    }
    
    func getTimelineEndDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        let currentDate = NSDate()
        print("end")
        print(currentDate)
        
        handler(currentDate)
    }
    
    func getPrivacyBehaviorForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.ShowOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntryForComplication(complication: CLKComplication, withHandler handler: ((CLKComplicationTimelineEntry?) -> Void)) {
        // Call the handler with the current timeline entry
      
        
        if complication.family == .ModularLarge {
            
            data = DataStore().loadData()!
            let current = data.last
            
            
            let entry = createTimeLineEntryLarge(current!["market"] as! String, price: current!["price"] as! String, currency: current!["currency"] as! String, ask: current!["ask"] as! String, bid: current!["bid"] as! String, date: NSDate())
            
            handler(entry)
        } else {
            
            if complication.family == .ModularSmall {
                
                data = DataStore().loadData()!
                let current = data.last
                
                
                let entry = createTimeLineEntrySmall(current!["market"] as! String, price: current!["price"] as! String, currency: current!["currency"] as! String, ask: current!["ask"] as! String, bid: current!["bid"] as! String, date: NSDate())
                
                handler(entry)
                
                
            }else{
                
                handler(nil)

                
            }
            
        }
        
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, beforeDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries prior to the given date
        
        
        
        if complication.family == .ModularLarge {
            //limite de 100
            //100 ultimas entradas falando que a date delas foi de minutos atras?
            //passar um vetor que possui o date tambem??
            
            var timeLineEntryArray = [CLKComplicationTimelineEntry]()
            
            
            for item in data {
                
                let oldDate  = item["date"] as! NSDate
                let realDate = oldDate//.dateByAddingTimeInterval(-3 * 60 * 60)
                let entry = createTimeLineEntryLarge(item["market"] as! String, price: item["price"] as! String, currency: item["currency"] as! String, ask: item["ask"] as! String, bid: item["bid"] as! String, date: realDate)
                timeLineEntryArray.append(entry)
                
                
            }
            
           
        
            handler(timeLineEntryArray)

            } else {
            
            if complication.family == .ModularSmall {
                
                var timeLineEntryArray = [CLKComplicationTimelineEntry]()
                
                
                for item in data {
                    
                    let oldDate  = item["date"] as! NSDate
                    let realDate = oldDate//.dateByAddingTimeInterval(-3 * 60 * 60)
                    let entry = createTimeLineEntrySmall(item["market"] as! String, price: item["price"] as! String, currency: item["currency"] as! String, ask: item["ask"] as! String, bid: item["bid"] as! String, date: realDate)
                    timeLineEntryArray.append(entry)
                    
                    
                }
                
                
                
                handler(timeLineEntryArray)
                
                
            }else{
            
                handler(nil)
            }
        }

    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, afterDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    // MARK: - Update Scheduling
    
    func getNextRequestedUpdateDateWithHandler(handler: (NSDate?) -> Void) {
        // Call the handler with the date when you would next like to be given the opportunity to update your complication content
        
        print("sup")
        handler(NSDate(timeIntervalSinceNow: 60));
    }
    
    //MARK : - Functions
    
    func createTimeLineEntryLarge(marketName: String, price: String,currency : String,ask: String,bid: String, date: NSDate) -> CLKComplicationTimelineEntry {
        
        let template = CLKComplicationTemplateModularLargeStandardBody()
        template.headerTextProvider = CLKSimpleTextProvider(text: marketName,shortText: marketName)
        template.headerTextProvider.tintColor = UIColor(colorLiteralRed: 9/255, green: 184/255, blue: 255/255, alpha: 1)
        
        template.body1TextProvider = CLKSimpleTextProvider(text: price + " " + currency)
        template.body2TextProvider = CLKSimpleTextProvider(text: "A:" + ask + "  B:" + bid)
        
        template.tintColor = UIColor(colorLiteralRed: 9/255, green: 184/255, blue: 255/255, alpha: 1)

        
        let entry = CLKComplicationTimelineEntry(date: date,
                                                 complicationTemplate: template)
        
        return(entry)
    }
    
    func createTimeLineEntrySmall(marketName: String, price: String,currency : String,ask: String,bid: String, date: NSDate) -> CLKComplicationTimelineEntry {
        
        let template = CLKComplicationTemplateModularSmallStackText()
        template.line1TextProvider = CLKSimpleTextProvider(text: currency,shortText: currency)
        //template.line1TextProvider
        template.line1TextProvider.tintColor = UIColor(colorLiteralRed: 9/255, green: 184/255, blue: 255/255, alpha: 1)
        
        template.line2TextProvider = CLKSimpleTextProvider(text: price , shortText: price.componentsSeparatedByString(".")[0])
        
        template.tintColor = UIColor(colorLiteralRed: 9/255, green: 184/255, blue: 255/255, alpha: 1)
        
        
        
        let entry = CLKComplicationTimelineEntry(date: date,
                                                 complicationTemplate: template)
        
        return(entry)
    }
    
    
    
    // MARK: - Placeholder Templates
    
    func getPlaceholderTemplateForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        var template: CLKComplicationTemplate? = nil
        switch complication.family {
        case .ModularSmall:
            let modularSmall = CLKComplicationTemplateModularSmallStackText()
            modularSmall.line1TextProvider = CLKSimpleTextProvider(text: "BRL", shortText: "BRL")
            modularSmall.line1TextProvider.tintColor = UIColor(colorLiteralRed: 9/255, green: 184/255, blue: 255/255, alpha: 1)

            modularSmall.line2TextProvider = CLKSimpleTextProvider(text: "-----", shortText: "-----")
           
            template = modularSmall
            template?.tintColor = UIColor(colorLiteralRed: 9/255, green: 184/255, blue: 255/255, alpha: 1)
            
        case .ModularLarge:
            let modularLarge = CLKComplicationTemplateModularLargeStandardBody()
            modularLarge.headerTextProvider = CLKSimpleTextProvider(text: "nome do mercado",shortText: "nome do mercado")
            modularLarge.headerTextProvider.tintColor = UIColor(colorLiteralRed: 9/255, green: 184/255, blue: 255/255, alpha: 1)

            modularLarge.body1TextProvider = CLKSimpleTextProvider(text: "----- BRL")
   
            modularLarge.body2TextProvider = CLKSimpleTextProvider(text: "A:-----   B:-----")

            template = modularLarge
            template?.tintColor = UIColor(colorLiteralRed: 9/255, green: 184/255, blue: 255/255, alpha: 1)
        case .UtilitarianSmall:
           template = nil
        case .UtilitarianLarge:
            template = nil
        case .CircularSmall:
            template = nil
        }
        handler(template)
        
        }

    
    
}
