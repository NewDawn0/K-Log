/*   _                                       _
 *  | | https://github.com/NewDawn0/logged  | |
 *  | |   / _ \   / _` |  / _` |  / _ \  / _` |
 *  | |_ | (_) | | (_| | | (_| | |  __/ | (_| |
 *  |___| \___/   \__, |  \__, |  \___|  \__,_|
 *                |___/   |___/
 *
 * File: common.h
 * Desc: Common functions and struct decl
*/

// Header guard start
#ifndef __COMMON_H__
#define __COMMON_H__

// Termcolors
typedef struct{
    const char red[8];
    const char reset[8];
} Colours;

const Colours colours {
    "\x1b[31;1m",
    "\x1b[0m",
};

// Header guard end
#endif
