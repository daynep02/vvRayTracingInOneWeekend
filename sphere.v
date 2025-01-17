module main
import math
struct Sphere implements Hittable{
	center Point3
	radius f64
	mat Material
}

fn Sphere.new(center Point3, radius f64, mat Material) Sphere {
	return Sphere{center: center, radius: radius, mat: &mat}
}
fn (s Sphere) hit(r Ray, ray_t Interval, mut rec Hit_Record) bool {
	oc := s.center - r.origin()
	a := r.direction().length_squared()
	h := r.direction().dot(oc)
	c := oc.length_squared() - s.radius*s.radius
	discriminant := h*h - a*c
	if discriminant < 0 { return false }

	sqrtd := math.sqrt(discriminant)	
	
	mut root := (h - sqrtd) / a
	if !ray_t.surrounds(root) {
		root = (h + sqrtd) / a
		if !ray_t.surrounds(root) {
			return false
		}
	}
	
	rec.t = root
	rec.p = r.at(rec.t)
	outward_normal := (rec.p - s.center).inverse_scale(s.radius)
	rec.set_face_normal(r, outward_normal)
	rec.mat = s.mat
	return true
}