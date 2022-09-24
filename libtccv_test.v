module libtccv

import os

type MainFun = fn (int, &&char) int

fn test_run() {
	mut tcc := new()
	tcc.set_output_type(.memory)
	tcc.compile_string('#include<stdio.h> int main(int argc, char *argv[]) { printf("Hello World!"); return 0; }') or {
		panic(err)
	}
	tcc.relocate() or { panic(err) }
	// Print exit code of the C function
	fun := MainFun(tcc.get_symbol('main') or { panic(err) })
	println(os.args)
	assert fun(os.args.len, v_to_cstringarray(os.args)) == 0
}
