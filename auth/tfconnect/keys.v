module tfconnect

// Generate new kyes for application server and set it into environment variables.
import os
import libsodium
import encoding.base64
import term

pub struct Keypair {
	public_key string [required]
	private_key string [required]
}

fn create_keypair() Keypair {
	sk_key := []u8{len: 32}
	pk_key := []u8{len: 32}
	_ := libsodium.crypto_sign_keypair(pk_key.data, sk_key.data)

	encoded_pk := base64.encode(pk_key)
	encoded_sk := base64.encode(sk_key)
	
	return Keypair {
		public_key: encoded_pk
		private_key: encoded_sk
	}
}

fn write_keys() ! {
	keypair := create_keypair()
	encoded_pk, encoded_sk := keypair.public_key, keypair.private_key

	mut file_path := os.args_after('.')
	if file_path.len <= 1 {
		println(term.red('You have to pass the path that you want to create the file in when you run create_keys file'))
		println(term.yellow('e.g.'))
		println(term.green('v run create_keys ../'))
		return
	}
	println(os.abs_path(file_path[1]))
	os.create(os.abs_path('${file_path[1]}/keys.toml'))!
	os.write_file('${file_path[1]}/keys.toml', '[server]\nSERVER_PUBLIC_KEY="${encoded_pk}"\nSERVER_SECRET_KEY="${encoded_sk}"')!
	println('Public, Private keys generated at ${file_path[1]}')
}
