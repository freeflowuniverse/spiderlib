module session

import db.sqlite
import log

// Creates and updates, authenticates email authentication sessions
[noinit]
struct DatabaseBackend {
mut:
	db     sqlite.DB
	logger &log.Logger = &log.Logger(&log.Log{
	level: .info
})
}

struct UserSessions {
	id int [primary]
	user_id string
	sessions []Session [fkey: 'fid']
}

struct Session {
	session_id string [primary]
	user_id string
	fid int
}

pub fn new_database_backend() !DatabaseBackend {
	db := sqlite.connect('session_authenticator.sqlite') or { panic(err) }

	sql db {
		create table UserSessions
		create table Session
	} or { panic(err) }

	return DatabaseBackend{
		db: db
	}
}

// add session id iadds the id of a session to the user's sessions
fn (mut backend DatabaseBackend) add_session(session Session) {
	sql backend.db {
		insert session into Session
	} or { panic('err:${err}') }
}

// add session adds the id of a session to the user's sessions
fn (mut backend DatabaseBackend) session_exists(session_id string) bool {
	sessions := sql backend.db {
		select from Session where session_id == session_id
	} or { panic('err:${err}') }
	if sessions.len > 1 { panic('this should never happen') }
	return sessions.len == 1
}

// add session id iadds the id of a session to the user's sessions
fn (mut backend DatabaseBackend) delete_session(session_id string) {
	sql backend.db {
		delete from Session where session_id == session_id
	} or { panic('err:${err}') }
}

// add session id iadds the id of a session to the user's sessions
fn (mut backend DatabaseBackend) add_user(user_id string) {
	user_sessions := UserSessions{
		user_id: user_id
		sessions: [Session {
			user_id: user_id
			session_id: 'gibberish'
			fid: 1
		}]
	} 
	sql backend.db {
		insert user_sessions into UserSessions
	} or { panic('err:${err}') }
}

// add session id iadds the id of a session to the user's sessions
fn (mut backend DatabaseBackend) user_exists(user_id string) bool {
	users := sql backend.db {
		select from UserSessions where user_id == user_id
	} or { panic('err:${err}') }
	if users.len > 1 { panic('this should never happen') }
	return users.len == 1
}