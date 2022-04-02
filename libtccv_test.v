module libtccv

type MainFun = fn (int, &&char) int

fn test_run() {
	mut tcc := new()
	tcc.set_output_type(.memory)
	tcc.compile_string('#include<stdio.h> int main2(int argc, char *argv[]) { printf("Hello World!"); return 0; }') or {
		panic(err)
	}
	tcc.relocate() or { panic(err) }
	// Print exit code of the C function
	fun := MainFun(tcc.get_symbol('main2') or { panic(err) })
	assert fun(0, &&char(voidptr(0))) == 0
}
