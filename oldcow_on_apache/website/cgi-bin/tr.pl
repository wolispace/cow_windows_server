#!/usr/bin/perl




sub get_url { # returns a web page from the passed URL..
  use IO::Socket;
  my ($host,$document) = split('/',$_[0],2);
  my $remote = IO::Socket::INET->new(Proto=>"tcp",PeerAddr=>$host,PeerPort=>"http(80)");
  if($remote){
    $remote->autoflush(1);
    print $remote ("GET /$document HTTP/1.0\nHost: $host\nUser-Agent: Mozilla\015\012\015\012");
    my @lines = <$remote>;
    close $remote;
    my $c=0;
    shift @lines while($c++ < 5);
    my $ret = join(' ',@lines);
    $ret =~ s/=(.?)\//=$1http\:\/\/$host\//ig; #"'
    #$ret =~ s/<(|\/)html>//ig; #"'
    #$ret =~ s/<(|\/)body>//ig; #"'
		$ret =~ s/\&lt\;/\</ig;
		$ret =~ s/\&gt\;/\>/ig;
		$ret =~ s/rdf\:/ /ig;

    return $ret;
  }
}
