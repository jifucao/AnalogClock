//
//  AnalogClockView.swift
//  AnalogClock
//
//  Created by Jifu Cao on 2023/4/27.
//

import Cocoa

struct AnalogClockConfiguration {
    static let `default` = AnalogClockConfiguration()
    let padding: CGFloat = 4.0
    let scale: CGSize = .init(width: 2, height: 8)
    
    let hourHandWidth: CGFloat = 4
    let minHandWidth: CGFloat = 3
    let secondHandWidth: CGFloat = 2
    
    let scaleColor: NSColor = .black
    let hourHandColor: NSColor = .black
    let minHandColor: NSColor = .black
    let secondHandColor: NSColor = .orange
    let backgroundColor: NSColor = .white
}

// MAK: -
private extension NSRect {
    func center() -> NSPoint {
        .init(x: origin.x + width / 2, y: origin.y + height / 2);
    }
}

// MAK: -
class AnalogClockView: NSView {
    
    let clock: AnalogClockConfiguration = .default
    
    var currentTime: Date = .now {
        didSet {
            needsDisplay = true
        }
    }
    
    var side: CGFloat {
        min(frame.size.width, frame.size.height)
    }
    
    var clockFrame: CGRect {
        frame.insetBy(dx: (frame.width - side) / 2 + clock.padding,
                      dy: (frame.height - side) / 2 + clock.padding)
    }
    
    private func drawClockScale() {
        clock.scaleColor.setFill()
        clock.scaleColor.setStroke()
        
        let path = NSBezierPath(ovalIn: clockFrame)
        path.lineWidth = 8
        path.stroke()
        let center = clockFrame.center()
        
        for i in 0..<60 {
            let handPath = NSBezierPath()
            var clockscaleSize = clock.scale
            
            if i % 5 == 0 {
                clockscaleSize = .init(width: clock.scale.width + 2, height: clock.scale.height + 2)
            }
            let clockScaleFrame = CGRect(x: -clockscaleSize.width/2,
                                         y: -clockscaleSize.height/2,
                                         width: clockscaleSize.width,
                                         height: clockscaleSize.height)
            handPath.appendRect(clockScaleFrame)
            var transform = AffineTransform(translationByX: center.x, byY: center.y)
            transform.rotate(byDegrees: CGFloat(i * 6))
            transform.translate(x: 0, y: side / 2 - clockscaleSize.height)
            handPath.transform(using: transform)
            handPath.fill()
        }
        
        for i in 1...12 {
            let str = NSAttributedString(string: "\(i)", attributes: [.font: NSFont.boldSystemFont(ofSize: 21)])
            let strSize = str.size()
            let y = (side - 50) / 2 * cos(.pi / 6 * CGFloat(i)) + center.y - strSize.height / 2
            let x = (side - 50) / 2 * sin(.pi / 6 * CGFloat(i) ) + center.x - strSize.width / 2
            str.draw(at: .init(x: x, y: y))
        }
    }
    
    private func drawClockHand() {
        func drawPath(backgroundColor: NSColor,
                      frame: CGRect,
                      center: NSPoint,
                      rotateDegress: CGFloat,
                      radius: CGFloat = 1) {
            
            let path = NSBezierPath(roundedRect: frame,
                                    xRadius: radius,
                                    yRadius: radius)
            var transform = AffineTransform(translationByX: center.x, byY: center.y)
            transform.rotate(byDegrees: rotateDegress)
            path.transform(using: transform)
            backgroundColor.setFill()
            path.fill()
        }
        
        let hour = Calendar.current.component(.hour, from: currentTime)
        let minute = Calendar.current.component(.minute, from: currentTime)
        let second = Calendar.current.component(.second, from: currentTime)
        
        let hourFrame =  CGRect(x: -clock.hourHandWidth/2,
                                y: -clock.scale.height - 4,
                                width: clock.hourHandWidth,
                                height: side * 0.45)
        
        let minFrame =  CGRect(x: -clock.minHandWidth/2,
                               y: -clock.scale.height - 4,
                               width: clock.minHandWidth,
                               height: side * 0.47)
        
        let secFrame =  CGRect(x: -clock.secondHandWidth/2,
                               y: -clock.scale.height - 4,
                               width: clock.secondHandWidth,
                               height: side * 0.49)
        
        drawPath(backgroundColor: clock.hourHandColor,
                 frame: hourFrame,
                 center: clockFrame.center(),
                 rotateDegress: (CGFloat(hour) / 12 * 360 + CGFloat(minute) / 60 * 30) * -1 )
        
        drawPath(backgroundColor: clock.minHandColor,
                 frame: minFrame,
                 center: clockFrame.center(),
                 rotateDegress: (CGFloat(minute) / 60 * 360 + CGFloat(second) / 60 * 6) * -1 )
        
        drawPath(backgroundColor: clock.secondHandColor,
                 frame: secFrame,
                 center: clockFrame.center(),
                 rotateDegress: (CGFloat(second) / 60 * 360) * -1 )
        
        let centerPointSide: CGFloat = 8
        drawPath(backgroundColor: clock.hourHandColor,
                 frame: .init(x: -centerPointSide / 2,
                              y: -centerPointSide / 2,
                              width: centerPointSide,
                              height: centerPointSide),
                 center: clockFrame.center(),
                 rotateDegress: 0,
                 radius: centerPointSide / 2)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        clock.backgroundColor.setFill()
        dirtyRect.fill()
        drawClockScale()
        drawClockHand()
    }
}
