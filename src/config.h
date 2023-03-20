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
    const char* key;
    const char* cmd;
} ExecKey;


/*========= Configuration =========*/ 
const char* LOG_FILE_PATH = "/var/log/logger.log";  // Where the log file is stored
const int BUFSIZE = 20;                             // Amount of characters until the buffer of keys is logged to the file
const bool DEBUG = true;                            // If debug messages shoudld be printed

// Keybinds:
// NOTE: do not seperate the keys with a space as it will not work
const char* DUMP = "cmd+9";                        // Key combination which dumps all the keys

// Exec Keys
// Using ExecKeys you can define keys and commands are run when the key is pressed
// These are just some dummy commands for demonstration
ExecKey EXEC_KEYS[] = {
    { "cmd+8", "sudo echo hi" },
    { "cmd+7", "ls ." }
};
