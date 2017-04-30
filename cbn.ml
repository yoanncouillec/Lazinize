type term = TVar of int
	  | TLam of term
	  | TApp of term * term

type value = VClos of term * env

and env = value list

(* STRING OF *)
let rec string_of_term = function
  | TVar n -> "TVar (" ^ (string_of_int n) ^ ")"
  | TLam t -> "TLam (" ^ (string_of_term t) ^ ")"
  | TApp (t1, t2) -> "TApp (" ^ (string_of_term t1) ^ ", " ^ (string_of_term t2) ^ ")"

and string_of_value = function
  | VClos (t, env) -> 
     "VClos (" ^ (string_of_term t) ^ ", " ^ (string_of_env env) ^ ")"

and string_of_env env = 
  "[" ^ (List.fold_left (fun accu v -> accu ^ (string_of_value v) ^";") "" env) ^ "]"

(* ENV *)
let rec env_lookup env n =
  match env with
  | v :: xs ->
     if n = 1 then v else env_lookup xs (n - 1)
  | _ -> failwith "env_lookup : no such binding"

(* "LAZINIZE" *)
let rec lazinize t =
  match t with
  | TVar n -> TApp (TVar n, TLam (TVar 0))
  | TApp (t1, t2) -> TApp (lazinize t1, TLam (lazinize (inc_free 0 t2)))
  | TLam (t1) -> TLam (lazinize t1)

and inc_free m = function
  | TVar n when n > m -> TVar (n + 1)
  | TVar n -> TVar n
  | TApp (t1, t2) -> TApp (inc_free m t1, inc_free m t2)
  | TLam (t1) -> TLam (inc_free (m+1) t1)

(* EVAL *)
let rec eval t env =
  match t with
  | TVar n -> env_lookup env n
  | TLam t -> VClos (t, env)
  | TApp (t1, t2) -> 
     match (eval t1 env, eval t2 env) with
       | (VClos (cbody, cenv), v2) -> eval cbody (v2 :: cenv)

let exec t = 
  let lazy_t = lazinize t in
  let result = eval lazy_t [] in
  print_endline ("initial term = " ^ (string_of_term t)) ;
  print_endline ("be lazy baby = " ^ (string_of_term lazy_t)) ;
  print_endline ("result = " ^ (string_of_value result))

(* MAIN *)
let _ = 
  let omega = (TApp (TLam (TApp (TVar 1, TVar 1)), 
		     TLam (TApp (TVar 1, TVar 1)))) in
  let t = TApp (TLam (TLam (TVar 1)), omega) in
  exec t
