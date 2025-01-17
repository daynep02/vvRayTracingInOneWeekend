module main

struct Interval {
	min f64
	max f64

}
fn Interval.new(min f64, max f64) Interval {
	return Interval{min, max}
}

fn (i Interval) size() f64 {
	return i.max - i.min
}

fn (i Interval) contains(x f64) bool {
	return i.min <= x && x <= i.max
}

fn (i Interval) surrounds(x f64) bool {
	return i.min < x && x < i.max
}

fn (i Interval) clamp(x f64) f64{
	return if x < i.min {i.min} else if x > i.max {i.max} else {x}
}

const empty_interval := Interval.new(infinity, -infinity)
const universe_interval := Interval.new(-infinity, infinity)