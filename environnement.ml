module Type = struct 

  let not_rec = function 
    | Int | Char | Typenull -> true
    | _ -> false

  let equiv t1 t2 = match t1,t2 with  
    | _,_ when (not_rec t1)&& (not_rec t2) -> true
    | Typenull, (Pointer _) | (Pointer _), Typenull -> true 
    | (Pointer Void),(Pointer _) | (Pointer _),(Pointer Void) -> true
    |  _,_  -> t1 = t2
;;

  let rec num = function 
    | Int | Pointer _ -> true
    | _ -> false
;;

(*manque une fonction pour savoir si un ident correspond à une variable*)
  let lvalue = function 
    | Id s when _is_variable s -> true
    | Pointer_access_expr _ -> true
    | Access_field e,_ -> lvalue e
    | _ -> false
;;


end ;;
