// This is an example of how to compile Jai code into a library for iOS.
// After compiling this file, you can open the accompanying Xcode project
// and compile it to see the result.
//
// CAREFUL: Jai currently does not implement the iOS ARM calling convention correctly!
// So passing structs by value between Jai and native code is broken in most cases!
// Only pass structs by pointer across the language boundary until we’ve fixed this.
//  -rluba, 2023-11-15


#run {
    set_build_options_dc(.{do_output = false});

    w := compiler_create_workspace("iOS library");

    options := get_build_options(w);
    copy_commonly_propagated_fields(get_build_options(), *options);

    options.output_type                       = .STATIC_LIBRARY;
    options.output_executable_name            = "jai_ios_library";
    options.backend                           = .LLVM;
    options.os_target                         = .IOS;
    options.cpu_target                        = .ARM64;
    options.backtrace_on_crash                = .OFF; // Runtime_Support_Crash_Handler doesn’t support iOS (yet?)

    set_build_options(options, w);

    // We will use the "generate_c_header" module to auto-generate a C header file for the library.
    // You can then include this file in your iOS project.
    header_info: Generate.Header_Info;
    header_info.prefix_enum_values = true;

    compiler_begin_intercept(w);

    add_build_file("library.jai", w);

    success := true;
    while true {
        message := compiler_wait_for_message();
        assert(message.workspace == w);

        Generate.handle_message(*header_info, message);

        if message.kind == .COMPLETE {
            complete := cast(*Message_Complete) message;
            if complete.error_code != .NONE {
                success = false;
            }
            break;
        }
    }

    compiler_end_intercept(w);

    if !success return;

    success = Generate.generate_header(*header_info, tprint("%/jai_exports.h", #filepath));
    if !success {
        compiler_report("Couldn’t generate C header file");
        return;
    }
}

#import "Basic";
#import "Compiler";

Generate :: #import "generate_c_header";
