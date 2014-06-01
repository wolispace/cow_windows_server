# NOTE: Derived from blib\lib\Mail\Internet.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Mail::Internet;

#line 522 "blib\lib\Mail\Internet.pm (autosplit into blib\lib\auto/Mail\Internet/_prephdr.al)"
sub _prephdr {
    my $hdr = shift;

    $hdr->delete('From '); # Just in case :-)

    # An original message should not have any Received lines

    $hdr->delete('Received');

    $hdr->replace('X-Mailer', "Perl5 Mail::Internet v" . $Mail::Internet::VERSION);

    my $name = eval { (getpwuid($>))[6] } || $ENV{NAME} || "";

    while($name =~ s/\([^\(\)]*\)//) { 1; }

    if($name =~ /[^\w\s]/) {
	$name =~ s/"/\"/g;
	$name = '"' . $name . '"';
    }

    my $from = sprintf "%s <%s>", $name, mailaddress();
    $from =~ s/\s{2,}/ /g;

    my $tag;

    foreach $tag (qw(From Sender)) {
	$hdr->add($tag,$from)
	    unless($hdr->get($tag));
    }
}

# end of Mail::Internet::_prephdr
1;
