module libtccv

const (
	lib_paths     = ['/usr/local/lib/x8664-linux-gnu', '/lib/x8664-linux-gnu',
		'/usr/lib/x8664-linux-gnu', '/usr/lib/x8664-linux-gnu64', '/usr/local/lib64', '/lib64',
		'/usr/lib64', '/usr/local/lib', '/lib', '/usr/lib', '/usr/x8664-linux-gnu/lib64',
		'/usr/x8664-linux-gnu/lib', '/home/gesusc/v', '/usr/local/lib/tcc']
	include_paths = ['/usr/lib/gcc/x86_64-linux-gnu/11/include', '/usr/local/include',
		'/usr/include/x86_64-linux-gnu', '/usr/include']
)

type MainFun = fn (int, &&char) int

fn test_run() {
	mut tcc := new()
	tcc.set_output_type(.memory)
	// Only for tcc
	$if tinyc {
		for dir in lib_paths {
			tcc.add_library_path(dir)
		}
	}
	// For both
	for dir in include_paths {
		tcc.add_sysinclude_path(dir)
	}
	tcc.compile_string('#include<stdio.h> int main2(int argc, char *argv[]) { printf("Hello World!"); return 0; }') or {
		panic(err)
	}
	tcc.relocate() or { panic(err) }
	// Print exit code of the C function
	fun := MainFun(tcc.get_symbol('main2') or { panic(err) })
	assert fun(0, &&char(voidptr(0))) == 0
}
