module main
import os
import math	
struct Camera {
mut:
	image_height int
	center Point3
	pixel00_loc Point3
	pixel_delta_u Vec3
	pixel_delta_v Vec3
	pixel_samples_scale f64
	u Vec3
	v Vec3
	w Vec3
	defocus_disk_u Vec3
	defocus_disk_v Vec3
pub mut:
	aspect_ratio f64 = 1.0
	image_width int = 100
	samples_per_pixel int = 10
	max_depth int = 10
	vfov f64 = 90.0
	lookfrom Point3 = Point3.new(0,0,0)
	lookat Point3 = Point3.new(0, 0, -1)
	vup Vec3 = Vec3.new(0, 1, 0)

	defocus_angle f64 = 0.0
	focus_dist f64 = 10	
}

fn (mut c Camera) initialize() {
	c.image_height = int(c.image_width / c.aspect_ratio)
	c.image_height = if c.image_height < 1 {1} else {c.image_height}

	c.center = c.lookfrom

	theta := degrees_to_radians(c.vfov)
	h := math.tan(theta/2)

	viewport_height := 2* h * c.focus_dist
	viewport_width := viewport_height * (f64(c.image_width) / f64(c.image_height))
	
	c.w = (c.lookfrom - c.lookat).unit_vector()
	c.u = c.vup.cross(c.w)
	c.v = c.w.cross(c.u)

	viewport_u := c.u.scale(viewport_width)
	viewport_v := c.v.negate().scale(viewport_height)

	c.pixel_delta_u = viewport_u.inverse_scale( c.image_width)
	c.pixel_delta_v = viewport_v.inverse_scale(c.image_height)
	
	viewport_upper_left := c.center - c.w.scale(c.focus_dist) - viewport_u.inverse_scale(2) - viewport_v.inverse_scale(2) 
	c.pixel00_loc = viewport_upper_left + (c.pixel_delta_u + c.pixel_delta_v).scale(0.5)
	c.pixel_samples_scale = 1.0 / f64(c.samples_per_pixel)
	
	defocus_radius := c.focus_dist * math.tan(degrees_to_radians(c.defocus_angle / 2.0))
	c.defocus_disk_u = c.u.scale(defocus_radius)	
	c.defocus_disk_v = c.v.scale(defocus_radius)	
}

fn (c Camera) ray_color(r Ray, depth int, world &Hittable) Color{
	if depth <= 0 { return Color.new(0,0,0)}
	mut rec := Hit_Record{}
	
	if world.hit(r, Interval.new(0.001, infinity), mut rec) {
		mut scattered := Ray{}
		mut attenuation := Color{}
		if rec.mat.scatter(r, rec, mut attenuation, mut scattered) {
			return attenuation * c.ray_color(scattered, depth-1, world)
		}
	}
	
	unit_direction := r.direction().unit_vector()
	
	a := 0.5*unit_direction.y() + 1.0
	return Color.new(1.0, 1.0, 1.0).scale(1.0-a) + Color.new(0.5, 0.7, 1.0).scale(a)
}

fn (mut c Camera) render(world &Hittable) {
	c.initialize()
	mut stderr := os.stderr()

	print("P3\n${c.image_width} ${c.image_height}\n255\n")

	for j in 0..c.image_height{
		stderr.write_string("\rScanline remaining: ${c.image_height - j} ") 
		or {}
		for i in 0..c.image_width {
			mut pixel_color := Color.new(0,0,0)
			for _ in 0..c.samples_per_pixel{
				r := c.get_ray(i, j)
				pixel_color = pixel_color + c.ray_color(r, c.max_depth, world)
			}
			write_color(pixel_color.scale(c.pixel_samples_scale))
		}
	}
	stderr.write_string("\r\nDone 				")
	or{}
}

fn (c Camera) get_ray(i int, j int) Ray{
	offset := c.sample_square()
	pixel_sample := c.pixel00_loc + c.pixel_delta_u.scale(i + offset.x()) + c.pixel_delta_v.scale(j + offset.y())
	
	ray_origin := if c.defocus_angle <= 0 {c.center} else {c.defocus_disk_sample()}
	ray_direction := pixel_sample - ray_origin
	return  Ray.new(ray_origin, ray_direction)
}

fn (c Camera) sample_square() Vec3{
	return Vec3.new(random_double() - 0.5, random_double() - 0.5, 0)
}

fn (c Camera) defocus_disk_sample() Point3{
	p := random_in_unit_disk()
	return c.center + c.defocus_disk_u.scale(p.x()) + c.defocus_disk_v.scale(p.y())
}