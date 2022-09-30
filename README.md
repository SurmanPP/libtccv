# libtccv
A friendly libtcc wrapper for V

Based on https://github.com/peregrine-lang/vlibtcc

Example usage:
```V
module main
import libtccv

type MainFun = fn (int, &&char) int

fn main() {
	mut tcc := libtccv.new()
	tcc.set_output_type(.memory)
	tcc.compile_string('#include<stdio.h>
			    int main2(int argc, char *argv[]) {
				printf("Hello World!");
				return 0;
			    }') or {
		panic(err)
	}
	tcc.relocate() or { 
		panic(err) 
  	}
	fun := MainFun(tcc.get_symbol('main2') or { panic(err) })
	fun(0, libtccv.v_to_cstringarray([]))
}
```
It only works when the compiler used for compilation is in the system path and uses system resources(/usr/lib).

Example:
v -cc gcc
or
v -cc /usr/bin/tcc
V's tcc does not work *shrug*
