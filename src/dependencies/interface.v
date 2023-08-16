module dependencies

pub interface IDependency {
	installed bool
	load() !
	install(string) !
	update() !
}
