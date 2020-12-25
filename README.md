# LinuxEnv

Here I store my linux (actually not only) configs etc.
Some stuff has an automatic install ability (refer to Autoinstal chapter).

## Autoinstall

./install.sh is used for auto-installation/update of environment. It goes to every subdirectory of this repo and tries to run following steps:
* **install.sh**: if subfolder contains it, it will be run
* **symlinks**: if this file exists, symlinks will be created. For format, see *Symlink formats*

### Symlink formats
The file symlink contains 2 arguments per line. The first one is the **target**: name of the file *in the same folder*. The second is the **link**, symlink that will be created to the target. Bash variables including ~ can be used here.

Example:
```
.gitconfig ~/.gitconfig
.gitconfig_knx.inc ~/.gitconfig_knx.inc

```
will create 2 symlinks in home directory to two corresponding files in the folder with the *symlinks* file.


