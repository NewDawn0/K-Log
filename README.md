# Logged

A configurable keylogger written in Objective-C

<!-- vim-markdown-toc GFM -->

* [How to use](#how-to-use)
* [Keybinds](#keybinds)
* [Config](#config)

<!-- vim-markdown-toc -->

## How to use

```bash
make # compile
sudo bin/logged # run
```

## Keybinds

- The dump key The dump key dumps the current buffer to the logfile</br>
  Default: `cmd + 9`
- Exec keys Exec keys add the ability to run custom shell commands using key
  combinations</br> Sudo should not be a problem as the parent process meaning
  the logger has sudo privileges</br>

## Config

To configure the keylogger open the `config.h` file in the src folder
