
% ============================================================
% Лабораторная работа: Решение задач на Prolog
% ============================================================

% ============================================================
% 1. Указать все делители натурального числа n.
% ============================================================
% Предикат: divisors(N, Divisors) - находит все делители числа N.
% Используется вспомогательный предикат с аккумулятором.
divisors(N, Divisors) :-
    N > 0,                         % Проверка, что число натуральное
    find_divisors(N, 1, Divisors). % Начинаем с делителя 1

% Базовый случай: дошли до числа N, добавляем N как делитель
find_divisors(N, N, [N]).

% Рекурсивный случай: проверяем, является ли текущее число M делителем N
find_divisors(N, M, [M|Tail]) :-
    M < N,
    N mod M =:= 0,                 % Если M делит N
    M1 is M + 1,
    find_divisors(N, M1, Tail).

% Рекурсивный случай: M не является делителем
find_divisors(N, M, Tail) :-
    M < N,
    N mod M =\= 0,                 % Если M не делит N
    M1 is M + 1,
    find_divisors(N, M1, Tail).

% ============================================================
% 2. Найти сумму чётных элементов списка целых чисел.
% ============================================================
% Предикат: sum_even(List, Sum) - вычисляет сумму чётных элементов.
sum_even([], 0).                   % Сумма пустого списка = 0

sum_even([Head|Tail], Sum) :-
    sum_even(Tail, TailSum),
    (   Head mod 2 =:= 0           % Если элемент чётный
    ->  Sum is Head + TailSum
    ;   Sum = TailSum              % Если нечётный, просто передаём сумму хвоста
    ).

% ============================================================
% 3. Доказать закон де Моргана для объединения.
% ============================================================
% Закон де Моргана: дополнение объединения = пересечению дополнений
% Для множеств A и B: complement(A ∪ B) = complement(A) ∩ complement(B)

% Определение множества как списка без повторяющихся элементов.
% Универсальное множество задаётся отдельно.

% Предикат для удаления дубликатов (если нужно привести список к множеству)
make_set([], []).
make_set([H|T], [H|Set]) :-
    not(member(H, T)),
    make_set(T, Set).
make_set([H|T], Set) :-
    member(H, T),
    make_set(T, Set).

% Предикат для дополнения множества относительно универсума
% complement(Universal, Set, Complement) - дополнение Set до Universal
complement(Universal, Set, Complement) :-
    findall(X, (member(X, Universal), not(member(X, Set))), Complement).

% Предикат для объединения двух множеств
union(Set1, Set2, Union) :-
    append(Set1, Set2, Temp),
    sort(Temp, Union).  % sort также удаляет дубликаты

% Предикат для пересечения двух множеств
intersection(Set1, Set2, Intersection) :-
    findall(X, (member(X, Set1), member(X, Set2)), Intersection).

% Доказательство закона де Моргана:
% Проверяем, что complement(A ∪ B) = complement(A) ∩ complement(B)
demorgan_proof(Universal, A, B) :-
    % Левая часть: дополнение объединения
    union(A, B, UnionAB),
    complement(Universal, UnionAB, LeftPart),
    
    % Правая часть: пересечение дополнений
    complement(Universal, A, CompA),
    complement(Universal, B, CompB),
    intersection(CompA, CompB, RightPart),
    
    % Сортируем для корректного сравнения
    sort(LeftPart, SortedLeft),
    sort(RightPart, SortedRight),
    
    % Выводим результат
    write('left part (dopolnenie): '), write(LeftPart), nl,
    write('right part(peresechenie): '), write(RightPart), nl,
    
    (   SortedLeft = SortedRight
    ->  write('morgan completed!'), nl
    ;   write('morgan not completed!'), nl
    ).

% ============================================================
% 4. Задача о полярной экспедиции.
% ============================================================
% Отобрать 6 специалистов из 8 претендентов.
% Определим претендентов, специальности и ограничения.

% Специальности:
% bio - биолог, hydro - гидролог, sinoptik - синоптик,
% radio - радист, mech - механик, doctor - врач.

% Возможности претендентов:
can(A, doctor).       % A может быть врачом
can(B, hydro).        % B может быть гидрологом
can(C, radio).        % C может быть радистом
can(C, mech).         % C также может быть механиком
can(D, radio).        % D может быть радистом
can(D, doctor).       % D также может быть врачом
can(E, bio).          % E может быть биологом
can(F, hydro).        % F может быть гидрологом
can(F, sinoptik).     % F также может быть синоптиком
can(G, bio).          % G может быть биологом
can(G, sinoptik).     % G также может быть синоптиком
can(H, mech).         % H может быть механиком

% Список всех претендентов
all_candidates([a,b,c,d,e,f,g,h]).

% Список всех специальностей
all_specialties([bio, hydro, sinoptik, radio, mech, doctor]).

% Основной предикат решения
expedition(Team) :-
    % Все претенденты
    all_candidates(Candidates),
    % Выбираем 6 человек
    find_team(Candidates, Team),
    % Каждый выбранный получает одну специальность
    assign_specialties(Team, []),
    % Проверяем все ограничения
    check_constraints(Team).

% Генерация всех комбинаций по 6 человек из 8
find_team([C1,C2,C3,C4,C5,C6,C7,C8], [C1,C2,C3,C4,C5,C6]).
find_team([C1,C2,C3,C4,C5,C6,C7,C8], [C1,C2,C3,C4,C5,C7]).
find_team([C1,C2,C3,C4,C5,C6,C7,C8], [C1,C2,C3,C4,C5,C8]).
find_team([C1,C2,C3,C4,C5,C6,C7,C8], [C1,C2,C3,C4,C6,C7]).
find_team([C1,C2,C3,C4,C5,C6,C7,C8], [C1,C2,C3,C4,C6,C8]).
find_team([C1,C2,C3,C4,C5,C6,C7,C8], [C1,C2,C3,C4,C7,C8]).
find_team([C1,C2,C3,C4,C5,C6,C7,C8], [C1,C2,C3,C5,C6,C7]).
find_team([C1,C2,C3,C4,C5,C6,C7,C8], [C1,C2,C3,C5,C6,C8]).
find_team([C1,C2,C3,C4,C5,C6,C7,C8], [C1,C2,C3,C5,C7,C8]).
find_team([C1,C2,C3,C4,C5,C6,C7,C8], [C1,C2,C3,C6,C7,C8]).
find_team([C1,C2,C3,C4,C5,C6,C7,C8], [C1,C2,C4,C5,C6,C7]).
find_team([C1,C2,C3,C4,C5,C6,C7,C8], [C1,C2,C4,C5,C6,C8]).
find_team([C1,C2,C3,C4,C5,C6,C7,C8], [C1,C2,C4,C5,C7,C8]).
find_team([C1,C2,C3,C4,C5,C6,C7,C8], [C1,C2,C4,C6,C7,C8]).
find_team([C1,C2,C3,C4,C5,C6,C7,C8], [C1,C2,C5,C6,C7,C8]).
find_team([C1,C2,C3,C4,C5,C6,C7,C8], [C1,C3,C4,C5,C6,C7]).
find_team([C1,C2,C3,C4,C5,C6,C7,C8], [C1,C3,C4,C5,C6,C8]).
find_team([C1,C2,C3,C4,C5,C6,C7,C8], [C1,C3,C4,C5,C7,C8]).
find_team([C1,C2,C3,C4,C5,C6,C7,C8], [C1,C3,C4,C6,C7,C8]).
find_team([C1,C2,C3,C4,C5,C6,C7,C8], [C1,C3,C5,C6,C7,C8]).
find_team([C1,C2,C3,C4,C5,C6,C7,C8], [C1,C4,C5,C6,C7,C8]).
find_team([C1,C2,C3,C4,C5,C6,C7,C8], [C2,C3,C4,C5,C6,C7]).
find_team([C1,C2,C3,C4,C5,C6,C7,C8], [C2,C3,C4,C5,C6,C8]).
find_team([C1,C2,C3,C4,C5,C6,C7,C8], [C2,C3,C4,C5,C7,C8]).
find_team([C1,C2,C3,C4,C5,C6,C7,C8], [C2,C3,C4,C6,C7,C8]).
find_team([C1,C2,C3,C4,C5,C6,C7,C8], [C2,C3,C5,C6,C7,C8]).
find_team([C1,C2,C3,C4,C5,C6,C7,C8], [C2,C4,C5,C6,C7,C8]).
find_team([C1,C2,C3,C4,C5,C6,C7,C8], [C3,C4,C5,C6,C7,C8]).

% Назначение специальностей
assign_specialties([], _).
assign_specialties([Person|Rest], Assigned) :-
    can(Person, Specialty),
    not(member(Specialty, Assigned)),  % Каждая специальность только один раз
    assign_specialties(Rest, [Specialty|Assigned]).

% Проверка ограничений
check_constraints(Team) :-
    % F не может ехать без B
    (member(f, Team) -> member(b, Team) ; true),
    % D не может ехать без C и без H
    (member(d, Team) -> member(c, Team), member(h, Team) ; true),
    % C не может ехать одновременно с G
    (member(c, Team) -> not(member(g, Team)) ; true),
    % A не может ехать вместе с B
    (member(a, Team) -> not(member(b, Team)) ; true).

% ============================================================
% Основная программа с вводом данных
% ============================================================
main :-
    % Task 1: divisors
    write('=== Task 1: Divisors of a natural number ==='), nl,
    write('Enter a natural number n: '),
    read(N),
    divisors(N, Divisors),
    write('Divisors of '), write(N), write(': '), write(Divisors), nl, nl,

    % Task 2: sum of even elements
    write('=== Task 2: Sum of even elements of a list ==='), nl,
    write('Enter a list of integers (e.g., [1,2,3,4,5]): '),
    read(List),
    sum_even(List, SumEven),
    write('Sum of even elements in '), write(List), write(' = '), write(SumEven), nl, nl,

    % Task 3: De Morgan's law
    write('=== Task 3: De Morgan\'s law for union ==='), nl,
    write('Enter the universal set (list without duplicates): '),
    read(Universal),
    write('Enter set A (list without duplicates): '),
    read(A),
    write('Enter set B (list without duplicates): '),
    read(B),
    demorgan_proof(Universal, A, B), nl,

    % Task 4: polar expedition
    write('=== Task 4: Polar expedition ==='), nl,
    write('Searching for expedition team...'), nl,
    findall(Team, expedition(Team), Solutions),
    (   Solutions = []
    ->  write('No solutions found.'), nl
    ;   write('Found solutions:'), nl,
        print_solutions(Solutions)
    ).

% Output solutions
print_solutions([]).
print_solutions([Team|Rest]) :-
    write('Team: '), write(Team), nl,
    write('Specialties:'), nl,
    print_assignments(Team),
    nl,
    print_solutions(Rest).

print_assignments([]).
print_assignments([Person|Rest]) :-
    can(Person, Specialty),
    write(Person), write(' -> '), write_specialty(Specialty), nl,
    print_assignments(Rest).

write_specialty(bio) :- write('biologist').
write_specialty(hydro) :- write('hydrologist').
write_specialty(sinoptik) :- write('weather forecaster').
write_specialty(radio) :- write('radio operator').
write_specialty(mech) :- write('mechanic').
write_specialty(doctor) :- write('doctor').

% Entry point
:- main.