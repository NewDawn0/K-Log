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

/*========= Configuration =========*/ 
const char* LOG_FILE_PATH = "/var/log/logger.log";  // Where the log file is stored
const int BUFSIZE = 20;                             // Amount of characters until the buffer of keys is logged to the file
const bool DEBUG = true;                            // If debug messages shoudld be printed

// Keybinds:
// NOTE: do not seperate the keys with a space
const char* DUMP = "cmd+ö";                        // Key combination which dumps all the keys
                                                   // Key combination which executes shell command on keypress


