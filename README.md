# libtccv
A friendly libtcc wrapper for V

Based on https://github.com/peregrine-lang/vlibtcc

Example usage:
```V
module main
import libtccv

// Won't work without
const (
  // Extracted from gcc using: gcc -print-search-dirs | sed '/^lib/b 1;d;:1;s,/[^/.][^/]*/\.\./,/,;t 1;s,:[^=]*=,:;,;s,;,;  ,g' | tr \; \\012 | tr : \\012
  lib_paths     = ['/usr/local/lib/x8664-linux-gnu', '/lib/x8664-linux-gnu','/usr/lib/x8664-linux-gnu', '/usr/lib/x8664-linux-gnu64', '/usr/local/lib64', '/lib64', '/usr/lib64', '/usr/local/lib', '/lib', '/usr/lib', '/usr/x8664-linux-gnu/lib64', '/usr/x8664-linux-gnu/lib']
  // Extracted from gcc using: cc -xc /dev/null -E -Wp,-v 2>&1 | sed -n 's,^ ,,p'
  include_paths = ['/usr/lib/gcc/x86_64-linux-gnu/11/include', '/usr/local/include', '/usr/include/x86_64-linux-gnu', '/usr/include']
)


fn main() {
	mut tcc := libtccv.new()
	tcc.set_output_type(.memory)
	// Make it find the libs when compiling with tcc
	for dir in lib_paths {
		tcc.add_library_path(dir)
	}
	// Make it find the include paths for both
	for dir in include_paths {
		tcc.add_sysinclude_path(dir)
	}
	tcc.compile_string('#include<stdio.h> int main2(int argc, char *argv[]) { printf("Hello World!"); return 0; }') or {
		panic(err)
	}
	tcc.relocate() or { 
    panic(err) 
  }
	// Print exit code of the C function
	fun := MainFun(tcc.get_symbol('main2') or { panic(err) })
	fun(0, libtccv.v_to_cstringarray([]))
}
```
It only works when the compiler used for compilation is in the system path and uses system resources(/usr/lib).
