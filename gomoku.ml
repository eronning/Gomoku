#load "str.cma";;
#use "/course/cs017/src/ocaml/CS17setup.ml";; 

module type GAME =
sig
  (* TYPES *)

  (* names the players of the game *)
  type player = 
      | P1 
      | P2

  (* expresses the states of the game,
   * i.e., what the board looks like and whose turn it is *)
  type state

  (* describes the game's moves *)
  type move

  (* INITIAL VALUES *)

  (* defines the state at the start of the game *)
  val initial_state : state

  (* TYPE CONVERSIONS *)
  (* returns the name of a player *)
  val string_of_player : player -> string

  (* describes a state in words *)
  val string_of_state : state -> string

  (* describes a move in words *)
  val string_of_move : move -> string

  (* describes the game status (is it over or not),
   * and if it is over, the final outcome *)
  val status_string: state -> string

  (* Tool for a human player. 
   * produces the move that a string represents *)
  val move_of_string : string -> move

  (* GAME LOGIC *)

  (* determines whether a given move is legal in a given state *)
  val is_legal_move : state -> move -> bool

  (* produces the list of allowable moves in a given state *)
  val legal_moves : state -> move list

  (* produces the current player in a given state *)
  val current_player : state -> player

  (* executes the given move and produces the new game state *)
  val next_state : state -> move -> state

  (* estimates value of a given state
   * Remember: positive values are better for P1
   *       and negative values are better for P2 *)
  val estimate_value : state -> float

  (* determines whether the game is over or not given a state *)
  val is_game_over : state -> bool

end ;;

(*Grids for testing *)
let list_tester =  [[1 ; 2 ; 2 ; 2 ; 2 ; 0 ; 0] ;
                    [1 ; 2 ; 1 ; 0 ; 0 ; 0 ; 0] ;
                    [1 ; 2 ; 2 ; 1 ; 0 ; 0 ; 0] ;
                    [1 ; 2 ; 0 ; 0 ; 0 ; 0 ; 0] ;
                    [0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0] ;
                    [0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0]] ;;

let list_tester1 = [[1 ; 0 ; 0 ; 0 ; 2 ; 0 ; 0] ;
                    [1 ; 2 ; 2 ; 2 ; 2 ; 0 ; 0] ;
                    [1 ; 2 ; 1 ; 0 ; 0 ; 0 ; 0] ;
                    [1 ; 2 ; 2 ; 1 ; 0 ; 0 ; 0] ;
                    [1 ; 2 ; 0 ; 0 ; 0 ; 0 ; 0] ;
                    [0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0] ;
                    [0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0]] ;; 

let list_tester2 = [[2 ; 0 ; 0 ; 0 ; 2 ; 0 ; 0] ;
                    [2 ; 2 ; 2 ; 2 ; 2 ; 0 ; 0] ;
                    [1 ; 2 ; 1 ; 0 ; 0 ; 0 ; 0] ;
                    [1 ; 2 ; 2 ; 1 ; 0 ; 0 ; 0] ;
                    [1 ; 2 ; 0 ; 0 ; 0 ; 0 ; 0] ; 
                    [0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0] ;
                    [0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0]] ;;

let list_tester3 = [[2 ; 0 ; 0 ; 0 ; 2 ; 0 ; 0] ;
                    [2 ; 2 ; 1 ; 2 ; 2 ; 0 ; 0] ;
                    [1 ; 2 ; 2 ; 0 ; 0 ; 0 ; 0] ;
                    [1 ; 2 ; 2 ; 2 ; 0 ; 0 ; 0] ;
                    [1 ; 2 ; 0 ; 0 ; 2 ; 0 ; 0] ;
                    [0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0] ;
                    [0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0]] ;;

let list_tester4 = [[0 ; 0 ; 0 ; 0 ; 2 ; 0 ; 0] ;
                    [2 ; 2 ; 1 ; 2 ; 2 ; 0 ; 0] ;
                    [1 ; 2 ; 2 ; 0 ; 0 ; 0 ; 0] ;
                    [1 ; 2 ; 2 ; 2 ; 0 ; 0 ; 0] ;
                    [2 ; 2 ; 0 ; 0 ; 2 ; 0 ; 0] ;
                    [0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0] ;
                    [0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0]] ;;

let list_tester5 = [[0 ; 0 ; 0 ; 0 ; 2 ; 0 ; 0] ;
                    [2 ; 2 ; 1 ; 2 ; 2 ; 0 ; 0] ;
                    [1 ; 2 ; 2 ; 0 ; 0 ; 0 ; 0] ;
                    [1 ; 1 ; 2 ; 2 ; 0 ; 0 ; 0] ;
                    [2 ; 2 ; 1 ; 0 ; 2 ; 0 ; 0] ;
                    [0 ; 0 ; 0 ; 1 ; 0 ; 0 ; 0] ;
                    [0 ; 0 ; 0 ; 0 ; 1 ; 0 ; 0]] ;;

let list_tester6 =  [[1 ; 2 ; 1 ; 0 ; 0 ; 0 ; 0] ;
                     [1 ; 1 ; 2 ; 1 ; 0 ; 0 ; 0] ;
                     [1 ; 2 ; 1 ; 0 ; 0 ; 0 ; 0] ;
                     [0 ; 0 ; 0 ; 1 ; 0 ; 0 ; 0] ;
                     [0 ; 0 ; 0 ; 0 ; 1 ; 0 ; 0]] ;;

let list_tester7 = [[0 ; 1 ; 0 ; 0 ; 0 ; 0 ; 0] ;
                    [0 ; 0 ; 1 ; 0 ; 0 ; 0 ; 0] ;
                    [0 ; 0 ; 0 ; 1 ; 0 ; 0 ; 0] ;
                    [0 ; 0 ; 0 ; 0 ; 1 ; 0 ; 0] ;
                    [0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0] ;
                    [0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 2] ;
                    [0 ; 0 ; 0 ; 0 ; 0 ; 2 ; 2]] ;;


let list_tester8 = [[0 ; 0 ; 0 ; 0 ; 2 ; 0 ; 0] ;
                    [2 ; 2 ; 1 ; 2 ; 2 ; 0 ; 0] ;
                    [1 ; 2 ; 2 ; 0 ; 0 ; 0 ; 0] ;
                    [1 ; 2 ; 2 ; 2 ; 0 ; 0 ; 0] ;
                    [1 ; 2 ; 0 ; 0 ; 2 ; 0 ; 0] ;
                    [0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0] ;
                    [0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0]] ;;

let list_tester9 = [[1 ; 2 ; 1 ; 1 ; 2 ; 2 ; 2] ;
                    [2 ; 1 ; 2 ; 2 ; 2 ; 1 ; 1] ;
                    [1 ; 1 ; 2 ; 1 ; 2 ; 1 ; 1] ;
                    [1 ; 2 ; 2 ; 1 ; 2 ; 2 ; 2] ;
                    [1 ; 1 ; 2 ; 2 ; 1 ; 2 ; 1] ;
                    [2 ; 1 ; 1 ; 2 ; 1 ; 2 ; 2] ;
                    [1 ; 2 ; 1 ; 2 ; 2 ; 2 ; 1]] ;;

let list_tester10 = [[1 ; 2 ; 1 ; 1 ; 2 ; 2 ; 2] ;
                     [2 ; 1 ; 2 ; 2 ; 2 ; 1 ; 1] ;
                     [1 ; 1 ; 2 ; 1 ; 2 ; 1 ; 1] ;
                     [1 ; 2 ; 2 ; 1 ; 2 ; 2 ; 2] ;
                     [1 ; 1 ; 2 ; 2 ; 1 ; 2 ; 1] ;
                     [2 ; 1 ; 1 ; 2 ; 1 ; 2 ; 2] ;
                     [1 ; 2 ; 1 ; 2 ; 2 ; 2 ; 0]] ;;

let list_tester11 = [[1 ; 2 ; 1 ; 1 ; 2 ; 2 ; 2] ;
                     [2 ; 1 ; 2 ; 2 ; 2 ; 1 ; 1] ;
                     [1 ; 1 ; 2 ; 1 ; 2 ; 1 ; 1] ;
                     [1 ; 2 ; 2 ; 1 ; 2 ; 2 ; 2] ;
                     [1 ; 1 ; 2 ; 2 ; 1 ; 2 ; 1] ;
                     [2 ; 1 ; 1 ; 2 ; 0 ; 2 ; 2] ;
                     [1 ; 2 ; 1 ; 2 ; 2 ; 2 ; 0]] ;;


(* I/P: the procedure takes in a number and a datum
 * O/P: the procedure returns a list intialized with length
 *     num and values of datum *)
let rec construct_list num datum = 
  match num with 
    |0 -> []
    |_ -> datum :: construct_list (num - 1) datum ;;

(* Test cases: *)
check_expect (construct_list 0 0) 
  [] ;;

check_expect (construct_list 5 0) 
  [0 ; 0 ; 0 ; 0 ; 0] ;;

(* construct list of all lengths of 1 and 2 - run length encoding - then use database to classify
 * I/P: the procedure takes in a listof datum : my_list
 * O/P: the procedure outputs a list of all the pieces in a 
 *      a row tupled with the amount of ends those pieces have 
 *      makes a list for each of the players pieces *)
let estimate my_list =
  let rec _estimate my_list (acc1, ends1) (acc2, ends2) acc1_list acc2_list last =
    match my_list with
      | []       -> 
          (match last with 
            |0 -> acc1_list, acc2_list
            |1 -> ((acc1, ends1) :: acc1_list), acc2_list
            |2 -> acc1_list, ((acc2, ends2) :: acc2_list)
            |_ -> failwith "this should never happen")
      | hd :: tl -> 
          (match hd with
            |0 -> 
                (match last with
                  |0 -> _estimate tl (0, 0) (0, 0) acc1_list acc2_list 0
                  |1 -> _estimate tl (0, 0) (0, 0) ((acc1, ends1 + 1) :: acc1_list) acc2_list 0
                  |2 -> _estimate tl (0, 0) (0, 0) acc1_list ((acc2, ends2 + 1) :: acc2_list) 0
                  |_ -> failwith "this should never happen (0)")
            |1 ->  
                (match last with
                  |0 -> _estimate tl (acc1 + 1, 1) (0, 0) acc1_list acc2_list 1
                  |1 -> _estimate tl (acc1 + 1, ends1) (0, 0) acc1_list acc2_list 1
                  |2 -> _estimate tl (acc1 + 1, 0) (0, 0) acc1_list ((acc2, ends2) :: acc2_list) 1
                  |_ -> failwith "this should never happen (1)")

            |2 ->
                (match last with
                  |0 -> _estimate tl (0, 0) (acc2 + 1, 1) acc1_list acc2_list 2
                  |1 -> _estimate tl (0, 0) (acc2 + 1, 0) ((acc1, ends1) :: acc1_list) acc2_list 2
                  |2 -> _estimate tl (0, 0) (acc2 + 1, ends2) acc1_list acc2_list 2
                  |_ -> failwith "this should never happen (2)")
            |_ -> failwith "this should never happen (main)") in
    _estimate my_list (0, 0) (0, 0) [] [] (List.hd my_list) ;;

(* Test Cases: *)
check_expect (estimate [2 ; 1 ; 1 ; 1 ; 0 ; 0 ; 0]) 
  ([(3, 1)], [(1, 0)]) ;;

check_expect (estimate [0 ; 1 ; 1 ; 1 ; 0 ; 0 ; 0]) 
  ([(3, 2)], []);;

check_expect (estimate [2 ; 1 ; 1 ; 1 ; 2 ; 0 ; 0]) 
  ([(3, 0)], [(1, 1) ; (1, 0)]) ;;

check_expect (estimate [1 ; 1 ; 1 ; 0 ; 0 ; 0]) 
  ([(3, 1)], []) ;;

check_error (fun x -> (estimate [1 ; 1 ; 1 ; 6 ; 0 ; 0]))
  "this should never happen (main)" ;;

(* I/P: the procedure takes in a tuple : (val1, val2)
 * O/P: the procedure assigns a float value to that tuple *)
let val_assign (val1, val2) : float =
  match val1, val2 with
    | 1, 0 -> 0.
    | 1, 1 -> 1.
    | 1, 2 -> 2.
    | 2, 0 -> 0.
    | 2, 1 -> 2.
    | 2, 2 -> 3.
    | 3, 0 -> 0.
    | 3, 1 -> 3.
    | 3, 2 -> 30.
    | 4, 0 -> 0.
    | 4, 1 -> 25.
    | 4, 2 -> 1000.
    | x, _ when (x >= 5) -> 1000.
    | _, _ -> failwith "Error in val_assign" ;;

(* Test cases *)
check_expect (val_assign (4, 2)) 
  1000. ;;

check_expect (val_assign (6, 2)) 
  1000.;;

check_expect (val_assign (1, 0)) 
  0.;;

check_error (fun x -> (val_assign (-1, -5))) 
  "Error in val_assign" ;;

(*  I/P: the procedure takes in a listof datum: my_list
 *  O/P: the procedure outputs a boolean based on 
 *       whether or not there was five in a row for one of the players *) 
let test my_list : bool =
  let rec _test my_list acc acc2 : bool =
    if (acc = 5) || (acc2 = 5) then true
    else 
      (match my_list with
        | []       -> false
        | hd :: tl -> 
            (if (hd = 1) then _test tl (acc + 1) 0
             else if (hd = 2) then _test tl 0 (acc2 + 1)
             else _test tl 0 0)) in
    _test my_list 0 0 ;;

(* Test cases: *)
check_expect (test [])
  false ;;

check_expect (test [1 ; 2 ; 2 ; 2 ; 1 ; 0]) 
  false ;;

check_expect (test [1 ; 2 ; 2 ; 2 ; 2 ; 2 ; 1 ; 0]) 
  true ;;

(* I/P: the procedure takes a function, binary operator, datum, and a list
 *     that contains the grid of values from a state : my_list
 * O/P: the procedure outputs a value that corresponds to f1 and f2 
 *      being applied to the list *)
let rec row_tester (f1 : 'a -> 'b) (f2 : 'b -> 'b -> 'b) base my_list  =
  match my_list with
    | []       -> base
    | hd :: tl -> (f2 (f1 hd) (row_tester f1 f2 base tl)) ;;

(* Test cases: *)
let tuple_append (a, b) (x, y) = ((a @ x), (b @ y)) ;;
check_expect (row_tester (test) (||) false []) 
  false ;;

check_expect (row_tester (test) (||) false list_tester2) 
  true ;;

check_expect (row_tester (estimate) (tuple_append) ([], []) list_tester) 
  ([(1, 0); (1, 1); (1, 0); (1, 1); (1, 0); (1, 0)], [(4, 1); (1, 0); (2, 0); (1, 1)]) ;; 

check_expect (row_tester (estimate) (tuple_append) ([], []) list_tester2)
  ([(1, 1); (1, 0); (1, 1); (1, 0); (1, 0)],
   [(1, 2); (1, 1); (5, 1); (1, 0); (2, 0); (1, 1)]);;

(* I/P: the procedure takes a function, binary operator, datum, and a list
 *     that contains the grid of values from a state : my_list
 * O/P: the procedure outputs a value that corresponds to f1 and f2 
 *      being applied to the list iterated by columns *)
let rec col_tester (f1 : 'a -> 'b) (f2 : 'b -> 'b -> 'b) base my_list =
  match my_list with
    | []       -> base
    | hd :: tl ->
        if (List.hd my_list) = [] then base
        else (f2 (f1 (List.map (List.hd) my_list)) (col_tester f1 f2 base (List.map (List.tl) my_list))) ;;

(* Test cases: *)
check_expect (col_tester (test) (||) false []) 
  false ;; 

check_expect (col_tester (test) (||) false list_tester1) 
  true ;;

check_expect (col_tester (estimate) (tuple_append) ([], []) list_tester) 
  ([(4, 1); (1, 0); (1, 2)], [(4, 1); (1, 1); (1, 0); (1, 1); (1, 1)]) ;;

check_expect (col_tester (estimate) (tuple_append) ([], []) list_tester1)
  ([(5, 1); (1, 0); (1, 2)], [(4, 2); (1, 1); (1, 1); (1, 2); (2, 1)]) ;;

(* I/P: the procedure takes in the list that contains the grid
 *     of values from a state : my_list
 * O/P: the procedure outputs a list that contains all the values 
 *      of a diagonal from the top left to bottom right of a grid. *)
let rec get_diag (my_list : 'a list list) : 'a list =
  match my_list with
    | []         -> []
    | hd1 :: tl1 -> 
        (match hd1 with 
          | []         -> []
          | hd2 :: tl2 -> hd2 :: get_diag (List.map (List.tl) tl1)) ;;

(* Test cases: *)
check_expect (get_diag []) 
  [] ;;

check_expect (get_diag list_tester1) 
  [1 ; 2 ; 1 ; 1 ; 0 ; 0 ; 0] ;;

check_expect (get_diag list_tester) 
  [1 ; 2 ; 2 ; 0 ; 0 ; 0] ;;

check_expect (get_diag list_tester6) 
  [1 ; 1 ; 1 ; 1 ; 1] ;;

(* I/P: the procedure takes a function, binary operator, datum, and a list
 *     that contains the grid of values from a state : my_list
 * O/P: the procedure outputs a value that corresponds to f1 and f2 
 *      being applied to the list iterated by diagnols *)
let rec diag_rows_test (f1 : 'a -> 'b) (f2 : 'b -> 'b -> 'b) base my_list = 
  match my_list with
    | []       -> base
    | hd :: tl -> (f2 (f1 (get_diag my_list)) (diag_rows_test f1 f2 base tl)) ;;

(* Test cases: *)
check_expect (diag_rows_test (test) (||) false []) 
  false ;;

check_expect (diag_rows_test (test) (||) false list_tester3) 
  true ;;

check_expect (diag_rows_test (estimate) (tuple_append) ([], []) list_tester)  
  ([(1, 0); (1, 0); (1, 0); (1, 1)], [(2, 1); (1, 1); (1, 1)]);;

check_expect (diag_rows_test (estimate) (tuple_append) ([], []) list_tester2) 
  ([(2, 1); (1, 0); (1, 0); (1, 1)], [(2, 0); (3, 1); (1, 1); (1, 1)]);;

(* I/P: the procedure takes a function, binary operator, datum, and a list
 *     that contains the grid of values from a state : my_list
 * O/P: the procedure outputs a value that corresponds to f1 and f2 
 *      being applied to the list iterated by diagnols *)
let rec diag_cols_test (f1 : 'a -> 'b) (f2 : 'b -> 'b -> 'b) base my_list =
  match my_list with
    | []       -> base
    | hd :: tl ->
        if (List.hd my_list) = [] then base
        else (f2 (f1 (get_diag my_list)) (diag_cols_test f1 f2 base (List.map (List.tl) my_list))) ;;

(* Test cases: *)
check_expect (diag_cols_test (test) (||) false []) 
  false ;;

check_expect (diag_cols_test (test) (||) false list_tester3)
  true ;;

check_expect (diag_cols_test (estimate) (tuple_append) ([], []) list_tester) 
  ([(1, 0); (2, 1)], [(2, 1); (1, 0); (1, 1); (1, 1); (1, 1)]) ;;

check_expect (diag_cols_test (estimate) (tuple_append) ([], []) list_tester1) 
  ([(2, 1); (1, 0)], [(1, 0); (1, 2); (1, 2); (1, 2); (1, 1)]) ;;

(* I/P: the procedure takes a function, binary operator, datum, and a list
 *     that contains the grid of values from a state : my_list
 * O/P: the procedure outputs a value that corresponds to f1 and f2 
 *      being applied to the list *)
let diag_tester (f1 : 'a -> 'b) (f2 : 'b -> 'b -> 'b) base my_list =
  let rev_list = (List.map (List.rev) my_list) in
    (f2 (f2 (diag_rows_test f1 f2 base my_list) (diag_cols_test f1 f2 base my_list))
       (f2 (diag_rows_test f1 f2 base rev_list) (diag_cols_test f1 f2 base rev_list))) ;; 

(* Test cases: *)
check_expect (diag_tester (test) (||) false []) 
  false ;;

check_expect (diag_tester (test) (||) false list_tester3) 
  true ;;

check_expect (diag_tester (test) (||) false list_tester4) 
  true ;;

check_expect (diag_tester (test) (||) false list_tester5) 
  true ;;

check_expect (diag_tester (estimate) (tuple_append) ([], []) list_tester)
  ([(1, 0); (1, 0); (1, 0); (1, 1); (1, 0); (2, 1); (1, 2); (1, 0);  (1, 0);
    (1, 0); (1, 0); (1, 0)], [(2, 1); (1, 1); (1, 1); (2, 1); (1, 0); (1, 1); 
                              (1, 1); (1, 1); (2, 2); (1, 1); (1, 0); (1, 0);
                              (2, 0); (1, 0)]) ;;

check_expect (diag_tester (estimate) (tuple_append) ([], []) list_tester1) 
  ([(2, 1); (1, 0); (1, 0); (1, 0); (1, 0); (1, 1); (2, 1); (1, 0); 
    (1, 2); (1, 2); (1, 0); (1, 0); (1, 0); (1, 0); (1, 1); (1, 0)],
   [(1, 0); (2, 1); (1, 1); (1, 1); (1, 0); (1, 2); (1, 2); (1, 2); 
    (1, 1); (2, 2); (1, 2); (1, 0); (2, 0); (2, 1); (1, 1)]) ;;

(* Fill in the code that defines your game here. *)
module Game  =
struct

  (* The number of rows in the grid *)
  let rows = 7

  (* The number of columns in the grid *)
  let columns = 7

  type player = 
      | P1 
      | P2

  type state = State of ((int list) list * player)

  type move = Move of (int * int)

  (* The intial construction of the game board: state *)
  let initial_state = 
    State((construct_list rows (construct_list columns 0)), P1)

  (* TYPE CONVERSIONS *)
  (* returns the name of a player 
   * I/P: the procedure takes a player: p 
   * O/P: the procedure outputs a string *)
  let string_of_player p = 
    match p with
      |P1 -> "Player 1"
      |P2 -> "Player 2"

  (* describes a state in words 
   * I/P: the procedure takes in a state 
   * O/P: the procedure outputs a string  
   *      that represents the state inputted *)
  let string_of_state (State(my_list, p)) : string =  
    let rec print_grid (my_list2 : (int list) list) : string =
      match my_list2 with
        |[]       -> ""
        |hd :: tl -> 
            (List.fold_right (fun x y -> ((if x = 0 then "-" else if x = 1 then "X" else "O") ^ " " ^ y)) hd "\n") ^ (print_grid tl) in 
      ("The current player is " ^ (string_of_player p) ^ " and the game grid is \n" ^ (print_grid my_list))


  (* describes a move in words 
   * I/P: the procedure takes in a move
   * O/P: the procedure outputs a string
   *      that represents the inputted move *)
  let string_of_move (Move(x, y)) = 
    ("(" ^ (string_of_int x) ^ ", " ^ (string_of_int y) ^ ")")

  (* produces the list of allowable moves in a given state 
   * I/P: the procedure takes in a state
   * O/P: the procedure outputs the a list of 
   *      all the legal moves in the inputted state *)
  let legal_moves (State(my_list, p)) =
    let rec helper1 my_list row =
      let rec helper2 my_list column =
        match my_list with
          |[] -> []
          |hd :: tl -> 
              if (hd = 0) then column :: (helper2 tl (column + 1))
              else (helper2 tl (column + 1))
      in match my_list with
        |[] -> []
        |hd :: tl -> (List.map (fun x -> (Move (x, row))) (helper2 hd 0)) @ (helper1 (tl) (row + 1))
    in (helper1 my_list 0)

  (* determines whether the game is over or not gi ven a state 
   * I/P: the procedure takes in a state 
   * O/P: the procedure outputs a boolean
   *      based upon whether or not the game has finished *)
  let is_game_over (State(my_list, p)) = 
    if (legal_moves (State(my_list, p)) = [])
    then true
    else ((row_tester (test) (||) false my_list) || 
          (col_tester (test) (||) false my_list) || 
          (diag_tester (test) (||) false my_list))

  (* describes the game status (is it over or not),
   * and if it is over, the final outcome 
   * I/P: the procedure takes in a state
   * O/P: the procedure outputs a string of 
   *      the current status of the game *)
  let status_string (State(my_list, p)) = 
    if (is_game_over (State(my_list, p)))
    then (if ((row_tester (test) (||) false my_list) ||
              (col_tester (test) (||) false my_list) ||
              (diag_tester (test) (||) false my_list))
          then "The winner is " ^ string_of_player (if p = P1 then P2 else P1) ^ "."
          else "It was a tie!")
    else "The game is not over."

  (* Tool for a human player. 
   * produces the move that a string represents 
   * I/P: the procedure takes in a string
   * O/P: the procedure outputs a move that
   *      corresponds to the inputted string *)
  let move_of_string my_string = 
    match ((Str.split (Str.regexp " ")) my_string) with
      |[x ; y] -> Move(int_of_string x, int_of_string y)
      |_ -> failwith "Input is invalid."

  (* GAME LOGIC *)
  (* determines whether a given move is legal in a given state 
   * I/P: the procedure takes in a state and a move
   * O/P: the procedure outputs a boolean based on whether or not 
   *      the move inputted is legal in the inputted state *)
  let is_legal_move (State(my_list, p)) (Move (x, y)) = 
    if ((x > (columns - 1)) || (y > (rows - 1))) then false
    else if ((List.nth (List.nth my_list y) x) = 0) then true
    else false

  (* produces the current player in a given state 
   * I/P: the procedure takes in a *)
  let current_player (State(my_list, p)) = p

  (* executes the given move and produces the new  game state 
   * I/P: the procedure takese in a state and a move
   * O/P: the procedure outputs the next_state that corresponds
   *      to the inputted state with the inputted move applied to it *)
  let next_state (State(my_list, p)) (Move(x, y)) = 
    let rec helper1 my_list x y p row =
      let rec helper2 my_list x p column =
        match my_list with
          |[] -> failwith "There is no such move in the list"
          |hd :: tl -> 
              if (x = column) then
                if (p = P1) then 1 :: tl
                else 2 :: tl
              else hd :: (helper2 tl x p (column + 1)) in 
        (match my_list with
          |[] -> failwith "There is no such move in the list"
          |hd :: tl -> 
              if (y = row) then
                (helper2 hd x p 0) :: tl
              else 
                hd :: (helper1 tl x y p (row + 1))) in 
      (State ((helper1 my_list x y p 0), (if (p = P1) then P2 else P1)))

  (* estimates value of a given state
   * I/P: the procedure takes in a state 
   * O/P: the procedure outputs a float describing
   *      that states value *)
  let estimate_value (State(my_list, p)) = 
    let rec _estimate_value vlist1 vlist2 =
      match vlist1, vlist2 with
        | [], []               -> 0.
        | hd :: tl, []         -> (val_assign hd) +. (_estimate_value tl [])
        | [], hd :: tl         -> (-1. *. (val_assign hd)) +. (_estimate_value [] tl)
        | hd :: tl, hd2 :: tl2 -> (val_assign hd) -. (val_assign hd2) +. (_estimate_value tl tl2) in
    let (vlist1, vlist2) = (tuple_append 
                              (tuple_append (row_tester (estimate) (tuple_append) ([], []) my_list) 
                                 (col_tester (estimate) (tuple_append) ([], []) my_list))
                              (diag_tester (estimate) (tuple_append) ([], []) my_list)) in
      _estimate_value vlist1 vlist2


end ;;

(* Test cases: *)

check_expect (Game.current_player (Game.initial_state)) 
  (Game.current_player (Game.initial_state)) ;;

check_expect (Game.is_game_over(Game.initial_state)) 
  false ;;

check_expect (Game.is_game_over(Game.State(list_tester2, Game.P1))) 
  true;;

check_expect (Game.string_of_move (Game.Move(1, 0))) 
  "(1, 0)" ;;

check_expect (Game.move_of_string "1 2")
  (Game.Move(1, 2)) ;;

check_error (fun x -> (Game.move_of_string "12"))
  "Input is invalid.";;

check_expect (Game.is_legal_move (Game.initial_state) (Game.Move(8, 10))) 
  false ;;

check_expect (Game.is_legal_move (Game.initial_state) (Game.Move(1, 1))) 
  true ;;

check_expect (Game.is_legal_move (Game.State(list_tester2, Game.P1)) (Game.Move(0, 0))) 
  false ;;

check_expect (Game.estimate_value (Game.State(list_tester2, Game.P1))) 
  (-2015.) ;;

check_expect (Game.estimate_value (Game.State(list_tester3, Game.P2)))
  (-3038.);;

check_expect (Game.estimate_value (Game.State([], Game.P1)))
  (0.) ;;

check_expect (Game.next_state (Game.initial_state) (Game.Move(1, 0)))
  (Game.next_state (Game.initial_state) (Game.Move(1, 0))) ;;

check_error (fun x -> (Game.next_state (Game.initial_state) (Game.Move(10, 0))))
  "There is no such move in the list" ;;

check_expect (Game.string_of_player (Game.P1)) 
  "Player 1" ;;

check_expect (Game.string_of_player (Game.P2)) 
  "Player 2" ;;

check_expect (Game.legal_moves (Game.State(list_tester2, Game.P1))) 
  [Game.Move (1, 0); Game.Move (2, 0); Game.Move (3, 0); Game.Move (5, 0);
   Game.Move (6, 0); Game.Move (5, 1); Game.Move (6, 1); Game.Move (3, 2);
   Game.Move (4, 2); Game.Move (5, 2); Game.Move (6, 2); Game.Move (4, 3);
   Game.Move (5, 3); Game.Move (6, 3); Game.Move (2, 4); Game.Move (3, 4);
   Game.Move (4, 4); Game.Move (5, 4); Game.Move (6, 4); Game.Move (0, 5);
   Game.Move (1, 5); Game.Move (2, 5); Game.Move (3, 5); Game.Move (4, 5);
   Game.Move (5, 5); Game.Move (6, 5); Game.Move (0, 6); Game.Move (1, 6);
   Game.Move (2, 6); Game.Move (3, 6); Game.Move (4, 6); Game.Move (5, 6);
   Game.Move (6, 6)];;

check_expect (Game.legal_moves (Game.State([], Game.P1)))
  [] ;;

check_expect (Game.status_string(Game.State(list_tester2, Game.P1))) 
  "The winner is Player 2.";;

check_expect (Game.status_string(Game.State(list_tester8, Game.P1))) 
  "The game is not over.";;

check_expect (Game.status_string(Game.State(list_tester9, Game.P1)))
  "It was a tie!" ;;




module type GAME_PLAYER =
sig
  open Game

  (* given a state, and decides which legal move to make *)
  val next_move : state -> move
end ;;

(* The HumanPlayer makes its moves based on user input.
 * We've written this player for you because it uses some imperative language constructs. *)
module HumanPlayer : GAME_PLAYER =
struct
  open Game

  let move_string state =
    (string_of_player (current_player state)) ^ ", please type your move: "

  let bad_move_string str =
    "Bad move for this state: " ^ str ^ "!\n"

  let rec next_move state =
    print_string (move_string state);
    flush stdout;

    try
      let str = (input_line stdin) in
      let new_move = move_of_string str in
        if (is_legal_move state new_move) then new_move
        else (print_string (bad_move_string str); next_move state)
    with 
      | End_of_file -> (print_endline "\nEnding game"; exit 1)
      | _ -> (print_endline "That move makes no sense!"; next_move state)
end ;;


(* Fill in the code for your AI player here. *)
(* Note that your AI player simply needs to decide on its next move.
 * It does not have to worry about printing to the screen or any of
 * the other silliness in the HumanPlayers's chunk of code. *)

module AIPlayer  =
struct
  open Game

  (* the amount moves the AI looks ahead *)
  let depth = 2

  (* I/P: the procedure takes in a function and a listof (float * move) : f alon
   * O/P: the procedure outputs a tuple corresponding to the best float 
   *     value and the move that is associated with it *)
  let best (f : 'a -> 'a -> bool) (alon : (float * move) list) : float * move =
    let rec _best alon (best_float, best_move) =
      match alon with
        |[] -> (best_float, best_move)
        |(my_float, my_move) :: tl -> 
            if (f my_float best_float) then
              _best tl (my_float, my_move)
            else _best tl (best_float, best_move) in
      _best alon (List.hd alon)

  (* I/P: the procedure takes in a binary operator and a state
   * O/P: the procedure outputs a float * move *)
  let call_to_best (f : 'a -> 'a -> bool) state = (best (f) (List.map (fun x -> (estimate_value (next_state state x)), x) (legal_moves state)))

  (* I/P: the procedure takes in a state : state
   * O/P: the procedure outputs a float * move after calling best *)
  let _estimator state : float * move = 
    if ((current_player state) = P1) 
    then (call_to_best (>) state)
    else (call_to_best (<) state)

  (* I/P: takes in a state : state
   * O/P: checks to see if the amount of legal moves left in that
   *      state is greater than one *)
  let greater_than_one state = ((List.length (legal_moves state)) > 1) 

  (* I/P: takes in a value 
   * O/P: checks to see if that value is less than
   *      the depth *)
  let less_than_depth acc = (acc < depth)


  (* I/P: the procedure takes in a state : state
   * O/P: the procedure outputs the best float * move *)
  let minimax state : float * move = 
    let rec _get_best state acc = 
      let call_to_get_best (f : 'a -> 'a -> bool) = 
        (best (f) (List.map (fun x -> (let (bfloat, bmove) = (_get_best (next_state state x) (acc+1)) in 
                                         (bfloat, x))) (legal_moves state))) in
        if (less_than_depth acc) && ((current_player state) = P1) && (greater_than_one state)
        then (call_to_get_best (>))
        else if (less_than_depth acc) && ((current_player state) = P2) && (greater_than_one state)
        then (call_to_get_best (<))
        else _estimator state
    in _get_best state 0

  (* I/P: the procedure takes in a state
   * O/P: the procedure outputs the best move for that state *)
  let next_move state : move =
    let (my_float, my_move) = minimax state  in
      my_move


end ;;

(* Test cases: *)

check_expect (AIPlayer.best (>) [(-2055., Game.Move (1, 5)) ; (-5069., Game.Move (3, 2)) ; (-1032., Game.Move (1, 5))]) 
  (-1032., Game.Move (1, 5));;

check_expect (AIPlayer.best (<) [(-2055., Game.Move (1, 5)) ; (-5069., Game.Move (3, 2)) ; (-1032., Game.Move (1, 5))]) 
  (-5069., Game.Move (3, 2)) ;;

check_expect (AIPlayer._estimator(Game.State(list_tester2, Game.P1))) 
  (-1032., Game.Move (1, 5)) ;;

check_expect (AIPlayer._estimator(Game.State(list_tester3, Game.P1))) 
  (-2055., Game.Move (1, 5)) ;;

check_expect (AIPlayer._estimator(Game.State(list_tester4, Game.P2))) 
  (-5069., Game.Move (3, 2)) ;;

check_expect (AIPlayer.call_to_best (>) (Game.initial_state)) 
  (12., Game.Move (3, 3));;

check_expect (AIPlayer.call_to_best (>) (Game.State(list_tester4, Game.P1))) 
  (-2087., Game.Move (5, 5)) ;; 

check_expect (AIPlayer.greater_than_one(Game.initial_state)) 
  true ;;

check_expect (AIPlayer.greater_than_one(Game.State(list_tester9, Game.P2))) 
  false ;;

check_expect (AIPlayer.less_than_depth 1) 
  true ;;

check_expect (AIPlayer.less_than_depth 5) 
  false ;;

check_expect (AIPlayer.minimax (Game.State(list_tester4, Game.P2))) 
  (-5059., Game.Move (3, 2)) ;;

check_expect (AIPlayer.minimax (Game.State(list_tester4, Game.P1))) 
  (-3039., Game.Move (1, 0)) ;;

check_expect (AIPlayer.minimax (Game.State(list_tester10, Game.P1))) 
  (0., Game.Move (6, 6)) ;;

check_expect (AIPlayer.minimax (Game.State(list_tester11, Game.P1))) 
  (0., Game.Move(4, 5)) ;;

check_expect (AIPlayer.next_move (Game.State(list_tester4, Game.P2)))
  (Game.Move(3, 2)) ;;

check_expect (AIPlayer.next_move (Game.State(list_tester10, Game.P2))) 
  (Game.Move(6, 6)) ;;

check_expect (AIPlayer.next_move (Game.initial_state)) 
  (Game.Move(3, 3)) ;;


module Referee =
struct
  open Game
  open HumanPlayer
  open AIPlayer

  module Player1 = AIPlayer
  module Player2 = AIPlayer

  let game_on_string player move =
    (string_of_player player) ^ " decides to make the move " ^ (string_of_move move) ^ "."

  let rec play state =
    print_endline (string_of_state state);
    if (is_game_over state) then (print_endline 
                                    ("Game over! Final result: " ^ (status_string state)); ())
    else let player = current_player state in
      let move = (match player with
                   | P1 -> Player1.next_move state
                   | P2 -> Player2.next_move state) in
        print_endline (game_on_string player move);
        play (next_state state move)

  let start_game () = play (initial_state)
end ;;

Referee.start_game () ;;

(*
* The AI will use estimate_value, next_state, and legal_moves
* 
* There should be no time in the game when the AI has no legal moves because 
* isgameover checks to see if the list of legal moves is empty
* 
* The AI player takes into account that the player is smart and will always 
* pick the move with the highest value.
* 
* This strategy will work for two AI players as well because each of the AI's
* will pick the highest value move for themselves. 

*)








