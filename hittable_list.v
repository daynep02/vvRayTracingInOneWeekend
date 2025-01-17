module main
struct Hittable_List implements Hittable {
mut:
	objects []&Hittable
}

fn (h Hittable_List) hit(r Ray, ray_t Interval, mut rec Hit_Record) bool {
	mut temp_rec := Hit_Record{}
	mut hit_anything := false
	mut closest_so_far := ray_t.max
	
	for object in h.objects {
		if object.hit(r, Interval.new(ray_t.min, closest_so_far), mut temp_rec) {
			hit_anything = true
			closest_so_far = temp_rec.t
			rec = temp_rec
		}
	}
	return hit_anything
}

fn (mut h Hittable_List) add(object &Hittable) {
	h.objects << object
}

fn (mut h Hittable_List) clear() {
	h.objects = []&Hittable{}	
}

