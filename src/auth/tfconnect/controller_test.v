module tfconnect

import json
import time
import net.http
import vweb

struct TFConnectApp {
	vweb.Context
	vweb.Controller
}

pub fn (mut app TFConnectApp) index() vweb.Result {
	return app.ok('')
}

// todo: more testing
fn test_controller() ! {
	authenticator := new(app_id: 'test')!
	auth_controller := new_controller(
		tfconnect: authenticator
		success_url: '/user'
	)!

	mut app := &TFConnectApp{
		controllers: [
			vweb.controller('/auth', &auth_controller),
		]
	}
	spawn vweb.run(app, 8080)
	time.sleep(5000000000)
	response := http.get('http://127.0.0.1:8080/auth/login')!
	assert response.status_code == 200
}
