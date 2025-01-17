module main
import rand
import math

const infinity := math.inf(1)
const pi := 3.1415926535897932385

@[inline]
fn degrees_to_radians(degrees f64) f64 {
	return degrees * pi / 180.0
}

@[inline]
fn random_double() f64 {
	return 	rand.f64()
}

@[inline]
fn random_double_bounds(min f64, max f64) f64 {
	return min + (max-min) * random_double()
}