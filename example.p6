#!/usr/bin/perl6
use v6;
use IO::Prompt;

my $a;

## OO style
my $prompt = IO::Prompt.new();
$a = $prompt.ask_yn( "Defaults to false?", Bool::False );
say $a.perl;

## You can define the sub that will do the prompting
$prompt.prompter = sub{ return "yai" };
$a = $prompt.ask_yn( "Defaults to false?", Bool::False );
say $a.perl;

## Procedural style
$a = IO::Prompt.ask_yn( "Defaults to false?", Bool::False );
say $a.perl;

$a = IO::Prompt.ask_yn( "Defaults to true?", Bool::True );
say $a.perl;

$a = IO::Prompt.ask_yn( "No default?" );
say $a.perl;
