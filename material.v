module main
import math
interface Material {
    scatter(r_in &Ray, rec &Hit_Record, mut attenuation Color, mut scattered Ray) bool
}

struct Lambertian implements Material {
    albedo Color
}

fn Lambertian.new(albedo Color) Lambertian{
    return Lambertian{albedo: albedo}
}

fn (l Lambertian) scatter(r_in &Ray, rec &Hit_Record, mut attenuation Color, mut scattered Ray) bool{
    mut scatter_direction := rec.normal + random_unit_vector()
    if scatter_direction.near_zero() {
        scatter_direction = rec.normal
    }
    scattered = Ray.new(rec.p, scatter_direction)
    attenuation = l.albedo
    return true
}

struct Metal implements Material {
    albedo Color
    fuzz f64
}

fn Metal.new(albedo Color, fuzz f64) Metal {
    return Metal{albedo: albedo, fuzz: if fuzz < 1 {fuzz} else {1}}
}

fn (m Metal) scatter(r_in &Ray, rec &Hit_Record, mut attenuation Color, mut scattered Ray) bool {
    mut reflected := r_in.direction().reflect(rec.normal)
    reflected = reflected.unit_vector() + random_unit_vector().scale(m.fuzz)
    scattered = Ray.new(rec.p, reflected)
    attenuation = m.albedo
    return true
}

struct Dielectric implements Material {
    refraction_index f64
}

fn Dielectric.new(refraction_index f64) Dielectric {
    return Dielectric{refraction_index: refraction_index}
}

fn (d Dielectric) scatter(r_in &Ray, rec &Hit_Record, mut attenuation Color, mut scattered Ray) bool {
    attenuation = Color.new(1.0,1.0,1.0)
    ri := if rec.front_face {1.0 / d.refraction_index } else {d.refraction_index}

    unit_direction := r_in.direction().unit_vector()
    cos_theta := math.min(unit_direction.negate().dot(rec.normal), 1.0)
    sin_theta := math.sqrt(1.0 - cos_theta*cos_theta)
    
    cannot_refract := ri * sin_theta > 1.0
    mut direction := Vec3{}
    if cannot_refract {
        direction = unit_direction.reflect(rec.normal)
    } else {
        direction = unit_direction.refract(rec.normal, ri)
    }

    scattered = Ray.new(rec.p, direction)
    return true

    
    /*
    unit_direction := r_in.direction().unit_vector()
    cos_theta := math.min(unit_direction.negate().dot(rec.normal), 1.0)
    sin_theta := math.sqrt(1.0 - cos_theta* cos_theta)
    
    cannot_refract := ri * sin_theta > 1.0
    mut direction := Vec3{}
    
    if cannot_refract{
        direction = unit_direction.reflect(rec.normal)
    }
    else { direction = unit_direction.refract( rec.normal, ri)}
    
    scattered = Ray.new(rec.p, direction)
    */
//    return true
}

fn Dielectric.reflectance(cosine f64, refraction_index f64) f64{
    mut r0 := (1.0 - refraction_index) / (1.0 + refraction_index)
    r0 = r0 * r0
    return r0 + (1-r0)*math.pow((1-cosine), 5)
}