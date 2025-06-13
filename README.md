# Erlang Ecosystem Foundation CNA Website

[![EEF Security WG project](https://img.shields.io/badge/EEF-Security-black)](https://github.com/erlef/security-wg)

<br clear="left"/>

---

# How to see documentation locally

Requirerments:
 * ruby >= 3.2
 * bundler

**Or use VSCode Devcontainer**

Instructions

```bash
bundle install
bundle exec jekyll serve
```

## Changing `security.txt`

The file contents of `security.txt` are signed with the CNA GPG key. Therefore
the contents (excluding the Jekyll header) must be signed after every change.

```bash
# Copy contents into clipboard

# Replace `xclip -o` with `pbpaste` for Mac OS
xclip -o | gpg --clear-sign --default-key 38BD201B397E28F1F3D93EC76E031A811F266E21

# Paste into file contents
```
