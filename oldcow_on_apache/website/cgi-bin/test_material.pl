$class = '';
  #$class =~ s/(\?|\||\.|\"|\'|\<|\>)//g; # dont allow these characters..
  #$material .= '_|_'.$class; # add the class on as a material..
	$material = &clean_material($class);

print "$material\n\n";

sub clean_material { # remove unwanted stuff and make delims orderly.. 
	$ret = $_[0];
	$ret =~ s/ (of|and|for|to|as|at|in|on) / /g; # remove anoying little words..
	$ret =~ s/(\-|\||\_|\?|\.|\"|\'|\>|\<)/ /g; # make sure all material words are seperated.
	$ret =~ s/  +/ /g; # remove anoying little words..
  $ret =~ s/^ //; # remove leading pipes
  $ret =~ s/ $//; # remove trailing pipes
  $ret =~ s/ /_\|_/g; # remove leading pipes
	
	$ret = '' if($ret eq '_|_');
	$ret = '_'.$ret.'_' if($ret ne '');
	return $ret;
}
