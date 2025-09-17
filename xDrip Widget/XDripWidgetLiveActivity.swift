//
//  XDripWidgetLiveActivity.swift
//  XDripWidget
//
//  Created by Paul Plant on 29/12/23.
//  Copyright © 2023 Johan Degraeve. All rights reserved.
//

import ActivityKit
import SwiftUI
import WidgetKit

struct XDripWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: XDripWidgetAttributes.self) { context in
            LiveActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) { Text("\(context.state.bgValueStringInUserChosenUnit())\(context.state.trendArrow())")
                    .font(.largeTitle).bold()
                    .foregroundStyle(context.state.bgTextColor())
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .minimumScaleFactor(0.1)
                    .lineLimit(1)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text(context.state.deltaChangeStringInUserChosenUnit())
                            .font(.title).fontWeight(.semibold)
                            .foregroundStyle(context.state.deltaChangeTextColor())
                            .minimumScaleFactor(0.2)
                            .lineLimit(1)

                        Text(context.state.bgUnitString)
                            .font(.title)
                            .foregroundStyle(.colorSecondary)
                            .minimumScaleFactor(0.2)
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    GlucoseChartView(glucoseChartType: .dynamicIsland, bgReadingValues: context.state.bgReadingValues, bgReadingDates: context.state.bgReadingDates, isMgDl: context.state.isMgDl, urgentLowLimitInMgDl: context.state.urgentLowLimitInMgDl, lowLimitInMgDl: context.state.lowLimitInMgDl, highLimitInMgDl: context.state.highLimitInMgDl, urgentHighLimitInMgDl: context.state.urgentHighLimitInMgDl, liveActivityType: nil, hoursToShowScalingHours: nil, glucoseCircleDiameterScalingHours: nil, overrideChartHeight: nil, overrideChartWidth: nil, highContrast: nil)
                }
            } compactLeading: {
                Text("\(context.state.bgValueStringInUserChosenUnit())\(context.state.trendArrow())")
                    .foregroundStyle(context.state.bgTextColor())
                    .minimumScaleFactor(0.1)
            } compactTrailing: {
                Text(context.state.deltaChangeStringInUserChosenUnit())
                    .foregroundStyle(context.state.deltaChangeTextColor())
                    .minimumScaleFactor(0.1)
            } minimal: {
                Text("\(context.state.bgValueStringInUserChosenUnit())")
                    .foregroundStyle(context.state.bgTextColor())
                    .minimumScaleFactor(0.1)
            }
            .widgetURL(URL(string: "xdripswift"))
            .keylineTint(context.state.bgTextColor())
        }
        .supplementalActivityFamilies([.small])
    }
}


struct XDripWidgetLiveActivity_Previews: PreviewProvider {
    // generate some random dates for the preview
    static func bgDateArray() -> [Date] {
        let endDate = Date(timeIntervalSinceNow: -300)
        let startDate = endDate.addingTimeInterval(-3600 * 12)
        var currentDate = startDate

        var dateArray: [Date] = []

        while currentDate < endDate {
            dateArray.append(currentDate)
            currentDate = currentDate.addingTimeInterval(60 * 5)
        }
        return dateArray
    }

    // generate some random bg values for the preview
    static func bgValueArray() -> [Double] {
        var bgValueArray: [Double] = Array(repeating: 0, count: 144)
        var currentValue: Double = 100
        var increaseValues = true

        for index in bgValueArray.indices {
            let randomValue = Double(Int.random(in: -10 ..< 10))

            if currentValue < 80 {
                increaseValues = true
                bgValueArray[index] = currentValue + abs(randomValue)
            } else if currentValue > 160 {
                increaseValues = false
                bgValueArray[index] = currentValue - abs(randomValue)
            } else {
                bgValueArray[index] = currentValue + (increaseValues ? randomValue : -randomValue)
            }
            currentValue = bgValueArray[index]
        }
        return bgValueArray
    }

    static let attributes = XDripWidgetAttributes()

    static let contentState = XDripWidgetAttributes.ContentState(bgReadingValues: bgValueArray(), bgReadingDates: bgDateArray(), isMgDl: true, slopeOrdinal: 5, deltaValueInUserUnit: -2, urgentLowLimitInMgDl: 70, lowLimitInMgDl: 80, highLimitInMgDl: 140, urgentHighLimitInMgDl: 180, liveActivityType: .large, dataSourceDescription: "Dexcom G6", deviceStatusCreatedAt: nil, deviceStatusLastLoopDate: nil)

    static var previews: some View {
        attributes
            .previewContext(contentState, viewKind: .content)
            .previewDisplayName("Notification")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Compact")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Expanded")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal")
    }
}
