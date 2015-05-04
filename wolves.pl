/***************************************************************************
*    
*   
*
*   Lorenzo Luciano
*   
*
*******************************************************************************/

/************************************************************
*
* To Begin playing  game:
* 
* us. To begin game, user goes first, as sheep
*
* uw. To begin game, user goes first, as wolves
*
* cs. To begin game, computer goes first as sheep.
*
* cw. To begin game, computer goes first as wolves.
*
**************************************************************/


% which player?
player(state(_,s,_,_),s).
player(state(_,w,_,_),w).


% addToList(): adds Item to List
addToList([],Item,[Item]).
addToList([Head|Tail],Item,[Item,Head|Tail]) :-
  Item =< Head.
addToList([Head|Tail],Item,[Head|NewTail]) :-
  Item > Head,
  addToList(Tail,Item,NewTail).

delFromList(Item,[Item|Tail],Tail).
delFromList(Item,[Head|Tail],[Head|R]):-
	delFromList(Item,Tail,R).


% *** Gets Wolf Number ***
getWolfNo(Number,[W1,W2,W3,W4],1) :- Number = W1.
getWolfNo(Number,[W1,W2,W3,W4],2) :- Number = W2.
getWolfNo(Number,[W1,W2,W3,W4],3) :- Number = W3.
getWolfNo(Number,[W1,W2,W3,W4],4) :- Number = W4.

% *** Gets Wolf Position ***
getWolfPos(WolfNo,[W1,W2,W3,W4],W1) :- WolfNo = 1.
getWolfPos(WolfNo,[W1,W2,W3,W4],W2) :- WolfNo = 2.
getWolfPos(WolfNo,[W1,W2,W3,W4],W3) :- WolfNo = 3.
getWolfPos(WolfNo,[W1,W2,W3,W4],W4) :- WolfNo = 4.
 
 
/*******************************************************************************
 * Display Game Board/State
 * displays 8x8 game board 
 *   
 *********************************************************************************/

displayState(state(_,_,Slist,Wlist)) :-
  write('     a   b   c   d   e   f   g   h  \n'),
  write('   ---------------------------------\n'),
  write('8'),
  displayRow(1,Slist,Wlist),
  write('   ---------------------------------\n'),
  write('7'),
  displayRow(9,Slist,Wlist),
  write('   ---------------------------------\n'),
  write('6'),
  displayRow(17,Slist,Wlist),
  write('   ---------------------------------\n'),
  write('5'),
  displayRow(25,Slist,Wlist),
  write('   ---------------------------------\n'),
  write('4'),
  displayRow(33,Slist,Wlist),
  write('   ---------------------------------\n'),
  write('3'),
  displayRow(41,Slist,Wlist),
  write('   ---------------------------------\n'),
  write('2'),
  displayRow(49,Slist,Wlist),
  write('   ---------------------------------\n'),
  write('1'),
  displayRow(57,Slist,Wlist),
  write('   ---------------------------------\n').
    
% displayRow(+Start, +Slist, +Wlist):
% Start is the first square of the row
displayRow(Start, Slist, Wlist) :-
  tab(2), % looks better if it's indented a bit
  write('|'),
  displaySquare(Start, Slist, Wlist),
  write('|'),
  Second is Start+1,
  displaySquare(Second, Slist, Wlist),
  write('|'),
  Third is Second+1,
  displaySquare(Third, Slist, Wlist),
  write('|'),
  Forth is Third+1,
  displaySquare(Forth, Slist, Wlist),
  write('|'),
  Fifth is Forth+1,
  displaySquare(Fifth, Slist, Wlist),
  write('|'),
  Sixth is Fifth+1,
  displaySquare(Sixth, Slist, Wlist),
  write('|'),
  Seventh is Sixth+1,
  displaySquare(Seventh, Slist, Wlist),
  write('|'),
  Eight is Seventh+1,
  displaySquare(Eight, Slist, Wlist),
  write('|'),
  nl.
  

% *** display 'S' if Sheep position ***
displaySquare(Number, Slist, _) :-
  member(Number, Slist),
  !,
  write(' S ').

% *** display 'W' if Wolf position ***
displaySquare(Number, _, Wlist) :-
  member(Number, Wlist),
  !,
  getWolfNo(Number,Wlist,WolfNumber),
  write(' W'),
  write(WolfNumber).
  
% *** display '?' if grey square on(no move allowed) ***
displaySquare(Number, Slist, _) :-
  not(member(Number,[2,4,6,8,9,11,13,15,18,20,22,24,25,27,29,31,34,36,38,40,41,43,45,47,50,52,54,56,57,59,61,63])),
  !,
  write('---').
  
%***** display blank square on board ***********  
displaySquare(_, _, _) :-
  write('  '),
  tab(1).
  
  
  

/*******************************************************************
 *  Evaluate "End of Game" states.
 *  
 *  2 = Sheep wins
 *  1 = Wolves win
 * 
 *********************************************************************/

terminal(state(_,_,[H|T],_),2) :-
  member(H,[57,59,61,63]),
  !.  

terminal(state(_,_,[SheepPos|T],Wlist),1) :-
  TopLeftPos is SheepPos - 9, 
  checkForWolf(TopLeftPos, Wlist),
  TopRightPos is SheepPos-7, 
  checkForWolf(TopRightPos, Wlist),
  BotLeftPos is SheepPos+7, 
  checkForWolf(BotLeftPos, Wlist),
  BotRightPos is SheepPos+9, 
  checkForWolf(BotRightPos, Wlist),
  !.

% *** check if wolf exists in blocking position ***
checkForWolf(Pos,Wlist) :-
  member(Pos,Wlist),
  !.
  
% *** check if out of range(top) ***  
checkForWolf(Pos,_) :-
  Pos < 2,
  !.

% *** check if out of range(bottom) ***  
checkForWolf(Pos,_) :-
  Pos > 63,
  !.
  
% *** check if out of range(sides) ***  
checkForWolf(Pos,_) :-
  not(member(Pos,[2,4,6,8,9,11,13,15,18,20,22,24,25,27,29,31,34,36,38,40,41,43,45,47,50,52,54,56,57,59,61,63])),
  !.

/***********************************************************************
*  Evaluate a State
*
*
*
************************************************************************/

evaluateState(state(_,_,[H|T],Wlist),Result) :-
   
   Pos is H,  % sheep's position
  
   
   wolfPos(Result1,Wlist),  % check if valid state
  
   
   evalSheep1(Pos,Result2,Wlist),  % evaluate state, based on sheep position
 
   
   getResult(Result,Result1, Result2).
   
    
     
%****** end evaluateState() ***********************
    
    
    getResult(Result,Result1,Result2) :-
      Result1 = -999,
      !,
      Result is -999.
    getResult(Result,Result1,Result2) :-
      Result is Result2.
   
   
   
   wolfPos(Result,[W1,W2,W3,W4]) :-
      not(member(W1,[2,4,6,8,9,11,13,15,18,20,22,24,25,27,29,31,34,36,38,40,41,43,45,47,50,52,54,56,57,59,61,63])),
      !,
      Result is -999.
   wolfPos(Result,[W1,W2,W3,W4]) :-
      not(member(W2,[2,4,6,8,9,11,13,15,18,20,22,24,25,27,29,31,34,36,38,40,41,43,45,47,50,52,54,56,57,59,61,63])),
      !,
      Result is -999.   
   wolfPos(Result,[W1,W2,W3,W4]) :-
      not(member(W3,[2,4,6,8,9,11,13,15,18,20,22,24,25,27,29,31,34,36,38,40,41,43,45,47,50,52,54,56,57,59,61,63])),
      !,
      Result is -999.   
   wolfPos(Result,[W1,W2,W3,W4]) :-
      not(member(W4,[2,4,6,8,9,11,13,15,18,20,22,24,25,27,29,31,34,36,38,40,41,43,45,47,50,52,54,56,57,59,61,63])),
      !,
      Result is -999.   
   wolfPos(Result[W1,W2,W3,W4]) :-
      member(W1,[W2,W3,W4]),
      !,
      Result is -999.
   wolfPos(Result[W1,W2,W3,W4]) :-
      member(W2,[W1,W3,W4]),
      !,
      Result is -999.   
   wolfPos(Result[W1,W2,W3,W4]) :-
      member(W3,[W1,W2,W4]),
      !,
      Result is -999.  
   wolfPos(Result[W1,W2,W3,W4]) :-
      member(W4,[W1,W2,W3]),
      !,
      Result is -999.   
   wolfPos(Result,[W1,W2,W3,W4]) :-
      Result is 1.
        
   
          
   % *************************************************************************
   % *** evaluate Sheep Positon **********************************************
   %**************************************************************************
  
   % ***  New Pos Off Grid *****
   evalSheep1(Pos,Result,_) :-
     not(member(Pos,[2,4,6,8,9,11,13,15,18,20,22,24,25,27,29,31,34,36,38,40,41,43,45,47,50,52,54,56,57,59,61,63])),
     !,
     Result is -999.
     
     
   % *** New Pos occupied by a Wolf ***
   evalSheep1(Pos,Result,Wlist) :-
       member(Pos,Wlist),
       !,
       Result is -999.
       
   
   % *** Eval New Pos ***
   evalSheep1(Pos,Result,Wlist) :-
      StepsToBottom is (64-Pos)/8,
      numWolves1(WolfCount,Pos,Wlist),
      Result is (4-WolfCount)-StepsToBottom.
   
   %*******************************************************************************
   
   
   %*******************************************************************
   % **** Count number of Wolves surrounding Sheep ***
   numWolves1(WolfCount,Pos,Wlist) :-
     TopLeftPos is Pos - 9, 
     ifWolf1(TopLeftPos,Result1,Wlist),
     TopRightPos is Pos-7, 
     ifWolf1(TopRightPos,Result2,Wlist),
     BotLeftPos is Pos+7, 
     ifWolf1(BotLeftPos,Result3,Wlist),
     BotRightPos is Pos+9, 
     ifWolf1(BotRightPos,Result4,Wlist),
     WolfCount is Result1+Result2+Result3+Result4.
     
      
   ifWolf1(Pos,Result,Wlist) :-
     not(member(Pos,[2,4,6,8,9,11,13,15,18,20,22,24,25,27,29,31,34,36,38,40,41,43,45,47,50,52,54,56,57,59,61,63])),
     !,
     Result is 1.
     
   ifWolf1(Pos,Result,Wlist) :-
     member(Pos, Wlist),
     !,
     Result is 1.
     
   ifWolf1(Pos,Result,Wlist) :-
     !,
     Result is 0.
   %***********************************************************  






/************************************************************************
 * Computer Move.
 * 
 * 
 ************************************************************************/

 %*** Computer's Move and Sheep's Turn *************
 computer_move(state(X,Y,[H|T],Wlist),state(u,w,[NewPos|T],Wlist)) :-
   Y = 's',  % if sheep's turn
   !,
   
   Temp1 is H-9,   
   evaluateState(state(X,Y,[Temp1|T],Wlist),Result1),
   write(Result1),nl,
  
   Temp2 is H-7,
   evaluateState(state(X,Y,[Temp2|T],Wlist),Result2),
   write(Result2),nl,
    
   Temp3 is H+7,
   evaluateState(state(X,Y,[Temp3|T],Wlist),Result3),
   write(Result3),nl,
   
   Temp4 is H+9, 
   evaluateState(state(X,Y,[Temp4|T],Wlist),Result4),
   write(Result4),nl,
   
   
   getBestMove(NewPos,H,Result1,Result2,Result3,Result4),
   
   write(NewPos),nl.
   
%****** end computer_move() ***********************
   
   
      
   getBestMove(NewPos,Pos,Result1,Result2,Result3,Result4) :-
     Result1>Result2,
     Result1>Result3,
     Result1>Result4,
     !,
     NewPos is Pos - 9.
     
   getBestMove(NewPos,Pos,Result1,Result2,Result3,Result4) :-
     Result2>Result3,
     Result2>Result4,
     !,
     NewPos is Pos - 7.
  
   getBestMove(NewPos,Pos,Result1,Result2,Result3,Result4) :-
     Result3>Result4,
     !,
     NewPos is Pos + 7.
     
   getBestMove(NewPos,Pos,Result1,Result2,Result3,Result4) :-
     NewPos is Pos + 9.
  
  
  
  
  /*
      
     getBestMove(NewPos,Pos,Result1,Result2,Result3,Result4,Wlist) :-
       Result1 = -999,
       Result2 = -999,
       Result3 = -999,
       Result4 = -999,
       getLegalMove(NewPos,Pos,Wlist).
   
  
  
   getLegalMove(NewPos,Pos,Wlist) :-
     NewPos is Pos - 9,
     member(NewPos,[2,4,6,8,9,11,13,15,18,20,22,24,25,27,29,31,34,36,38,40,41,43,45,47,50,52,54,56,57,59,61,63]),
     not(member(NewPos, Wlist)),
     !.
     
   getLegalMove(NewPos,Pos,Wlist) :-
     NewPos is Pos - 7,
     member(NewPos,[2,4,6,8,9,11,13,15,18,20,22,24,25,27,29,31,34,36,38,40,41,43,45,47,50,52,54,56,57,59,61,63]),
     not(member(NewPos, Wlist)),
     !.
  
   getLegalMove(NewPos,Pos,Wlist) :-
     NewPos is Pos + 7,
     member(NewPos,[2,4,6,8,9,11,13,15,18,20,22,24,25,27,29,31,34,36,38,40,41,43,45,47,50,52,54,56,57,59,61,63]),
     not(member(NewPos, Wlist)),
     !.
  
   getLegalMove(NewPos,Pos,Wlist) :-
     NewPos is Pos + 9,
     member(NewPos,[2,4,6,8,9,11,13,15,18,20,22,24,25,27,29,31,34,36,38,40,41,43,45,47,50,52,54,56,57,59,61,63]),
     not(member(NewPos, Wlist)),
     !.
    
  */
   


 
%******************************************************************************************** 
 %***Computer's Move and Wolve's Turn **************
 
 computer_move(state(X,Y,[H|T],[W1,W2,W3,W4|T]),state(u,s,[H|T],[NewW1,NewW2,NewW3,NewW4|T])) :-
  
     Y = 'w',  % if wolve's turn
     !,
    
      
        write(W1),nl,
        write(W2),nl,
        write(W3),nl,
        write(W4),nl,nl,
       
 
     
    % *** Wolf1 ***        
    Temp1a is W1-9,
    evaluateState(state(X,Y,[H|T],[Temp1a,W2,W3,W4|T]),Result1a),
    
      
    Temp2a is W1-7,
    evaluateState(state(X,Y,[H|T],[Temp2a,W2,W3,W4|T]),Result2a),
    
  
    Temp3a is W1+7, 
    evaluateState(state(X,Y,[H|T],[Temp3a,W2,W3,W4|T]),Result3a),
   
    
    Temp4a is W1+9,         
    evaluateState(state(X,Y,[H|T],[Temp4a,W2,W3,W4|T]),Result4a),
   
    
    % *** Wolf2 ***
    Temp1b is W2-9,
    evaluateState(state(X,Y,[H|T],[W1,Temp1b,W3,W4|T]),Result1b),
    
            
    Temp2b is W2-7,        
    evaluateState(state(X,Y,[H|T],[W1,Temp2b,W3,W4|T]),Result2b),
    
    
    Temp3b is W2+7, 
    evaluateState(state(X,Y,[H|T],[W1,Temp3b,W3,W4|T]),Result3b),
    
    
    Temp4b is W2+9, 
    evaluateState(state(X,Y,[H|T],[W1,Temp4b,W3,W4|T]),Result4b),
   
    
    % *** Wolf3 ***
    Temp1c is W3-9,
    evaluateState(state(X,Y,[H|T],[W1,W2,Temp1c,W4|T]),Result1c),
   
                
    Temp2c is W3-7,            
    evaluateState(state(X,Y,[H|T],[W1,W2,Temp2c,W4|T]),Result2c),
    
    Temp3c is W3+7, 
    evaluateState(state(X,Y,[H|T],[W1,W2,Temp3c,W4|T]),Result3c),
    
    Temp4c is W3+9, 
    evaluateState(state(X,Y,[H|T],[W1,W2,Temp4c,W4|T]),Result4c),
   
    
    % *** Wolf4 ***
    Temp1d is W4-9,
    evaluateState(state(X,Y,[H|T],[W1,W2,W3,Temp1d|T]),Result1d),
   
    Temp2d is W4-7,
    evaluateState(state(X,Y,[H|T],[W1,W2,W3,Temp2d|T]),Result2d),
    
    Temp3d is W4+7, 
    evaluateState(state(X,Y,[H|T],[W1,W2,W3,Temp3d|T]),Result3d),
    
    Temp4d is W4+9, 
    evaluateState(state(X,Y,[H|T],[W1,W2,W3,Temp4d|T]),Result4d),
   
        
      
    getHighest(NewPos1,W1,Resulta,Result1a,Result2a,Result3a,Result4a),
    getHighest(NewPos2,W2,Resultb,Result1b,Result2b,Result3b,Result4b),
    getHighest(NewPos3,W3,Resultc,Result1c,Result2c,Result3c,Result4c),
    getHighest(NewPos4,W4,Resultd,Result1d,Result2d,Result3d,Result4d),
    
    
    write(W1),nl,
    write(W2),nl,
    write(W3),nl,
    write(W4),nl,nl,
       
    write(NewPos1),nl,
    write(NewPos2),nl,
    write(NewPos3),nl,
    write(NewPos4),nl,
    
    
    getHighest1(W1,W2,W3,W4,NewPos1,NewPos2,NewPos3,NewPos4,NewW1,NewW2,NewW3,NewW4,Resulta,Resultb,Resultc,Resultd),
        
    write(NewW1),nl,
    write(NewW2),nl,
    write(NewW3),nl,
    write(NewW4),nl.
     
    
   
   
    getHighest(NewPos,Pos,Result,Result1,Result2,Result3,Result4) :-
       Result1>Result2,
       Result1>Result3,
       Result1>Result4,
       !,
       Result is Result1,
       NewPos is Pos - 9.
    getHighest(NewPos,Pos,Result,Result1,Result2,Result3,Result4) :-
       Result2>Result3,
       Result2>Result4,
       !,
       Result is Result2,
       NewPos is Pos - 7.   
    getHighest(NewPos,Pos,Result,Result1,Result2,Result3,Result4) :-
       Result3>Result4,
       !,
       Result is Result3,
       NewPos is Pos + 7.   
    getHighest(NewPos,Pos,Result,Result1,Result2,Result3,Result4) :-
       Result is Result4, 
       NewPos is Pos + 9.
    
  
    
     getHighest1(W1,W2,W3,W4,NewPos1,NewPos2,NewPos3,NewPos4,NewW1,NewW2,NewW3,NewW4,Resulta,Resultb,Resultc,Resultd) :-
       Resulta > Resultb,
       Resulta > Resultc,
       Resulta > Resultd,
       !,
       NewW1 is NewPos1,
       NewW2 is W2,
       NewW3 is W3,
       NewW4 is W4.
     getHighest1(W1,W2,W3,W4,NewPos1,NewPos2,NewPos3,NewPos4,NewW1,NewW2,NewW3,NewW4,Resulta,Resultb,Resultc,Resultd) :-
       Resultb > Resultc,
       Resultb > Resultd,
       !,
       NewW1 is W1,
       NewW2 is NewPos2,
       NewW3 is W3,
       NewW4 is W4.   
     getHighest1(W1,W2,W3,W4,NewPos1,NewPos2,NewPos3,NewPos4,NewW1,NewW2,NewW3,NewW4,Resulta,Resultb,Resultc,Resultd) :-
       Resultc > Resultd,
       !,
       NewW1 is W1,
       NewW2 is W2,
       NewW3 is NewPos3,
       NewW4 is W4.   
     getHighest1(W1,W2,W3,W4,NewPos1,NewPos2,NewPos3,NewPos4,NewW1,NewW2,NewW3,NewW4,Resulta,Resultb,Resultc,Resultd) :-
       NewW1 is W1,
       NewW2 is W2,
       NewW3 is W3,
       NewW4 is NewPos4.
    


/************************************************************************
 * I/O code to play the game.
 * 
 *
 ************************************************************************/

% play(State) starts play at the specified state and 
% continues until the game is won, lost or drawn.
reportEnding(2) :-
  write('Sheep Wins!!!\n').
reportEnding(1) :-
  write('Wolves Win!!!\n').
  
play(State) :-
  terminal(State,Value),
  !,
  reportEnding(Value).


play(state(X,Y,Slist,Wlist)) :-
  X ='c', % computer's turn
  !,
  write('checking for a move...\n'),
  computer_move(state(X,Y,Slist,Wlist),NewState),
   
  displayState(NewState),
  play(NewState).
  

  
play(State) :-
  % user's turn
  !,
  getPos(CurrPos,Pos,State,State1),
  makeMove(State1, CurrPos, Pos, NextState),
  displayState(NextState),
  play(NextState).
 
 
% **** Get Current Position of Sheep **** 
getPos(Pos,NewPos,state(_,X,[H|T],Wlist), state(_,X,T,Wlist)):-
   X = 's',  % sheep's turn
   write('\nSheep''s Turn\n'),
   Pos is H,
   getMove(Move),
   calMove(Move,Pos,NewPos,state(_,X,[H|T],Wlist)).

% **** Get Current Position of Wolf wish to move ****      
getPos(Pos,NewPos,state(Y,X,Slist,Wlist), state(_,X,Slist,NewWlist)):-
    X = 'w',   % wolf's turn
    write('*** Enter Number of Wolf you wish to move ***\n'),
    read(WolfNo),
    checkWolfNo(WolfNo,state(Y,X,Slist,Wlist)),
    getWolfPos(WolfNo,Wlist,Pos),
              
    getMove(Move),
    calMove(Move,Pos,NewPos,state(Y,X,Slist,Wlist)),
        
    delFromList(Pos,Wlist,NewWlist).
	
    
checkWolfNo(WolfNo,state(Y,X,Slist,Wlist)) :-
  WolfNo = 1,
  !.
checkWolfNo(WolfNo,state(Y,X,Slist,Wlist)) :-
  WolfNo = 2,
  !.
checkWolfNo(WolfNo,state(Y,X,Slist,Wlist)) :-
  WolfNo = 3,
  !.
checkWolfNo(WolfNo,state(Y,X,Slist,Wlist)) :-
  WolfNo = 4,
  !.
checkWolfNo(WolfNo,state(Y,X,Slist,Wlist)) :-
  write('Try Again! 1,2,3 or 4'),nl,
  play(state(Y,X,Slist,Wlist)).
    
    
   calRow(Row,0) :- Row = 8, !.
   calRow(Row,8) :- Row = 7, !.
   calRow(Row,16) :- Row = 6, !.
   calRow(Row,24) :- Row = 5, !.
   calRow(Row,32) :- Row = 4, !.
   calRow(Row,40) :- Row = 3, !.
   calRow(Row,48) :- Row = 2, !.
   calRow(Row,56).
   
   calCol(Col,1) :- Col = 'a', !.
   calCol(Col,2) :- Col = 'b', !.
   calCol(Col,3) :- Col = 'c', !.
   calCol(Col,4) :- Col = 'd', !.
   calCol(Col,5) :- Col = 'e', !.
   calCol(Col,6) :- Col = 'f', !.
   calCol(Col,7) :- Col = 'g', !.
   calCol(Col,8).
 
 
 getMove(Move) :-
   write('Enter Move - Use Keypad(followed by period)\n'),
   write('7->Top Left    9->Top Right   \n'),
   write('1->Bottom Left 3->Bottom Right\n'),
   read(Move).
      
      
 calMove(Move,Pos,NewPos,State) :-
   Move = 7,
   NewPos is Pos-9,
   !.
 calMove(Move,Pos,NewPos,State) :-
   Move = 9,
   NewPos is Pos-7,
   !.
 calMove(Move,Pos,NewPos,State) :-
   Move = 1,
   NewPos is Pos+7,
   !.
 calMove(Move,Pos,NewPos,State) :-
   Move = 3,
   NewPos is Pos+9,
   !.
 calMove(Move,Pos,NewPos,State) :-
   write('Try Again!'),
   play(State).
 
 
/******* Sheep's Move *********************/
makeMove(state(_,s,Slist,Wlist), _, Square, state(c,w,NewSlist,Wlist)) :-
  s = 's',  % if Sheep's turn
  member(Square,[2,4,6,8,9,11,13,15,18,20,22,24,25,27,29,31,34,36,38,40,41,43,45,47,50,52,54,56,57,59,61,63]),
  not(member(Square,Slist)),
  not(member(Square,Wlist)),
  !,
  addToList(Slist, Square, NewSlist).

/******* Wolf's Move *********************/  
makeMove(state(_,w,Slist,Wlist), _, Square, state(c,s,Slist,NewWlist)) :-
  w = 'w',   % if Wolf's turn
  member(Square,[2,4,6,8,9,11,13,15,18,20,22,24,25,27,29,31,34,36,38,40,41,43,45,47,50,52,54,56,57,59,61,63]),
  not(member(Square,Slist)),
  not(member(Square,Wlist)),
  !,
  addToList(Wlist, Square, NewWlist).


/***** Sheep Illegal Move ***********************/
makeMove(state(_,s,Slist,Wlist), CurrPos, Square, state(_,w,NewSlist,Wlist)) :-
  s = 's',  % if Sheep's turn
  !,
  write(' Illegal Move - Try Again!\n'),
  addToList(Slist, CurrPos, NewSlist),
  play(state(s,NewSlist,Wlist)).
  
 
/***** Wolves Illegal Move ***********************/
makeMove(state(_,w,Slist,Wlist), CurrPos, Square, state(_,s,Slist,NewWlist)) :-
  w = 'w',  % if Wolve's turn
  !,
  write(' Illegal Move - Try Again!\n'),
  addToList(Wlist, CurrPos, NewWlist),
  play(state(w,Slist,NewWlist)).
  


/*
/**** If Ilegal Move *********************/
makeMove(State1, _, _) :-
  write(' Illegal Move - Try Again!\n'),
  play(State1).
*/
  
/*******************************************************************
* Play Game
*
********************************************************************/

% user first, as sheep
us :-  
  displayAndPlay(state(u,s,[52],[57,59,61,63])).

% user first, as wolf
uw :-
  displayAndPlay(state(u,w,[52],[57,59,61,63])).

% computer first, as sheep  
cs :-  
  displayAndPlay(state(c,s,[52],[57,59,61,63])).

% computer first, as wolf
cw :-
  displayAndPlay(state(c,w,[52],[57,59,61,63])).
  

displayAndPlay(State) :-
  displayState(State),
  play(State).
  

