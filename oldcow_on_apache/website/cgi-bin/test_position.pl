    
    $po = "this|that|those|them|these";
    
    $this_cmd = "\$pp = position of 'this' in \$po";
    
    #if($this_cmd =~ /(.+) (=|to) position of (.+) (in|from) (.+)/){          # {$position} = position of|at {string} in {delimitedstring} by {delimiter};
    if($this_cmd =~ /^(\$\w+) (to|=) position (at|of) (.+) (in|from) (.+)/){
    
      print "$1 - $2 - $3 - $4 - $5 - $6 \n";
	  }
	print "\nhmm $op1\n";
