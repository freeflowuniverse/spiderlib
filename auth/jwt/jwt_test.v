module jwt

import crypto.hmac
import crypto.sha256
import crypto.bcrypt
import encoding.base64
import json
import rand
import vweb.sse { SSEMessage }
import time
import net.smtp
import crypto.rand as crypto_rand
import os
import freeflowuniverse.spiderlib.publisher2 { Publisher, User, Email, Access }
import vweb

// creates user jwt cookie, enables session keeping
fn test_make_token() {
	

	token := make_token(User{name: 'timur'})
	panic('yok: $token')
}
