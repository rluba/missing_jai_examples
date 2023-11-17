#program_export
hello_from_jai :: (s: string, number: int) -> string #c_call {
    ctx: Context;
    push_context ctx {
        log("Hello from jai. The number was %, the string was \"%\".", number, s);
        log("And the type of s is %. The type of context is %.", type_of(s), type_of(context));
        return "Stuff we return from Jai";
    }
}

Our_Jai_Struct :: struct {
    s: string;
    value: int;
}

#program_export
more_hello_from_jai :: (x: *Our_Jai_Struct) -> string #c_call {
    ctx: Context;
    push_context ctx {
        return sprint("You gave us: \"%\" and %", x.s, x.value);
    }
}

#import "Basic";
