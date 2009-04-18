class IO::Prompt;

has $.do_prompt is rw = sub ( Str $question? ) {
    return defined $question ?? prompt($question)
                             !! prompt('');
};

has $.do_say is rw = sub ( Str $output ) {
    say $output;
    return Bool::True;
};

method ask_yn ( Str $message, Bool $default? ) {

    my $q = defined $default
            ?? $default ?? '[Y/n]'
                        !! '[y/N]'
            !! '[y/n]';

    $q = $message ~ (defined $q ?? " $q " !! ' ');

    my $result;
    loop {
        my Str $response = defined $.do_prompt
            ?? &.do_prompt( $q )
            !!      prompt( $q );

        given lc $response {
            when m/ ^^ y / { $result = Bool::True }
            when m/ ^^ n / { $result = Bool::False }
            when ''        { $result = $default }
        }
        last if defined $result;

        my $reprompt = 'Please enter a valid response';
        my $said;
        if defined $.do_say {
            $said = &.do_say( $reprompt );
        } else {
            say $reprompt;
            $said = Bool::True;
        }
        last if not $said;
    }
 
   return $result;
}
