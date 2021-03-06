### Define Subroutines
sub RunSQL {
	$sth = $dbh->prepare(@_);
	$sth->execute
	or die "SQL Error: $DBI::errstr\n";
}

sub PrintDateBox {
    if (@_ == '') {
	    print "<br><br>Date: <input type='text' name=date id='datepicker' autocomplete='off'/><br><br>";
    }
    else {
		print "<br><br>Review Date: <input type='text' name=reviewdate id='datepicker' autocomplete='off'/><br><br>";

    }
}

sub PrintFeedbackBoxes {
	$type = $_;
	print "$type: \n";
	foreach (1..8) {
		print "<input type='text' maxlength='3' size='2' name='$type$_'>";
	}
	print "<p>"
}

sub PrintSubmit {
	print "<br><br><br>";
	print submit ('action', "@_");
	print reset;
	print "</form>";
}

sub PrintSetterBox {
	print "<select name=\"@_\">\n
			<option value=\"Blank\"> </option>\n";
	RunSQL("SELECT `Name` FROM `Setter_Index`");
	while (@row = $sth->fetchrow_array) {
		foreach (@row) {
			$inactivesetter = m\#\;
			if (!$inactivesetter) {
				print "<option value=\"$_\">$_</option>\n";
			}
		}
	}
	print "</select>";
}

sub PrintDataAvailableBox {
    RunSQL("SELECT Date FROM `Feedback_Data` ORDER BY Date DESC LIMIT 1;");
    $newest_date = $sth->fetchrow_array;
    RunSQL("SELECT Date FROM `Feedback_Data` ORDER BY Date ASC LIMIT 1;");
    $oldest_date = $sth->fetchrow_array;

	$newest_date = DateMDY($newest_date);
	$oldest_date = DateMDY($oldest_date);

    print "Data available from <b>$oldest_date</b> to <b>$newest_date</b>.<br><br>";
}

sub PrintLengthOfReview {
    print "Length of Review:<br>";
    print '<input type="radio" name="duration" value="sixmonths"> 6 Months<br>';
    print '<input type="radio" name="duration" value="oneyear"> 1 Year<br>';
}

sub FeedbackAverage {
    my $total = 0;
    my $counter = 0;
    foreach (@_) {
        if ($_ ne "" and $_ ne "x") {
            $total = $total + $_;
            ++$counter;
        }
    }
    if ($counter) {
        return $total / $counter;
    }
}

sub PrintCalendarWidgit {
	print '<link rel="stylesheet" href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css" />
		<script src="http://code.jquery.com/jquery-1.9.1.js"></script>
		<script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
		<link rel="stylesheet" href="/resources/demos/style.css" />
		<script>
		$(function() {
		$( "#datepicker" ).datepicker();
		});
		$(function() {
		$( "#datepicker1" ).datepicker1();
		});
		</script>';
}

sub DateMDY {
	($year, $month, $day) = split '-', $_[0];
	return "$month/$day/$year";
}

1;
