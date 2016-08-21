#load "str.cma";;
#use "C:/Users/Erik/Desktop/CS017/OCaml/Projects/Game//game_signature.ml" ;;


(* IMPLEMENT SWITCH PLAYER AND ABSTRACT WHEREVER (IF PLAYER = P1 IS) *)

let rec construct_list num datum = 
  match num with 
    |0 -> []
    |_ -> datum :: construct_list (num - 1) datum ;;

(*  I/P: the procedure takes in a listof datum: my_list
 *  O/P: the procedure outputs a boolean based on 
 *       whether or not there was five in a row for one of the players *) 
let test my_list =
  let rec _test my_list acc acc2 =
    match my_list with
      | [] -> false
      | hd :: tl -> 
          (if (acc = 5) || (acc2 = 5) then true
           else 
             (if (hd = 1) then _test tl (acc + 1) 0
              else if (hd = 2) then _test tl 0 (acc2 + 1)
              else _test tl 0 0)) in
    _test my_list 0 0;;

(* I/P: the procedure takes in the list that contains the grid
 *     of values from a state : my_list
 * O/P: the procedure outputs a boolean that tests all the rows
 *     of the state to see if there are five pieces in a row. *)
let rec row_tester my_list =
  match my_list with
    | [] -> false
    | hd :: tl -> (test hd) || (row_tester tl) ;;

(* I/P: the procedure takes in the list that contains the grid
 *     of values from a state : my_list
 * O/P: the procedure outputs a boolean that tests all the columns
 *     of the state to see if there are five pieces in a columns. *)
let rec col_tester my_list =
  (if (List.hd my_list) = [] then false
   else test (List.map (List.hd) my_list) || col_tester (List.map (List.tl) my_list)) ;;

(* I/P: the procedure takes in the list that contains the grid
 *     of values from a state : my_list
 * O/P: the procedure outputs a list that contains all the values 
 *      of a diagonal from the top left to bottom right of a grid. *)
let rec get_diag my_list =
  match my_list with
    | [] -> []
    | hd1 :: tl1 -> 
        (match hd1 with 
          | [] -> []
          | hd2 :: tl2 -> hd2 :: get_diag (List.map (List.tl) tl1)) ;;

(* I/P: the procedure takes in the list that contains the grid
 *     of values from a state : my_list
 * O/P: the procedure outputs a boolean based on whether or not
 *      the diagonals in the row direction contain five in a row
 *      for one player or not. *)
let rec diag_rows_test my_list = 
  match my_list with
    | [] -> false
    | hd :: tl -> ((test (get_diag my_list) ) || (diag_rows_test tl)) ;;

(* I/P: the procedure takes in the list that contains the grid
 *     of values from a state : my_list
 * O/P: the procedure outputs a boolean based on whether or not
 *      the diagonals in the column direction contain five in a row for
 *      one player or not. *)
let rec diag_cols_test my_list =
  if (List.hd my_list) = [] then false
  else (test (get_diag my_list) || diag_cols_test (List.map (List.tl) my_list)) ;;

(* I/P: the procedure takes in the list that contains the grid
 *     of values from a state : my_list
 * O/P: the procedure outputs a boolean based on whether or not
 *      the diagonals going from the top left to the bottom right
 *      contain five pieces in a row for one player. *)
let diag_test my_list =
  (diag_rows_test my_list || diag_cols_test my_list)

(* I/P: the procedure takes in the list that contains the grid
 *     of values from a state : my_list
 * O/P: the procedure outputs a boolean based on whether or not
 *      the diagonals going from the top left to the bottom right 
 *      and vice versa contain five pieces in a row for one player. *)
let rec diag_tester my_list =
  (diag_test my_list || diag_test (List.map (List.rev) my_list))



(* Fill in the code that defines your game here. *)
module Game : GAME =
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
    State ((construct_list rows (construct_list columns 0)), P1)

  (* TYPE CONVERSIONS *)

  (* returns the name of a player 
   * I/P: the procedure takes a player: p 
   * O/P: the procedure outputs a string *)
  let string_of_player p = 
    match p with
      |P1 -> "Player 1"
      |P2 -> "Player 2"

  (* describes a state in words *)
  let string_of_state (State(my_list, p)) : string =  
    let rec print_grid (my_list2 : (int list) list) : string =
      match my_list2 with
        |[] -> ""
        |hd :: tl -> (List.fold_right (fun x y -> ((string_of_int x) ^ " " ^ y)) hd "\n") ^ (print_grid tl) in 
      "The current player is " ^ (string_of_player p) ^ " and the game grid is \n" ^ (print_grid my_list)


  (* describes a move in words *)
  let string_of_move (Move(x, y)) = 
    "(" ^ (string_of_int x) ^ ", " ^ (string_of_int y) ^ ")"

  (* produces the list of allowable moves in a given state *)
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

  (* determines whether the game is over or not given a state *)
  let is_game_over (State(my_list, p)) = 
    if (legal_moves (State(my_list, p)) = [])
    then true
    else (row_tester my_list) || (col_tester my_list || diag_tester my_list)

  (* describes the game status (is it over or not),
   * and if it is over, the final outcome *)
  let status_string (State(my_list, p)) = 
    if (is_game_over (State(my_list, p))) then
      "The game is over. The winner is " ^ (if p = P1 then "P2" else "P1") ^ "."
    else "The game is not over."

  (* Tool for a human player. 
   * produces the move that a string represents *)
  let move_of_string my_string = 
    match ((Str.split (Str.regexp " ")) my_string) with
      |[x ; y] -> Move(int_of_string x, int_of_string y)
      |_ -> failwith "Input is invalid."

  (* GAME LOGIC *)

  (* determines whether a given move is legal in a given state *)
  let is_legal_move (State(my_list, p)) (Move (x, y)) = 
    if ((x > (columns - 1)) || (y > (rows - 1))) then false
    else if ((List.nth (List.nth my_list x) y) = 0) then true
    else false

  (* produces the current player in a given state *)
  let current_player (State(my_list, p)) = p

  (* executes the given move and produces the new game state *)
  let next_state (State(my_list, p)) (Move(x, y)) = 
    let rec helper1 my_list x y p row =
      let rec helper2 my_list y p column =
        match my_list with
          |[] -> failwith "There is no such move in the list"
          |hd :: tl -> 
              if (y = column) then
                if (p = P1) then 1 :: tl
                else 2 :: tl
              else hd :: (helper2 tl y p (column + 1))
      in match my_list with
        |[] -> failwith "There is no such move in the list"
        |hd :: tl -> 
            if (x = row) then
              (helper2 hd y p 0) :: tl
            else 
              hd :: (helper1 tl x y p (row + 1))
    in (State ((helper1 my_list x y p 0), (if (p = P1) then P2 else P1)))

  (* estimates value of a given state
   * Remember: positive values are better for P1
   *       and negative values are better for P2 *)
  let estimate_value my_state = 
    Random.float 10.


end ;;

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
(*
Game.current_player (Game.initial_state) ;;

Game.is_game_over(Game.initial_state) ;;

print_endline(Game.string_of_state (Game.next_state (Game.initial_state) (Game.move_of_string("0 0")))) ;;

print_endline(Game.string_of_state (Game.next_state (Game.next_state (Game.initial_state) (Game.move_of_string("0 0"))) (Game.move_of_string("3 4")))) ;;


List.map (fun x -> (Game.string_of_move x)) (Game.legal_moves (Game.initial_state)) ;;
*)


