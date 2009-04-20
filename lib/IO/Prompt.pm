use v6;

class IO::Prompt {

## The exported functional call interface.
##
sub ask ( Str $message, $default?, :$type ) is export {
    return IO::Prompt.do($message,$default,:$type);
}

## The low-level IO methods. Override for testing etc.
## (Should use CORE::prompt to be carefull? RAKUDO NIY.)
method do_prompt ( Str $question? ) returns Str {
    return defined $question ?? prompt($question)
                             !! prompt('');
}

method do_say ( Str $output ) returns Bool {
    say $output;
    return Bool::True;
}

## Method frontend to lowlevel type-specific methods
## Note: multi methods not appropriate here, since type
## can be specified by (a positional) parameter also,
## other rules under construction too..
##
method do ( Str $message, $default?, :$type ) {
    my $r;

    given $type {
    when .isa('Bool'){ $r = self.ask_yn(  $message, $default ); }
    when .isa('Int') { $r = self.ask_int( $message, $default ); }
    when .isa('Num') { $r = self.ask_num( $message, $default ); }
    when .isa('Str') { $r = self.ask_str( $message, $default ); }
    default          {
        given $default {
        when .isa('Bool'){ $r = self.ask_yn(  $message, $default ); }
        when .isa('Int') { $r = self.ask_int( $message, $default ); }
        when .isa('Num') { $r = self.ask_num( $message, $default ); }
        when .isa('Str') { $r = self.ask_str( $message, $default ); }
        default          { $r = self.ask_str( $message, $default ); }
    } } }

    return $r;
}

## Boolean Yes/No 
##
our Str $.lang_prompt_Yn = 'Y/n';
our Str $.lang_prompt_yN = 'y/N';
our Str $.lang_prompt_yn = 'y/n';
our Str $.lang_prompt_yn_retry = 'Please enter yes or no';
our $.lang_prompt_match_y = m/ ^^ <[yY]> /;
our $.lang_prompt_match_n = m/ ^^ <[nN]> /;

method ask_yn ( Str $message, Bool $default? ) returns Bool {
    my Str $q = defined $default
                ?? $default ?? $.lang_prompt_Yn
                            !! $.lang_prompt_yN
                !! $.lang_prompt_yn;

    my Bool $result;
    loop {
        my Str $response = self.do_prompt( "$message [$q] " );

        given $response {
            when $.lang_prompt_match_y { $result = Bool::True }
            when $.lang_prompt_match_n { $result = Bool::False }
            when ''                    { $result = $default }
            default                    { $result = undef }
        }
        last if defined $result;
        last if not self.do_say( $.lang_prompt_yn_retry );
    }

    return $result // Bool;
}

## Only Integers
##
our Str $.lang_prompt_int       = 'Int';
our Str $.lang_prompt_int_retry = 'Please enter a valid integer';

method ask_int ( Str $message, Int $default? ) returns Int {
    my Str $q = defined $default
                ?? ~$default
                !! $.lang_prompt_int;

    my Int $result;
    loop {
        my Str $response = self.do_prompt( "$message [$q] " );

        given $response {
            when /^^ <Perl6::Grammar::integer> $$/
                { $result = int $response }
            when ''
                { $result = $default }
            default
                { $result = undef }
        }
        last if defined $result;
        last if not self.do_say( $.lang_prompt_int_retry );
    }
 
   return $result // Int;
}

## Numeric type, can hold integers, numbers and eventually rationals
##
our Str $.lang_prompt_num       = 'Num';
our Str $.lang_prompt_num_retry = 'Please enter a valid number';

method ask_num ( Str $message, Num $default? ) returns Num {
    my Str $q = defined $default
                ?? ~$default
                !! $.lang_prompt_num;

    my Num $result;
    loop {
        my Str $response = self.do_prompt( "$message [$q] " );

        given $response {
            when /^^ <Perl6::Grammar::number> $$/
                { $result = +$response }
            when ''
                { $result = $default }
            default
                { $result = undef }
        }

        last if defined $result;
        last if not self.do_say( $.lang_prompt_num_retry );
    }
 
   return $result // Num;
}

## Str type, can hold anything that can be read from IO
## (not sure if this is true...?) This is the default.
##
our Str $.lang_prompt_str       = 'Str';
our Str $.lang_prompt_str_retry = 'Please enter a valid string';

method ask_str ( Str $message, Str $default? ) returns Str {
    my Str $q = defined $default
                ?? $default
                !! $.lang_prompt_str;

    my Str $result;
    loop {
        my Str $response = self.do_prompt( "$message [$q] " );

        given $response {
            when ''
                { $result = $default }
            default
                { $result = ~$response }
        }

        last if defined $result;
        last if not self.do_say( $.lang_prompt_str_retry );
    }
 
   return $result // Str;
}

}
