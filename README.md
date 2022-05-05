# Introduction

`pkgset` is a simple utility to manage the packages installed on an OpenBSD system in a declarative way.

# What is it doing?

Create a file `/etc/pkgset.conf` or files in `/etc/pkgset.conf.d/` listing a package per line, `pkgset` will make sure no extra packages (not counting dependencies) are installed or missing compared to your list.

It does so by marking extra packages as "auto installed" and by installing missing packages, then run `pkg_delete -a` to delete unused packages (the one marked as auto installed) if they are not a dependency of another required package.

# How to install

- get the sources
- run `make install` as root

The documentation is available as a man page (see `man pkgset`).

# Why?

After using NixOS too long, it's just a must have for me to manage my packages this way.

# pkg_add -l does the same!

Wrong, `pkg_add -l` will install packages from a list but it won't delete packages not in the list.  This could be a feature to add in `pkg_add` one day.

# Todo?

This is a list of ideas I have that could make `pkgset` better:

- simulate mode to show what will be installed and removed
- better error management (exit code, reporting errors, continue/abort)
- try to find a way to pick a package if a result is ambiguous for `pkg_add`
- reduce the lines of code
