use strict;
use warnings;

my $zshrc_path = "$ENV{HOME}/.zshrc";
my $zsh_theme = "fino-time";
my @plugins = (
    'arduino-cli', 'bun', 'cakephp3', 'command-not-found', 'composer', 'docker', 'docker-compose', 'git',
    'github', 'dotenv', 'drush', 'history', 'laravel', 'mongocli', 'node', 'npm', 'nvm', 'pip', 'python',
    'ssh', 'sudo', 'symfony', 'tmux', 'ubuntu', 'vscode', 'yarn'
);
my @aliases = (
    "# Custom aliases:",
    "alias up='sudo apt update && sudo apt upgrade -y'",
    "alias ll='ls -alF'"
);

open(my $fh, '<', $zshrc_path) or die "Can't open file: $!";
my @lines = <$fh>;
close($fh);

# Join plugins to string and replace the existing plugins line
foreach my $line (@lines) {
    if ($line =~ /plugins=\((.*)\)/) {
        my $plugins_str = join(' ', @plugins);
        $line =~ s/\((.*)\)/($plugins_str)/;
    }
    if ($line =~ /ZSH_THEME=".*"/) {
        $line =~ s/ZSH_THEME=".*"/ZSH_THEME="$zsh_theme"/;
    }
}

# Join aliases to lines
foreach my $alias (@aliases) {
    push(@lines, "\n".$alias);
}

print @lines;
print "\n\n\n\n Whats up homie Im Tony\n";
die;

# Write the modified lines back to the file
open($fh, '>', $zshrc_path) or die "Can't open file: $!";
print $fh @lines;
close($fh);