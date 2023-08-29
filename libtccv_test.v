module libtccv

import os

type MainFun = fn (int, &&char) int

const hello_world = 'int puts(char *); int main(int argc, char *argv[]) { return puts("Hello World!"); }'

fn vputs(cstr &char) int {
	unsafe { println('V puts ${cstring_to_vstring(cstr)}') }
	return -42
}

fn test_run() {
	mut tcc := new()
	tcc.set_output_type(.memory)
	tcc.add_symbol('puts', voidptr(vputs))
	tcc.compile_string(libtccv.hello_world)!
	assert tcc.run([]) == -42
}

fn test_reloacte() {
	mut tcc := new()
	tcc.set_output_type(.memory)
	tcc.compile_string(libtccv.hello_world)!
	tcc.relocate()!
	fun := MainFun(tcc.get_symbol('main')!)
	assert tcc.list_symbols()['main'] or { panic('failed') } == fun
	assert fun(os.args.len, v_to_cstringarray(os.args)) >= 0
	unsafe { tcc.free() }
}
