import os

zshrc_path = os.path.expanduser("~/.zshrc")

plugins_line_index = None
plugins = [
    'arduino-cli', 'bun', 'cakephp3', 'command-not-found', 'composer', 'docker', 'docker-compose', 'git',
    'github', 'dotenv', 'drush', 'history', 'laravel', 'mongocli', 'node', 'npm', 'nvm', 'pip', 'python',
    'ssh', 'sudo', 'symfony', 'tmux', 'ubuntu', 'vscode', 'yarn'
]

new_aliases = [
    "alias up='sudo apt update && sudo apt upgrade -y'",
    "alias ll='ls -alF'"
]

with open (zshrc_path, 'rt') as zshrc_file:
    lines = zshrc_file.read()

# Find the line with plugins=()
for index, line in enumerate(lines):
    if line.startswith('plugins='):
        plugins_line_index = index
        break

if plugins_line_index is not None:
    current_plugins = lines[plugins_line_index].strip()
    existing_plugins = current_plugins[current_plugins.index('(')+1:current_plugins.index(')')].split()
    updated_plugins = set(existing_plugins) | set(plugins)
    lines[plugins_line_index] = f"plugins=({ ' '.join(updated_plugins) })\n"

lines.extend(new_aliases)

with open(zshrc_path, 'w') as file:
    file.writelines(lines)    