module testmodule

struct TestStruct {
	name    string
	aliases []string
}

struct TestModel {
	test_structs []TestStruct = [
		TestStruct{
			name: 'timur'
			aliases: ['timmy, timbo']
		},
	]
}

// this is not a method of the model so shouldn't be in api
pub fn get_aliases0(name string) []string {
	testlist := [TestStruct{
		name: 'timur'
		aliases: ['timmy, timbo']
	}]
	target := testlist.map(it.name == 'timur')
	return target[0].aliases
}

// this is private so shouldn't be in api
fn get_aliases1(name string) []string {
	testlist := [TestStruct{
		name: 'timur'
		aliases: ['timmy, timbo']
	}]
	target := testlist.map(it.name == 'timur')
	return target[0].aliases
}

// this shouldn't be in api since it's a private method of model
fn (model TestModel) get_aliases2(name string) []string {
	testlist := [TestStruct{
		name: 'timur'
		aliases: ['timmy, timbo']
	}]
	target := testlist.map(it.name == 'timur')
	return target[0].aliases
}

// this should be in api since it's a public method of model
// this should be a get endpoint since it doesn't mutate model
pub fn (model TestModel) get_aliases3(name string) []string {
	target := model.test_structs.map(it.name == 'timur')
	return target[0].aliases
}

// this should be in api since it's a public method of model
// this should be a post endpoint since it mutates model
pub fn (mut model TestModel) add_alias(name string, alias string) []string {
	target := model.test_structs.map(it.name == 'timur')
	target[0].aliases << alias
	return target[0].aliases
}
