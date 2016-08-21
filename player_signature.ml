#use "C:/Users/Erik/Desktop/CS017/OCaml/Projects/Game/game.ml" ;;

module type GAME_PLAYER =
sig
  open Game

  (* given a state, and decides which legal move to make *)
  val next_move : state -> move
end ;;
