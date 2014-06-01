$c = 'HELLO WORLD? ';

$flag_loudly = 1 if ($c =~ /^([A-Z _!?]+)$/);
$c = lc($c) if($flag_loudly == 1);
print "$c $flag_loudly\n\n";

$flag_simply = 1 if ($c =~ s/(^simply|simply$)//i);
