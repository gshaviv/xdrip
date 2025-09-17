//
//  LiveActivityView.swift
//  xdrip
//
//  Created by Paul Plant on 30/7/25.
//  Copyright © 2025 Johan Degraeve. All rights reserved.
//

import SwiftUI
import WidgetKit

// conditionally show a view with the activity families added if available
struct LiveActivityView: View {
    @Environment(\.activityFamily) var activityFamily
    var context: ActivityViewContext<XDripWidgetAttributes>

    var body: some View {
        if activityFamily == .small {
            // watch
            ZStack {
                GlucoseChartView(glucoseChartType: .dynamicIsland, bgReadingValues: context.state.bgReadingValues, bgReadingDates: context.state.bgReadingDates, isMgDl: context.state.isMgDl, urgentLowLimitInMgDl: context.state.urgentLowLimitInMgDl, lowLimitInMgDl: context.state.lowLimitInMgDl, highLimitInMgDl: context.state.highLimitInMgDl, urgentHighLimitInMgDl: context.state.urgentHighLimitInMgDl, liveActivityType: nil, hoursToShowScalingHours: 1.75, glucoseCircleDiameterScalingHours: nil, overrideChartHeight: nil, overrideChartWidth: 160, highContrast: nil, needFrame: false)

                VStack(alignment: .leading) {
                    HStack(alignment: .bottom) {
                        Text(context.state.bgValueStringInUserChosenUnit())
                            .contentTransition(.numericText(value: Double(context.state.bgValueStringInUserChosenUnit()) ?? 0))

                        Text(context.state.trendArrow())
                    }
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .font(.title3.weight(.heavy))
                    .opacity(0.75)

                    Spacer()
               
                    if let lastDate = context.state.bgReadingDates.first {
                        Text(lastDate, style: .timer)
                            .foregroundStyle(.gray)
                            .contentTransition(.numericText())
                            .font(.callout.bold())
                    }
                }
                .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 0))
            }
        } else if context.state.liveActivityType == .minimal {
            // 1 = minimal widget with no chart
            HStack(alignment: .center) {
                Text("\(context.state.bgValueStringInUserChosenUnit()) \(context.state.trendArrow())")
                    .font(.system(size: 35)).bold()
                    .foregroundStyle(context.state.bgTextColor())
                    .minimumScaleFactor(0.1)
                    .lineLimit(1)

                Spacer()

                if context.state.warnUserToOpenApp {
                    Text("Open app...")
                        .font(.footnote).bold()
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.center)
                        .padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
                        .background(.cyan).opacity(0.9)
                        .cornerRadius(10)

                    Spacer()
                }

                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(context.state.deltaChangeStringInUserChosenUnit())
                        .font(.title).fontWeight(.semibold)
                        .foregroundStyle(context.state.deltaChangeTextColor())
                        .minimumScaleFactor(0.2)
                        .lineLimit(1)

                    Text(context.state.bgUnitString)
                        .font(.title)
                        .foregroundStyle(.colorTertiary)
                        .minimumScaleFactor(0.2)
                        .lineLimit(1)
                }
            }
            .activityBackgroundTint(.black)
            .padding([.top, .bottom], 0)
            .padding([.leading, .trailing], 20)
        } else if context.state.liveActivityType == .normal {
            // 0 = normal size chart
            HStack(spacing: 30) {
                VStack(spacing: 0) {
                    Text("\(context.state.bgValueStringInUserChosenUnit())\(context.state.trendArrow())")
                        .font(.system(size: 44)).bold()
                        .foregroundStyle(context.state.bgTextColor())
                        .minimumScaleFactor(0.1)
                        .lineLimit(1)

                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text(context.state.deltaChangeStringInUserChosenUnit())
                            .font(.system(size: 20)).fontWeight(.semibold)
                            .foregroundStyle(context.state.deltaChangeTextColor())
                            .minimumScaleFactor(0.2)
                            .lineLimit(1)

                        Text(context.state.bgUnitString)
                            .font(.system(size: 20))
                            .foregroundStyle(.colorTertiary)
                            .minimumScaleFactor(0.2)
                            .lineLimit(1)
                    }
                }

                ZStack {
                    GlucoseChartView(glucoseChartType: .liveActivity, bgReadingValues: context.state.bgReadingValues, bgReadingDates: context.state.bgReadingDates, isMgDl: context.state.isMgDl, urgentLowLimitInMgDl: context.state.urgentLowLimitInMgDl, lowLimitInMgDl: context.state.lowLimitInMgDl, highLimitInMgDl: context.state.highLimitInMgDl, urgentHighLimitInMgDl: context.state.urgentHighLimitInMgDl, liveActivityType: .normal, hoursToShowScalingHours: 3, glucoseCircleDiameterScalingHours: nil, overrideChartHeight: nil, overrideChartWidth: nil, highContrast: nil)

                    if context.state.warnUserToOpenApp {
                        VStack(alignment: .center) {
                            Spacer()
                            Text("Open \(ConstantsHomeView.applicationName)")
                                .font(.footnote).bold()
                                .foregroundStyle(.black)
                                .multilineTextAlignment(.center)
                                .padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
                                .background(.cyan).opacity(0.9)
                                .cornerRadius(10)
                            Spacer()
                        }
                        .padding(8)
                    }
                }
            }
            .activityBackgroundTint(.black)
            .padding(.top, 10)
            .padding(.bottom, 10)
        } else {
            // 3 = large chart is final default option. lock screen
 
                ZStack {
                    GlucoseChartView(glucoseChartType: .liveActivity, bgReadingValues: context.state.bgReadingValues, bgReadingDates: context.state.bgReadingDates, isMgDl: context.state.isMgDl, urgentLowLimitInMgDl: context.state.urgentLowLimitInMgDl, lowLimitInMgDl: context.state.lowLimitInMgDl, highLimitInMgDl: context.state.highLimitInMgDl, urgentHighLimitInMgDl: context.state.urgentHighLimitInMgDl, liveActivityType: .large, hoursToShowScalingHours: 3, glucoseCircleDiameterScalingHours: nil, overrideChartHeight: nil, overrideChartWidth: nil, highContrast: nil, needFrame: false)
                        .frame(height: 140)
                        .overlay(alignment: .top) {
                            VStack(spacing: 0) {
                                HStack(alignment: .bottom) {
                                    if let lastDate = context.state.bgReadingDates.first {
                                        Text(lastDate, style: .timer)
                                            .font(.system(size: 24)).fontWeight(.bold)
                                            .foregroundStyle(.primary)
                                            .contentTransition(.numericText())
                                    }
                                    
                                    Spacer()
                                    
                                    Text(context.state.deltaChangeStringInUserChosenUnit())
                                        .font(.system(size: 28)).fontWeight(.semibold)
                                        .foregroundStyle(context.state.deltaChangeTextColor())
                                        .lineLimit(1)
                                        .contentTransition(.numericText())
                                    
                                    Group {
                                        Text(context.state.bgValueStringInUserChosenUnit())
                                            .contentTransition(.numericText(value: Double(context.state.bgValueStringInUserChosenUnit()) ?? 0))
                                        
                                        Text(context.state.trendArrow())
                                    }
                                    .font(.system(size: 32)).fontWeight(.bold)
                                    .foregroundStyle(context.state.bgTextColor())
                                    .scaledToFill()
                                    .minimumScaleFactor(0.5)
                                    .lineLimit(1)
                                }
                                .padding(EdgeInsets(top: 8, leading: 0, bottom: 2, trailing: 0))
                            }
                        }
                    if context.state.warnUserToOpenApp {
                        VStack(alignment: .center) {
                            Text("Please open \(ConstantsHomeView.applicationName)")
                                .font(.footnote).bold()
                                .foregroundStyle(.black)
                                .multilineTextAlignment(.center)
                                .padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
                                .background(.cyan).opacity(0.9)
                                .cornerRadius(10)
                        }
                    }
                    

                }
                .padding(.bottom, 8)
            .padding([.leading, .trailing], 15)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(0)
            .activityBackgroundTint(.black)
        }
    }
}

@available(iOS 18.0, *)
struct LiveActivityViewWithActivityFamily: View {
    @Environment(\.activityFamily) var activityFamily
    @State var context: ActivityViewContext<XDripWidgetAttributes>
    
    var body: some View {
        if #available(iOS 18.0, *) {
            switch activityFamily {
            case .small:
                LiveActivityViewContentActivityFamilies(context: context)
            case .medium:
                LiveActivityViewContent(context: context)
            @unknown default:
                LiveActivityViewContent(context: context)
            }
        }
    }
}

struct LiveActivityViewWithoutActivityFamily: View {
    @State var context: ActivityViewContext<XDripWidgetAttributes>
    
    var body: some View {
        LiveActivityViewContent(context: context)
    }
}
