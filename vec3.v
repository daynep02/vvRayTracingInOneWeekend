module main
import math

struct Vec3 {
	e [3]f64 = [3]f64{} 
}

fn Vec3.new_clean() Vec3 { 
	return Vec3{
		e: [3]f64{}
	}
}

fn Vec3.new(e0 f64, e1 f64, e2 f64) Vec3 {
	mut e := [3]f64{}
	e[0] = e0
	e[1] = e1
	e[2] = e2 
	return Vec3{e: e}
}

fn (v Vec3) x() f64	{ return v.e[0]}
fn (v Vec3) y() f64 { return v.e[1]}
fn (v Vec3) z() f64 { return v.e[2]}


fn (v Vec3) negate() Vec3{
	return Vec3.new(-v.x(), -v.y(), -v.z())
}

@[inline]
fn (v Vec3) -(v2 Vec3) Vec3{
	return Vec3.new(v.x() - v2.x(), v.y() - v2.y(), v.z() - v2.z())
}

@[inline]
fn (v Vec3) +(v2 Vec3) Vec3{
	return Vec3.new(v.x() + v2.x(), v.y() + v2.y(), v.z() + v2.z())
}

@[inline]
fn (v Vec3) *(v2 Vec3) Vec3{
	return Vec3.new(v.x() * v2.x(), v.y() * v2.y(), v.z() * v2.z())
}

@[inline]
fn (v Vec3) /(v2 Vec3) Vec3{
	return Vec3.new(v.x() / v2.x(), v.y() / v2.y(), v.z() / v2.z())
}

fn (v Vec3) length() f64 {
	return math.sqrt(v.length_squared())	
}

fn (v Vec3) length_squared() f64 {
	return v.x() * v.x() + v.y() * v.y() + v.z() * v.z()
}

type Point3 = Vec3

@[inline]
fn (v Vec3) scale(t f64) Vec3{
	return Vec3.new(v.x() *t, v.y() *t, v.z() *t)
}

@[inline]
fn (v Vec3) inverse_scale(t f64) Vec3{
	return v.scale(1.0 / t)
}

@[inline]
fn (u Vec3) dot(v Vec3) f64 {
	return u.x() * v.x() + u.y() * v.y() + u.z() * v.z()
} 

@[inline]
fn (u Vec3) cross(v Vec3) Vec3 {
	return Vec3.new(u.y() * v.z() - u.z() * v.y(), u.z() * v.x() - u.x() * v.z(), u.x() * v.y() - u.y() * v.x())
}

@[inline]
fn (v Vec3) unit_vector() Vec3{
	return v.inverse_scale(v.length())
}

@[inline]
fn Vec3.random() Vec3{
	return Vec3.new(random_double(), random_double(), random_double())
}

@[inline]
fn Vec3.random_bound(min f64, max f64) Vec3{
	return Vec3.new(random_double_bounds(min, max),random_double_bounds(min, max),random_double_bounds(min, max))
}

@[inline]
fn random_unit_vector() Vec3 {
	for {
		p := Vec3.random_bound(-1, 1)
		lensq := p.length_squared()
		if 1e-160 < lensq && lensq <= 1 { return p.inverse_scale(math.sqrt(lensq))}
	} 
	return Vec3{}
}

@[inline]
fn Vec3.random_on_hemisphere(normal Vec3) Vec3{
	on_unit_sphere := random_unit_vector()
	if on_unit_sphere.dot(normal) > 0.0 {
		return on_unit_sphere
	} else {
		return on_unit_sphere.negate()
	}
}

fn (v Vec3) near_zero() bool{
	s := 1e-8
	return math.abs(v.x()) < 0 && math.abs(v.y()) < s && math.abs(v.z()) < s
}

@[inline]
fn (v Vec3) reflect(n &Vec3)  Vec3{
	return v - n.scale(2*v.dot(n))
}

@[inline]
fn (v Vec3) refract(n Vec3, etai_over_etat f64) Vec3 {
	cos_theta := math.min(v.negate().dot(n), 1.0)
	r_out_perp := (v + n.scale(cos_theta)).scale(etai_over_etat)
	r_out_parallel := n.scale(-math.sqrt(math.abs(1.0 - r_out_perp.length_squared())))
	return r_out_perp + r_out_parallel
}

@[inline]
fn random_in_unit_disk() Vec3{
	for {
		p := Vec3.new(random_double_bounds(-1, 1), random_double_bounds(-1, 1), 0)
		if p.length_squared() < 1 { return p }
	}
	
	return Vec3{}
}