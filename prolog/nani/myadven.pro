%% Dynamic
:- dynamic location/2.
:- dynamic location_s/2.
:- dynamic turned_off/1.
:- dynamic here/1.
:- dynamic have/1.
:- dynamic turned_on/1.
:- dynamic turned_off/1.
% :- dynamic opened/2.
% :- dynamic closed/2.

%%%% Basics %%%%%%%%%%%%
% Rooms
room(kitchen).
room(office).
room(hall).
room('dining room').
room(cellar).

% Things
% location(desk, office).
% location(apple, kitchen).
% location(flashlight, desk).
% location('washing machine', cellar).
% location(nani, 'washing machine').
% location(broccoli, kitchen).
% location(crackers, kitchen).
% location(computer, office).
% location(envelope, desk).
% location(stamp, envelope).
% location(key, envelope).
location_s(object(candle, red, small, 1), kitchen).
location_s(object(apple, red, small, 1), kitchen).
location_s(object(apple, green, small, 1), kitchen).
location_s(object(table, blue, big, 50), kitchen).
location_s(object(desk, brown, big, 100), office).
location_s(object(flashlight, silver, small, 1), desk).
location_s(object('washing machine', white, big, 30), cellar).
location_s(object(nani, rainbow, small, 1), 'washing machine').
location_s(object(broccoli, green, small, 0.1), kitchen).
location_s(object(crackers, brown, small, 'a quarter'), kitchen).
location(computer, office).
location(envelope, desk).
location(stamp, envelope).
location(key, envelope).

% Paths
door(office, hall).
door(kitchen, office).
door(hall, 'dining room').
door(kitchen, cellar).
door('dining room', kitchen).

% closed(office, hall).
% closed(kitchen, office).
% closed(hall, 'dining room').
% closed(kitchen, cellar).
% closed('dining room', kitchen).

% Food
edible(apple).
edible(crackers).
tastes_yucky(broccoli).

% Initialize
turned_off(flashlight).
here(kitchen).
%%%%%%%%%%%%%%%%%%%%%%%%%%


% Food stuff!
where_food(X, Y) :-
	location(X, Y),
	edible(X).
where_food(X, Y) :-
	location(X, Y),
	tastes_yucky(X).

% See if different rooms are connected
connect(X,Y) :- door(X,Y).
connect(X,Y) :- door(Y,X).

list_things(Place) :-
	location(X, Place),
	tab(2),
	write(X),
	nl,
	fail.  % this always fails, so we couldn't use it with other rules
list_things(_).

list_connections(Place) :-
	connect(Place, X),
	tab(2),
	write(X),
	nl,
	fail.
list_connections(_).

look :-
	here(Place),
	write('You are in the '), write(Place), nl,
	write('You can see:'), nl,
	list_things_s(Place),
	write('You can go to:'),nl,
	list_connections(Place).

% Spiced up list-things for the game
look_in(Thing) :-
	location(_, Thing),
	write('The '), write(Thing), write(' contains:'), nl,
	list_things(Thing).
look_in(Thing) :-
	write('There''s nothing in '), write(Thing).


goto(Place) :-
	can_go(Place),
	move(Place),
	look.

can_go(Place) :-
	here(X),
	connect(X, Place).
can_go(Place) :-
	here(X),
	\=(Place, X),
	write('Can''t go there from here'),
	fail.
can_go(Place) :-
	here(X),
	=(Place, X),
	write('You are already there...'),
	fail.

move(Place) :-
	retract(here(_)),
	asserta(here(Place)).

take(Thing) :-
	can_take(Thing),
	take_object(Thing).

can_take(Thing) :-
	here(Place),
	location(Thing, Place).
can_take(Thing) :-
	write('There''s no '), write(Thing), write(' here'), nl,
	fail.

take_object(Thing) :-
	retract(location(Thing, _)),
	asserta(have(Thing)),
	write('taken.'), nl.

backtracking_assert(X):-  
	asserta(X).
backtracking_assert(X):-
	retract(X),fail.

put(Thing) :-
	have(Thing),
	here(Room),
	retract(have(Thing)),
	asserta(location(Thing, Room)).

inventory :-
	write('You have:'), nl,
	have(X),
	tab(2), write(X), nl,
	fail.
inventory.

turn_on(Thing) :-
	turned_off(Thing),
	retract(turned_off(Thing)),
	asserta(turned_on(Thing)),
	write(Thing), write(' is turned on.').
turn_on(Thing) :-
	turned_on(Thing),
	write(Thing), write(' is already on.').
turn_on(Thing) :-
	write(Thing), write(' cannot be turned on...'), fail.

turn_off(Thing) :-
	turned_on(Thing),
	retract(turned_on(Thing)),
	asserta(turned_off(Thing)),
	write(Thing), write(' is turned off.').
turn_off(Thing) :-
	turned_off(Thing),
	write(Thing), write(' is already off.').
turn_off(Thing) :-
	write(Thing), write(' cannot be turned off...'), fail.


% is_closed(P1, P2) :- closed(P1, P2).
% is_closed(P1, P2) :- closed(P2, P1).

% is_opened(P1, P2) :- opened(P1, P2).
% is_opened(P1, P2) :- opened(P1, P2).

% %%%% Breaks somehow...
% open(P1, P2) :-
% 	connect(P1, P2),
% 	is_closed(P1, P2),
% 	retract(closed(P1, P2)),
% 	retract(closed(P2, P1)),
% 	asserta(opened(P1, P2)).
% open(P1, P2) :-
% 	connect(P1, P2),
% 	is_opened(P1, P2),
% 	write('The door is already open').
% open(P1, P2) :-
% 	write('There''s no door between '), write(P1), write(' and '), write(P2),
% 	fail.

%%% Some no permission to modify message?
% close(P1, P2) :-
% 	connect(P1, P2),
% 	is_opened(P1, P2),
% 	retract(opened(P1, P2)),
% 	retract(opened(P2, P1)),
% 	asserta(closed(P1, P2)).
% close(P1, P2) :-
% 	connect(P1, P2),
% 	is_open(P1, P2),
% 	write('The door is already closed').
% close(P1, P2) :-
% 	write('There is no door between '), write(P1), write(' and '), write(P2),
% 	fail.


is_contained_in(T1, T2) :-  
	location(T1, T2).
is_contained_in(T1, T2) :-
	location(T1, X),
	is_contained_in(X, T2).

% location_s(object(candle, red, small, 1), kitchen).
% location_s(object(apple, red, small, 1), kitchen).
% location_s(object(apple, green, small, 1), kitchen).
% location_s(object(table, blue, big, 50), kitchen).

can_take_s(Thing) :-
	here(Room),
	location_s(object(Thing, _, small, _), Room).
can_take_s(Thing) :-
	here(Room),
	location_s(object(Thing, _, big, _), Room),
	write('The '), write(Thing), 
	write(' is too big to carry.'), nl,
	fail.
can_take_s(Thing) :-
	here(Room),
	not(location_s(object(Thing, _, _, _), Room)),
	write('There is no '), write(Thing), write(' here.'), nl,
	fail.

list_things_s(Place) :-
	location_s(object(Thing, Color, Size, Weight), Place),
	write('A '),write(Size),tab(1),
	write(Color),tab(1),
	write(Thing), write(', weighing '),
	write_plural(Weight,'kilo','kilos'), nl,
	fail.
list_things_s(_).

write_plural(1, Sform, _) :-
	write('1 '), write(Sform).
write_plural(P, _, Pform) :-
	P \= 1,
	write(P), write(' '), write(Pform).