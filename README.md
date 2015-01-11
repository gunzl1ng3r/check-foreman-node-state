# check-foreman-node-state
* A small script checking the status of hosts known to The Foreman.
* It also outputs the number of ok, warning & critical as performance data

## Requirements
* The Foreman - a read-only user to connect with
* Perl - LWP::Simple
* Perl - Switch

## Usage
* as the password is stored in plain text within the script, I recommend securing file permissions so only authorized people can read it.

## Plans For The Future
* Pass "hostgroup" to check only hosts in said hostgroup.
