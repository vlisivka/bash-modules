#!/bin/bash
#
# Copyright (c) 2009 Volodymyr M. Lisivka <vlisivka@gmail.com>, All Rights Reserved
#
# This file is part of bash-modules (http://trac.assembla.com/bash-modules/).
#
# bash-modules is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 2.1 of the License, or
# (at your option) any later version.
#
# bash-modules is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with bash-modules  If not, see <http://www.gnu.org/licenses/>.



[ "${__terminal__DEFINED:-}" == "yes" ] || {
  __terminal__DEFINED="yes"

  . import.sh log # error function is neccessary

  terminal_summary() {
    echo "Some useful functions for terminal."
  }

  terminal_usage() {
    echo '
  stdin_is_tty  - returns true (0) if STDIN is connected to tty
  stdout_is_tty - returns true (0) if STDOUT is connected to tty
  stderr_is_tty - returns true (0) if STDERR is connected to tty
'
  }

  stdin_is_tty() {
    test -t 0
  }

  stdout_is_tty() {
    test -t 1
  }

  stderr_is_tty() {
    test -t 2
  }


  switch_to_alternate_screen() {
    tput smcup
  }

  switch_from_alternate_screen() {
    tput rmcup
  }

# TODO: add more functions

  T_BOLD_ON="$(setterm -term $TERM -bold on 2>/dev/null || :)"
  T_BOLD_OFF="$(setterm -term $TERM -bold off  2>/dev/null || :)"

  T_CURSOR_ON="$(setterm -term $TERM -cursor on 2>/dev/null || :)"
  T_CURSOR_OFF="$(setterm -term $TERM -cursor off 2>/dev/null || :)"

  T_UNDERLINE_ON="$(setterm -term $TERM -underline on 2>/dev/null || :)"
  T_UNDERLINE_OFF="$(setterm -term $TERM -underline off 2>/dev/null || :)"

  T_REVERSE_ON="$(setterm -term $TERM -reverse on 2>/dev/null || :)"
  T_REVERSE_OFF="$(setterm -term $TERM -reverse off 2>/dev/null || :)"

  T_CLEAR_ALL="$(clear 2>/dev/null || setterm -term $TERM -clear all || :)"
  T_CLEAR_REST="$(setterm -term $TERM -clear rest || :)"
  
}

return 0

__END__

=pod

=head1 Terminal Capabilities for tput

=head2 Boolean Capabilities

=over 4

=item am      Has automatic margins

=item bw      'cub1' wraps from column 0 to last column

=item chts    Cursor is hard to see

=item da      Display may be retained above screen

=item db      Display may be retained below screen

=item eo      Can erase overstrikes with a blank

=item eslok   Using escape on status line is ok

=item gn      Generic line type (e.g., 'dialup', 'switch')

=item hc      Hardcopy terminal

=item hs      Has a status line

=item hz      Hazeltine; cannot print tildes

=item in      Insert mode distinguishes nulls

=item km      Has a meta key (a shift that sets parity bit)

=item mc5i    Data sent to printer does not echo on screen

=item mir     Safe to move while in insert mode

=item msgr    Safe to move in standout modes

=item npc     No pad character is needed

=item nrrmc   'smcup' does not reverse 'rmcup'

=item nxon    Padding does not work; xon/xoff is required

=item os      Overstrikes

=item ul      Underline character overstrikes

=item xenl    Newline ignored after 80 columns (Concept)

=item xhp     Standout is not erased by overwriting (HP)

=item xon     Uses xon/xoff handshaking

=item xsb     Beehive (f1=escape, f2=ctrl-c)

=item xt      Tabs are destructive, magic 'smso' (t1061)

=back

=head2 Numeric Capabilities

=over 4

=item cols    Number of columns in a line

=item it      Width of initial tab settings

=item lh      Number of rows in each label

=item lines   Number of lines on screen or page

=item lm      Lines of memory if > 'lines'; 0 means varies

=item lw      Number of columns in each label

=item nlab    Number of labels on screen (start at 1)

=item pb      Lowest baud rate where padding is needed

=item vt      Virtual terminal number (CB/Unix)

=item wsl     Number of columns in status line

=item xmc     Number of blanks left by 'smso' or 'rmso'

=back

=head2 String Capabilities

In the following table, '(P)' following an explanation means that the
capability takes one or more parameters (and is evaluated by the tparam
function, or in the case of 'cup', tgoto); '(*)' means that padding may
be based on the number of lines affected; and '#n' refers to the 'n'th
parameter.

=over 4

=item acsc    Graphic character set pairs aAbBcC - default vt100

=item bel     Ring bell (beep)

=item blink   Begin blinking mode

=item bold    Begin double intensity mode

=item cbt     Back tab

=item civis   Make cursor invisible

=item clear   Clear screen (*)

=item cmdch   Settable command character in prototype

=item cnorm   Make cursor normal (undo 'cvvis' & 'civis)'

=item cr      Carriage return (*)

=item csr     Change scrolling region to lines #1 through #2 (P)

=item cub     Move cursor left #1 spaces (P)

=item cub1    Move cursor left one space

=item cud     Move cursor down #1 lines (P*)

=item cud1    Move cursor down one line

=item cuf     Move cursor right #1 spaces (P*)

=item cuf1    Move cursor right one space

=item cup     Move cursor to row #1, column #2 of screen (P)

=item cuu     Move cursor up #1 lines (P*)

=item cuu1    Move cursor up one line

=item cvvis   Make cursor very visible

=item dch     Delete #1 characters (P*)

=item dch1    Delete one character (*)

=item dim     Begin half intensity mode

=item dl      Delete #1 lines (P*)

=item dl1     Delete one line (*)

=item dsl     Disable status line

=item ech     Erase #1 characters (P)

=item ed      Clear to end of display (*)

=item el      Clear to end of line

=item el1     Clear to beginning of line, inclusive

=item enacs   Enable alternate character set

=item ff      Form feed for hardcopy terminal (*)

=item flash   Visible bell (must not move cursor)

=item fsl     Return from status line

=item hd      Move cursor down one-half line

=item home    Home cursor (if no 'cup')

=item hpa     Move cursor to column #1 (P)

=item ht      Tab to next 8 space hardware tab stop

=item hts     Set a tab in all rows, current column

=item hu      Move cursor up one-half line

=item ich     Insert #1 blank characters (P*)

=item ich1    Insert one blank character

=item if      Name of file containing initialization string

=item il      Add #1 new blank lines (P*)

=item il1     Add one new blank line (*)

=item ind     Scroll forward (up) one line

=item indn    Scroll forward #1 lines (P)

=item invis   Begin invisible text mode

=item ip      Insert pad after character inserted (*)

=item iprog   Path of program for initialization

=item is1     Terminal initialization string

=item is2     Terminal initialization string

=item is3     Terminal initialization string

=item kBEG    Shifted beginning key

=item kCAN    Shifted cancel key

=item kCMD    Shifted command key

=item kCPY    Shifted copy key

=item kCRT    Shifted create key

=item kDC     Shifted delete char key

=item kDL     Shifted delete line key

=item kEND    Shifted end key

=item kEOL    Shifted clear line key

=item kEXT    Shifted exit key

=item kFND    Shifted find key

=item kHLP    Shifted help key

=item kHOM    Shifted home key

=item kIC     Shifted input key

=item kLFT    Shifted left arrow key

=item kMOV    Shifted move key

=item kMSG    Shifted message key

=item kNXT    Shifted next key

=item kOPT    Shifted options key

=item kPRT    Shifted print key

=item kPRV    Shifted prev key

=item kRDO    Shifted redo key

=item kRES    Shifted resume key

=item kRIT    Shifted right arrow

=item kRPL    Shifted replace key

=item kSAV    Shifted save key

=item kSPD    Shifted suspend key

=item kUND    Shifted undo key

=item ka1     Upper left of keypad

=item ka3     Upper right of keypad

=item kb2     Center of keypad

=item kbeg    Beginning key

=item kbs     Backspace key

=item kc1     Lower left of keypad

=item kc3     Lower right of keypad

=item kcan    Cancel key

=item kcbt    Back tab key

=item kclo    Close key

=item kclr    Clear screen or erase key

=item kcmd    Command key

=item kcpy    Copy key

=item kcrt    Create key

=item kctab   Clear tab key

=item kcub1   Left arrow key

=item kcud1   Down arrow key

=item kcuf1   Right arrow key

=item kcuu1   Up arrow key

=item kdch1   Delete character key

=item kdl1    Delete line key

=item ked     Clear to end of screen key

=item kel     Clear to end of line key

=item kend    End key

=item kent    Enter/send key (unreliable)

=item kext    Exit key

=item kf0     Function key f0

=item kf1     Function key f1

=item kf10    Function key f10

=item kf11    Function key f11

=item kf12    Function key f12

=item kf13    Function key f13

=item kf14    Function key f14

=item kf15    Function key f15

=item kf16    Function key f16

=item kf17    Function key f17

=item kf18    Function key f18

=item kf19    Function key f19

=item kf2     Function key f2

=item kf20    Function key f20

=item kf21    Function key f21

=item kf22    Function key f22

=item kf23    Function key f23

=item kf24    Function key f24

=item kf25    Function key f25

=item kf26    Function key f26

=item kf27    Function key f27

=item kf28    Function key f28

=item kf29    Function key f29

=item kf3     Function key f3

=item kf30    Function key f30

=item kf31    Function key f31

=item kf32    Function key f32

=item kf33    Function key f13

=item kf34    Function key f34

=item kf35    Function key f35

=item kf36    Function key f36

=item kf37    Function key f37

=item kf38    Function key f38

=item kf39    Function key f39

=item kf4     Function key f4

=item kf40    Function key f40

=item kf41    Function key f41

=item kf42    Function key f42

=item kf43    Function key f43

=item kf44    Function key f44

=item kf45    Function key f45

=item kf46    Function key f46

=item kf47    Function key f47

=item kf48    Function key f48

=item kf49    Function key f49

=item kf5     Function key f5

=item kf50    Function key f50

=item kf51    Function key f51

=item kf52    Function key f52

=item kf53    Function key f53

=item kf54    Function key f54

=item kf55    Function key f55

=item kf56    Function key f56

=item kf57    Function key f57

=item kf58    Function key f58

=item kf59    Function key f59

=item kf6     Function key f6

=item kf60    Function key f60

=item kf61    Function key f61

=item kf62    Function key f62

=item kf63    Function key f63

=item kf7     Function key f7

=item kf8     Function key f8

=item kf9     Function key f9

=item kfnd    Find key

=item khlp    Help key

=item khome   Home key

=item khts    Set tab key

=item kich1   Ins char/enter ins mode key

=item kil1    Insert line key

=item kind    Scroll forward/down key

=item kll     Home down key

=item kmov    Move key

=item kmrk    Mark key

=item kmsg    Message key

=item knp     Next page key

=item knxt    Next object key

=item kopn    Open key

=item kopt    Options key

=item kpp     Previous page key

=item kprt    Print or copy key

=item kprv    Previous object key

=item krdo    Redo key

=item kref    Reference key

=item kres    Resume key

=item krfr    Refresh key

=item kri     Scroll backward/up key

=item krmir   rmir or smir in insert mode

=item krpl    Replace key

=item krst    Restart key

=item ksav    Save key

=item kslt    Select key

=item kspd    Suspend key

=item ktbc    Clear all tabs key

=item kund    Undo key

=item lf0     Label on function key f0 if not 'f0'

=item lf1     Label on function key f1 if not 'f1'

=item lf10    Label on function key f10 if not 'f10'

=item lf2     Label on function key f2 if not 'f2'

=item lf3     Label on function key f3 if not 'f3'

=item lf4     Label on function key f4 if not 'f4'

=item lf5     Label on function key f5 if not 'f5'

=item lf6     Label on function key f6 if not 'f6'

=item lf7     Label on function key f7 if not 'f7'

=item lf8     Label on function key f8 if not 'f8'

=item lf9     Label on function key f9 if not 'f9'

=item ll      Go to last line, first column (if no 'cup')

=item mc0     Print screen contents

=item mc4     Turn printer off

=item mc5     Turn printer on

=item mc5p    Turn printer on for #1 bytes (P)

=item mgc     Clear left and right soft margins

=item mrcup   Move cursor to row #1, column #2 of memory (P)

=item nel     Newline (like cr followed by lf)

=item pad     Pad character (rather than nul)

=item pfkey   Program function key #1 to type string #2 (P)

=item pfloc   Program function key #1 to execute string #2 (P)

=item pfx     Program function key #1 to transmit string #2 (P)

=item pln     Program label #1 to show string #2 (P)

=item prot    Begin protected mode

=item rc      Restore cursor to position of last 'sc'

=item rep     Repeat character #1, #2 times (P*)

=item rev     Begin reverse video mode

=item rf      Name of file containing reset string

=item rfi     Send next input character (for ptys)

=item ri      Scroll backward (down) one line

=item rin     Scroll backward #1 lines (P)

=item rmacs   End alternate character set

=item rmam    Turn off automatic margins

=item rmcup   String to end programs that use 'cup'

=item rmdc    End delete mode

=item rmir    End insert mode

=item rmkx    End keypad transmit mode

=item rmln    Turn off soft labels

=item rmm     End meta mode

=item rmp     Like 'ip' but when in replace mode

=item rmso    End standout mode

=item rmul    End underscore mode

=item rmxon   Turn off xon/xoff handshaking

=item rs1     Reset terminal to sane modes

=item rs2     Reset terminal to sane modes

=item rs3     Reset terminal to sane modes

=item sc      Save cursor position

=item sgr     Define video attributes #1 through #9 (P)

=item sgr0    Turn off all attributes

=item smacs   Begin alternate character set

=item smam    Turn on automatic margins

=item smcup   String to begin programs that use 'cup'

=item smdc    Begin delete mode

=item smgl    Set soft left margin to #1 (P)

=item smgr    Set soft right margin to #1 (P)

=item smir    Begin insert mode

=item smkx    Begin keypad transmit mode

=item smln    Turn on soft labels

=item smm     Begin meta mode (8th bit set)

=item smso    Begin standout mode

=item smul    Begin underscore mode

=item smxon   Turn on xon/xoff handshaking

=item tbc     Clear all tab stops

=item tsl     Go to status line, column #1 (P)

=item uc      Underscore one character and move past it

=item vpa     Move cursor to row #1 (P)

=item wind    Set window to lines #1-#2, columns #3-#4 (P)

=item xoffc   xoff character

=item xonc    xon character

=back

=cut
