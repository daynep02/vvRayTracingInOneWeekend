module main



fn main() {
	mut world := Hittable_List{}
	
	material_ground := Lambertian.new(Color.new(0.8, 0.8, 0.0))
	material_center := Lambertian.new(Color.new(0.1, 0.2, 0.5))
	material_left := Dielectric.new(1.50)
	material_bubble := Dielectric.new(1.00 / 1.5)
	material_right := Metal.new(Color.new(0.8, 0.6, 0.2), 1.0)
	
	world.add(Sphere.new(Point3.new(0.0, -100.5, -1.0), 100.0, material_ground))
	world.add(Sphere.new(Point3.new(0.0, 0.0, -1.2), 0.5, material_center))
	world.add(Sphere.new(Point3.new(-1.0, 0.0, -1.0), 0.5, material_left))
	world.add(Sphere.new(Point3.new(-1.0, 0.0, -1.0), 0.4, material_bubble))
	world.add(Sphere.new(Point3.new(1.0, 0.0, -1.0), 0.5, material_right))


	mut cam := Camera{}

	cam.aspect_ratio = 16.0 / 9.0
	cam.image_width = 400
	
	cam.samples_per_pixel = 100
	cam.max_depth = 20
	cam.vfov = 20

	cam.lookfrom = Point3.new(-2, 2, 1)
	cam.lookat = Point3.new(0, 0, -1)
	cam.vup = Vec3.new(0, 1, 0)
	
	cam.defocus_angle = 10.0
	cam.focus_dist = 3.4

	cam.render(world)	
	
}
