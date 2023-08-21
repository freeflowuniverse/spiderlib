module email

import db.sqlite
import log

// Creates and updates, authenticates email authentication sessions
[noinit]
struct DatabaseBackend {
mut:
	db sqlite.DB
	logger   &log.Logger = &log.Logger(&log.Log{
		level: .info
	})
}

// factory for 
pub fn new_database_backend() !DatabaseBackend {
	db := sqlite.connect('email_authenticator.db') or { panic(err) }

	sql db {
		create table AuthSession
	} or { panic(err) }

	return DatabaseBackend{
		db: db
	}
}

pub fn (auth DatabaseBackend) create_auth_session(session AuthSession) ! {
	sql auth.db {
		insert session into AuthSession
	} or {panic('err:${err}')}
}

pub fn (auth DatabaseBackend) read_auth_session(email string) ?AuthSession {
	session := sql auth.db {
		select from AuthSession where email == '${email}'
	} or {panic('err:${err}')}
	return session[0] or {return none}
}

pub fn (auth DatabaseBackend) update_auth_session(session AuthSession) ! {
	sql auth.db {
		update AuthSession set attempts_left = session.attempts_left where email == session.email
	} or {panic('err:${err}')}
}

pub fn (auth DatabaseBackend) delete_auth_session(email string) ! {
	sql auth.db {
		delete from AuthSession where email == '${email}'
	} or {panic('err:${err}')}
}


	// if session.attempts_left <= 0 { // checks if remaining attempts
	// 	return AttemptResult{
	// 		authenticated: false

	// 		attempts_left: 0
	// 		time_left: 
	// 	}
	// }

	// // authenticates if cypher in link matches authcode
	// if cypher == auth.sessions[email].auth_code {
	// 	auth.logger.debug(@FN + ':\nUser authenticated email: ${email}')
	// 	auth.sessions[email].authenticated = true
	// 	result := AttemptResult{
	// 		authenticated: true
	// 		attempts_left: auth.sessions[email].attempts_left
	// 	}
	// 	return result
	// } else {
	// 	auth.sessions[email].attempts_left -= 1
	// 	result := AttemptResult{
	// 		authenticated: false
	// 		attempts_left: auth.sessions[email].attempts_left
	// 	}
	// 	return result
	// }
