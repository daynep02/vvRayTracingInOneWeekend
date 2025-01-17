module main



fn main() {
	mut world := Hittable_List{}
	
	ground_material := Lambertian.new(Color.new(0.5, 0.5, 0.5))
	world.add(Sphere.new(Point3.new(0, -1000, 0), 1000, ground_material))
	
	for a in -11..11 {
		for b in -11..11 {
			choose_mat := random_double()
			center := Point3.new(a + 0.9*random_double(), 0.2, b + 0.9*random_double())
			
			if (center - Point3.new(4, 0.2, 0)).length() > 0.9 {
				if choose_mat < 0.8 {
					albedo := Color.random() * Color.random()
					sphere_material := Lambertian.new(albedo)
					world.add(Sphere.new(center, 0.2, sphere_material))
				}
				else if choose_mat < 0.95 {
					albedo := Color.random_bound(0.5, 1)
					fuzz := random_double_bounds(0, 0.5)
					sphere_material := Metal.new(albedo, fuzz)
					world.add(Sphere.new(center, 0.2, sphere_material))
				} else {
					sphere_material := Dielectric.new(1.5)
					world.add(Sphere.new(center, 0.2, sphere_material))
				}
			}
		}
	}
	
	material1 := Dielectric.new(1.5)
	world.add(Sphere.new(Point3.new(0, 1, 0), 1.0, material1))

	material2 := Lambertian.new(Color.new(0.4, 0.2, 0.1))
	world.add(Sphere.new(Point3.new(-4, 1, 0), 1.0, material2))
	
	material3 := Metal.new(Color.new(0.7, 0.6, 0.5), 0.0)
	world.add(Sphere.new(Point3.new(4,1,0), 1.0, material3))

	mut cam := Camera{}

	cam.aspect_ratio = 16.0 / 9.0
	cam.image_width = 1200
	
	cam.samples_per_pixel = 10
	cam.max_depth = 10
	cam.vfov = 20

	cam.lookfrom = Point3.new(13, 2, 3)
	cam.lookat = Point3.new(0, 0,0)
	cam.vup = Vec3.new(0,1,0)
	
	cam.defocus_angle = 0.6
	cam.focus_dist = 10.0

	cam.render(world)	
	
}
