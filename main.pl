%Reference : https://wiki.ubc.ca/Course:CPSC312-2019/ChomskySentenceGenerator. Our project is inspired by / based on the project linked here. 
%The code at these lines are inspired by, or based on the resource's code. (With permission granted by the repo owner) : 7-14, 124, 133, 156-224. 
%The details of the reference above are explained in comments above or at those line numbers. We refer to this project as "CSG" throughout the code for the references.

%Get user requirements with simple error handling, generate poem and then output the poem. Starting generator by getting user preference (7-14), inspired by CSG.
main:-
	write("How many lines would you like the lyrics to have? Enter 0 for random. \n"),
	read(Lines),
	write("How many words per line? Enter 0 for random, or a number between 5 - 7\n"),
	read(Size),
	write("Should the lyrics rhyme? Enter 'yes' or 'no'.\n"),
	read(Rhyme),
	write("What's the mood? Enter 'happy', 'sad', or 'none'.\n"),
	read(Mood),
	lyrichandler(L, S, Mood, Rhyme, Ret),
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
lyrichandler(L, S, Mood, E, Ret) :- 
	E \= no, 
	E \= yes, 
	lyricsrhyme(L, S, Mood, Ret, _, _).

%If user requests rhyming, call lyricsrhyme, otherwise, call lyrics.
lyrichandler(L, S, Mood, yes, Ret) :- lyricsrhyme(L, S, Mood, Ret, _, _).
lyrichandler(L, S, Mood, no, Ret) :- lyrics(L, S, Mood, Ret).

%Base Case. Needs two for each pattern
lyricsrhyme(0, _, _, [], none, 0).
lyricsrhyme(0, _, _, [], none, 1).
%Incorporate Rhyming. Get L number of lines by recursively calling this function. 
lyricsrhyme(L, S, Mood, [N|T], NewR, 0):-
	lyricsrhyme(L1, S, Mood, T, R, 1),
	getnewline(S, N, Mood, R, NewR),
	L is L1 + 1.

%Case where it should rhyme with the last line
lyricsrhyme(L, S, Mood, [N|T], NewR, 1):-
	lyricsrhyme(L1, S, Mood, T, R, 0),
	getnewline(S, N, Mood, none, NewR),
	L is L1 + 1.

%Base case
lyrics(0, _, _, []).
%No Rhyming. Get L number of lines by recursively calling this function.
lyrics(L, S, Mood, [N|T]):-
	lyrics(L1, S, Mood, T),
	getnewline(S, N, Mood, none, X),
	L is L1 + 1.

%getNewLine's first parameter is the number of words in the sentence, which determines the range of the random number.
%Then, this function generates a random number based on the range, which is then used to pick what type of sentence is generated.
getnewline(5, N, Mood, Rhyme, NR) :- 
	random(1, 4, R),
	generateRandomLine(R, N, Mood, Rhyme, NR).
	
getnewline(6, N, Mood, Rhyme, NR) :- 
	random(4, 7, R),
	generateRandomLine(R, N, Mood, Rhyme, NR).

getnewline(7, N, Mood, Rhyme, NR) :- 
	random(7, 10, R),
	generateRandomLine(R, N, Mood, Rhyme, NR).

%0 indicates a random sentence size. 
getnewline(0, N, Mood, Rhyme, NR) :-
	random(1, 10, R),
	generateRandomLine(R, N, Mood, Rhyme, NR).

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
generateRandomLine(1, N, Mood, Rhyme, NR) :- fiveSentenceTypeOne(N, Mood, Rhyme, NR).
generateRandomLine(2, N, Mood, Rhyme, NR) :- fiveSentenceTypeTwo(N, Mood, Rhyme, NR).
generateRandomLine(3, N, Mood, Rhyme, NR) :- fiveSentenceTypeThree(N, Mood, Rhyme, NR).

%Six words
generateRandomLine(4, N, Mood, Rhyme, NR) :- sixSentenceTypeOne(N, Mood, Rhyme, NR).
generateRandomLine(5, N, Mood, Rhyme, NR) :- sixSentenceTypeTwo(N, Mood, Rhyme, NR).
generateRandomLine(6, N, Mood, Rhyme, NR) :- sixSentenceTypeThree(N, Mood, Rhyme, NR).

%Seven words
generateRandomLine(7, N, Mood, Rhyme, NR) :- sevenSentenceTypeOne(N, Mood, Rhyme, NR).
generateRandomLine(8, N, Mood, Rhyme, NR) :- sevenSentenceTypeTwo(N, Mood, Rhyme, NR).
generateRandomLine(9, N, Mood, Rhyme, NR) :- sevenSentenceTypeThree(N, Mood, Rhyme, NR).

%These predicates group words of different types (Nouns, Adjectives, Adverbs) in seperate lists. (Lines 156-168) Based on CSG, reference above.

nounList(['love', 'heart', 'soul', 'brain', 'dove', 'art', 'goal', 'campaign']).
adjList(['beautiful', 'lovely', 'graceful', 'lucky', 'fuzzy', 'lively', 'dreamy','fantastic', 'nostalgic', 'exotic'], Mood) :- Mood \= happy, Mood \= sad.
adjList(['cheerful', 'peaceful', 'blissful', 'contented', 'delighted', 'elated', 'jubilant', 'exultant', 'pleasant'], happy).
adjList(['bitter', 'somber', 'darker', 'dismal', 'miserable', 'deplorable', 'gloomy', 'unhappy', 'melancholy'], sad).
adjLyList(['beautifully', 'gracefully', 'corageously', 'artistically'], Mood) :- Mood \= happy, Mood \= sad.
adjLyList(['gladly', 'joyfully', 'heartily', 'graciously', 'merrily'], happy).
adjLyList(['dolefully', 'grievously', 'morosely', 'sorely'], sad).
verbPastList(['tames', 'loves', 'betrays', 'kills', 'lives']).
verbPresList(['tame', 'love', 'betray', 'kill', 'live']).
prepList(['through', 'in', 'throughout', 'into']).
advList(['deeply', 'beautifully', 'corageously', 'gracefully']).
proList(['your', 'my', 'his', 'her', 'their']).
subjList(['I', 'you', 'he', 'she', 'they']).

%These functions below (Lines 173 - 190) will get a single word NR that rhymes with Rhyme. They pass a list of list that groups words into rhymes. 
%Lists are based on a mood (happy, sad, or neither). This selects a word randomly from a list of appropriate words : Based on CSG (Reference Above) 
%Find a rhyming adjective NR for Rhyme
getLastAdj(Adj, Mood, none) :- adjList(Adj_List, Mood), rand(Adj, Adj_List).
getLastAdj(NR, happy, Rhyme) :-
	Rhyme \= none,
	findAdj2(Rhyme, [['cheerful', 'peaceful', 'blissful'],['contented', 'delighted', 'elated'],['jubilant', 'exultant', 'pleasant']], NR).

getLastAdj(NR, sad, Rhyme) :-
	Rhyme \= none,
	findAdj2(Rhyme, [['bitter', 'somber', 'darker'],['dismal', 'miserable', 'deplorable'],['gloomy', 'unhappy', 'melancholy']], NR).

getLastAdj(NR, E, Rhyme) :-
	E \= happy,
	E \= sad,
	Rhyme \= none,
	findAdj2(Rhyme, [['beautiful', 'colorful', 'graceful'],['fantastic', 'nostalgic', 'exotic'],['lovely', 'lucky', 'fuzzy', 'lively', 'dreamy']], NR).

%Find a rhyming noun NR for Rhyme
getLastNoun(NR, Rhyme) :- Rhyme \= none, findNoun2(Rhyme, [['love', 'dove'], ['heart', 'art'], ['soul', 'goal'], ['brain', 'campaign']], NR).
getLastNoun(Noun, none) :- nounList(Noun_List), rand(Noun, Noun_List).

%Generates sentences word by word, and selects these words randomly (Functions from lines 194-204) Based on CSG. (Reference above)
%Algorithm : Grabs all lists of words needed from the lists at lines 153-169, and then randomly selects a member from the lists to build the line. 
fiveSentenceTypeOne([Adj1, Noun, 'is', Adj2, Adj3], Mood, Rhyme, Adj3) :-  nounList(N), adjList(A, Mood), adjLyList(A2, Mood), rand(Adj1, A), rand(Noun, N), rand(Adj2, A2), getLastAdj(Adj3, Mood, Rhyme).
fiveSentenceTypeTwo([Adj1, Noun1, Verb, Adj2, Noun2], Mood, Rhyme, Noun2) :- adjList(A, Mood), verbPastList(V), nounList(N), rand(Adj1, A), rand(Noun1, N), rand(Adj2, A), rand(Verb, V), getLastNoun(Noun2, Rhyme). 
fiveSentenceTypeThree([Verb, 'the', Adj1, Adj2, Noun], Mood, Rhyme, Noun) :- nounList(N), adjList(A, Mood), adjLyList(A2, Mood), verbPresList(V), rand(Verb, V), rand(Adj1, A2), rand(Adj2, A), getLastNoun(Noun, Rhyme).

sixSentenceTypeOne([Adj1, 'like', 'a', Adj2, Adj3, Noun], Mood, Rhyme, Noun) :- adjList(A, Mood), adjLyList(A2, Mood), rand(Adj1, A), rand(Adj2, A2), rand(Adj3, A), getLastNoun(Noun, Rhyme).
sixSentenceTypeTwo([Adj, Noun, Verb, Adv, Prep, Noun2], Mood, Rhyme, Noun2) :-  adjList(A, Mood), verbPastList(V), nounList(N), advList(AV), prepList(P), rand(Adj, A), rand(Noun, N), rand(Verb, V), rand(Adv, AV), rand(Prep, P), getLastNoun(Noun2, Rhyme).
sixSentenceTypeThree([Subj, Adv, Verb, Pro, Adj, Noun], Mood, Rhyme, Noun) :- proList(P), subjList(S), advList(AV), adjList(A, Mood), verbPresList(V), rand(Subj, S), rand(Adv, AV), rand(Verb, V), rand(Pro, P), rand(Adj, A), getLastNoun(Noun, Rhyme).

sevenSentenceTypeOne([Adj1, Noun, 'is', 'as', Adj2, 'as', Noun2], Mood, Rhyme, Noun2) :- adjList(A, Mood), nounList(N), rand(Adj1, A), rand(Noun, N), rand(Adj2, A), getLastNoun(Noun2, Rhyme).
sevenSentenceTypeTwo([Pro, Adj, Noun, 'is', 'like', Adj2, Noun2], Mood, Rhyme, Noun2) :- adjList(A, Mood), nounList(N), proList(P), rand(Pro, P), rand(Adj, A), rand(Noun, N), rand(Adj2, A), getLastNoun(Noun2, Rhyme).
sevenSentenceTypeThree([Subj, Adv, Verb, Pro, Adj, Adj2, Noun], Mood, Rhyme, Noun) :-  subjList(S), advList(A), verbPresList(V), proList(P), adjLyList(AL, Mood), adjList(AJ, Mood), rand(Subj, S), rand(Adv, A), rand(Verb, V), rand(Pro, P), rand(Adj, AL), rand(Adj2, AJ), getLastNoun(Noun, Rhyme).

%Instead of printing the poem as a variable binded 2d array, we will format it nicely in the console. (208-218) Inspired by CSG (Reference above).
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

%Custom function for random selection from list. The idea of random selection from list is from CSG, so this is "semi-inspired" by CSG (221-224).
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
