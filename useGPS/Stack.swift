//
//  Stack.swift
//  useGPS
//
//  Created by Daichi Yoshikawa on 2020/09/14.
//  Copyright © 2020 Daichi Yoshikawa. All rights reserved.
//

import Foundation
import MapKit

//MKPointAnnotationのためのスタッククラス
class StackPin {
  var stackArray = [MKPointAnnotation]()
    //pushメソッド
    func push(pinPush: MKPointAnnotation){
      self.stackArray.append(pinPush)
    }
    
    
    //popメソッド
    func pop() -> MKPointAnnotation? {
      if self.stackArray.last != nil {
        var Return = self.stackArray.last
        self.stackArray.removeLast()
        return Return!
      } else {
        return nil
      }
    }
}

//MKPolygonのためのスタッククラス
class StackPoly {
  var stackArray = [MKPolygon]()
    //pushメソッド
    func push(polyPush: MKPolygon){
      self.stackArray.append(polyPush)
    }
    
    
    //popメソッド
    func pop() -> MKPolygon? {
      if self.stackArray.last != nil {
        var Return = self.stackArray.last
        self.stackArray.removeLast()
        return Return!
      } else {
        return nil
      }
    }
}
