#version 3.7;
global_settings { assumed_gamma 1.0 }

camera {
  location <0, 2, -5>
  look_at <0, 1, 0>
}

light_source { <3, 5, -2> color rgb <1, 1, 1> }
light_source { <-4, 5, -3> color rgb <0.6, 0.7, 1.0> }

sphere {
  <0, 1, 0>, 1
  texture {
    pigment { color rgb <0.8, 0.2, 0.2> }
    finish  { specular 0.5 roughness 0.02 }
  }
}

plane {
  y, 0
  texture {
    pigment { color rgb <0.85, 0.85, 0.85> }
    finish { diffuse 0.9 }
  }
}
