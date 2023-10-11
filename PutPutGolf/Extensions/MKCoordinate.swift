//
//  MKCoordinate.swift
//  PutPutGolf
//
//  Created by Kevin Green on 10/9/23.
//

import MapKit

// https://stackoverflow.com/questions/14374030/center-coordinate-of-a-set-of-cllocationscoordinate2d

extension MKCoordinateRegion {
    
    /// Usage:  let region = MKCoordinateRegion(coordinates: coordinates)
    ///         region.center
    ///         region.span
    init(coordinates: [CLLocationCoordinate2D], spanDifference: (CLLocationDegrees, CLLocationDegrees) = (0,0)) {
        var minLatitude: CLLocationDegrees = 90.0
        var maxLatitude: CLLocationDegrees = -90.0
        var minLongitude: CLLocationDegrees = 180.0
        var maxLongitude: CLLocationDegrees = -180.0
        
        for coordinate in coordinates {
            let lat = Double(coordinate.latitude)
            let long = Double(coordinate.longitude)
            if lat < minLatitude {
                minLatitude = lat
            }
            if long < minLongitude {
                minLongitude = long
            }
            if lat > maxLatitude {
                maxLatitude = lat
            }
            if long > maxLongitude {
                maxLongitude = long
            }
        }
        
        
        let span = MKCoordinateSpan(
            latitudeDelta: maxLatitude - (minLatitude - spanDifference.0),
            longitudeDelta: maxLongitude - (minLongitude - spanDifference.0)
        )
        let center = CLLocationCoordinate2DMake(
            (maxLatitude - span.latitudeDelta / 2),
            (maxLongitude - span.longitudeDelta / 2)
        )
        self.init(center: center, span: span)
    }
}
