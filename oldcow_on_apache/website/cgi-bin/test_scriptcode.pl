
$val="##think: runsub hmmm;

##hmmm:
  $this is something;
  '[\$this] blah';
  set $actor's loc to a;
  call 'hmmm';
  if a = b then
";

print "$val\n----\n";


      foreach my $bit (split(/\#\#/,$val)){
        my ($blk,$rst) = split(/\:/,$bit,2);
        $val =~ s/'($blk)'/'$1'/ig;
      }


$script_blockwords='(set|msg)';

my @script = split(/\n/,$val);
$val = '';

foreach my $sline (@script){
	if ($sline =~ /^\s*$script_blockwords/i){
		# ignore this..
	}else{
		$val .= $sline."\n";
	}
}

print $val;
