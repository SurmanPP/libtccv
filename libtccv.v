module libtccv

#flag -ltcc -dl
#include "libtcc.h"

[typedef]
pub struct C.TCCState {
}

type ErrorFun = fn (voidptr, &char)

// create a new TCC compilation context //
fn C.tcc_new() &C.TCCState

// TCCState *tcc_new(void);

// free a TCC compilation context //
fn C.tcc_delete(&C.TCCState)

// void tcc_delete(TCCState *s);

// set CONFIG_TCCDIR at runtime //
fn C.tcc_set_lib_path(state &C.TCCState, const_path &char)

// void tcc_set_lib_path(TCCState *s, const char *path);

// set error/warning display callback
fn C.tcc_set_error_func(&C.TCCState, voidptr, ErrorFun)

// void tcc_set_error_func(TCCState *s, void *error_opaque, TCCErrorFunc error_func);

// return error/warning callback
fn C.tcc_get_error_func(&C.TCCState) ErrorFun

// TCCErrorFunc tcc_get_error_func(TCCState *s);

// return error/warning callback opaque pointer
fn C.tcc_get_error_opaque(&C.TCCState) voidptr

// void *tcc_get_error_opaque(TCCState *s);

// set options as from command line (multiple supported) //
fn C.tcc_set_options(state &C.TCCState, const_str &char)

// void tcc_set_options(TCCState *s, const char *str);

// add include path
fn C.tcc_add_include_path(state &C.TCCState, const_pathname &char) int

// int tcc_add_include_path(TCCState *s, const char *pathname);

// add in system include path
fn C.tcc_add_sysinclude_path(state &C.TCCState, const_pathname &char) int

// int tcc_add_sysinclude_path(TCCState *s, const char *pathname);

// define preprocessor symbol 'sym'. Can put optional value
fn C.tcc_define_symbol(state &C.TCCState, const_sym &char, const_value &char)

// void tcc_define_symbol(TCCState *s, const char *sym, const char *value);

// undefine preprocess symbol 'sym'
fn C.tcc_undefine_symbol(state &C.TCCState, const_sym &char)

// void tcc_undefine_symbol(TCCState *s, const char *sym);

// add a file (C file, dll, object, library, ld script). Return -1 if error.
fn C.tcc_add_file(state &C.TCCState, const_filename &char) int

// int tcc_add_file(TCCState *s, const char *filename);

// compile a string containing a C source. Return -1 if error.
fn C.tcc_compile_string(state &C.TCCState, const_buf &char) int

// int tcc_compile_string(TCCState *s, const char *buf);

// set output type. MUST BE CALLED before any compilation
fn C.tcc_set_output_type(&C.TCCState, int) int

// int tcc_set_output_type(TCCState *s, int output_type);
// 1 output will be run in memory (default)
// 2 executable file
// 3 dynamic library
// 4 object file
// 5 only preprocess (used internally)

// equivalent to -Lpath option
fn C.tcc_add_library_path(state &C.TCCState, const_pathname &char) int

// int tcc_add_library_path(TCCState *s, const char *pathname);

// the library name is the same as the argument of the '-l' option
fn C.tcc_add_library(state &C.TCCState, const_libraryname &char) int

// int tcc_add_library(TCCState *s, const char *libraryname);

// add a symbol to the compiled program
fn C.tcc_add_symbol(state &C.TCCState, const_name &char, const_val voidptr) int

// int tcc_add_symbol(TCCState *s, const char *name, const void *val);

// output an executable, library or object file. DO NOT call tcc_relocate() before.
fn C.tcc_output_file(state &C.TCCState, const_filename &char) int

// int tcc_output_file(TCCState *s, const char *filename);

// link and run main() function and return its value. DO NOT call tcc_relocate() before.
fn C.tcc_run(&C.TCCState, int, &&char) int

// int tcc_run(TCCState *s, int argc, char **argv);

// do all relocations (needed before using tcc_get_symbol())
fn C.tcc_relocate(&C.TCCState, voidptr) int

// int tcc_relocate(TCCState *s1, void *ptr);
/*
possible values for 'ptr':
   - voidptr(1)		: Allocate and manage memory internally
   - none			: return required memory size for the step below
   - memory address	: copy code to memory passed by the caller
   returns -1 if error.*/

// return symbol value or NULL if not found
fn C.tcc_get_symbol(state &C.TCCState, const_name &char) voidptr

// void *tcc_get_symbol(TCCState *s, const char *name);

// return symbol value or NULL if not found
fn C.tcc_list_symbols(&C.TCCState, voidptr, fn (voidptr, &char, voidptr))

pub enum OutputType {
	memory = 1
	executable = 2
	dynamic = 3
	object = 4
	preprocess = 5
}

pub fn new() &C.TCCState {
	return C.tcc_new()
}

[unsafe]
pub fn (state &C.TCCState) free() {
	C.tcc_delete(state)
}

pub fn (state &C.TCCState) set_lib_path(path string) {
	C.tcc_set_lib_path(state, &char(path.str))
}

pub fn (state &C.TCCState) set_error_function(opaque voidptr, fun ErrorFun) {
	C.tcc_set_error_func(state, opaque, fun)
}

pub fn (state &C.TCCState) get_error_function() ErrorFun {
	return C.tcc_get_error_func(state)
}

pub fn (state &C.TCCState) get_error_opaque() voidptr {
	return C.tcc_get_error_opaque(state)
}

pub fn (state &C.TCCState) set_options(option string) {
	C.tcc_set_options(state, &char(option.str))
}

pub fn (state &C.TCCState) add_include_path(path string) {
	C.tcc_add_include_path(state, &char(path.str))
}

pub fn (state &C.TCCState) add_sysinclude_path(pathname string) {
	C.tcc_add_sysinclude_path(state, &char(pathname.str))
}

pub fn (state &C.TCCState) define_symbol(sym string, value string) {
	C.tcc_define_symbol(state, &char(sym.str), &char(value.str))
}

pub fn (state &C.TCCState) undefine_symbol(sym string) {
	C.tcc_undefine_symbol(state, &char(sym.str))
}

pub fn (state &C.TCCState) add_file(filename string) ? {
	if C.tcc_add_file(state, &char(filename.str)) != 0 {
		return error('Error adding file')
	}
}

pub fn (state &C.TCCState) compile_string(buffer string) ? {
	if C.tcc_compile_string(state, &char(buffer.str)) != 0 {
		return error('Error compiling string')
	}
}

pub fn (state &C.TCCState) set_output_type(output_type OutputType) {
	C.tcc_set_output_type(state, int(output_type))
}

pub fn (state &C.TCCState) add_library_path(pathname string) {
	C.tcc_add_library(state, &char(pathname.str))
}

pub fn (state &C.TCCState) add_library(name string) ? {
	if C.tcc_add_library(state, &char(name.str)) != 0 {
		return error('Error adding library $name')
	}
}

pub fn (state &C.TCCState) add_symbol(name string, val voidptr) {
	C.tcc_add_symbol(state, &char(name.str), val)
}

pub fn (state &C.TCCState) output_file(name string) ? {
	if C.tcc_output_file(state, &char(name.str)) != 0 {
		return error('Error setting output file to $name')
	}
}

[deprecated: 'Does not work! Use get_symbol() instead']
pub fn (state &C.TCCState) run(argv []string) int {
	mut argvc := []&char{cap: argv.len}
	for arg in argv {
		argvc << &char(arg.str)
	}
	return C.tcc_run(state, argv.len, argvc.data)
}

pub fn (state &C.TCCState) relocate() ? {
	if C.tcc_relocate(state, voidptr(1)) != 0 {
		println(C.tcc_relocate(state, voidptr(1)))
		return error('Error relocating automatically')
	}
}

pub fn (state &C.TCCState) get_relocation_size() {
	C.tcc_relocate(state, voidptr(0))
}

pub fn (state &C.TCCState) relocate_to_address(address voidptr) ? {
	if C.tcc_relocate(state, address) != 0 {
		return error('Error relocating to adress')
	}
}

pub fn (state &C.TCCState) get_symbol(name string) ?voidptr {
	symbol := C.tcc_get_symbol(state, &char(name.str))
	if symbol == voidptr(0) {
		return error('Error getting symbol')
	}
	return symbol
}

type VoidMap = &map[string]voidptr

pub fn (state &C.TCCState) list_symbols() map[string]voidptr {
	mut ret := &map[string]voidptr{}
	C.tcc_list_symbols(state, voidptr(ret), fn (ctx voidptr, name &char, val voidptr) {
		mut ret := VoidMap(ctx)
		unsafe {
			ret[cstring_to_vstring(name)] = val
		}
	})
	return *ret
}

[inline]
pub fn v_to_cstringarray(arr []string) &&char {
	mut carr := []&char{cap: arr.len}
	for entry in arr {
		carr << &char(entry.str)
	}
	return &&char(carr.data)
}
