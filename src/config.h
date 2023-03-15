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

const char* OUT_FILE_PATH = "/var/log/logger.log";
const int BUFSIZE = 20; // Sets the amount of character it needs until the log file is written to again;

// Keybinds
// force dump the collected chars to the log file
const char* DUMP = "cmd + l"; // Sepereate the keys by +
