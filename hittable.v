module main
struct Hit_Record {
pub mut:
	p Point3
	normal Vec3
	t f64
	front_face bool
	mat Material = Lambertian{Color.new(0, 0, 0)}
}

fn (mut h Hit_Record) set_face_normal(r Ray, outward_normal Vec3) {
	h.front_face = r.direction().dot(outward_normal) < 0
	h.normal = if h.front_face {outward_normal} else {outward_normal.negate()}
}


interface Hittable {
	hit(r Ray, ray_t Interval, mut rec Hit_Record) bool
}
