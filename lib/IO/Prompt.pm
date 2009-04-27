use v6;

class IO::Prompt {

## Exported functional frontend
##
sub ask ( Str $message, $default?, :$type ) is export {
    return IO::Prompt.ask($message,$default,:$type);
}
sub asker ( Str $message, $default?, :$type ) is export {
    return IO::Prompt.new( :$message, :$default, :$type );
}

## Private state for object calls. Populated by constructor.
##
has $!default;
has $!message;
has $!type;

## Method frontend to lowlevel type-specific methods
##
method ask ( Str $message=$!message,
                 $default=$!default,
                   :$type=$!type ) {

    my $r;

    given $type        {
      when .^isa('Bool') { $r = self.ask_yn(  $message, $default ); }
      when .^isa('Int')  { $r = self.ask_int( $message, $default ); }
      when .^isa('Num')  { $r = self.ask_num( $message, $default ); }
      when .^isa('Str')  { $r = self.ask_str( $message, $default ); }
      default            {
        given $default     {
          when .^isa('Bool') { $r = self.ask_yn(  $message, $default ); }
          when .^isa('Int')  { $r = self.ask_int( $message, $default ); }
          when .^isa('Num')  { $r = self.ask_num( $message, $default ); }
          when .^isa('Str')  { $r = self.ask_str( $message, $default ); }
          default            { $r = self.ask_str( $message, $default ); }
        } # given $default
      } # given $type default
    } # given $type

    return $r;
}

## The low-level IO methods. Override for testing etc.
##
method !do_prompt ( Str $question? ) returns Str {
    return defined $question ?? prompt($question)
                             !! prompt('');
}
## Return False, if there is no point to continue
##
method !do_say ( Str $output ) returns Bool {
    say $output;
    return Bool::True;
}

## Object evaluation in various contexts (type coersion)
##
method true {
    return self.ask( $!message, $!default, :type($!type // Bool) );
}
method Int {
    return self.ask( $!message, $!default, :type($!type // Int) );
}
method Num {
    return self.ask( $!message, $!default, :type($!type // Num) );
}
method Str {
    return self.ask( $!message, $!default, :type($!type // Str) );
}

## Boolean Yes/No 
##
my Str $.lang_prompt_Yn = 'Y/n';
my Str $.lang_prompt_yN = 'y/N';
my Str $.lang_prompt_yn = 'y/n';
my Str $.lang_prompt_yn_retry = 'Please enter yes or no';
my $.lang_prompt_match_y = m/ ^^ <[yY]> /;
my $.lang_prompt_match_n = m/ ^^ <[nN]> /;

method ask_yn (  Str $message=$!message,
                Bool $default=$!default ) returns Bool {

    my Bool $result;
    my  Str $prompt = ( $message ?? "$message " !! '' )
                    ~ '['
                    ~ ( defined $default ?? $default
                        ?? $.lang_prompt_Yn
                        !! $.lang_prompt_yN
                        !! $.lang_prompt_yn )
                    ~ ']'
                    ~ ' ';

    loop {
        my Str $response = self!do_prompt( $prompt );

        given $response {
            when $.lang_prompt_match_y { $result = Bool::True }
            when $.lang_prompt_match_n { $result = Bool::False }
            when ''                    { $result = $default }
            default                    { $result = undef }
        }
        last if defined $result;
        last if not self!do_say( $.lang_prompt_yn_retry );
    }

    return $result // Bool;
}

## Only Integers
##
my Str $.lang_prompt_int       = 'Int';
my Str $.lang_prompt_int_retry = 'Please enter a valid integer';

method ask_int ( Str $message=$!message,
                 Int $default=$!default ) returns Int {

    my Int $result;
    my Str $prompt = ( $message ?? "$message " !! '' )
                   ~ '['
                   ~ ( $default // $.lang_prompt_int )
                   ~ ']'
                   ~ ' ';

    loop {
        my Str $response = self!do_prompt( $prompt );

        given $response {
            when /^^ <Perl6::Grammar::integer> $$/
                { $result = int $response }
            when ''
                { $result = $default }
            default
                { $result = undef }
        }
        last if defined $result;
        last if not self!do_say( $.lang_prompt_int_retry );
    }
 
   return $result // Int;
}

## Numeric type, can hold integers, numbers and eventually rationals
##
my Str $.lang_prompt_num       = 'Num';
my Str $.lang_prompt_num_retry = 'Please enter a valid number';

method ask_num ( Str $message=$!message,
                 Num $default=$!default ) returns Num {

    my Num $result;
    my Str $prompt = ( $message ?? "$message " !! '' )
                   ~ '['
                   ~ ( $default // $.lang_prompt_num )
                   ~ ']'
                   ~ ' ';

    loop {
        my Str $response = self!do_prompt( $prompt );

        given $response {
            when /^^ <Perl6::Grammar::number> $$/
                { $result = +$response }
            when ''
                { $result = $default }
            default
                { $result = undef }
        }

        last if defined $result;
        last if not self!do_say( $.lang_prompt_num_retry );
    }
 
   return $result // Num;
}

## Str type, can hold anything that can be read from IO
## (not sure if this is true...?) This is the default.
##
my Str $.lang_prompt_str       = 'Str';
my Str $.lang_prompt_str_retry = 'Please enter a valid string';

method ask_str ( Str $message=$!message,
                 Str $default=$!default ) returns Str {

    my Str $result;
    my Str $prompt = ( $message ?? "$message " !! '' )
                   ~ '['
                   ~ ( $default // $.lang_prompt_str )
                   ~ ']'
                   ~ ' ';

    loop {
        my Str $response = self!do_prompt( $prompt );

        given $response {
            when ''
                { $result = $default }
            default
                { $result = ~$response }
        }

        last if defined $result;
        last if not self!do_say( $.lang_prompt_str_retry );
    }
 
   return $result // Str;
}

}

# vim: ft=perl6
