%********************************************************
%*  Game Name: Othello                    Date:11/26/18 *
%*  Group: I                            File: Othello.m *
%*  Instructor: Chrispher Ratcliff          Time: 15:00 *
%******************************************************** 
clc;
clear;


load Othello.mat;


CURRENT_BOARD=[2,2,2,2,2,2,2,2;
               2,2,2,2,2,2,2,2;
               2,2,2,2,2,2,2,2;
               2,2,2,0,1,2,2,2;
               2,2,2,1,0,2,2,2;
               2,2,2,2,2,2,2,2;
               2,2,2,2,2,2,2,2;
               2,2,2,2,2,2,2,2;]; %white is 0 black is 1

imshow([Board{1,:};Board{2,:};Board{3,:};Board{4,:};Board{5,:};Board{6,:};Board{7,:};Board{8,:}])

game_state=1;
user_Valid=1; %start
npc_Valid=1;

while game_state %main thread
    user_Valid=valid_Step(CURRENT_BOARD,1);
    if user_Valid
        [CURRENT_BOARD]=user_step(CURRENT_BOARD);
    end % if user_Valid
    
    for i=1:1:8
        for j=1:1:8
            if CURRENT_BOARD(i,j)==1
                Board{i,j}=blackdisc;
            elseif CURRENT_BOARD(i,j)==0
                Board{i,j}=whitedisc;
            end % if board
        end % j for loop
    end % i for loop
    %update graphic board
    imshow([Board{1,:};Board{2,:};Board{3,:};Board{4,:};Board{5,:};Board{6,:};Board{7,:};Board{8,:}])
    
    pause(0.4);
    
    npc_Valid=valid_Step(CURRENT_BOARD,0);
    if npc_Valid
        CURRENT_BOARD=npc_step(CURRENT_BOARD);
    end % if npc_Valid
    for i=1:1:8
        for j=1:1:8
            if CURRENT_BOARD(i,j)==1
                Board{i,j}=blackdisc;
            elseif CURRENT_BOARD(i,j)==0
                Board{i,j}=whitedisc;
            end %  if board
        end % j for loop
    end % i for loop
    %update graphic board
    imshow([Board{1,:};Board{2,:};Board{3,:};Board{4,:};Board{5,:};Board{6,:};Board{7,:};Board{8,:}])
    
    [game_state,black_number,white_number]=counter(CURRENT_BOARD);
    user_Valid=valid_Step(CURRENT_BOARD,1);
    npc_Valid=valid_Step(CURRENT_BOARD,0);
    
    if (~user_Valid&&~npc_Valid) % validation for both side valid steps
        game_state=0;
    end % if valid
    
    CURRENT_BOARD
    fprintf('i = %0.0f , j = %0.0f \n',i,j)
end % game_state
fprintf('_____________________________________\n')
fprintf('The game has ended. Here is the statistics:\n')
fprintf('Black Disc = %0.0f , White Disc = %0.0f \n',black_number,white_number)
if black_number==white_number
    fprintf('The game ended with a DRAW.\n')
elseif black_number>white_number
    fprintf('You have WON the game! Congratulations!\n')
else 
    fprintf('You have lost the game. Try better next time!\n')
end % if num comparison

function [validStep]=valid_Step(board,playerTurn)
    validStep=1;

    for i=1:1:8
        for j=1:1:8
            validStep=validity_check(board,i,j,playerTurn);
            if validStep
               break;
            end % if validStep
        end % j for loop
        if validStep
           break;
        end % if validStep
    end % i for loop
end % valid_Step


function [board_output]=user_step(board)
    state=0;
    
    while state==0
        [row,col]=user_pos(); 
        state=validity_check(board,row,col,1);
    end
    board(row,col)=1;
    board=flipping_disc(board,row,col,1);
    
    board_output=board;
end % user_step

function [row,col]=user_pos()
    [user_x,user_y]=ginput(1);
    while ~(user_x>0&&user_x<=671&&user_y>0&&user_y<=628)
        [user_x,user_y]=ginput(1);
    end % while loop
    user_y=631-user_y;
    
    if user_x>0&&user_x<=83.875
        col=1;
    elseif user_x>83.875&&user_x<=167.75
        col=2;
    elseif user_x>167.75&&user_x<=251.625
        col=3;
    elseif user_x>251.625&&user_x<=335.5
        col=4;
    elseif user_x>335.5&&user_x<=419.375
        col=5;
    elseif user_x>419.375&&user_x<=503.25
        col=6;
    elseif user_x>503.25&&user_x<=587.125
        col=7;
    elseif user_x>587.125&&user_x<=671
        col=8;
    end
    
    
    if user_y>0&&user_y<=78.5
        row=1;
    elseif user_y>78.5&&user_y<=157
        row=2;
    elseif user_y>157&&user_y<=235.5
        row=3;
    elseif user_y>235.5&&user_y<=314
        row=4;
    elseif user_y>314&&user_y<=392.5
        row=5;
    elseif user_y>392.5&&user_y<=471
        row=6;
    elseif user_y>471&&user_y<=549.5
        row=7;
    elseif user_y>549.5&&user_y<=628
        row=8;
    end
    
    row=9-row;
end % user_pos

function state = validity_check(board,row,col,playerTurn)
    state=0;
    jump=0;%initialization
    stateR=0;
    stateL=0;
    stateU=0;
    stateD=0;
    stateUR=0;
    stateUL=0;
    stateDR=0;
    stateDL=0;
    
    if board(row,col)==2
        if state==0&&col<7
            for j=col+1:1:8 % right horizontal direction
            if (playerTurn == 0)    
                switch board(row,j)
                    case 0
                        if j==col+1
                            stateR=0;
                            jump=1;
                        else
                            stateR=1;
                            jump=1; %jump
                        end % case 0
                    case 1
                        % do nothing
                        if j==8
                            stateR=0;
                            jump=1;
                        end % case 1
                    case 2
                        stateR=0;
                        jump=1; %jump
                end % switch 0
            elseif (playerTurn == 1)
                switch board(row,j)
                    case 0
                        % Do nothing
                        if j==8
                            stateR=0;
                            jump=1;
                        end % case 0
                    case 1
                        if j==col+1
                            stateR=0;
                            jump=1;
                        else
                            stateR=1;
                            jump=1; %jump
                        end % case 1
                    case 2
                        stateR=0;
                        jump=1;
                end % switch 1
            end % if playerTurn
            if jump
                jump=0;
                break;
            end % if jump
            end  % for loop
        end % if right
        
        if stateR
            state=stateR;
        end % stateR
        
        if state==0&&col>2
            for j=col-1:-1:1 % left horizontal direction
            if (playerTurn == 0) %npc   
                switch board(row,j)
                    case 0
                        if j==col-1
                            stateL=0;
                            jump=1;
                        else
                            stateL=1;
                            jump=1;
                        end % case 0
                    case 1
                        if j==1
                            stateL=0;
                            jump=1;
                        end % case 1
                    case 2
                        stateL = 0;
                        jump=1;
                end % switch 0
            elseif (playerTurn == 1)
                switch board(row,j)
                    case 0
                        if j==1
                            stateL=0;
                            jump=1;
                        end % case 0
                    case 1
                        if j==col-1
                            stateL=0;
                            jump=1;
                        else
                            stateL=1;
                            jump=1;
                        end % case 1
                    case 2
                        stateL=0;
                        jump=1;
                end % switch 1
            end % if playerTurn
            if jump
                jump=0;
                break;
            end % if jump
            end % for loop
        end % if left 
        
        if stateL
            state=stateL;
        end % stateL
        
        if state==0&&row<7
            for i=row+1:1:8 % down vertical direction
            if (playerTurn == 0)    
                switch board(i,col)
                    case 0
                        if i==row+1
                            stateD=0;
                            jump=1;
                        else
                            stateD=1;
                            jump=1;
                        end % case 0
                    case 1
                        if i==8
                            stateD=0;
                            jump=1;
                        end % case 1
                    case 2
                        stateD=0;
                        jump=1;
                end % switch 0
            elseif (playerTurn == 1)
                switch board(i,col)
                    case 0
                        if i==8
                            stateD=0;
                            jump=1;
                        end % case 0
                    case 1
                        if i==row+1
                            stateD=0;
                            jump=1;
                        else
                            stateD=1;
                            jump=1;
                        end % case 1
                    case 2
                        stateD=0;
                        jump=1;
                end % switch 0
            end % if playerTurn
            if jump
                jump=0;
                break;
            end % if jump
            end % for loop
        end % if down
        
        if stateD
            state=stateD;
        end % stateD
        
        if state==0&&row>2
            for i=row-1:-1:1 % up vertical direction
            if (playerTurn == 0)    
                switch board(i,col)
                    case 0
                        if i==row-1
                            stateU=0;
                            jump=1;
                        else
                            stateU=1;
                            jump=1;
                        end % case 0
                    case 1
                        if i==1
                            stateU=0;
                            jump=1;
                        end % case 1
                    case 2
                        stateU=0;
                        jump=1;
                end % end switch playerTurn 0
            elseif (playerTurn == 1)
                switch board(i,col)
                    case 0
                        if i==1
                            stateU=0;
                            jump=1;
                        end % case 0
                    case 1
                        if i==row-1
                            stateU=0;
                            jump=1;
                        else
                            stateU=1;
                            jump=1;
                        end % case 1
                    case 2
                        stateU=0;
                        jump=1;
                end % end switch playerTurn 1
            end % end if-else statement
            if jump
                jump=0;
                break;
            end % if jump
            end % end for i loop
        end % if up
        
        if stateU
            state=stateU;
        end % stateU
        
        if state==0&&col<7&&row<7
            j=col;
            for i=row+1:1:8 % down-right direction
            j=j+1;
            if j>8||i>8
                break;
            end % if j>8||i>8
            if (playerTurn == 0)    
                switch board(i,j)
                    case 0
                        if i==row+1&&j==col+1
                            stateDR=0;
                            jump=1;
                        else
                            stateDR=1;
                            jump=1;
                        end % case 0
                    case 1
                        if j==8||i==8
                            stateDR=0;
                            jump=1;
                        end % case 1
                    case 2
                        stateDR=0;
                        jump=1;
                end % end switch playerTurn 0
            elseif (playerTurn == 1)
                switch board(i,j)
                    case 0
                        if j==8||i==8
                            stateDR=0;
                            jump=1;
                        end % case 0
                    case 1
                        if i==row+1&&j==col+1
                            stateDR=0;
                            jump=1;
                        else
                            stateDR=1;
                            jump=1;
                        end % case 1
                    case 2
                        stateDR=0;
                        jump=1;
                end % end switch playerTurn 1
            end % end if-else statement
            if jump
                jump=0;
                break;
            end % if jump
            end % end for i loop
        end % if down-right
        
        if stateDR
            state=stateDR;
        end % stateDR
        
        if state==0&&col>2&&row<7
            j=col;
            for i=row+1:1:8 % down-left direction
            j=j-1;
            if j<1||i>8
                break;
            end % if j<1||i>8
            if (playerTurn == 0)    
                switch board(i,j)
                    case 0
                        if i==row+1&&j==col-1
                            stateDL=0;
                            jump=1;
                        else
                            stateDL=1;
                            jump=1;
                        end % case 0
                    case 1
                        if j==1||i==8
                            stateDL=0;
                            jump=1;
                        end % case 1
                    case 2
                        stateDL=0;
                        jump=1;
                end % end switch playerTurn 0
            elseif (playerTurn == 1)
                switch board(i,j)
                    case 0
                        if j==1||i==8
                            stateDL=0;
                            jump=1;
                        end % case 0
                    case 1
                        if i==row+1&&j==col-1
                            stateDL=0;
                            jump=1;
                        else
                            stateDL=1;
                            jump=1;
                        end % case 1
                    case 2
                        stateDL=0;
                        jump=1;
                end % switch 1
            end % if playerTurn
            if jump
                jump=0;
                break;
            end % if jump
            end % for loop
        end % if down-left
        
        if stateDL
            state=stateDL;
        end % stateDL
        
        if state==0&&col<7&&row>2
            j=col;
            for i=row-1:-1:1 % up-right direction
            j=j+1;
            if j>8||i<1
                break;
            end % if j>8||i<1
            if (playerTurn == 0)    
                switch board(i,j)
                    case 0
                        if i==row-1&&j==col+1
                            stateUR=0;
                            jump=1;
                        else
                            stateUR=1;
                            jump=1;
                        end % case 0
                    case 1
                        if j==8||i==1
                            stateUR=0;
                            jump=1;
                        end % case 1
                    case 2
                        stateUR=0;
                        jump=1;
                end % end switch playerTurn 0
            elseif (playerTurn == 1)
                switch board(i,j)
                    case 0
                        if j==8||i==1
                            stateUR=0;
                            jump=1;
                        end % case 0
                    case 1
                        if i==row-1&&j==col+1
                            stateUR=0;
                            jump=1;
                        else
                            stateUR=1;
                            jump=1;
                        end % case 1
                    case 2
                        stateUR=0;
                        jump=1;
                end % end switch playerTurn 1
            end % end if-else statement
            if jump
                jump=0;
                break;
            end % if jump
            end % end for i loop
        end % end if up-right
        
        if stateUR
            state=stateUR;
        end
        
        if state==0&&col>2&&row>2
            j=col;
            for i=row-1:-1:1 % up-left direction
            j=j-1;
            if j<1||i<1
                break;
            end % if j<1||i<1
            if (playerTurn == 0)    
                switch board(i,j)
                    case 0
                        if i==row-1&&j==col-1
                            stateUL=0;
                            jump=1;
                        else
                            stateUL=1;
                            jump=1;
                        end % case 0
                    case 1
                        if j==1||i==1
                            stateUL=0;
                            jump=1;
                        end % case 1
                    case 2
                        stateUL=0;
                        jump=1;
                end % end switch playerTurn 0
            elseif (playerTurn == 1)
                switch board(i,j)
                    case 0
                        if j==1||i==1
                            stateUL=0;
                            jump=1;
                        end % case 0
                    case 1
                        if i==row-1&&j==col-1
                            stateUL=0;
                            jump=1;
                        else
                            stateUL=1;
                            jump=1;
                        end % case 1
                    case 2
                        stateUL=0;
                        jump=1;
                end % end switch playerTurn 1
            end % end if-else statement  
            if jump
                jump=0;
                break;
            end % if jump
            end % end for i loop
        end % if up-left
        
        if stateUL
            state=stateUL;
        end % stateUL
            
        
    end % if board 2
end % end valid_check

function board_flip_output=flipping_disc(board,row,col,playerTurn) %Player=1 NPC=0
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    jump=0; %initialization
    flip_number=0;
    flip_disc=[];
    
    previous_disc=flip_disc;
    previous_number=flip_number;
    if col<7
        for j=col+1:1:8 % right horizontal direction
        if (playerTurn == 0)    
            switch board(row,j)
                case 0
                    jump=1;
                case 1
                    if j<8
                        flip_number=flip_number+1;
                        flip_disc(flip_number,1)=row;
                        flip_disc(flip_number,2)=j;
                    else
                        flip_disc=previous_disc;
                        flip_number=previous_number;
                        jump=1;
                    end % case 1
                case 2
                    flip_disc=previous_disc;
                    flip_number=previous_number;
                    jump=1;
            end % end switch playerTurn 0
        elseif (playerTurn == 1)
            switch board(row,j)
                case 0
                    if j<8
                        flip_number=flip_number+1;
                        flip_disc(flip_number,1)=row;
                        flip_disc(flip_number,2)=j;
                    else
                        flip_disc=previous_disc;
                        flip_number=previous_number;
                        jump=1;
                    end % case 0
                case 1
                    jump=1;
                case 2
                    flip_disc=previous_disc;
                    flip_number=previous_number;
                    jump=1;
            end % end switch playerTurn 1
        end % end if-else statement  
        if jump
            jump=0;
            break;
        end % if jump
        end  % end for j loop
    end % if right
    
    previous_disc=flip_disc;
    previous_number=flip_number;
    if col>2
        for j=col-1:-1:1 % left horizontal direction
        if (playerTurn == 0)    
            switch board(row,j)
                case 0
                    jump=1;
                case 1
                    if j>1
                        flip_number=flip_number+1;
                        flip_disc(flip_number,1)=row;
                        flip_disc(flip_number,2)=j;
                    else
                        flip_disc=previous_disc;
                        flip_number=previous_number;
                        jump=1;
                    end % case 1
                case 2
                    flip_disc=previous_disc; %cancel previous flipping actions
                    flip_number=previous_number;
                    jump=1;
            end % end switch playerTurn 0
        elseif (playerTurn == 1)
            switch board(row,j)
                case 0
                    if j>1
                        flip_number=flip_number+1;
                        flip_disc(flip_number,1)=row;
                        flip_disc(flip_number,2)=j;
                    else
                        flip_disc=previous_disc;
                        flip_number=previous_number;
                        jump=1;
                    end % case 0
                case 1
                    jump=1;
                case 2
                    flip_disc=previous_disc;
                    flip_number=previous_number;
                    jump=1;
            end % end switch playerTurn 1
        end % end if-else statement
        if jump
            jump=0;
            break;
        end % if jump
        end % end for j loop
    end % if left
    
    previous_disc=flip_disc;
    previous_number=flip_number;
    if row<7
        for i=row+1:1:8 % down vertical direction
        if (playerTurn == 0)    
            switch board(i,col)
                case 0
                    jump=1;
                case 1
                    if i<8
                        flip_number=flip_number+1;
                        flip_disc(flip_number,1)=i;
                        flip_disc(flip_number,2)=col;
                    else
                        flip_disc=previous_disc;
                        flip_number=previous_number;
                        jump=1;
                    end % case 1
                case 2
                    flip_disc=previous_disc;
                    flip_number=previous_number;
                    jump=1;
            end % end switch playerTurn 0
        elseif (playerTurn == 1)
            switch board(i,col)
                case 0
                    if i<8
                        flip_number=flip_number+1;
                        flip_disc(flip_number,1)=i;
                        flip_disc(flip_number,2)=col;
                    else
                        flip_disc=previous_disc;
                        flip_number=previous_number;
                        jump=1;
                    end % case 0
                case 1
                    jump=1;
                case 2
                    flip_disc=previous_disc;
                    flip_number=previous_number;
                    jump=1;
            end % end switch playerTurn 1
        end % end if-else statement
        if jump
            jump=0;
            break;
        end % if jump
        end % end for i loop
    end % if down
    
    previous_disc=flip_disc; %save previous board
    previous_number=flip_number;
    if row>2
        for i=row-1:-1:1 % up vertical direction
        if (playerTurn == 0)    
            switch board(i,col)
                case 0
                    jump=1;
                case 1
                    if i>1
                        flip_number=flip_number+1;
                        flip_disc(flip_number,1)=i;
                        flip_disc(flip_number,2)=col;
                    else
                        flip_disc=previous_disc;
                        flip_number=previous_number;
                        jump=1;
                    end % case 1
                case 2
                    flip_state=previous_disc;
                    flip_number=previous_number;
                    jump=1;
            end % end switch playerTurn 0
        elseif (playerTurn == 1)
            switch board(i,col)
                case 0
                    if i>1
                        flip_number=flip_number+1;
                        flip_disc(flip_number,1)=i;
                        flip_disc(flip_number,2)=col;
                    else
                        flip_disc=previous_disc;
                        flip_number=previous_number;
                        jump=1;
                    end % case 0
                case 1
                    jump=1;
                case 2
                    flip_disc=previous_disc;
                    flip_number=previous_number;
                    jump=1;
            end % end switch playerTurn 1
        end % end if-else statement
        if jump
            jump=0;
            break;
        end % if jump
        end % end for i loop
    end % if up
    
    previous_disc=flip_disc;
    previous_number=flip_number;
    if col<7&&row<7
        j=col;
        for i=row+1:1:8 % down-right direction
        j=j+1; 
        if j>8||i>8
            break;
        end % if j>8||i>8
        if (playerTurn == 0)    
            switch board(i,j)
                case 0
                    jump=1;
                case 1
                    if i<8&&j<8
                        flip_number=flip_number+1;
                        flip_disc(flip_number,1)=i;
                        flip_disc(flip_number,2)=j;
                    else
                        flip_disc=previous_disc;
                        flip_number=previous_number;
                        jump=1;
                    end % case 1
                case 2
                    flip_disc=previous_disc;
                    flip_number=previous_number;
                    jump=1;
            end % end switch playerTurn 0
        elseif (playerTurn == 1)
            switch board(i,j)
                case 0
                    if i<8&&j<8
                        flip_number=flip_number+1;
                        flip_disc(flip_number,1)=i;
                        flip_disc(flip_number,2)=j;
                    else
                        flip_disc=previous_disc;
                        flip_number=previous_number;
                        jump=1;
                    end % case 0
                case 1
                    jump=1;
                case 2
                    flip_disc=previous_disc;
                    flip_number=previous_number;
                    jump=1;
            end % end switch playerTurn 1
        end % end if-else statement  
        if jump
            jump=0;
            break;
        end % if jump
        end % end for i loop
    end % if down-right 
    
    previous_disc=flip_disc;
    previous_number=flip_number;
    if col>2&&row<7
        j=col;
        for i=row+1:1:8 % down-left direction
        j=j-1;
        if j<1||i>8
            break;
        end % if j<1
        if (playerTurn == 0)    
            switch board(i,j)
                case 0
                    jump=1;
                case 1
                    if i<8&&j>1
                        flip_number=flip_number+1;
                        flip_disc(flip_number,1)=i;
                        flip_disc(flip_number,2)=j;
                    else
                        flip_disc=previous_disc;
                        flip_number=previous_number;
                        jump=1;
                    end % case 1
                case 2
                    flip_disc=previous_disc;
                    flip_number=previous_number;
                    jump=1;
            end % end switch playerTurn 0
        elseif (playerTurn == 1)
            switch board(i,j)
                case 0
                    if i<8&&j>1
                        flip_number=flip_number+1;
                        flip_disc(flip_number,1)=i;
                        flip_disc(flip_number,2)=j;
                    else
                        flip_disc=previous_disc;
                        flip_number=previous_number;
                        jump=1;
                    end % case 0
                case 1
                    jump=1;
                case 2
                    flip_disc=previous_disc;
                    flip_number=previous_number;
                    jump=1;
            end % end switch playerTurn 1
         end % end if-else statement  
         if jump
            jump=0;
            break;
         end % if jump
        end % end for i loop
    end % if down-left
    
    previous_disc=flip_disc;
    previous_number=flip_number;
    if col<7&&row>2
        j=col;
        for i=row-1:-1:1 % up-right direction
        j=j+1;
        if j>8||i<1
            break;
        end % if j>8||i<1
        if (playerTurn == 0)    
            switch board(i,j)
                case 0
                    jump=1;
                case 1
                    if i>1&&j<8
                        flip_number=flip_number+1;
                        flip_disc(flip_number,1)=i;
                        flip_disc(flip_number,2)=j;
                    else
                        flip_disc=previous_disc;
                        flip_number=previous_number;
                        jump=1;
                    end % case 1
                case 2
                    flip_disc=previous_disc;
                    flip_number=previous_number;
                    jump=1;
            end % end switch playerTurn 0
        elseif (playerTurn == 1)
            switch board(i,j)
                case 0
                    if i<8
                        flip_number=flip_number+1;
                        flip_disc(flip_number,1)=i;
                        flip_disc(flip_number,2)=j;
                    else
                        flip_disc=previous_disc;
                        flip_number=previous_number;
                        jump=1;
                    end % case 0
                case 1
                    jump=1;
                case 2
                    flip_disc=previous_disc;
                    flip_number=previous_number;
                    jump=1;
            end % end switch playerTurn 1
        end % end if-else statement  
        if jump
            jump=0;
            break;
        end % if jump
        end % end for i loop
    end % if up-right
    
    previous_disc=flip_disc;
    previous_number=flip_number;
    if col>2&&row>2
        j=col;
        for i=row-1:-1:1 % up-left direction
        j=j-1;
        if j<1||i<1
            break;
        end % if j<1||i<1
        if (playerTurn == 0)    
            switch board(i,j)
                case 0
                    jump=1;
                case 1
                    if i>1&&j>1
                        flip_number=flip_number+1;
                        flip_disc(flip_number,1)=i;
                        flip_disc(flip_number,2)=j;
                    else
                        flip_disc=previous_disc;
                        flip_number=previous_number;
                        jump=1;
                    end % case 1
                case 2
                    flip_disc=previous_disc;
                    flip_number=previous_number;
                    jump=1;
             end % end switch playerTurn 0
        elseif (playerTurn == 1)
            switch board(i,j)
                case 0
                    if i>1&&j>1
                        flip_number=flip_number+1;
                        flip_disc(flip_number,1)=i;
                        flip_disc(flip_number,2)=j;
                    else
                        flip_disc=previous_disc;
                        flip_number=previous_number;
                        jump=1;
                    end % case 0
                case 1
                    jump=1;
                case 2
                    flip_disc=previous_disc;
                    flip_number=previous_number;
                    jump=1;
            end % end switch playerTurn 1
        end % end if-else statement  
        if jump
            break;
        end % if jump
        end % end for i loop
    end % if up-left
    
    %FOR DEGUBBING
    fprintf("\n%d %d\n",row,col);
    %END
    
    if playerTurn&&flip_number>0
        for i=1:1:flip_number
            if flip_disc(i,1)~=0&&flip_disc(i,2)~=0
                board(flip_disc(i,1),flip_disc(i,2))=1;
            end % if flip_disc
        end % for loop
    elseif ~playerTurn&&flip_number>0
        for i=1:1:flip_number
            if flip_disc(i,1)~=0&&flip_disc(i,2)~=0
                board(flip_disc(i,1),flip_disc(i,2))=0;
            end % if flip_disc
        end % for loop
    end % if playerTurn
    
    board_flip_output=board;
end % flipping_disc

function board_output=npc_step(board)
    state=0;
    jump=0;
%     for i=1:1:8
%         for j=1:1:8
%             if board(i,j)==0
%                 npc_number=npc_number+1;
%                 npc_point(npc_number,1)=i; %find row
%                 npc_point(npc_number,2)=j; %find column
%             end
%         end
%     end



    for x=1:1:8 %search the first valid coordinate
        for y=1:1:8
            state=validity_check(board,x,y,0);
            if state
                board(x,y)=0;
                fprintf("Valid point found:%d %d\n",x,y);
                board=flipping_disc(board,x,y,0);
                jump=1;
            end % if state
            if jump
                break;
            end % if jump
        end % for loop y
        if jump
            jump=0;
            break;
        end % if jump
    end % for loop x
    
    board_output=board;
            
end % npc_step

function [state,black_number,white_number]=counter(board)
    black_number=0;
    white_number=0;
    total_number=0;
    validity_state=1;
    for a=1:1:8
        for b=1:1:8
            if board(a,b)==1
                validity_state=validity_check(board,a,b,1);
                black_number=black_number+1;
                total_number=total_number+1;
            elseif board(a,b)==0
                validity_state=validity_check(board,a,b,0);
                white_number=white_number+1;
                total_number=total_number+1;
            end % if board 1
        end % for loop b
    end % for loop a
    if total_number==64
        state=0;
    else
        state=1;
    end % if total_number 64
end % counter