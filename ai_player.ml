#use "C:/Users/Erik/Desktop/CS017/OCaml/Projects/Game/player_signature.ml" ;;

(* Fill in the code for your AI player here. *)
(* Note that your AI player simply needs to decide on its next move.
 * It does not have to worry about printing to the screen or any of
 * the other silliness in the HumanPlayers's chunk of code. *)
type 'a tree = 
    | Empty
    | Node of 'a * 'a tree list ;;

module AIPlayer : GAME_PLAYER =
struct
  open Game

  let depth = 2

  let minmax p = (if p = P1 then max else min)

  let switch p = (if p = P1 then P2 else P1)

  let best (f : 'a -> 'a -> bool) (alon : (float * (move list)) list) : float * (move list) =
    let rec _best alon (best_float, best_list) =
      match alon with
        |[] -> (best_float, best_list)
        |hd :: tl -> 
            (let (my_float, my_move_list) = hd in
               if (f my_float best_float) then
                 _best alon hd
               else _best alon (best_float, best_list)) in
      _best alon (List.hd alon)

  let rec get_tree_value (my_tree : (state * (move list)) tree) : float * (move list) = 
    match my_tree with 
      |Empty -> failwith "bad"
      |Node((state, mlist), [Empty]) -> ((estimate_value state), mlist) 
      |Node((state, mlist), alomlist) -> (best (if (current_player state) = P1 then (>) else (<)) (List.map (fun x -> (get_tree_value x)) alomlist))

  let get_tree state : ((state * (move list)) tree) =
    let rec next_level state moves : (state * (move list)) tree list =
      (if (List.length moves) <= depth then
         (List.map (fun x -> (Node(((next_state state x), x :: moves), (next_level (next_state state x) (x :: moves))))) 
            (legal_moves state))
       else [Empty]) in
      Node((state, []), (next_level state []))

  let next_move state =
    let (my_float, my_list) = (get_tree_value (get_tree state))  in
      (match my_list with
        |hd :: [] -> hd
        |_ -> failwith "something bad happened")


end ;;
