CMO=lexer.cmo parser.cmo Definition.cmo typeur.cmo mips.cmo aide_prod.cmo prod_code.cmo main.cmo 
GENERATED = lexer.ml parser.ml parser.mli 
BIN=minic
FLAGS=

all: $(BIN)
	exit 0

$(BIN):$(CMO)
	ocamlc $(FLAGS) -o $(BIN) $(CMO)

.SUFFIXES: .mli .ml .cmi .cmo .mll .mly  

.mli.cmi:
	ocamlc $(FLAGS) -c  $<

.ml.cmo:
	ocamlc $(FLAGS) -c  $<

.mll.ml:
	ocamllex $<

.mly.ml:
	menhir -v $<

clean:
	rm -f *.cm[io] *.o *~ $(BIN) $(GENERATED) parser.output parser.automaton parser.conflicts

.depend depend:$(GENERATED)
	rm -f .depend
	ocamldep *.ml *.mli > .depend

include .depend
