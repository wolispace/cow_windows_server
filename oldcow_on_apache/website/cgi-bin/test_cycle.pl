$one='bong';
$this_cmd = "cycle \$one through (bing,bong,x ,bang)";

if($this_cmd =~ m/^cycle (\$\w+) (through|in|to|=|between) (.+)/i){
			print "[$1] [$2] [$3]\n---\n";
      my $op1 = $1;
      my @op2 = eval($3);
			my $op4 = eval($op1);
			my $tlen = scalar @op2; # get the number of items in this list..
			my $tptr = 0;
			while($tptr < $tlen){
				print "$tptr = $op2[$tptr] = $op4\n";
				if($op2[$tptr] eq $op4){
					$nptr=($tptr==$tlen) ? 0 : $tptr+1; # point at next one or point to start..
					$op3 = $op2[$nptr]; # get the next item in the list..
					print " -- $op3\n";
				}
				$tptr++;
			}
			$op3=$op2[0] if($op3 eq '');	# grab the first one if nothing defined..
      eval("$op1 = \"$op3\""); # create a new variable..
 } else {
	 print "[$this_cmd]\n";
 }

 print "one=$one\n\n";