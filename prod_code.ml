open Typeur
open Mips
open Ast_Type
open Definition
open Aide_prod
open List
	

let get_offset = function 
  | Areg(i,_) -> i
  | Alab(i,_) -> i

let add_offset i = function 
  | Areg(j,reg) -> Areg(i+j,reg)
  | Alab(j,lab) -> Alab(i+j,lab)


(*fonction pour deplacer des blocs de donnees,
  doit pouvoir marcher même sur des donnees non alignees*)
let rec move adr_depart adr_arrivee size = match size with 
  | 0 -> nop
  | i when (i >= 4)&&((get_offset adr_depart) mod 4 = 0)
      &&((get_offset adr_arrivee) mod 4 = 0) -> 
      mips [Lw(T4,adr_depart) ; Sw(T4,adr_arrivee)]
      ++ (move (add_offset 4 adr_depart) (add_offset 4 adr_arrivee) (size -4) ) 
	(*traite le cas ou les donnees sont alignees*)
  | i -> mips [Lb(T4,adr_depart) ; Sb(T4,adr_arrivee)]
      ++ (move (add_offset 1 adr_depart) (add_offset 1 adr_arrivee) (size -1) ) 
	(*cas general : on deplace bit par bit*)
	
let rec lvalue_code e = match e.texp with
  |TCharacter _ |TEntier _ |TChaine _ |TAssignement _ |TCall _ -> assert false
  |TUnop _ |TBinop _ |TSizeof _ -> assert false 
  |TVariable var -> begin match var with 
      | TGvar v -> mips [La(A0,"var_"^v.gv_name)]
      | TLvar v -> mips [Arith(Add,A0,FP,Oimm(v.lv_loc))] 
    end 
  |TPointer_access e ->  code_expr e   
  |TAccess_field (e,x) -> begin let lval_code = lvalue_code e in
    match e.texp_type with
      | TUnion uni -> 
          let str_var = List.find (fun var -> var.lv_name = x) uni.u_content in
	lval_code ++ (mips [Arith(Add,A0,A0,Oimm(str_var.lv_loc))])
      | TStruct stru -> 
          let str_var = List.find (fun var -> var.lv_name = x) stru.s_content in
	lval_code ++ (mips [Arith(Add,A0,A0,Oimm(str_var.lv_loc))])
      | _ -> assert false
    end
     
and code_expr e = 
  match e.texp with
    |TCharacter c -> mips[Li (A0,int_of_char c)]
    |TEntier i -> mips[Li32 (A0,i)]
    |TChaine s -> begin try
	mips[La(A0,Hashtbl.find Typeur.echaine s)] 
      with Not_found -> assert false 
      end
    |TVariable (TGvar gvar) -> begin match(gvar.gv_type) with 
        | TInt | TChar | TPointer _ -> mips[Lw(A0,Alab(0,"var_"^gvar.gv_name))]
        | TStruct _ | TUnion _  -> let size = taille_arrondie gvar.gv_type in 
	  mips [Arith(Sub,SP,SP,Oimm(size))]
	  ++ move (Alab(0,"var_"^gvar.gv_name)) (Areg(0,SP)) size	  
        | TVoid | TTypenull -> assert false
      end
       
    |TVariable (TLvar lvar) -> begin match(lvar.lv_type) with
        | TInt | TChar | TPointer _ -> mips[Lw(A0,Areg(lvar.lv_loc,FP))]
        | TStruct _ | TUnion _ ->  let size = taille_arrondie lvar.lv_type in 
	  mips [Arith(Sub,SP,SP,Oimm(size))]
	  ++ move (Areg(lvar.lv_loc,FP)) (Areg(0,SP)) size	  
        | TVoid | TTypenull -> assert false
      end 
       
    |TPointer_access e when num (pointed_type e.texp_type) -> 
       let code = code_expr e and type1 = pointed_type (e.texp_type) in 
       code ++ load_reg A0 (Areg(0,A0)) type1
	 
    |TPointer_access e -> 
       let code = code_expr e and size = taille_arrondie e.texp_type in
      code ++ mips [Arith(Sub,SP,SP,Oimm(size))]
      ++ (move (Areg(0,A0)) (Areg(0,SP)) size)
	
    |TAccess_field (e,x) when lvalue e.texp -> 
       begin let code_adr = lvalue_code e in 
       match e.texp_type with 
	 | TUnion uni -> 
            let uni_var = List.find (fun var -> var.lv_name = x) uni.u_content
             in
	    if num uni_var.lv_type then 
	     code_adr ++ load_reg A0 (Areg(uni_var.lv_loc,A0)) (uni_var.lv_type)
	   else
	     (let size_var = taille_arrondie uni_var.lv_type in
	     code_adr 
	     ++ mips([Arith(Sub,SP,SP,Oimm(size_var))])
	     ++ move (Areg(0,A0)) (Areg(0,SP)) size_var
	     )
	 | TStruct stru -> 
             let str_var = List.find (fun var -> var.lv_name = x) stru.s_content
             in
	   if num str_var.lv_type then 
	     code_adr ++ load_reg A0 (Areg(str_var.lv_loc,A0)) (str_var.lv_type)
	   else 
	     (let size_var = taille_arrondie str_var.lv_type in
	     code_adr 
	     ++ mips([Arith(Sub,SP,SP,Oimm(size_var))])
	     ++ move (Areg(0,A0)) (Areg(0,SP)) size_var
	     )
	 | _ -> assert false
       end 
    |TAccess_field (e,x) -> begin 
        (*dans le cas general, le resultat de e est en SP*)
	let code = code_expr e and size = taille_arrondie e.texp_type in
	match e.texp_type with 
	  | TUnion uni -> 
              let uni_var = List.find (fun var -> var.lv_name = x) uni.u_content
              in
	    if num uni_var.lv_type then 
	      code ++ load_reg A0 (Areg(uni_var.lv_loc,SP)) (uni_var.lv_type) 
              ++ (mips[Arith(Add,SP,SP,Oimm(size))]) 
                (*La structure est en 0($sp)*)
	    else 
	      (let size_var = taille_arrondie uni_var.lv_type in
	      code 
	      ++ mips([Arith(Sub,SP,SP,Oimm(size_var))])
	      ++ move (Areg(size_var+uni_var.lv_loc,SP)) (Areg(0,SP)) size_var
	      ++ move (Areg(0,SP)) (Areg(size,SP)) size_var
	      ++ mips [Arith(Add,SP,SP,Oimm(size))]
	      )
	  | TStruct str -> 
              let str_var = List.find (fun var -> var.lv_name = x) str.s_content
              in
	    if num str_var.lv_type then 
	      code ++ load_reg A0 (Areg(str_var.lv_loc,SP)) (str_var.lv_type) 
              ++ (mips[Arith(Add,SP,SP,Oimm(size))]) 
                (*La structure est en 0($sp)*)
	    else 
	      (let size_var = taille_arrondie str_var.lv_type in
	      code 
	      ++ mips([Arith(Sub,SP,SP,Oimm(size_var))])
	      ++ move (Areg(size_var+str_var.lv_loc,SP)) (Areg(0,SP)) size_var
	      ++ move (Areg(0,SP)) (Areg(size,SP)) size_var
	      ++ mips [Arith(Add,SP,SP,Oimm(size))]
	      )
	  | _ -> assert false
      end
       
    |TAssignement (e1,e2) when num e2.texp_type -> 
       (*cas ou e2 est num, son resultat est dans A0*)
       let code_adr = lvalue_code e1 in 
       let type1 = e1.texp_type in
       let code_e = code_expr e2 in 
       code_adr 
       ++ (mips [Arith(Sub,SP,SP,Oimm(4))]) 
       ++ store_reg A0 (Areg(0,SP)) (TPointer type1) 
       ++ code_e
       ++ load_reg A1 (Areg(0,SP)) (TPointer type1) 
       ++ store_reg A0 (Areg(0,A1)) type1 
       ++ mips[Arith(Add,SP,SP,Oimm(4))]
         
         
    | TAssignement (e1,e2) ->
	(* cas ou le resultat est sur la pile (structures et unions)*) 
	let code_adr = lvalue_code e1 in 
	let type1 = e1.texp_type in
	let code_e = code_expr e2 in
	let taille_2 = taille_arrondie e2.texp_type in
	code_adr
	++ (mips [Arith(Sub,SP,SP,Oimm(4))]) 
	++ store_reg A0 (Areg(0,SP)) (TPointer type1)
	++ code_e
	++ load_reg A1 (Areg(taille_2,SP)) (TPointer type1)
	++ move (Areg(0,SP)) (Areg(0,A1)) taille_2
	++ mips [Arith(Add,SP,SP,Oimm(taille_2+4))]
	++ (mips [Arith(Sub,SP,SP,Oimm(taille_2))])
	++ move (Areg(0,A1)) (Areg(0,SP)) taille_2 
          
    |TCall (f,[e]) when f.f_name = "putchar"-> 
       let c = code_expr e in c++ (mips [Li (V0, 11) ; Syscall ])
                                                                        
    |TCall (f,[e]) when f.f_name = "sbrk"-> 
       let c = code_expr e in c ++ (mips [Li (V0, 9); Syscall; Move(A0,V0)]) 
                                                                     
    |TCall (f,l) ->
       let put_arg e =
	 if num e.texp_type then    
    	   (code_expr e) 
           ++ (mips [Arith(Sub,SP,SP,Oimm(4))]) 
           ++ store_reg A0 (Areg(0,SP)) TInt
	 else 
	   code_expr e
       in 
       let taille_resultat = taille_arrondie f.f_type in
       let code_arg = List.fold_left (fun acc e -> acc ++ (put_arg e)) nop l in
       if not_struct f.f_type then 
         (mips[Arith(Sub,SP,SP,Oimm(taille_resultat)) ]) 
	 ++ code_arg 
	 ++ mips [Jal("fun_"^f.f_name) ] 
           (*a l'issue de l'appel de fonction, SP pointe sur le resultat,
             et le resultat est sur la pile*)
	 ++ store_reg A0 (Areg(0,SP)) f.f_type 
	 ++ mips[Arith(Add,SP,SP,Oimm(taille_resultat))]
       else
	 (mips[Arith(Sub,SP,SP,Oimm(taille_resultat)) ])
	 ++ code_arg
	 ++ mips [Jal("fun_"^f.f_name)]
	   
    |TUnop (op,e) -> (begin let type1 = e.texp_type in
      match op with
        | PPleft -> let code_adr = lvalue_code e in
	  code_adr 
          ++ load_reg T0 (Areg(0,A0)) type1 
          ++ mips[ Arith(Add,T0,T0,Oimm(1)) ] 
          ++ store_reg T0 (Areg(0,A0)) type1 
          ++ mips[ Move(A0,T0)] 
        | PPright -> let code_adr = lvalue_code e in
	  code_adr 
          ++ load_reg T0 (Areg(0,A0)) type1 
          ++ mips[ Arith(Add,T0,T0,Oimm(1)) ] 
          ++ store_reg T0 (Areg(0,A0)) type1 
          ++ mips[ Arith(Sub,A0,T0,Oimm(1))] 
        | MMleft -> let code_adr = lvalue_code e in
	  code_adr 
          ++ load_reg T0 (Areg(0,A0)) type1 
          ++ mips[Arith(Sub,T0,T0,Oimm(1)) ] 
          ++ store_reg T0 (Areg(0,A0)) type1 
          ++ mips[ Move(A0,T0)] 
        | MMright -> let code_adr = lvalue_code e in
	  code_adr 
          ++ load_reg T0 (Areg(0,A0)) type1 
          ++ mips[Arith(Sub,T0,T0,Oimm(1)) ] 
          ++ store_reg T0 (Areg(0,A0)) type1
          ++ mips[ Arith(Add,A0,T0,Oimm(1))] 
        | Adr_get -> lvalue_code e 
        | Definition.Not -> 
            (code_expr e) 
            ++ (mips[Mips.Set(Mips.Eq,A0,A0,Oimm(0))])
        | UMinus -> let code_e = code_expr e in 
	  code_e ++ (mips[Neg(A0,A0)])
        | UPlus  -> code_expr e
            
        | PointerPPleft -> let code_adr = lvalue_code e in
	  let taille = get_size (pointed_type e.texp_type) in
	  code_adr 
          ++ (mips[Lw(T0,Areg(0,A0)) ; Arith(Add,T0,T0,Oimm(taille)) ;
                   Sw(T0,Areg(0,A0)) ; Move(A0,T0)])
        | PointerPPright -> let code_adr = lvalue_code e in
	  let taille = get_size (pointed_type e.texp_type) in
	  code_adr 
          ++ (mips[Lw(T0,Areg(0,A0)) ; Arith(Add,T0,T0,Oimm(taille)) ; 
                   Sw(T0,Areg(0,A0)) ; Arith(Mips.Sub,A0,T0,Oimm(taille))])
        | PointerMMleft -> let code_adr = lvalue_code e in
	  let taille = get_size (pointed_type e.texp_type) in
	  code_adr 
          ++ (mips[Lw(T0,Areg(0,A0)) ; Arith(Mips.Sub,T0,T0,Oimm(taille)) ; 
                   Sw(T0,Areg(0,A0)) ; Move(A0,T0)])
        | PointerMMright -> let code_adr = lvalue_code e in
	  let taille = get_size (pointed_type e.texp_type) in
	  code_adr 
          ++ (mips[Lw(T0,Areg(0,A0)) ; Arith(Mips.Sub,T0,T0,Oimm(taille)) ; 
                   Sw(T0,Areg(0,A0)) ])
      end )
       
       
    |TBinop (And,e1,e2) -> let label1 = new_label "and" in
      code_expr e1
      ++ mips[Beqz(A0,label1)]
      ++ code_expr e2
      ++ mips[Label(label1);Set(Ne,A0,A0,Oimm(0))]
        
    |TBinop (Or,e1,e2) -> let label1 = new_label "or" in
      code_expr e1
      ++ mips[Bnez(A0,label1)]
      ++ code_expr e2
      ++ mips[Label(label1);Set(Ne,A0,A0,Oimm(0))]
 	
    |TBinop (op,e1,e2) -> begin let code_debut = (code_expr e1) 
	++ (mips[Arith(Sub,SP,SP,Oimm(4)); Sw(A0,Areg(0,SP))]) 
	++ (code_expr e2) 
	++ (mips[Lw(T0,Areg(0,SP)) ; Arith(Add,SP,SP,Oimm(4)) ; Move(T1,A0)]) in
      let code_operation = 
	match op with 
	  | Eq -> mips[Set(Mips.Eq,A0,T0,Oreg(T1))]
	  | Neq -> mips[Set(Mips.Ne,A0,T0,Oreg(T1))]
	  | Lt -> mips[Set(Mips.Lt,A0,T0,Oreg(T1))]
	  | Leq -> mips[Set(Mips.Le,A0,T0,Oreg(T1))]
	  | Gt -> mips[Set(Mips.Gt,A0,T0,Oreg(T1))]
	  | Geq -> mips[Set(Mips.Ge,A0,T0,Oreg(T1))]
	  | BPlus -> mips[Arith(Mips.Add,A0,T0,Oreg(T1))]
	  | BMinus -> mips[Arith(Mips.Sub,A0,T0,Oreg(T1))]
	  | Mul -> mips[Arith(Mips.Mul,A0,T0,Oreg(T1))]
	  | Div -> mips[Arith(Mips.Div,A0,T0,Oreg(T1))]
	  | Mod -> mips[Arith(Mips.Rem,A0,T0,Oreg(T1))]
	  | PointerBPlus -> let taille = get_size (pointed_type e1.texp_type) in
	    mips[Arith(Mips.Mul,T1,T1,Oimm(taille)) ; 
                 Arith(Mips.Add,A0,T0,Oreg(T1))]
	  | PointerIntBMinus -> 
              let taille = get_size (pointed_type e1.texp_type) in
	        mips[Arith(Mips.Mul,T1,T1,Oimm(taille)) ; 
                     Arith(Sub,A0,T0,Oreg(T1))]
	  | PointerPointerBMinus -> 
	      let taille = get_size (pointed_type e1.texp_type) in
	      mips[Arith(Sub,A0,T0,Oreg(T1)) ; 
                   Arith(Mips.Div,A0,A0,Oimm(taille))]
	  |And|Or -> assert false (*deja traite*)
      in code_debut ++ code_operation
      end 
       
    |TSizeof (t) -> mips[Li (A0,get_size (t))]
       
(*on passe en argument la fonction dont c'est le corps pour les returns*)
let rec code_instr f = function
  | TEmpty -> nop

  | TWhile(e,i) -> let label_1 = new_label "while" 
                   and label_2 = new_label "while" in 
    (mips[J label_2 ; Label label_1]) ++ (code_instr f i.tinstr) 
    ++ (mips[Label label_2]) ++ (code_expr e) ++ (mips[Bnez(A0,label_1)])   

  | TReturn None -> nop		   

  | TReturn (Some e) when not_struct e.texp_type -> 
      (*cas ou la sortie est dans A0*) 
      (code_expr e) 
      ++ store_reg A0 (Areg(f.f_result_pos,FP))  f.f_type  
      ++ mips [J ("f_end_" ^f.f_name)]

  | TReturn (Some e) -> let size = taille_arrondie e.texp_type in 
    code_expr e 
    ++ move (Areg(0,SP)) (Areg(f.f_result_pos,FP)) size
    ++ mips [J ("f_end_"^f.f_name)]
      
  | TIf(e,i1,None) -> let code_e = code_expr e in
    let label_1 = new_label "if" in
    let code_i1 = code_instr f i1.tinstr in
    code_e ++ mips[Beqz(A0,label_1)] ++ code_i1 ++ mips[Label label_1]
      
  | TIf(e,i1,Some i2) -> let code_e = code_expr e in
    let label_1 = new_label "if" and label_2 = new_label "if" in
    let code_i1 = code_instr f i1.tinstr and code_i2 = code_instr f i2.tinstr in
    code_e ++ mips[Beqz(A0,label_1)] ++ code_i1 ++ mips[B(label_2)] 
    ++ mips[Label label_1] ++ code_i2 ++ mips[Label (label_2)]
      
  | TExpression e -> if not_struct e.texp_type then 
      code_expr e
    else 
      code_expr e ++ mips [Arith(Add,SP,SP,Oimm(taille_arrondie e.texp_type))]
        
  | TBloc b -> 
      List.fold_left (fun acc inst -> acc ++ (code_instr f (inst.tinstr))) 
        nop (snd(b.tbloc))
        
let code_decl = function 
  | TDt _ -> nop 
  | TDvar _ -> nop (*les declarations de variables vont dans le champ data*)
  | TDf dec_f ->  let f = dec_f.tfun in
    let code = code_instr f (TBloc dec_f.tcontent) in			
    mips[Label ("fun_"^f.f_name)] 
    ++ (func_begin (f.f_lvar_size)) ++ code ++ (func_end f) 	
      
let code_data2 = function 
  | TDt _ | TDf _ -> []
  | TDvar {tdecvar = TGvar v; tdecvar_pos = _} -> (match v.gv_type with
      | TInt | TChar | TPointer _ -> [Word("var_"^v.gv_name, [Wint 0])]
      | TStruct stru -> [Align 2 ; Space("var_"^v.gv_name,get_size(v.gv_type))] 
      | TUnion uni -> [Align 2 ; Space("var_"^v.gv_name,get_size(v.gv_type))]
      | TVoid | TTypenull -> assert false			
          
    )
  | _ -> assert false
      
let code_data () =  
  Hashtbl.fold (fun x y l -> (Align 2)::Asciiz (y, x) :: l) 
               Typeur.echaine [Align 2 ; Asciiz ("newline", "\n")]

let code_main = 
  mips[Label "main"; Arith(Sub, FP,SP,Oimm(12)); Arith(Sub, SP,SP,Oimm(12));
       Sw(A0,Areg(4,SP)); Sw(A1,Areg(0,SP)); Jal "fun_main"; Li(V0,10); Syscall]

    
    
let code_prog p = 
  set_loc p ;
  {text = code_main ++ List.fold_left 
      (fun acc_code decl -> (code_decl decl) ++ acc_code) nop p.tdecl ; 
  data = code_data() @ List.fold_left 
      (fun acc_data decl -> (code_data2 decl) @ acc_data ) [] p.tdecl}
    
    
