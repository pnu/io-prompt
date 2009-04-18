use IO::Prompt;
use Test;
plan 5;

my $prompt = IO::Prompt.new();

isa_ok( $prompt, 'IO::Prompt', 'create object' );

my @yesno_tests = (
   'daa?',	'yai',	undef,		Bool::True,
   'daa?',	'nai',	undef,		Bool::False,
   'daa?',	'',    	Bool::True,	Bool::True,
   'daa?',	'',	Bool::False,	Bool::False,
);

for @yesno_tests -> $question, $answer, $default, $result {

    $prompt.prompter = sub { return $answer; };
    is(
	$prompt.ask_yn( $question, $default ),
	$result,
	"question $question answer $answer default $default result $result"
    );

}
