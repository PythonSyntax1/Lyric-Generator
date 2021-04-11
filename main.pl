%Reference : https://wiki.ubc.ca/Course:CPSC312-2019/ChomskySentenceGenerator. Our project is inspired by / based on the project linked here. 
%The code at these lines are inspired by, or based on the resource's code. (With permission granted by the repo owner) : 7-12, 122, 131, 153-217. 
%The details of the reference above are explained in comments above or at those line numbers. We refer to this project as "CSG" throughout the code for the references.

%Get user requirements with simple error handling, generate poem and then output the poem. Starting generator by getting user preference (7-12), inspired by CSG.
main:-
	write("How many lines would you like the lyrics to have? Enter 0 for random. \n"),
	read(Lines),
	write("How many words per line? Enter 0 for random, or a number between 5 - 7\n"),
	read(Size),
	write("Should the lyrics rhyme? Enter 'yes' or 'no'.\n"),
	read(Rhyme),
	lyrichandler(L, S, Rhyme, Ret),
	sizeInputHandler(Size, S),
	linesInputHandler(Lines, L),
	formatOutput(Ret).

%Error handling code from 20 - 70
%Handles the case where user enters 0 for a random amount of lines
linesInputHandler(0, L) :- random(1, 20, L).
%Handles case where user enters a specified amount of lines that fits the bounds. 
linesInputHandler(Lines, Lines) :- 
	number(Lines),
	Lines =\= 0,
	Lines < 101,
	Lines > 0. 

%Handles the case where there's too many lines requested
linesInputHandler(Lines, 100) :- 
	number(Lines),
	Lines > 100.

%Handles negative number case by returning a random number
linesInputHandler(Lines, L) :-
	number(Lines),
	Lines < 0,
	random(1, 20, L). 

%Handles case where user does not input number for lines
linesInputHandler(Lines, L) :-
	not(number(Lines)),
	random(1, 20, L).

%Handles the case where user enters between 5-7 for amount of words per line
sizeInputHandler(Size, Size) :- 
	number(Size),
	Size > 4,
	Size < 8.

%Handles the case where user enters a number outside of range 5-7. (Too big, negative or too small) Sets size to random (0).
sizeInputHandler(Size, 0) :- 
	number(Size),
	Size < 5.

sizeInputHandler(Size, 0) :- 
	number(Size),
	Size > 7.

%Handles the case where user enters a non-number. 
sizeInputHandler(Size, 0) :-
	not(number(Size)).

% Handles case where user does not input number for size
% sizeInputHandler(Size, 0) :- not(number(Size)).

%Handles case where user does not enter yes or no.
lyrichandler(L, S, E, Ret) :- 
	E \= no, 
	E \= yes, 
	lyricsrhyme(L, S, Ret, _, _).

%If user requests rhyming, call lyricsrhyme, otherwise, call lyrics.
lyrichandler(L, S, yes, Ret) :- lyricsrhyme(L, S, Ret, _, _).
lyrichandler(L, S, no, Ret) :- lyrics(L, S, Ret).

%Base Case. Needs two for each pattern
lyricsrhyme(0, _, [], none, 0).
lyricsrhyme(0, _, [], none, 1).
%Incorporate Rhyming. Get L number of lines by recursively calling this function. 
lyricsrhyme(L, S, [N|T], NewR, 0):-
	lyricsrhyme(L1, S, T, R, 1),
	getnewline(S, N, R, NewR),
	L is L1 + 1.

%Case where it should rhyme with the last line
lyricsrhyme(L, S, [N|T], NewR, 1):-
	lyricsrhyme(L1, S, T, R, 0),
	getnewline(S, N, none, NewR),
	L is L1 + 1.

%Base case
lyrics(0, _, []).
%No Rhyming. Get L number of lines by recursively calling this function.
lyrics(L, S, [N|T]):-
	lyrics(L1, S, T),
	getnewline(S, N, none, X),
	L is L1 + 1.

%getNewLine's first parameter is the number of words in the sentence, which determines the range of the random number.
%Then, this function generates a random number based on the range, which is then used to pick what type of sentence is generated.
getnewline(5, N, Rhyme, NR) :- 
	random(1, 4, R),
	generateRandomLine(R, N, Rhyme, NR).
	
getnewline(6, N, Rhyme, NR) :- 
	random(4, 7, R),
	generateRandomLine(R, N, Rhyme, NR).

getnewline(7, N, Rhyme, NR) :- 
	random(7, 10, R),
	generateRandomLine(R, N, Rhyme, NR).

%0 indicates a random sentence size. 
getnewline(0, N, Rhyme, NR) :-
	random(1, 10, R),
	generateRandomLine(R, N, Rhyme, NR).

%Searches adjective rhyming groups for the correct group, and then gets a random member. If no group is found, gets a random adjective. 
findAdj2(X, [], X).
findAdj2(X, [H|T], Y) :-
	member(X, H),
	rand(Y, H). %randomly selecting word based on CSG

findAdj2(X, [H|T], Y1) :-
	findAdj2(X, T, Y1).

%Searches noun rhyming groups for the correct group, and then gets a random member. If no group is found, gets a random noun.
findNoun2(X, [], X).
findNoun2(X, [H|T], Y) :-
	member(X, H),
	rand(Y, H). %randomly selecting word based on CSG

findNoun2(X, [H|T], Y1) :-
	findNoun2(X, T, Y1).

%Each random number corresponds to a different sentence generator. 
%Five words
generateRandomLine(1, N, Rhyme, NR) :- fiveSentenceTypeOne(N, Rhyme, NR).
generateRandomLine(2, N, Rhyme, NR) :- fiveSentenceTypeTwo(N, Rhyme, NR).
generateRandomLine(3, N, Rhyme, NR) :- fiveSentenceTypeThree(N, Rhyme, NR).

%Six words
generateRandomLine(4, N, Rhyme, NR) :- sixSentenceTypeOne(N, Rhyme, NR).
generateRandomLine(5, N, Rhyme, NR) :- sixSentenceTypeTwo(N, Rhyme, NR).
generateRandomLine(6, N, Rhyme, NR) :- sixSentenceTypeThree(N, Rhyme, NR).

%Seven words
generateRandomLine(7, N, Rhyme, NR) :- sevenSentenceTypeOne(N, Rhyme, NR).
generateRandomLine(8, N, Rhyme, NR) :- sevenSentenceTypeTwo(N, Rhyme, NR).
generateRandomLine(9, N, Rhyme, NR) :- sevenSentenceTypeThree(N, Rhyme, NR).

%These predicates group words of different types (Nouns, Adjectives, Adverbs) in seperate lists. (Lines 153-169) Based on CSG, reference above.
nounList(['love', 'heart', 'soul', 'brain', 'dove', 'art', 'goal', 'campaign']).

adjList(['beautiful', 'lovely', 'graceful', 'lucky', 'fuzzy', 'lively', 'dreamy','fantastic', 'nostalgic', 'exotic']).

adjLyList(['beautifully', 'gracefully', 'corageously', 'artistically']).

verbPastList(['tames', 'loves', 'betrays', 'kills', 'lives']).

verbPresList(['tame', 'love', 'betray', 'kill', 'live']).

prepList(['through', 'in', 'throughout', 'into']).

advList(['deeply', 'beautifully', 'corageously', 'gracefully']).

proList(['your', 'my', 'his', 'her', 'their']).

subjList(['I', 'you', 'he', 'she', 'they']).

%These functions below (Lines 174 - 183) will get a single word NR that rhymes with Rhyme. They pass a list of list that groups words into rhymes. 
%This selects a word randomly from a list of appropriate words : Based on CSG (Reference Above) 
%Find a rhyming adjective NR for Rhyme
getLastAdj(NR, Rhyme) :-
	Rhyme \= none,
	findAdj2(Rhyme, [['beautiful', 'colorful', 'graceful'],['fantastic', 'nostalgic', 'exotic'],['lovely', 'lucky', 'fuzzy', 'lively', 'dreamy']], NR).
%Find a rhyming noun NR for Rhyme
getLastNoun(NR, Rhyme) :-
	Rhyme \= none,
	findNoun2(Rhyme, [['love', 'dove'], ['heart', 'art'], ['soul', 'goal'], ['brain', 'campaign']], NR).

getLastNoun(Noun, none) :- nounList(Noun_List), rand(Noun, Noun_List).
getLastAdj(Adj, none) :- adjList(Adj_List), rand(Adj, Adj_List).

%Generates sentences word by word, and selects these words randomly (Functions from lines 187-197) Based on CSG. (Reference above)
%Algorithm : Grabs all lists of words needed from the lists at lines 153-169, and then randomly selects a member from the lists to build the line. 
fiveSentenceTypeOne([Adj1, Noun, 'is', Adj2, Adj3], Rhyme, Adj3) :-  nounList(N), adjList(A), adjLyList(A2), rand(Adj1, A), rand(Noun, N), rand(Adj2, A2), getLastAdj(Adj3, Rhyme).
fiveSentenceTypeTwo([Adj1, Noun1, Verb, Adj2, Noun2], Rhyme, Noun2) :- adjList(A), verbPastList(V), nounList(N), rand(Adj1, A), rand(Noun1, N), rand(Adj2, A), rand(Verb, V), getLastNoun(Noun2, Rhyme). 
fiveSentenceTypeThree([Verb, 'the', Adj1, Adj2, Noun], Rhyme, Noun) :- nounList(N), adjList(A), adjLyList(A2), verbPresList(V), rand(Verb, V), rand(Adj1, A2), rand(Adj2, A), getLastNoun(Noun, Rhyme).

sixSentenceTypeOne([Adj1, 'like', 'a', Adj2, Adj3, Noun], Rhyme, Noun) :- adjList(A), adjLyList(A2), rand(Adj1, A), rand(Adj2, A2), rand(Adj3, A), getLastNoun(Noun, Rhyme).
sixSentenceTypeTwo([Adj, Noun, Verb, Adv, Prep, Noun2], Rhyme, Noun2) :-  adjList(A), verbPastList(V), nounList(N), advList(AV), prepList(P), rand(Adj, A), rand(Noun, N), rand(Verb, V), rand(Adv, AV), rand(Prep, P), getLastNoun(Noun2, Rhyme).
sixSentenceTypeThree([Subj, Adv, Verb, Pro, Adj, Noun], Rhyme, Noun) :- proList(P), subjList(S), advList(AV), adjList(A), verbPresList(V), rand(Subj, S), rand(Adv, AV), rand(Verb, V), rand(Pro, P), rand(Adj, A), getLastNoun(Noun, Rhyme).

sevenSentenceTypeOne([Adj1, Noun, 'is', 'as', Adj2, 'as', Noun2], Rhyme, Noun2) :- adjList(A), nounList(N), rand(Adj1, A), rand(Noun, N), rand(Adj2, A), getLastNoun(Noun2, Rhyme).
sevenSentenceTypeTwo([Pro, Adj, Noun, 'is', 'like', Adj2, Noun2], Rhyme, Noun2) :- adjList(A), nounList(N), proList(P), rand(Pro, P), rand(Adj, A), rand(Noun, N), rand(Adj2, A), getLastNoun(Noun2, Rhyme).
sevenSentenceTypeThree([Subj, Adv, Verb, Pro, Adj, Adj2, Noun], Rhyme, Noun) :-  subjList(S), advList(A), verbPresList(V), proList(P), adjLyList(AL), adjList(AJ), rand(Subj, S), rand(Adv, A), rand(Verb, V), rand(Pro, P), rand(Adj, AL), rand(Adj2, AJ), getLastNoun(Noun, Rhyme).

%Instead of printing the poem as a variable binded 2d array, we will format it nicely in the console. (201-211) Inspired by CSG (Reference above).
%The poem is generated as a list of lists. This function calls formatLineOutput on each list, and then prints a new line.
formatOutput([]).
formatOutput([LINE|T]) :- formatLineOutput(LINE),
	write("\n"),
	formatOutput(T).

%This takes in a singular list of words. It prints each word with a space between them.
formatLineOutput([]).
formatLineOutput([H|T]) :- 
	write(H),
	write(" "),
	formatLineOutput(T).

%Custom function for random selection from list. Inspired by CSG (214-217).
rand(X, Lst) :-
	length(Lst, L),
	random(0, L, L1),
	nth0(L1, Lst, X). %There is an option to have weighted random selection, where words at the front are more likely to be chosen. Uncomment 218-220, and comment out 217 for this.
	% random(0, L, L2),	
	% min(L2, L1, L3),
	% nth0(L3, Lst, X).
	

%Returns the smaller of two numbers
min(L2, L1, L2) :- L2 > L1.
min(L2, L1, L1) :- L1 >= L2. 
