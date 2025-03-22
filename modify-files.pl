use strict;
use warnings;
use File::Copy;

sub zsh {
    my $whoami = getpwuid($<);
    my $zshrc_path = "/home/".$whoami."/.zshrc";
    my $zshrc_backup_path  = "/home/".$whoami."/.zshrc.bak";

    my $zsh_theme = "jovial";
    my @plugins = (
        'arduino-cli', 'bun', 'cakephp3', 'command-not-found', 'composer', 'docker', 'docker-compose', 'git',
        'github', 'dotenv', 'drush', 'history', 'laravel', 'mongocli', 'node', 'npm', 'nvm', 'pip', 'python',
        'ssh', 'sudo', 'symfony', 'tmux', 'ubuntu', 'vscode', 'yarn', 'zsh-autosuggestions', 'zsh-syntax-highlighting',
        'jovial', 'zsh-history-enquirer', 'bg-notify', 'autojump', 'urltools'
    );
    my @aliases = (
        "# Custom aliases:",
        "alias up='sudo apt update && sudo apt upgrade -y'",
        "alias ll='ls -alF'",
        "alias nf='neofetch'",
    );

    # Backup original zshrc
    copy($zshrc_path, $zshrc_backup_path) or die "Failed to create backup: $!";

    my @lines = do {
        open(my $fh, '<', $zshrc_path) or die "Can't open file: $!";
        <$fh>;
    };

    my $in_plugins_block = 0;
    my @collected_plugins = ();
    my @new_lines = ();

    # Join plugins to string and replace the existing plugins line
    foreach my $line (@lines) {
        if ($line =~ /^\s*plugins\s*=\s*\(/) {
            $in_plugins_block = 1;
            @collected_plugins = ();
            next;
        }
        if ($in_plugins_block) {
            if ($line =~ /\)/) {
                $in_plugins_block = 0;
                my $plugins_str = join(' ', @plugins);
                push @new_lines, "plugins=($plugins_str)\n";
            } else {
                # Ignore existing plugins
                next;
            }
        } else {
            # Change theme 
            $line =~ s/ZSH_THEME=".*"/ZSH_THEME="$zsh_theme"/;
            push @new_lines, $line;
        }
    }

    # Join aliases to the end of .zshrc
    my %existing_lines = map { $_ => 1 } @lines;
    foreach my $alias (@aliases) {
        push(@new_lines, "$alias\n") unless $existing_lines{$alias};
    }

    # Write the modified lines back to the file
    open($fh, '>', $zshrc_path) or die "Can't write to file: $!";
    print $fh @new_lines;
    close($fh);

    print("Zsh configuration successful!\n");
}

sub php {
    my $php_ini_path = "/etc/php/8.4/apache2/php.ini";
    my $backup_php_path  = "/etc/php/8.4/apache2/php.ini.bak";

    # Backup original php.ini
    copy($php_ini_path, $php_ini_backup_path) or die "Failed to create backup: $!";

    my @lines = do {
        open(my $fh, '<', $php_ini_path) or die "Can't open file: $!";
        <$fh>;
    };

    # Modify php.ini
    for (@lines) {
        s/^memory_limit\s*=.*/memory_limit = 256M/;
        s/^upload_max_filesize\s*=.*/upload_max_filesize = 10M/;
        s/^post_max_size\s*=.*/post_max_size = 12M/;
        s/^max_execution_time\s*=.*/max_execution_time = 60/;
        s/^max_input_time\s*=.*/max_input_time = 60/;
        s/^error_reporting\s*=.*/error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT & ~E_NOTICE/;
        s/^display_errors\s*=.*/display_errors = Off/;
        s/^log_errors\s*=.*/log_errors = On/;
        s/^error_log\s*=.*/error_log = \/var\/log\/php_errors.log/;
        s/^session\.save_path\s*=.*/session.save_path = "\/var\/lib\/php\/sessions"/;
        s/^disable_functions\s*=.*/disable_functions = exec,shell_exec,system,passthru/;
        s/^expose_php\s*=.*/expose_php = Off/;
        s/^file_uploads\s*=.*/file_uploads = On/;
    }

    # Write back to a temp file to avoid corruption
    my $temp_file = "$php_ini_path.tmp";
    open(my $fh_out, '>', $temp_file) or die "Can't open temp file: $!";
    print $fh_out @lines;
    close($fh_out);

    # Move the temp file to the original php.ini
    rename $temp_file, $php_ini_path or die "Failed to update php.ini: $!";

    print("PHP configuration successful! \n");
}

if (@ARGV) {
    my $command = shift @ARGV;
    if ($command eq 'zsh') {
        zsh();
    } elsif ($command eq 'php') {
        php();
    }
     else {
        print "Unknown command: $command\n";
    }
} else {
    print "No command provided.\n";
}