module main

pub fn (mut app App) controller_get_user(user_id string) ?User {
	rlock app.users {
		if user_id in app.users {
			return app.users[user_id]
		} else {
			return none
		}
	}
	return none
}
