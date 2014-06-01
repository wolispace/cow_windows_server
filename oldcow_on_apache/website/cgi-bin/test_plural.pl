my @plural_list = qw /wife|wives knife|knives life|lives studio|studios piano|pianos kangaroo|kangaroos zoo|zoos mouse|mice child|children foot|feet tooth|teeth person|people man|men woman|women/;
my $plural_same = ' grass fish sheep '; #these words dont change when pluraled..


&resolve_plural('knife',1);
&resolve_plural('knives',2);

&resolve_plural('knife',1);
&resolve_plural('knives',2);

&resolve_plural('buzz',1);
&resolve_plural('buzzes',2);

&resolve_plural('tomato',1);
&resolve_plural('tomatoes',2);

&resolve_plural('tomato',1);
&resolve_plural('tomatoes',2);

&resolve_plural('fish',1);
&resolve_plural('fish',2);

&resolve_plural('mouse',1);
&resolve_plural('mice',2);

&resolve_plural('cat',1);
&resolve_plural('cats',2);

&resolve_plural('box',1);
&resolve_plural('boxes',2);

sub resolve_plural{
	my $stxt = $_[0];
	my $tqty = $_[1];
	my $ptxt = '';
	if($tqty > 1){	# treat the singular as the plural and resolve tine singular from it in reverse..
		$ptxt = $stxt;
		$stxt = '';
	}		
	foreach my $p0 (@plural_list){
		my ($p1,$p2) = split(/\|/,$p0);
		if(($stxt eq $p1)||($stxt eq $p2)||($ptxt eq $p1)||($ptxt eq $p2)) {
			$stxt=$p1;
			$ptxt=$p2;
		}
	}
	if($ptxt eq ''){
		$ptxt = $stxt; 
		if($plural_same =~ / $ptxt /i){  print "no change"; # no change..
		}elsif($ptxt =~ /(fe|f)$/i){  $ptxt =~ s/(fe|f)$/ves/i;
		}elsif($ptxt =~ /o$/i){  $ptxt =~ s/o$/oes/i;
		}elsif($ptxt =~ /us$/i){  $ptxt =~ s/us$/i/i;
		}elsif($ptxt =~ /is$/i){  $ptxt =~ s/is$/es/i;
		}elsif($ptxt =~ /on$/i){  $ptxt =~ s/on$/a/i;
		}elsif($ptxt =~ /(z|s|x|ch|sh)$/i){  $ptxt =~ s/(z|s|x|ch|sh)$/$1es/i;
		}elsif($ptxt =~ /y$/i){  $ptxt =~ s/y$/ies/i;
		}else{
			$ptxt .= 's'; # resort to adding an 's'..
		}
	}else{
		if($stxt eq ''){
			$stxt = $ptxt; 
			if($plural_same =~ / $stxt /i){ print "no change"; # no change..
			}elsif($stxt =~ /ves$/i){  $stxt =~ s/ves$/f/i;	#end in F is more common so handle FE endings in @pliral_list
			}elsif($stxt =~ /oes$/i){  $stxt =~ s/oes$/o/i;
			}elsif($stxt =~ /i$/i){  $stxt =~ s/i$/us/i;
			}elsif($stxt =~ /a$/i){  $stxt =~ s/a$/on/i;
			}elsif($stxt =~ /es$/i){  $stxt =~ s/es//i;
			}elsif($stxt =~ /ies$/i){  $stxt =~ s/ies$/y/i;
			}else{
				$stxt =~ s/s$//i; # resort to taking off the s..
			}
		}
	}
	return ($stxt,$ptxt);
}
