This module allows our 2nd tier admins to execute specific set of administrative commands
(those defined as files/commands/*) on our servers without having the interactive shell
access.

The restricted nature of this mode allows us to hand out the access to a larger number of
audience to streamline the maintenance/administrative tasks.

New users can be added via manifests/init.pp. The command option must have the user name
as the first argument. The idea is to use this to further restrict access in the future.