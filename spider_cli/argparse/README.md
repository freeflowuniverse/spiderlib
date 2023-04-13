# ArgParse

A v implementation of the python command line parsing tool https://docs.python.org/3/library/argparse.html.
ArgParse is a parser that allows for easy parsing of command line arguments into v structs.

## Differences from ArgParse.py

- In this implementation of the ArgParse, the parser can either parse arguments into a Params struct, or into a generic type using reflection (see parser_reflection.v for implementation). This is different from ArgParse.py which places parsed arguments into a namespace.

Apart from these differences, the implementation of the parsers are quite similar. Thus, the ArgParse.py documentation can be a helpful resource where this document doesn't suffice.

## Getting started

One can create a parser, add arguments, and parse command line arguments the following way:

```
parser := ArgumentParser{
    program: 'example'
}

parser.add_argument(name: 'verbose', labels: [-v, --verbose], typ: bool)
parser.add_argument(name: 'command', typ: string, required: true)
parser.add_argument(name: 'path', typ: string, required: false, default: '.')

// sample cli input:
// example -v run ./example

println(parser.parse(os.args)!)

/* Output
Params{
    params: [
        Param{
            key: 'verbose'
            value: 'true'
        },
        Param{
            key: 'command'
            value: 'run'
        },
        Param{
            key: 'path'
            value: './example'
        }
    ]
}
*/

```

### Positional Arguments

The cli:positional attribute can be passed to struct fields to instruct the parser

```
struct Example

```

### Adding arguments

**Constraints**

- There can be at most one non-required positional argument per parser. If m

### Definitions

- Struct

- Argument label: arg_label refers to the label that represents an argument. In case of positional arguments, this label can be any value that matches the type of the positional argument, since positional arguments are not preceeded by a flag

### Order of arguments

By default, the order of arguments is determined by the order in which the arguments are added to the parser using the `add_argument()` method. However, the order of arguments may be adjusted before using the parser, as the parser calls the `arguments_fix()` method before any parsing action. This occurs exclusively in the following cases:

- A non-required positional argument preceeds a required positional argument:

If a positional argument is not required, it could be the case that the user inputting an array of arguments does not wish to provide an argument for a non-required positional argument.

If a non-required positional argument preceeds a required positional argument, the parser will have no knowledge on wether the argument passed was meant to fulfill the non-required positional argument or the required one.

Since positional arguments, as per their name, depend on the position of an argument along a list of arguments, this can be avoided by always expecting required positional arguments prior to non-required ones.

Positional arguments, as per their name, depend on the position of an argument along a list of arguments.
Therefore, this requires the parser to have knowledge on which position an argument is expected to occur in, which cannot be

- A required psiti
