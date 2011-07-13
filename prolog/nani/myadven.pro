% Rooms
room(kitchen).
room(office).
room(hall).
room('dining room').
room(cellar).

% Things
location(desk, office).
location(apple, kitchen).
location(flashlight, desk).
location('washing machine', cellar).
location(nani, 'washing machine').
location(broccoli, kitchen).
location(crackers, kitchen).
location(computer, office).

% Paths
door(office, hall).
door(kitchen, office).
door(hall, 'dining room').
door(kitchen, cellar).
door('dining room', kitchen).

% Food
edible(apple).
edible(crackers).
tastes_yucky(broccoli).

% Initialize
turned_off(flashlight).
here(kitchen).

% Food stuff!
where_food(X, Y) :-
	location(X, Y),
	edible(X).
where_food(X, Y) :-
	location(X, Y),
	tastes_yucky(X).

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
	list_things(Place),
	write('You can go to:'),nl,
	list_connections(Place).

% This is probably not good, since just the same as list_things/1
look_in(Place) :-
	location(X, Place),
	tab(2),
	write(X),
	nl,
	fail.
look_in(_).