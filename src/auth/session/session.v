module session

import freeflowuniverse.spiderlib.auth.jwt
import time
import log

// Authenticator deals and authenticates refresh and access tokens
pub struct Authenticator {
	refresh_secret string = jwt.create_secret() // secret used for signing/verifying refresh tokens
	access_secret  string = jwt.create_secret() // secret used for signing/verifying refresh tokens
mut:
	logger   &log.Logger
	sessions map[string][]string // maps uuid's to users refresh tokens
}

[params]
pub struct TokenParams {
pub:
	uuid     string [required]
	issuer   string [required]
	audience string
}

[params]
pub struct RefreshTokenParams {
	TokenParams
pub:
	expiration time.Time = time.now().add_days(7)
}

// secret := os.getenv('SECRET_KEY')

pub fn (mut auth Authenticator) new_refresh_token(params RefreshTokenParams) string {
	token := jwt.create_token(
		sub: params.uuid
		iss: params.issuer
		exp: params.expiration
	)
	signed_token := token.sign(auth.refresh_secret)

	// creates new entry if first issued refresh token
	// appends to entry if not.
	if params.uuid in auth.sessions {
		auth.sessions[params.uuid] << signed_token
	} else {
		auth.sessions[params.uuid] = [signed_token]
	}

	return signed_token
}

[params]
pub struct AccessTokenParams {
	expiration    time.Time = time.now().add(15 * time.minute)
	refresh_token jwt.SignedJWT [required]
}

pub fn (mut auth Authenticator) new_access_token(params AccessTokenParams) !string {
	if !auth.authenticate_refresh_token(params.refresh_token)! {
		auth.logger.info('Session authenticator: Failed to authenticate refresh token')
		return error('Refresh token not authenticated')
	}
	refresh_token := params.refresh_token.decode()!
	token := jwt.create_token(
		sub: refresh_token.sub
		iss: refresh_token.iss
		exp: params.expiration
	)
	signed_token := token.sign(auth.access_secret)
	return signed_token
}

fn (mut auth Authenticator) authenticate_refresh_token(token jwt.SignedJWT) !bool {
	if !token.verify(auth.refresh_secret)! {
		auth.logger.debug('Session authenticator: Failed to verify signature of refresh token')
		return false
	}
	decoded_token := token.decode() or {
		panic('Session authenticator: Failed to decode token:\n ${err}')
	}
	if decoded_token.is_expired() {
		auth.logger.debug('Session authenticator: Refresh token has expired')
		return false
	}
	if decoded_token.sub !in auth.sessions {
		auth.logger.debug('Session authenticator: Subject of refresh token not registered')
		return false
	}
	if token !in auth.sessions[decoded_token.sub] {
		auth.logger.debug('Session authenticator: Refresh token does not belong to subject')
		return false
	}
	return true
}

pub fn (mut auth Authenticator) authenticate_access_token(token jwt.SignedJWT) !bool {
	if !token.verify(auth.access_secret)! {
		auth.logger.info('Failed to verify access token')
		return false
	}
	return true
}

pub fn (mut auth Authenticator) revoke_refresh_token(token jwt.SignedJWT) ! {
	auth.authenticate_refresh_token(token)!
	auth.sessions.delete('${token.decode_subject()!}')
}
