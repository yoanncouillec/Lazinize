cbn.out: cbn.ml
	ocamlc $^ -o $@

clean:
	rm -rf cbn.out *.cm*

mrproper: clean
	rm -rf *~
