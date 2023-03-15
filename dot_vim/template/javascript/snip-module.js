// http://qiita.com/kaiinui/items/22a75d2adc56a40da7b7
(function(global) {
	"use strict";

	// var isBrowser = "document" in global;
	// var isWebWorkers = "WorkerLocation" in global;
	// var isNode = "process" in global;

	if ("process" in global) {
		module.exports = {{_var_:module_name}};
	}
	global["{{_var_:module_name}}"] = {{_var_:module_name}};
})((this || 0).self || global);

{{_define_:module_name:input("Molude Name: ", "{{_name_}}")}}
