# Script setup

## Install bundler

`gem bundler install`
`bundle install`
## Execution
`bundle exec ruby parser.rb`
## Options
For the purpose of easier script interaction i have implemented micro-optparse to  bring unix like options to the script usage. The options help can be invoked by calling:
`bundle exec ruby parser.rb -h` 
They include:

    -i, --input webserver.log               input file name
    -n, --input-format log                  input file format
    -o, --output undefined                  optional output file (instead of STDOUT)
    -u, --output-format log                 output file format
    -p  --processor Processors::DefaultProcessor,   select processor
    -s, --[no-]silent                       do not log into STDOUT
    -f, --[no-]fail-fast                    exit at first input error?
    -h, --help                              Show this message
    -v, --version                           Print version
There are defaults set to use `webserver.log` included in the repo and STDOUT logging.
As an example to log to a file we can run `bundle exec ruby parser.rb --output=output.log`

**Currently unused**

    --input-format
    --output-format
    --processor
Those are being unused due to time constraints but here to show the logic and intention behind the structure of the script and files/classes/modules. As in a fully modular OO implementation.

## Comments
1. I exceeded the intended 2.5hours by a margin of 1-1.5h (realised a bit late and was to deep to simplify the solution at that point)
2. The script doesn't take into consideration memory optimisation (and is as such quite memory hungry if executed on extra large files)
3. The Csv loggers/parsers were intended to be implemented but due to time constraints i did not finish them. I decided to leave them be to show the logic behind the approach and class/module separation.

