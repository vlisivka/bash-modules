#!/bin/bash
#
# Copyright (c) 2011 Volodymyr M. Lisivka <vlisivka@gmail.com>, All Rights Reserved
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

[ "${__keyboard_input_tokenizer__DEFINED:-}" == "yes" ] || {
  __keyboard_input_tokenizer__DEFINED="yes"
  
  . import.sh parser

  keyboard_input_tokenizer_summary() {
    echo "Tokenize keyboard input."
  }
  
  keyboard_input_tokenizer_usage() {
    echo '

    generate_keyboard_input_tokenizer

        Generate keyboard input tokenizer. Every c

   generate_xterm_keyboard_input_tokenizer

        Generate keyboard tokenizer to parse input on xterm-compatible
terminals.

'
  }

  generate_keyboard_input_tokenizer() {
    local TOKENIZER_COMMAND_PREFIX="${TOKENIZER_COMMAND_PREFIX:-echo }"
    local __TOP_LEVEL_DEFAULT_ACTION='echo "$TOKENIZER_KEY"'
    local TOKENIZER_TOP_LEVEL_DEFAULT_ACTION="${TOKENIZER_TOP_LEVEL_DEFAULT_ACTION:-$__TOP_LEVEL_DEFAULT_ACTION}"
    local __DEFAULT_ACTION='echo "alt_${TOKENIZER_KEY_SEQUENCE#?}"'
    local TOKENIZER_DEFAULT_ACTION="${TOKENIZER_DEFAULT_ACTION:-$__DEFAULT_ACTION}"
    
    local __ERROR_HANDLER='{ if [ $? -gt 128 ]; then echo "TIMEOUT" || break ; continue ; else echo "EOF" ; break ; fi ; }'
    local TOKENIZER_READ_ERROR_HANDLER="${TOKENIZER_READ_ERROR_HANDLER:-$__ERROR_HANDLER}"
    
    generate_input_tokenizer "$@"
  }
  
  generate_xterm_keyboard_input_tokenizer() {
    generate_keyboard_input_tokenizer \
 $'\n=newline' \
 $'\cA=ctrl_a' \
 $'\cB=ctrl_b' \
 $'\cC=ctrl_c' \
 $'\cD=ctrl_d' \
 $'\cE=ctrl_e' \
 $'\cF=ctrl_f' \
 $'\cG=ctrl_g' \
 $'\b=backspace' \
 $'\t=tab' \
 $'\cK=ctrl_k' \
 $'\cL=ctrl_l' \
 $'\r=carriagereturn' \
 $'\cN=ctrl_n' \
 $'\cO=ctrl_o' \
 $'\cP=ctrl_p' \
 $'\cQ=ctrl_q' \
 $'\cR=ctrl_r' \
 $'\cS=ctrl_s' \
 $'\cT=ctrl_t' \
 $'\cU=ctrl_u' \
 $'\cV=ctrl_v' \
 $'\cW=ctrl_w' \
 $'\cX=ctrl_x' \
 $'\cY=ctrl_y' \
 $'\cz=ctrl_z' \
 $'\034=ctrl_backslash' \
 $'\035=ctrl_rightbracket' \
 $'\036=ctrl_circumflex' \
 $'\037=ctrl_underscore' \
  \
 $'\E\n=alt_newline' \
 $'\E\001=alt_ctrl_a' \
 $'\E\cB=alt_ctrl_b' \
 $'\E\cC=alt_ctrl_c' \
 $'\E\cD=alt_ctrl_d' \
 $'\E\cE=alt_ctrl_e' \
 $'\E\cF=alt_ctrl_f' \
 $'\E\cG=alt_ctrl_g' \
 $'\E\b=alt_backspace' \
 $'\E\t=alt_tab' \
 $'\E\cK=alt_ctrl_k' \
 $'\E\cL=alt_ctrl_l' \
 $'\E\r=alt_carriagereturn' \
 $'\E\cN=alt_ctrl_n' \
 $'\E\cO=alt_ctrl_o' \
 $'\E\cP=alt_ctrl_p' \
 $'\E\cQ=alt_ctrl_q' \
 $'\E\cR=alt_ctrl_r' \
 $'\E\cS=alt_ctrl_s' \
 $'\E\cT=alt_ctrl_t' \
 $'\E\cU=alt_ctrl_u' \
 $'\E\cV=alt_ctrl_v' \
 $'\E\cW=alt_ctrl_w' \
 $'\E\cX=alt_ctrl_x' \
 $'\E\cY=alt_ctrl_y' \
 $'\E\cz=alt_ctrl_z' \
 $'\E\034=alt_ctrl_backslash' \
 $'\E\035=alt_ctrl_rightbracket' \
 $'\E\036=alt_ctrl_circumflex' \
 $'\E\037=alt_ctrl_underscore' \
  \
 $'\EOP=f1' \
 $'\EOQ=f2' \
 $'\EOR=f3' \
 $'\EOS=f4' \
 $'\E[15~=f5' \
 $'\E[17~=f6' \
 $'\E[18~=f7' \
 $'\E[19~=f8' \
 $'\E[20~=f9' \
 $'\E[21~=f10' \
 $'\E[23~=f11' \
 $'\E[24~=f12' \
 $'\EO1;2P=shift_f1' \
 $'\EO1;2Q=shift_f2' \
 $'\EO1;2R=shift_f3' \
 $'\EO1;2S=shift_f4' \
 $'\E[15;2~=shift_f5' \
 $'\E[17;2~=shift_f6' \
 $'\E[18;2~=shift_f7' \
 $'\E[19;2~=shift_f8' \
 $'\E[20;2~=shift_f9' \
 $'\E[21;2~=shift_f10' \
 $'\E[23;2~=shift_f11' \
 $'\E[24;2~=shift_f12' \
 $'\EO1;3P=alt_f1' \
 $'\EO1;3Q=alt_f2' \
 $'\EO1;3R=alt_f3' \
 $'\EO1;3S=alt_f4' \
 $'\E[15;3~=alt_f5' \
 $'\E[17;3~=alt_f6' \
 $'\E[18;3~=alt_f7' \
 $'\E[19;3~=alt_f8' \
 $'\E[20;3~=alt_f9' \
 $'\E[21;3~=alt_f10' \
 $'\E[23;3~=alt_f11' \
 $'\E[24;3~=alt_f12' \
 $'\EO1;5P=ctrl_f1' \
 $'\EO1;5Q=ctrl_f2' \
 $'\EO1;5R=ctrl_f3' \
 $'\EO1;5S=ctrl_f4' \
 $'\E[15;5~=ctrl_f5' \
 $'\E[17;5~=ctrl_f6' \
 $'\E[18;5~=ctrl_f7' \
 $'\E[19;5~=ctrl_f8' \
 $'\E[20;5~=ctrl_f9' \
 $'\E[21;5~=ctrl_f10' \
 $'\E[23;5~=ctrl_f11' \
 $'\E[24;5~=ctrl_f12' \
 $'\EO1;6P=ctrl_shift_f1' \
 $'\EO1;6Q=ctrl_shift_f2' \
 $'\EO1;6R=ctrl_shift_f3' \
 $'\EO1;6S=ctrl_shift_f4' \
 $'\E[15;6~=ctrl_shift_f5' \
 $'\E[17;6~=ctrl_shift_f6' \
 $'\E[18;6~=ctrl_shift_f7' \
 $'\E[19;6~=ctrl_shift_f8' \
 $'\E[20;6~=ctrl_shift_f9' \
 $'\E[21;6~=ctrl_shift_f10' \
 $'\E[23;6~=ctrl_shift_f11' \
 $'\E[24;6~=ctrl_shift_f12' \
  \
 $'\EO1;4P=alt_shift_f1' \
 $'\EO1;4Q=alt_shift_f2' \
 $'\EO1;4R=alt_shift_f3' \
 $'\EO1;4S=alt_shift_f4' \
 $'\E[15;4~=alt_shift_f5' \
 $'\E[17;4~=alt_shift_f6' \
 $'\E[18;4~=alt_shift_f7' \
 $'\E[19;4~=alt_shift_f8' \
 $'\E[20;4~=alt_shift_f9' \
 $'\E[21;4~=alt_shift_f10' \
 $'\E[23;4~=alt_shift_f11' \
 $'\E[24;4~=alt_shift_f12' \
  \
 $'\E[Z=shift_tab' \
 $'\E\t=alt_tab' \
  \
 $'\E[2~=insert' \
 $'\E[2;3~=alt_insert' \
 $'\E[3~=delete' \
 $'\E[3;2~=shift_delete' \
 $'\E[3;3~=alt_delete' \
 $'\E[3;5~=ctrl_delete' \
 $'\E[3;6~=ctrl_shift_delete' \
 $'\E[3;4~=alt_shift_delete' \
 $'\E[3;8~=alt_ctrl_shift_delete' \
  \
 $'\EOH=home' \
 $'\EOF=end' \
  \
 $'\E[5~=pageup' \
 $'\E[6~=pagedown' \
 $'\E[5;3~=alt_pageup' \
 $'\E[6;3~=alt_pagedown' \
 $'\E[5;5~=ctrl_pageup' \
 $'\E[6;5~=ctrl_pagedown' \
 $'\E[5;7~=alt_ctrl_pageup' \
 $'\E[6;7~=alt_ctrl_pagedown' \
  \
 $'\E[A=up' \
 $'\E[B=down' \
 $'\E[C=right' \
 $'\E[D=left' \
 $'\E[1;2A=shift_up' \
 $'\E[1;2B=shift_down' \
 $'\E[1;2C=shift_right' \
 $'\E[1;2D=shift_left' \
 $'\E[1;5A=ctrl_up' \
 $'\E[1;5B=ctrl_down' \
 $'\E[1;5C=ctrl_right' \
 $'\E[1;5D=ctrl_left' \
  \
 $'\E[1;3A=alt_up' \
 $'\E[1;3B=alt_down' \
 $'\E[1;3C=alt_right' \
 $'\E[1;3D=alt_left' \
  \
 $'\E[1;6D=ctrl_shift_left' \
 $'\E[1;6C=ctrl_shift_right' \
 $'\E[1;4A=alt_shift_up' \
 $'\E[1;4B=alt_shift_down' \
 $'\E[1;4C=alt_shift_right' \
 $'\E[1;4D=alt_shift_left' \
  \
 $'\E[1;8D=alt_ctrl_shift_left' \
 $'\E[1;8C=alt_ctrl_shift_right' \
  \
 $'\E\E=alt_escape' \
  \
 $'\EOP=f1' \
 $'\EOQ=f2' \
 $'\EOR=f3' \
 $'\EOS=f4' \
 $'\E[1;3P=alt_f1' \
 $'\E[1;3Q=alt_f2' \
 $'\E[1;3R=alt_f3' \
 $'\E[1;3S=alt_f4' \
 $'\E[1;5P=ctrl_f1' \
 $'\E[1;5Q=ctrl_f2' \
 $'\E[1;5R=ctrl_f3' \
 $'\E[1;5S=ctrl_f4' \
 $'\E[1;2P=shift_f1' \
 $'\E[1;2Q=shift_f2' \
 $'\E[1;2R=shift_f3' \
 $'\E[1;2S=shift_f4' \
 $'\E[1;4P=alt_shift_f1' \
 $'\E[1;4Q=alt_shift_f2' \
 $'\E[1;4R=alt_shift_f3' \
 $'\E[1;4S=alt_shift_f4' \
 $'\E[1;6P=ctrl_shift_f1' \
 $'\E[1;6Q=ctrl_shift_f2' \
 $'\E[1;6R=ctrl_shift_f3' \
 $'\E[1;6S=ctrl_shift_f4' \
 \
 $'\E[H=home' \
 $'\E[F=end' \
 $'\E[1;3H=alt_home' \
 $'\E[1;3F=alt_end' \
 $'\E[1;4H=alt_shift_home' \
 $'\E[1;4F=alt_shift_end' \
 $'\E[1;5H=ctrl_home' \
 $'\E[1;5F=ctrl_end' \
 $'\E[1;7H=alt_ctrl_home' \
 $'\E[1;7F=alt_ctrl_end' \
 $'\E[1;8H=alt_ctrl_shift_home' \
 $'\E[1;8F=alt_ctrl_shift_end' \
 $'\E[1;2H=shift_home' \
 $'\E[1;2F=shift_end' \
 $'\E[1;6H=ctrl_shift_home' \
 $'\E[1;6F=ctrl_shift_end' \
  \
 $'\E[E=keypad5' \
 $'\E[1;3E=alt_keypad5' \
 $'\E[1;5E=ctrl_keypad5' \
 $'\E[1;7E=alt_ctrl_keypad5' \
  \
 $'\E[2;5~=ctrl_insert' \
 $'\E[2;7~=alt_ctrl_insert' \

#
  }
}
