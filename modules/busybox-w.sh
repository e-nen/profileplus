#!/bin/bash

uptime|xargs
echo -n "Procs - User:"
echo -n `ps|grep -v '\['|grep -v COMMAND|wc -l`
echo -n " - Kernel:"
echo -n `ps|grep '\['|grep -v COMMAND|wc -l`
echo -n " - Total:"
echo `ps|grep -v COMMAND|wc -l`
echo;free -m
echo;df -h /
if [ $(pidof dockerd) ]; then
        echo;docker ps
fi

GETTYUSERS=`stdbuf -oL ps|grep getty|grep -v grep |
        while IFS= read -r psline
        do
                echo $psline|awk '{print $2}'
        done |
                sort|uniq -c|awk '{print $1}'|xargs`                                                                                                  
                                                                                                                                                      
if [ $GETTYUSERS -ne 6 ]; then                                                                                                                        
        NUMGETTY=$((6-$GETTYUSERS))                                                                                                                   
        echo;echo "CONSOLE USERS LOGGED ON: $NUMGETTY"                                                                                                
fi                                                                                                                                                    
                                                                                                                                                      
echo;echo "Active shells:"                                                                                                                            
stdbuf -oL ps|grep -- -bash|grep -v grep |                                                                                                            
        while IFS= read -r bashline                                                                                                                   
        do                                                                                                                                            
                echo $bashline|awk '{print $2}'                                                                                                       
        done |                                                                                                                                        
                sort|uniq -c                                                                                                                          
                                                                                                                                                      
echo;echo "SSH total users:"                                                                                                                          
stdbuf -oL ps|grep 'sshd:'|grep '\[priv\]'|grep -v grep |                                                                                             
        while IFS= read -r sshdline                                                                                                                   
        do                                                                                                                                            
                echo $sshdline|awk '{print $5}'                                                                                                       
        done |
                sort|uniq -c
