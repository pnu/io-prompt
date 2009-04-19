class IO::Prompt;

method do_prompt ( Str $question? ) returns Str {
    return defined $question ?? prompt($question)
                             !! prompt('');
}

method do_say ( Str $output ) returns Bool {
    say $output;
    return Bool::True;
}

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

   return $result;
}

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
                { $result = +$response; }
            when ''
                { $result = $default; }
            default
                { $result = undef }
        }

        last if defined $result;
        last if not self.do_say( $.lang_prompt_num_retry );
    }
 
   return $result;
}

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
 
   return $result;
}
