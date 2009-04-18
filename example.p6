#!/usr/bin/perl6
use v6;
use IO::Prompt;

my $a;

## OO style
my $prompt = IO::Prompt.new();
$a = $prompt.ask_yn( "Defaults to false?", Bool::False );
say $a.perl;

## You can define the sub that will do the prompting
$prompt.do_say = sub (Str $q) {
    say "Saying '$q'";
    return Bool::False;
};
$a = $prompt.ask_yn( "Defaults to false?", Bool::False );
say $a.perl;

## You can define the sub that will do the prompting
$prompt.do_prompt = sub (Str $q) {
    say "Prompting '$q', answer is 'yai'";
    return "yai"
};
$a = $prompt.ask_yn( "Defaults to false?", Bool::False );
say $a.perl;

## Procedural style
$a = IO::Prompt.ask_yn( "Defaults to false?", Bool::False );
say $a.perl;

$a = IO::Prompt.ask_yn( "Defaults to true?", Bool::True );
say $a.perl;

$a = IO::Prompt.ask_yn( "No default?" );
say $a.perl;
