#!/usr/bin/perl6
use v6;
use IO::Prompt;

## Functional style, exported method is "ask" ##
my $a;

$a = ask( 'No options?' );
say $a.perl;
say '------------------------------';

$a = ask( "Defaults to 42?", 42 );
say $a.perl;
say '------------------------------';

$a = ask( "Defaults to 42, type Num?", 42, :type(Num) );
say $a.perl;
say '------------------------------';

$a = ask( "Defaults to false?", Bool::False );
say $a.perl;
say '------------------------------';

$a = ask( "No default but type Bool?", :type(Bool) );
say $a.perl;
say '------------------------------';


## OO style ##
my $prompt = IO::Prompt.new();

$a = $prompt.do( "Dot notation?", Bool::False );
say $a.perl;
say '------------------------------';

# $a = do $prompt: "Indirect object notation?";
# say $a.perl;
# say '------------------------------';

## You can override the IO methods for testing purposes
class IO::Prompt::Testable is IO::Prompt {
    our Bool method do_say( Str $question ) {
        say "Testable saying    '$question'";
        say 'Please do not continue questioning';
        return Bool::False; # do not continue
    }
    our Str method do_prompt( Str $question ) {
        say "Testable saying    '$question'";
        say "Testable answering 'daa'";
        return 'daa';
    }
}

my $prompt_test = IO::Prompt::Testable.new();
$a = $prompt_test.ask_yn( "Testable, defaults to false?", Bool::False );
say $a.perl;
say '------------------------------';
