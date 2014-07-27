use strict;

use Getopt::Long;
use Data::Dump;

package BashCompleter;

our @program_options = ();
sub _complete_options {
	for my $option (@program_options) {
		print "$option ";
	}

	return 1;
}
our %program_actions = ( '__options' => \&_complete_options );

# Register completion for options
# complete_options o1, o2, ..., action
sub complete_options {
	my @options = ();

	my $last_arg = '';
	my $action = '';
	while (1) {
		my $arg = shift;
		if ($arg) {
			push(@options, $last_arg) if $last_arg =~ m/(-.+)/;
			$last_arg = $arg;
		} else {
			$action = $last_arg;
			last;
		}
	}
	die "No options defined for completion." unless scalar(@options) > 0;
	die "No action defined for completing options $options[0], ..." unless $action;

	# Register the options
	for my $option (@options) {
		$program_actions{$option} = $action;
	}
	push(@program_options, @options);
}

sub complete_actions {
	my $action = shift || die "No routine to complete actions.";

	$program_actions{'__actions'} = $action;
}

sub collect_options {
	die "No options to collect" unless scalar(@_) > 0;

	foreach my $option (@_) {
		$program_actions{$option} = \&_complete_options;
	}
	push(@program_options, @_);
}

sub complete {
	my $context = '';
	my $stream = '';
	my @program_args = @ARGV;
	my $parseResult = Getopt::Long::GetOptionsFromArray \@program_args, ("__complete=s" => \$context, "__stream=s" => \$stream);

	if ($parseResult && $context) {
		$context =~ s/@/-/g;

		if ($program_actions{$context}) {
			# there is a completion action defined
			exit $program_actions{$context}->($stream);
		} else {
			# No completion possible
			exit 4;
		}
	}
}

return 1;