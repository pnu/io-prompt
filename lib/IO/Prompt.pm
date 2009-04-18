class IO::Prompt;

has $.prompter is rw = sub ( $question? ) {
        return defined $question ?? prompt($question)
                                 !! prompt('');
};

method ask_yn ( Str $message, Bool $default? ) {

    my $q = defined $default
            ?? $default ?? '[Y/n]'
                        !! '[N/y]'
            !! '[y/n]';

    $q = $message ~ (defined $q ?? " $q " !! ' ');

    my $result;
    loop {
        my Str $response = defined $.prompter
            ?? &.prompter( $q )
            !!     prompt( $q );

        given lc $response {
            when m/ ^^ y / { $result = Bool::True }
            when m/ ^^ n / { $result = Bool::False }
            when ''        { $result = $default }
        }
        last if defined $result;

        say "Please enter a valid response yes/Yes/no/No/..";
    }
 
   return $result;
}
