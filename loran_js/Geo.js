const Geodesic = require("geographiclib-geodesic").Geodesic;

class Geo {
  static Direct(pos, azimuth, distance) {
    return Geodesic.WGS84.Direct(pos.lat, pos.lon, azimuth, distance);
  }
  
  static Inverse(pos1, pos2) {
    return Geodesic.WGS84.Inverse(pos1.lat, pos1.lon, pos2.lat, pos2.lon);
  }
}

module.exports = Geo;