module main
import math
type Color = Vec3

@[inline]
fn linear_to_gamma(linear_component f64) f64{
	if linear_component > 0 {return math.sqrt(linear_component)}
	return 0
}

fn write_color(pixel_color Color) {
	mut r := pixel_color.x()
	mut g := pixel_color.y()
	mut b := pixel_color.z()
	
	r = linear_to_gamma(r)
	g = linear_to_gamma(g)
	b = linear_to_gamma(b)
	intensity := Interval.new(0.000, 0.999)
	
	rbyte := int(256 * intensity.clamp(r))
	gbyte := int(256 * intensity.clamp(g))
	bbyte := int(256 * intensity.clamp(b))
	
	print("${rbyte} ${gbyte} ${bbyte}\n")

}