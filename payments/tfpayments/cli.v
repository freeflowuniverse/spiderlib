module main

import freeflowuniverse.spiderlib.api { FunctionCall, FunctionResponse } 
import os

struct PaymentCLI {
	call chan FunctionCall
	resp chan FunctionResponse
}

fn new_cli(call chan FunctionCall, resp chan FunctionResponse) {
	return PaymentCLI{
		call: call
		resp: resp
	}
}

fn (cli PaymentCLI) run() {
	for {
		command := os.input('>')
	}
}

fn (cli PaymentCLI) add_host() {
	
}
