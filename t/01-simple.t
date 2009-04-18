use IO::Prompt;
use Test;

my @ask_yn_tests = (

#    question default       output        answer   expected
[    'da1?',  Bool::True,  'da1? [Y/n] ', 'yai',   Bool::True  ],
[    'da2?',  Bool::False, 'da2? [y/N] ', 'yai',   Bool::True  ],
[    'da3?',  undef,       'da3? [y/n] ', 'yai',   Bool::True  ],
[    'da4?',               'da4? [y/n] ', 'yai',   Bool::True  ],
[    'db1?',  Bool::True,  'db1? [Y/n] ', 'Y',     Bool::True  ],
[    'db2?',  Bool::False, 'db2? [y/N] ', 'Y',     Bool::True  ],
[    'db3?',  undef,       'db3? [y/n] ', 'Y',     Bool::True  ],
[    'db4?',               'db4? [y/n] ', 'Y',     Bool::True  ],

[    'da5?',  Bool::True,  'da5? [Y/n] ', 'nai',   Bool::False ],
[    'da6?',  Bool::False, 'da6? [y/N] ', 'nai',   Bool::False ],
[    'da7?',  undef,       'da7? [y/n] ', 'nai',   Bool::False ],
[    'da8?',               'da8? [y/n] ', 'nai',   Bool::False ],
[    'db5?',  Bool::True,  'db5? [Y/n] ', 'N',     Bool::False ],
[    'db6?',  Bool::False, 'db6? [y/N] ', 'N',     Bool::False ],
[    'db7?',  undef,       'db7? [y/n] ', 'N',     Bool::False ],
[    'db8?',               'db8? [y/n] ', 'N',     Bool::False ],

[    'da9?',  Bool::True,  'da9? [Y/n] ', '',      Bool::True  ],
[    'd10?',  Bool::False, 'd10? [y/N] ', '',      Bool::False ],

# should ask again with this prompt, when answer is bad
# or empty when there is no default specified
[    'qa9?',  undef,       'Please enter a valid response', '',      undef ],
[    'q10?',               'Please enter a valid response', '',      undef ],
[    'wa9?',  Bool::True,  'Please enter a valid response', 'Daa',   undef ],
[    'w10?',  Bool::False, 'Please enter a valid response', 'Daa',   undef ],
[    'wa9?',  undef,       'Please enter a valid response', 'Daa',   undef ],
[    'w10?',               'Please enter a valid response', 'Daa',   undef ],

);

plan 1 + @ask_yn_tests * 2;

my $prompt = IO::Prompt.new();
isa_ok( $prompt, 'IO::Prompt', 'create object' );

for @ask_yn_tests -> @row {
    my ($question, $default, $output, $answer, $expected);

    if @row == 5 {
        ($question, $default, $output, $answer, $expected) = @row;
    } elsif @row == 4 {
        ($question, $output, $answer, $expected) = @row;
    }

    my $prompter_input;
    $prompt.do_prompt = sub ( Str $q) {
        $prompter_input = $q;
        return $answer;
    };
    $prompt.do_say = sub ( Str $q) {
        $prompter_input = $q;
        return Bool::False;
    };

    if @row == 5 {
    is(
        $prompt.ask_yn( $question, $default ),
        $expected,
        "question '$question' default '$default' answer '$answer' :: expected '$expected'"
    );
    } elsif @row == 4 {
    is(
        $prompt.ask_yn( $question ),
        $expected,
        "question '$question' answer '$answer' :: expected '$expected'"
    );
    }
    is(
        $prompter_input,
        $output,
        "question '$question' default '$default' :: output '$output'"
    );
}
