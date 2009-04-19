#!/usr/bin/perl6
use v6;
use IO::Prompt;

my $a;

#### Numericals ####

## Procedural style
$a = IO::Prompt.ask_num( "Defaults to 42?", 42 );
say $a.perl;

$a = IO::Prompt.ask_int( "No default?" );
say $a.perl;


#### Yes/No ####

## Procedural style
$a = IO::Prompt.ask_yn( "Defaults to false?", Bool::False );
say $a.perl;

$a = IO::Prompt.ask_yn( "Defaults to true?", Bool::True );
say $a.perl;

$a = IO::Prompt.ask_yn( "No default?" );
say $a.perl;

## OO style
my $prompt = IO::Prompt.new();
$a = $prompt.ask_yn( "OO style, defaults to false?", Bool::False );
say $a.perl;

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
