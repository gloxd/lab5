% ============================================================
% Laboratory Work: Solving Problems in Prolog
% ============================================================

% ============================================================
% 1. Find all divisors of a natural number N.
% ============================================================
% Predicate: divisors(N, Divisors) - finds all divisors of N.
divisors(N, Divisors) :-
    N > 0,                         % Check if N is a natural number
    find_divisors(N, 1, Divisors). % Start checking from divisor 1.

% Base case: reached N, add N as the last divisor
find_divisors(N, N, [N]).

% Recursive case: current M is a divisor of N
find_divisors(N, M, [M|Tail]) :-
    M < N,
    N mod M =:= 0,                 % N is divisible by M without remainder
    M1 is M + 1,
    find_divisors(N, M1, Tail).

% Recursive case: current M is not a divisor of N
find_divisors(N, M, Tail) :-
    M < N,
    N mod M =\= 0,                 % N is not divisible by M
    M1 is M + 1,
    find_divisors(N, M1, Tail).

% ============================================================
% 2. Find the sum of even elements in a list of integers.
% ============================================================
% Predicate: sum_even(List, Sum) - calculates the sum of even elements.
sum_even([], 0).                   % Sum of an empty list = 0

sum_even([Head|Tail], Sum) :-
    sum_even(Tail, TailSum),
    (   Head mod 2 =:= 0           % Check if the element is even
    ->  Sum is Head + TailSum      % If even -> add to the sum
    ;   Sum = TailSum              % If odd -> ignore it
    ).

% ============================================================
% 3. Prove De Morgan's law for union.
% ============================================================
% complement(A U B) = complement(A) /\ complement(B)

% Predicate for the complement of a set relative to the Universe
complement(Universal, Set, Complement) :-
    findall(X, (member(X, Universal), \+ member(X, Set)), Complement).

% Predicate for the union of two sets
union(Set1, Set2, Union) :-
    append(Set1, Set2, Temp),
    sort(Temp, Union).  % sort removes duplicates and orders elements

% Predicate for the intersection of two sets
intersection(Set1, Set2, Intersection) :-
    findall(X, (member(X, Set1), member(X, Set2)), Intersection).

% De Morgan's law proof execution
demorgan_proof(Universal, A, B) :-
    % Left part: complement(A U B)
    union(A, B, UnionAB),
    complement(Universal, UnionAB, LeftPart),
    
    % Right part: complement(A) /\ complement(B)
    complement(Universal, A, CompA),
    complement(Universal, B, CompB),
    intersection(CompA, CompB, RightPart),
    
    % Sorting for correct list comparison and binding
    sort(LeftPart, SortedLeft),
    sort(RightPart, SortedRight),
    
    write('Left side  (complement of union):        '), write(SortedLeft), nl,
    write('Right side (intersection of complements): '), write(SortedRight), nl,
    
    (   SortedLeft = SortedRight
    ->  write('Result: De Morgan law is successfully PROVED!'), nl
    ;   write('Result: Error, the law does not hold.'), nl
    ).

% ============================================================
% Main Entry Point and Interactive Menu
% ============================================================
main :-
    % Task 1
    write('=== Task 1: Divisors of a natural number ==='), nl,
    write('Enter natural number N: '),
    read(N),
    (   integer(N), N > 0
    ->  divisors(N, Divisors),
        write('Divisors of '), write(N), write(': '), write(Divisors), nl, nl
    ;   write('Error: You must enter a positive integer.'), nl, nl
    ),

    % Task 2
    write('=== Task 2: Sum of even elements in a list ==='), nl,
    write('Enter a list of integers (e.g. [1,2,3,4,6,8].): '),
    read(RawList),
    (   is_list(RawList)
    ->  sum_even(RawList, SumEven),
        write('Sum of even elements: '), write(SumEven), nl, nl
    ;   write('Error: Invalid list format.'), nl, nl
    ),

    % Task 3
    write('=== Task 3: De Morgan law for union ==='), nl,
    write('Enter Universal set (e.g. [1,2,3,4,5,6].): '),
    read(UniversalInput),
    write('Enter set A: '),
    read(AInput),
    write('Enter set B: '),
    read(BInput),
    
    % Sort blocks to clear duplicates and strictly bind elements
    sort(UniversalInput, Universal),
    sort(AInput, A),
    sort(BInput, B),
    
    (   is_list(Universal), is_list(A), is_list(B)
    ->  demorgan_proof(Universal, A, B), nl
    ;   write('Error: One of the inputs is not a valid list.'), nl
    ),
    
    write('Execution completed.'), nl.

% Auto-run on load/compilation
:- main.