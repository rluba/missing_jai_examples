// A basic "Hello WASM World" program

main :: ()  {
    print("Hello Jai!\n");
    write_strings("These", " will", " cause", " multiple", " calls", " to" , " write_string_unsynchronized!\n");
    log("Hello logger");

    numbers: [..] int;
    array_add(*numbers, 10);
    array_add(*numbers, 20);
    array_add(*numbers, 30);

    for numbers {
        print("numbers[%]: %\n", it_index, it);
    }

    debug_break();

    builder: String_Builder;
    for 0..10 {
        append(*builder, sprint("Entry-%\n", it));
    }
    print("Builder result: \n%", builder_to_string(*builder));

    // Enable this if you want to see a nice stack trace:
    // assert(false, "Assert test");

    log("Type info test: The type of the builder is %", type_of(builder));
    info := type_info(type_of(builder));
    log("It contains the following members:");
    for info.members {
        log("%: % of type %", it_index, it.name, type_to_string(it.type));
    }

    // Lets try something fancier
    context.logger = dom_logger;
    log("Logging to the DOM via Jai.");
    log_error("We can also log errors.");
}

dom_logger :: (message: string, data: *void, info: Log_Info) {
    is_error := (info.common_flags & .ERROR) != 0;
    wasm_log_dom(message.count, message.data, is_error);
}


// We need to declare all the JS functions that will be passed to our WebAssembly
// instance from the JS file that loads us.
wasm_log_dom :: (count: s64, data: *u8, is_error: bool) #foreign;


#import "Basic";
