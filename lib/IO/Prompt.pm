class IO::Prompt;

our Str method do_prompt ( Str $question? ) {
    return defined $question ?? prompt($question)
                             !! prompt('');
}

our Bool method do_say ( Str $output ) {
    say $output;
    return Bool::True;
}

our $.lang_prompt_Yn = ' [Y/n] ';
our $.lang_prompt_yN = ' [y/N] ';
our $.lang_prompt_yn = ' [y/n] ';
our $.lang_prompt_match_y = m/ ^^ <[yY]> /;
our $.lang_prompt_match_n = m/ ^^ <[nN]> /;
our $.lang_prompt_retry = 'Please enter a valid response';

method ask_yn ( Str $message, Bool $default? ) {
    my $q = defined $default
            ?? $default ?? $.lang_prompt_Yn
                        !! $.lang_prompt_yN
            !! $.lang_prompt_yn;

    my $result;
    loop {
        my Str $response = self.do_prompt( $message ~ $q );

        given $response {
            when $.lang_prompt_match_y { $result = Bool::True }
            when $.lang_prompt_match_n { $result = Bool::False }
            when ''                    { $result = $default }
        }
        last if defined $result;
        last if not self.do_say( $.lang_prompt_retry );
    }
 
   return $result;
}
