#!/bin/bash
# Sucrose Downloader
# shadowed1

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
BOLD=$(tput bold)
RESET=$(tput sgr0)

echo
echo "${BLUE}"
echo "                                                           .lxo. "                                    
echo "                                                 .';,.     .oOx' "                                    
echo "                                                 ;x00,      'c. "                                     
echo "                                                 .cl;       ,:. "                                     
echo "                                                .;c;.     .'cc.    ..  .';:;..    .:dd:. "            
echo "                                               .;cc:'.....;oxxo,,;cxOc.':clc;',:c:cOXN0, "            
echo "                                                .....     .;lc'...':l, .';;'.     .;ll;. "            
echo "                                                           .c'          .'. "                         
echo "                                                           .:.          .,. "                         
echo "                                      ...                  .c.          .;. "                         
echo "                           .ol.       ;Ok'       ...      .:l:.        .:c'     ... "               
echo "           ',.          .:;;cc:;.....,:;';oc.   :OK0o:::,;lxxdc,''''.';oxxd:,,:lx0O; "              
echo "          .x0c          lK0:   .,:llc,   ;d,    ,oxd:'....':l:........,lddo;..'':ol. "                
echo "           ;c.          :d,      ,oo:'. .'.                .,.         .cc. "                      
echo "         .,'          .l,       ',.  .';,.                .'.         .c; "                         
echo "         .:c;'.......,:l:.      .,.     ..                 ';,.        .c; "                          
echo "          .'......'';oxdc'..  .';.                        .;cc'        .c; "                         
echo "                     .;c'....'cdl.                         ',.         .c;. "                         
echo "                      .;.    ,:c:,,.                       ,'.,,.    .,lool' "                       
echo "       .ldc'          .:. ,lo,    .......                 .:,oKX0ocl::loxxxl;,'...     .... "        
echo "       ;0XOoccc,..',,..;' ;dc.       .'::;.  .           .;;.;xOd,.....:lc:...''...'..';:c:, "       
echo "        .,'...'..,:cc;,;:,.           .''...,:;'........;ldo,. .      .;'            .';ccc,. "      
echo "                  .,,,:clc,''..... ..','...';c:,......'':oddc,'...   .';.              .;;.. "     
echo "                    ':;,,. ....''',cdxo:,..  ..          ;c.  .',,'.;clc'...,ldc.      .c; "      
echo "                 .,ll.             'ldl'                :kx.       'ldxxl,,:cd0x'      .kd. "        
echo "               .l0Ko.               .:,                 ;do.        'll;.     .        'xo. "       
echo "                'cc.                 ;;                             .c'               ,d0Kk; "       
echo "                                     ,:                             ':.               'o0KO; "      
echo "                                     ':.                            ',                 ..'. "      
echo "                                    .:l:.                          .,' "                           
echo "                              .;c;,,cddd:'''....',,'.             .','. "                            
echo "                              .xOl'..:;'.  .....;cc;.            .,ccc,. "                           
echo "                               ..   ':.         .;;.             .;cc,. "                          
echo "                                   l0Oc         .od,            .l00o. "                           
echo "                                   ,ol'         cO0o.            .:c' "                            
echo "                                                :kkl. "                             
echo
echo "                                                Sucrose ${RESET}"
echo
curl -L https://raw.githubusercontent.com/shadowed1/sucrose/main/bin/sucrose_installer.sh -o /home/chronos/user/sucrose_installer
echo
echo "${CYAN}How to install: ${RESET}${BLUE}"
echo
echo "1.) ctrl-alt-refresh to open VT-2 (ctrl-alt-back to exit)"
echo "2.) Log in as chronos"
echo "3.) Run the command listed below in VT-2 to continue the installer:"
echo "${BOLD}"
echo "sudo bash ~/sucrose_installer"
echo "${RESET}${BLUE}"
echo "Can safely ignore noexec mount warning. ${RESET}"
echo
